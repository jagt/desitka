package com.pre_sence.mm;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import com.eclecticdesignstudio.motion.easing.Quad;
import com.eclecticdesignstudio.motion.easing.Linear;
import nme.display.Sprite;
import nme.events.MouseEvent;
import Tile.State;

/**
 * ...
 * @author lilo
 */
class SummedTiles
{
	private static var FLOATING:Float = 4.5; 
	public var arr:Array<Tile>;
	private var cgame:ChainGame;
	public var timer:IGenericActuator;
	
	public function new(cgame_:ChainGame) {
		arr = new Array<Tile>();
		cgame = cgame_;
		//start_tween();
	}
	
	public function next_to(target:Array<Tile>):Bool {
		for (lhs in arr) {
			for (rhs in target) {
				if (lhs.next_to(rhs)) {
					return true;
				}
			}
		}
		return false;
	}
	
	public function push_arr(target:Array<Tile>):Void {
		for (tile in target) {
			arr.push(tile);
			tile.state = State.Summed;
		}
		reset_tween();
		Auxi.sumSnd.play();
	}
	
	private function start_tween():Void {
		timer = Actuate.timer(FLOATING).onComplete(clear_complete);
		for (tile in arr) {
			Actuate.transform(tile.block, FLOATING)
				   .color(Auxi.dropColor)
				   .ease(Quad.easeOut);
		}
	}
	
	private function reset_tween():Void {
		stop_tween();
		for (tile in arr) {
			// hacky way to reset color by set state
			tile.state = State.Summed;
		}
		start_tween();
	}
	
	public function stop_tween():Void {
		Actuate.stop(timer, null, false, false);
		Actuate.stop(arr);
	}
	
	public function clear_complete():Void {
		var ix = 0;
		for (tile in arr) {
			if (ix++ % Game.SELECTING == 0) {
				cgame.add_score_at(tile, 10 * (1+Std.int(ix/Game.SELECTING)));
			}
			cgame.remove_tile(tile);
		}
		arr = null;
		cgame.summed.remove(this);
		cgame.drop_tiles();
		cgame = null;
		Auxi.clearSnd.play();
	}
}
 
 
class ChainGame extends Game
{
	public var summed:Array<SummedTiles>;
	private var time:Int;
	private var bar:Sprite;
	
	public function new(time_:Int)
	{
		super();
		summed = new Array<SummedTiles>();
		time = time_;
		
		bar = new Sprite();
		bar.graphics.beginFill(Auxi.fontColor);
		addChild(bar);
	}
	
	override private function do_gameover():Void {
		super.do_gameover();
		// stops and do not call destroy at the end
		Actuate.stop(bar, null, false, false);
		// this becomes hacky since clear_complete removes its self
		// from the array.
		while (summed.length > 0) {
			summed[0].stop_tween();
			summed[0].clear_complete();
		}
		Actuate.timer(1.5).onComplete(Main.instance.game_over);
		Main.instance.menu.set_score(true, score);
	}
	
	override public function resize(sWidth:Int, sHeight:Int):Dynamic 
	{
		super.resize(sWidth, sHeight);
		bar.graphics.drawRect(0, 0, width * 0.9, 8);
		bar.x = Auxi.center(bar.width, Auxi.screenWidth);
		bar.y = y + height + Auxi.tileSize * 0.5;
		bar.mouseEnabled = false;
		
		#if debug
		time = 10;
		#end
		Actuate.tween(bar, time, { scaleX:0 } )
			   .ease(Linear.easeNone)
			   .onComplete(do_gameover);
	}
	
	override private function clear_selected():Void 
	{
		Auxi.assert(selected.is_full(), "clear on not full");
		var modded = selected.sum() % Game.SUM;
		if (modded == 0) {
			var found_next_to = false;
			for (sumtile in summed) {
				if (sumtile.next_to(selected.arr)) {
					sumtile.push_arr(selected.arr);
					found_next_to = true;
				}
				break;
			}
			if (!found_next_to) {
				var sumtile = new SummedTiles(this);
				sumtile.push_arr(selected.arr);
				summed.push(sumtile);
			}
		} else {
			for (ix in 0...selected.length-1) {
				remove_tile(selected.arr[ix]);
			}
			selected.top.value = modded;
			selected.top.state = State.Idle;
			add_score_at(selected.top, modded);
			Auxi.clearSnd.play();
		}
		selected.clear();
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		Auxi.assert(summed.length == 0);
	}
	
}
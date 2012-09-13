package com.pre_sence.mm;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import com.eclecticdesignstudio.motion.easing.Quad;
import com.eclecticdesignstudio.motion.easing.Linear;
import nme.display.Sprite;
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
		trace("pushed");
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
		Actuate.stop(timer, null, false, false);
		Actuate.stop(arr);
		for (tile in arr) {
			// hacky way to reset color by set state
			tile.state = State.Summed;
		}
		start_tween();
	}
	
	public function clear_complete():Void {
		var ix = 0;
		for (tile in arr) {
			if (ix++ % Game.SELECTING == 0) {
				cgame.add_score_at(tile, 10 * (1+Std.int(ix/Game.SELECTING)));
			}
			cgame.remove_tile(tile);
		}
		cgame.summed.remove(this);
		cgame.drop_tiles();
		trace("cleared called");
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
	
	private function do_gameover():Void {
		for (sum in summed) {
			Actuate.stop(sum.timer);
			sum.clear_complete();
		}
		tileContainer.mouseEnabled = false;
		tileContainer.mouseChildren = false;
		Actuate.timer(1.5).onComplete(Main.instance.game_over);
	}
	
	override public function resize(sWidth:Int, sHeight:Int):Dynamic 
	{
		super.resize(sWidth, sHeight);
		bar.graphics.drawRect(0, 0, width * 0.9, 8);
		bar.x = Auxi.center(bar.width, Auxi.screenWidth);
		bar.y = y + height + Auxi.tileSize * 0.5;
		
		Actuate.tween(bar, 2, { scaleX:0 } )
			   .ease(Linear.easeNone)
			   .onComplete(do_gameover); // TODO game over
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
				trace("new sumtile");
			}
		} else {
			for (ix in 0...selected.length-1) {
				remove_tile(selected.arr[ix]);
			}
			selected.top.value = modded;
			selected.top.state = State.Idle;
			add_score_at(selected.top, modded);
		}
		selected.clear();
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
	
}
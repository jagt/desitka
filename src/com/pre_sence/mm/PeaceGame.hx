package com.pre_sence.mm;
import com.eclecticdesignstudio.motion.Actuate;
import nme.events.MouseEvent;
import nme.text.TextField;
import Tile.State;

/**
 * ...
 * @author lilo
 */

class PeaceGame extends Game
{
	public var done:TextField;
	
	public function new() 
	{
		super();
		done = Auxi.make_button("Done");
		//addChild(done);
	}
	
	override private function board_initialize():Void 
	{
		super.board_initialize();
	}
	
	override private function select_done():Void 
	{
		clear_selected();
		// do not drop in this mode
	}
	
	override public function resize(sWidth:Int, sHeight:Int):Dynamic 
	{
		super.resize(sWidth, sHeight);
		done.scaleX = done.scaleY = 0.7;
		done.x = Auxi.center(done.width, Auxi.screenWidth);
		done.y = tileContainer.y + tileContainer.height + 16;
	}
	
	override private function clear_selected():Void 
	{
		Auxi.assert(selected.is_full(), "clear on not full");
		var sum = selected.sum();
		sum = sum == 0 ? 10 : sum; // fix 0/0/0
		var modded = selected.sum() % Game.SUM;
		if (modded == 0) {
			add_score_at(selected.top, sum);
			for (tile in selected.arr) {
				tile.state = State.Summed;
			}
			selected.clear();
		} else {
			for (ix in 0...selected.length-1) {
				remove_tile(selected.arr[ix]);
			}
			selected.top.value = modded;
			add_score_at(selected.top, modded);
			selected.pop_all();
		}
		if (!has_more_move()) {
			do_gameover();
		}
	}
	
	private function do_gameover():Void {
		tileContainer.mouseEnabled = false;
		tileContainer.mouseChildren = false;
		Actuate.timer(2.5).onComplete(Main.instance.game_over);
	}
	
	private function has_more_move():Bool {
		#if debug
		return false;
		#end
		for (arr in tiles) {
			for (tile in arr) {
				if (tile != null && tile.state != State.Summed) {
					if (has_two_neighbor(tile)) {
						return true;
					}
				}
			}
		}
		return false;
	}
	
	private function has_two_neighbor(tile:Tile):Bool {
		var count:Int = 0;
		for (ix in -1...2) {
			for (jx in -1...2) {
				var tx = tile.col + ix;
				var ty = tile.row + jx;
				if (tx >= 0 && tx < Game.COLS
					&& ty >= 0 && ty < Game.ROWS
					&& !(ix == jx && jx == 0)) {
					if (tiles[ty][tx] != null && tiles[ty][tx].state != State.Summed) {
						trace(tx + "," + ty);
						count++;
						if (count >= 2) return true;
					}
				}
			}
		}
		return false;
	}
	
	#if debug
	override private function this_onClick(event:MouseEvent):Void 
	{
		super.this_onClick(event);
		if (Std.is(event.target, Tile)) {
			var tile = cast(event.target, Tile);
			trace(has_two_neighbor(tile));
		}
	}
	#end
	
}
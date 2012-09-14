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
	public function new() 
	{
		super();
	}
	
	override private function board_initialize():Void 
	{
		var arr = new Array<Int>();
		for (ix in 0...10) {
			for (jx in 0...4) {
				arr.push(ix);
			}
		}
		for (ix in 4...10) {
			for (jx in 0...4) {
				arr.push(ix);
			}
		}
		// shuffle
		for (ix in 0...arr.length) {
			var top = arr.length - ix - 1;
			var cur = Math.floor( Math.random() * (top + 1) );
			// swap top/cur
			var tmp = arr[top];
			arr[top] = arr[cur];
			arr[cur] = tmp;
		}
		
		Auxi.assert(arr.length == 64);
		for (row in 0...Game.ROWS) {
			tiles[row] = new Array<Tile>();
			for (col in 0...Game.COLS) {
				var val = arr.pop();
				var tile = add_tile(row, col, val);
			}
		}
	}
	
	override private function select_done():Void 
	{
		clear_selected();
		// do not drop in this mode
	}
	
	override public function resize(sWidth:Int, sHeight:Int):Dynamic 
	{
		super.resize(sWidth, sHeight);
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
	
	override private function do_gameover():Void {
		super.do_gameover();
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
	
	override public function destroy():Void 
	{
		super.destroy();
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
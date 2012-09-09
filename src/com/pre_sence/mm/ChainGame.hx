package com.pre_sence.mm;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import Tile.State;

/**
 * ...
 * @author lilo
 */
class SummedTiles
{
	private static var FLOATING:Float = 4.0; 
	public var arr:Array<Tile>;
	private var cgame:ChainGame;
	private var timer:IGenericActuator;
	
	public function new(cgame_:ChainGame) {
		arr = new Array<Tile>();
		cgame = cgame_;
		timer = Actuate.timer(FLOATING).onComplete(clear_complete);
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
	
	private function reset_tween():Void {
		Actuate.stop(timer, null, false, false);
		timer = Actuate.timer(FLOATING).onComplete(clear_complete);
	}
	
	private function clear_complete():Void {
		for (tile in arr) {
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
	
	public function new() 
	{
		super();
		summed = new Array<SummedTiles>();
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
		}
		selected.clear();
	}
	
}
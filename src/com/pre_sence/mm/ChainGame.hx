package com.pre_sence.mm;

import Tile.State;

/**
 * ...
 * @author lilo
 */
class SummedTiles
{
	public var arr:Array<Tile>;
	
	public function new() {
		arr = new Array<Tile>();
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
				var sumtile = new SummedTiles();
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
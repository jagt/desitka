package com.pre_sence.mm;

import Tile.State;

/**
 * ...
 * @author lilo
 */

class ChainGame extends Game
{
	public var summed:Array<Tile>;
	
	public function new() 
	{
		super();
		summed = new Array<Tile>();
	}
	
	override private function clear_selected():Void 
	{
		Auxi.assert(selected.is_full(), "clear on not full");
		var modded = selected.sum() % Game.SUM;
		if (modded == 0) {
			for (tile in selected.arr) {
				summed.push(tile);
				tile.state = State.Summed;
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
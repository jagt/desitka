package com.pre_sence.mm;
import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.events.Event;
import nme.geom.Point;

/**
 * ...
 * @author lilo
 */

class TileStack
{
	public var arr:Array<Tile>;
	public var length(get_length, null):Int;
	public var top(get_top, null):Tile;
	
	private var cap:Int;
	private var topIx:Int;
	
	public function new(cap_:Int) {
		// initialize selected
		arr = new Array<Tile>();
		cap = cap_;
		for (ix in 0...cap) {
			arr[ix] = null;
		}
		topIx = -1;
	}
	
	public function clear():Void {
		while (!is_empty()) {
			pop();
		}
	}
	
	public function push(tile:Tile):Void {
		if (topIx == cap - 1) {
			throw "tile stack overflow";
		}
		arr[++topIx] = tile;
		tile.selected = true;
	}
	
	public function pop():Tile {
		var poped = arr[topIx];
		poped.selected = false;
		arr[topIx] = null;
		topIx -= 1;
		return poped;
	}
	
	public function is_full():Bool {
		return get_length() == cap;
	}
	
	public function is_empty():Bool {
		return get_length() == 0;
	}
	
	public function sum():Int {
		Auxi.assert(is_full(), "sum when not full.");
		var sum = 0;
		for (tile in arr) {
			sum += tile.value;
		}
		return sum;
	}
	
	private function get_length():Int {
		return topIx + 1;
	}
	
	private function get_top():Tile {
		if (topIx < 0)
			return null;
		else
			return arr[topIx];
	}
}

class Game extends Sprite
{
	private static var COLS:Int = 8;
	private static var ROWS:Int = 8;
	private static var SELECTING:Int = 3;
	private static var SUM:Int = 10;
	
	public var tiles:Array< Array<Tile> >;
	public var selected:TileStack;
	private var selectIx:Int;
	
	public function new() 
	{
		super();
		init();
	}
	
	public function resize(sWidth:Int, sHeight:Int) {
		var scale = 1.0;
		trace(width);
		if (width > sWidth || height > sHeight) {
			// add a padding to width
			var new_scale_x = sWidth / (width + 12);
			var new_scale_y = sHeight / height;
			scale = Math.min(new_scale_x, new_scale_y);
			scaleX = scaleY = scale;
		}
		trace(scale);
		trace(width);
		x = sWidth / 2 - width / 2;
		y = sHeight / 2 - height / 2;
	}
	
	private function get_pos(row:Int, col:Int):Point {
		return new Point(col * Auxi.tileSize, row * Auxi.tileSize);
	}
	
	private function add_tile(row:Int, col:Int, value:Int, depth:Int = 0):Tile {
		Auxi.assert(tiles[row][col] == null, "adding to an existing tile");
		var tile = Tile.get_avail_tile();
		tile.row = row;
		tile.col = col;
		tiles[row][col] = tile;
		var pos = get_pos(row, col);
		tile.reset(pos.x, pos.y, value);
		
		if (depth < 0) {
			var first = get_pos(depth, col);
			tile.x = first.x;
			tile.y = first.y;
			tile.drop_to(get_pos(row, col).y);
		} else {
			var pos = get_pos(row, col);
			tile.x = pos.x;
			tile.y = pos.y;
		}
		
		addChild(tile);
		return tile;
	}
		
	private function remove_tile(tile:Tile) {
		tile.kill();
		tiles[tile.row][tile.col] = null;
	}
	
	// override this to custom board initiization
	private function board_initialize():Void {
		for (row in 0...ROWS) {
			tiles[row] = new Array<Tile>();
			for (col in 0...COLS) {
				var val = Math.floor( Math.random() * 10 );
				var tile = add_tile(row, col, val);
			}
		}
	}
	
	// override this to custom when selecting is done
	private function select_done():Void {
		clear_selected();
		drop_tiles();
	}
	
	private function init():Void {
		// initialize board
		tiles = new Array< Array<Tile> >();
		board_initialize();
		
		selected = new TileStack(SELECTING);
		
		// connect event handlers
		addEventListener(MouseEvent.CLICK, this_onClick);
		
		#if debug
		// assert all rows and cols have correct row/col
		for (row in 0...ROWS) {
			for (col in 0...COLS) {
				var tile = tiles[row][col];
				Auxi.assert(tile.row == row);
				Auxi.assert(tile.col == col);
			}
		}
		#end
	}
	
	private function destroy():Void {
		for (arr in tiles) {
			for (tile in arr) {
				tile.destroy();
			}
		}
	}

	
	private function clear_selected():Void {
		Auxi.assert(selected.is_full(), "clear on not full");
		var modded = selected.sum() % SUM;
		if (modded == 0) {
			for (tile in selected.arr) {
				remove_tile(tile);
			}
		} else {
			for (ix in 0...selected.length-1) {
				remove_tile(selected.arr[ix]);
			}
			selected.top.value = modded;
		}
		selected.clear();
	}
	
	private function drop_tiles():Void {
		for (col in 0...COLS) {
			var spaces = 0;
			for (row in 0...ROWS) {
				// search from bottom up
				var ix = (ROWS - 1) - row;
				var tile = tiles[ix][col];
				
				if (tile == null) {
					++spaces;
				} else if (spaces > 0) {
					Auxi.assert(tile.alive == true);
					// find a tile, need to drop
					var pos = get_pos(ix + spaces, col);
					var drop_row = ix + spaces;
					tile.drop_to(pos.y);
					tile.row = drop_row;
					tiles[drop_row][col] = tile;
					tiles[ix][col] = null;
				}
			}
			
			// fill in empty tiles
			//trace(col + " : " + spaces);
			for (ix in 0...spaces) {
				var depth = -ix - 1 ;
				add_tile( depth + spaces, col, 
					Math.floor( Math.random() * 10 ), depth);
			}
		}
		
		#if debug
		// assert all rows and cols have correct row/col
		for (row in 0...ROWS) {
			for (col in 0...COLS) {
				var tile = tiles[row][col];
				Auxi.assert(tile != null);
				Auxi.assert(tile.row == row);
				Auxi.assert(tile.col == col);
			}
		}
		#end
	}
	
	// event handlers
	private function this_onClick(event:MouseEvent):Void {
		#if debug
		if (Std.is(event.target, Tile)) {
			var tile = cast(event.target, Tile);
			if (event.shiftKey) {
				tile.kill();
				return;
			} else if (event.altKey) {
				return;
			}
		}
		#end
		if (Std.is(event.target, Tile)) {
			var tile = cast(event.target, Tile);
			if (!tile.selected) {
				if (selected.is_empty()) {
					selected.push(tile);
				} else {
					if (selected.top.next_to(tile)) {
						selected.push(tile);
					} else {
						selected.clear();
					}
				}
			} else {
				// TODO handle unselect
				if (selected.top == tile) {
					selected.pop();
				} else {
					selected.clear();
				}
			}
			if (selected.is_full()) {
				select_done();
			}
		}
	}
}
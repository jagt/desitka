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
	private static var COLS:Int = 10;
	private static var ROWS:Int = 10;
	private static var SELECTING:Int = 3;
	
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
		if (width > sWidth || height > sHeight) {
			var new_scale_x = sWidth / width;
			var new_scale_y = sHeight / height;
			scale = Math.min(new_scale_x, new_scale_y);
			scaleX = scaleY = scale;
		}
		x = sWidth / 2 - (width * scale) / 2;
		y = sHeight / 2 - (height * scale) / 2;
	}
	
	private function get_pos(row:Int, col:Int):Point {
		return new Point(col * Auxi.tileSize, row * Auxi.tileSize);
	}
	
	private function add_tile(row:Int, col:Int, value:Int, animate:Bool = true):Tile {
		var tile = Tile.get_avail_tile();
		tile.row = row;
		tile.col = col;
		var pos = get_pos(row, col);
		tile.reset(pos.x, pos.y, value);
		
		
		if (animate) {
			var first = get_pos(-1, col);
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
	
	private function init():Void {
		// initialize board
		tiles = new Array< Array<Tile> >();
		for (row in 0...ROWS) {
			tiles[row] = new Array<Tile>();
			for (col in 0...COLS) {
				var val = Math.floor( Math.random() * 10 );
				var tile = add_tile(row, col, val, false);
				tiles[row][col] = tile;
			}
		}
		
		selected = new TileStack(SELECTING);
		
		// connect event handlers
		addEventListener(MouseEvent.CLICK, this_onClick);
	}
	
	// event handlers
	
	private function this_onClick(event:MouseEvent):Void {
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
			trace(selected.length);
		}
	}
}
package com.pre_sence.mm;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.TextFieldAutoSize;
import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.events.Event;
import nme.geom.Point;
import nme.text.TextField;
import Tile.State;

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
	
	// do set to idle
	public function pop_all():Void {
		while (!is_empty()) {
			pop();
		}
	}
	
	// clear only
	public function clear():Void {
		for (ix in 0...cap) {
			arr[ix] == null;
		}
		topIx = -1;
	}
	
	public function push(tile:Tile):Void {
		if (topIx == cap - 1) {
			throw "tile stack overflow";
		}
		arr[++topIx] = tile;
		tile.state = State.Selected;
		//tile.selected = true;
	}
	
	public function pop():Tile {
		var poped = arr[topIx];
		poped.state = State.Idle;
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
	private static var SUM:Int = 10;
	public static var SELECTING:Int = 3;
	
	public var tiles:Array< Array<Tile> >;
	public var tileContainer:Sprite;
	public var selected:TileStack;
	public var popup:Popup;
	public var score(default, set_score):Int;
	public var giveUp:TextField;
	private var scoreField:TextField;
	private var selectIx:Int;

	
	public function new() 
	{
		super();
		init();
	}
	
	public function resize(sWidth:Int, sHeight:Int) {
		var scale = 1.0;
		var w = tileContainer.width;
		var h = tileContainer.height;
		if (w > sWidth || h > sHeight) {
			// add a padding to width
			var new_scale_x = sWidth / (w + 12);
			var new_scale_y = sHeight / h;
			scale = Math.min(new_scale_x, new_scale_y);
			tileContainer.scaleX = tileContainer.scaleY = scale;
		}
		// TODO this does not match, which is weird...
		tileContainer.x = Math.round( (sWidth - width) / 2 );
		tileContainer.y = Math.round( (sHeight - height) / 2 );
		
		// set score position
		scoreField.x = Auxi.center(scoreField.width, Auxi.screenWidth);
		scoreField.y = 12+Auxi.center(scoreField.height, tileContainer.y);
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
		
		tileContainer.addChild(tile);
		return tile;
	}
		
	public function remove_tile(tile:Tile) {
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
		tileContainer = new Sprite();
		board_initialize();
		addChild(tileContainer);
		
		selected = new TileStack(SELECTING);
		popup = new Popup(this);
		
		// connect event handlers
		// check click on tiles before parent
		addEventListener(MouseEvent.CLICK, this_onClick);//, false, 1);
		
		// TODO can't find a good way to mark tiles
		/*
		#if mobile
		addEventListener(TouchEvent.TOUCH_OVER, this_onTouchOver);
		#else
		addEventListener(MouseEvent.MOUSE_OVER, this_onMouseOver);
		#end
		*/
		
		// setup score field
		var scoreFormat = new TextFormat(Auxi.latoFont.fontName,
			50, Auxi.fontColor);
		scoreField = new TextField();
		scoreFormat.align = TextFormatAlign.CENTER;
		//scoreField.autoSize = TextFieldAutoSize.LEFT;
		scoreField.defaultTextFormat = scoreFormat;
		scoreField.embedFonts = true;
		scoreField.selectable = false;
		scoreField.text = "0";
		scoreField.width = 240;
		addChild(scoreField);
		
		var giveUpFormat = new TextFormat(Auxi.latoBoldFont.fontName,
			64, Auxi.fontColor);
		giveUpFormat.align = TextFormatAlign.LEFT;
		giveUp = new TextField();
		Auxi.set_field(giveUp, giveUpFormat);
		giveUp.text = " x";
		giveUp.scaleX = giveUp.scaleY = 0.5;
		giveUp.x = giveUp.y = 0;
		
		addChild(giveUp);
		
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
	
	public function destroy():Void {
		trace("destryoied");
		Main.instance.game = null;
		parent.removeChild(this);
		removeEventListener(MouseEvent.CLICK, this_onClick);
		for (arr in tiles) {
			for (tile in arr) {
				if (tile != null) {
					tile.destroy();
					tile = null;
				}
			}
		}
		tiles = null;
	}

	
	private function clear_selected():Void {
		Auxi.assert(selected.is_full(), "clear on not full");
		var modded = selected.sum() % SUM;
		if (modded == 0) {
			for (tile in selected.arr) {
				remove_tile(tile);
			}
			selected.clear();
		} else {
			for (ix in 0...selected.length-1) {
				remove_tile(selected.arr[ix]);
			}
			selected.top.value = modded;
			selected.pop_all();
		}
	}
	
	public function drop_tiles():Void {
		for (col in 0...COLS) {
			var spaces = 0;
			for (row in 0...ROWS) {
				// search from bottom up
				var ix = (ROWS - 1) - row;
				var tile = tiles[ix][col];
				
				if (tile == null) {
					++spaces;
				} else if (tile.state == State.Summed) {
					spaces = 0; // skip summed tiles
				} else if (spaces > 0) {
					Auxi.assert(tile.alive == true);
					if (tile.state == State.Selected) {
						selected.pop_all();
					}
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
				if (tile != null) {
					Auxi.assert(tile.row == row);
					Auxi.assert(tile.col == col);
				}
			}
		}
		#end
	}
	
	private function set_score(score_:Int):Int {
		score = score_;
		scoreField.text = Std.string(score);
		return score;
	}
	
	public function add_score_at(tile:Tile, added:Int) {
		popup.show_at_tile(tile, "+" + added);
		score += added;
	}
	
	private function do_gameover():Void {
		giveUp.visible = false;		
		tileContainer.mouseEnabled = false;
		tileContainer.mouseChildren = false;
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
			if (tile.state == State.Idle) {
				if (selected.is_empty()) {
					selected.push(tile);
				} else {
					if (selected.top.next_to(tile)) {
						selected.push(tile);
					} else {
						selected.pop_all();
					}
				}
			} else {
				// TODO handle unselect
				if (selected.top == tile) {
					selected.pop();
				} else {
					selected.pop_all();
				}
			}
			if (selected.is_full()) {
				select_done();
			}
		} else if (event.target == giveUp) {
			do_gameover();
		}
	}
	
	public function click_final(event:MouseEvent):Void {
		selected.pop_all();
	}
	
	private function this_onMouseOver(event:MouseEvent):Void {
		if (event.buttonDown && Std.is(event.target, Tile)) {
			var tile = cast(event.target, Tile);
			tile.set_marked();
		}
	}
	
	private function this_onMouseMove(event:MouseEvent):Void {
		// TODO seems target is not working but the event
		// is properly fired. now uses a hacky way to set mark
		if (event.buttonDown && Std.is(event.target, Tile)) {
			var tile = cast(event.target, Tile);
			tile.set_marked();
		}
	}
	
	private function giveup_onClick(event:MouseEvent):Void {
		
	}
}
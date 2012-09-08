package com.pre_sence.mm;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.display.Sprite;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;
import com.eclecticdesignstudio.motion.easing.Quad;


class Tile extends Sprite
{
	public static var tileTextFormat:TextFormat;
	public static var tilePool:Array<Tile>;
	private static var tilePoolSize:Int = 150;
	
	static public function static_init():Void {
		tileTextFormat = new TextFormat(Auxi.latoFont.fontName,
			32, Auxi.backColor);
		tileTextFormat.align = TextFormatAlign.CENTER;
		
		tilePool = new Array<Tile>();
		for (ix in 0...tilePoolSize) {
			tilePool.push(new Tile());
		}
	}
	
	static public function get_avail_tile():Tile {
		for (tile in tilePool) {
			if (!tile.alive)
				return tile;
		}
		throw "not enough tiles in the pool";
	}

	private var field:TextField;
	private var block:Sprite;
	public var moving:Bool;
	public var alive:Bool;
	public var selected(default, set_select):Bool;
	
	public var value(default, set_value):Int;
	public var row:Int;
	public var col:Int;
	
	
	public function new() 
	{
		super();
		
		field = new TextField();
		field.embedFonts = true;
		field.selectable = false;
		field.defaultTextFormat = tileTextFormat;
		field.width = 40;
		field.height = 40;
		field.x = 1;
		field.y = -1;
		
		// bounding box
		block = new Sprite();
		block.graphics.lineStyle(1.0, Auxi.borderColor);
		block.graphics.beginFill(Auxi.fontColor);
		block.graphics.drawRect(0, 0, 42, 42);
		
		addChild(block);
		addChild(field); // field is on top
		
		visible = false; // start out invisible
		moving = false;
		alive = false;
		mouseChildren = false; // only Tile receives mouse events
	}
	
	public function reset(x_:Float, y_:Float, value_:Int) {
		// use this to recycle 
		x = x_;
		y = y_;
		set_value(value_);
		visible = true;
		alive = true;
	}
	
	public function set_value(v:Int):Int {
		value = v;
		field.text = Std.string(value);
		return value;
	}
	
	public function drop_to(new_y:Float) {
		Auxi.assert(new_y > y, "must drop to a lower position");
		moving = true;
		var duration = (new_y - y) * 0.002;
		Actuate.tween(this, duration, { y:new_y })
			   .onComplete(on_drop_complete)
			   .ease(Quad.easeIn);
	}
	
	public function kill() {
		moving = true;
		// kill animation
		Actuate.tween(this, 0.2, { scaleX:0, scaleY:0,
			x:x + width / 2, y:y + height / 2 } )
			   .onComplete(on_klll_complete)
			   .ease(Quad.easeOut);
	}
	
	public function next_to(tile:Tile):Bool {
		var dist:Int = (row - tile.row) * (col - tile.col);
		return dist >= -1 && dist <= 1;
	}
	
	private function set_select(sel:Bool):Bool {
		if (selected == sel) return sel;
		selected = sel;
		
		if (selected) {
			Actuate.transform(block, 0.2).color(Auxi.selectedColor);
		} else {
			Actuate.transform(block, 0.2).color(Auxi.fontColor);
		}
		return selected;
	}
	
	// handlers
	private function on_drop_complete() {
		moving = false;
	}
	
	private function on_klll_complete() {
		moving = false;
		visible = false;
		alive = false;
		parent.removeChild(this);
	}
	
}
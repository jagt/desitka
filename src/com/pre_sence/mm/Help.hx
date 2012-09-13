package com.pre_sence.mm;
import nme.text.TextField;
import nme.display.Sprite;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.TextFieldAutoSize;
import Tile.State;

/**
 * ...
 * @author lilo
 */

// ugly ugly code for a single page help
class Graph extends Sprite
{
	public var t1:Tile;
	public var t2:Tile;
	public var t3:Tile;
	public var text:TextField;
	
	public function new(line:String) {
		super();
		t1 = new Tile();
		t2 = new Tile();
		t3 = new Tile();
		t1.reset(0, 0, 2);
		t2.reset(Auxi.tileSize, Auxi.tileSize, 5);
		t3.reset(Auxi.tileSize * 2, Auxi.tileSize, 3);
		addChild(t1);
		addChild(t2);
		addChild(t3);
		
		var format = new TextFormat(Auxi.latoFont.fontName, 32, Auxi.fontColor);
		format.align = TextFormatAlign.LEFT;
		
		text = new TextField();
		Auxi.set_field(text, format);
		text.autoSize = TextFieldAutoSize.LEFT;
		text.x = t3.x + Auxi.tileSize*1.4;
		text.y = Auxi.tileSize / 2;
		text.text = line;
		
		addChild(text);
		this.x = 10; // hack to add some padding
	}
}

class AltGraph extends Graph {
	public function new(line:String) {
		super(line);
		t1.y = Auxi.tileSize;
		t2.y = 0;
		t1.value = 3;
		t2.value = 9;
		t3.value = 5;
	}
}

class Help extends Sprite
{
	// very stupid way to create the help
	public function new() 
	{
		super();
		
		var g1 = new Graph("Here're blocks with numbers.");
		var g2 = new Graph("Click to select 3 neighbors.");
		var g3 = new Graph("If sum is a factor of 10, +10");
		
		g1.y = 10;
		g2.y = Auxi.tileSize * 2.5 + 10;
		g3.y = Auxi.tileSize * 5 + 10;
		g2.t1.state = g2.t2.state = State.Selected;
		g3.t1.state = g3.t2.state = g3.t3.state = State.Summed;
		
		addChild(g1);
		addChild(g2);
		addChild(g3);
		
		// part to 
		var start_y = g3.y + 2.5 * Auxi.tileSize;
		
		var a1 = new AltGraph("If not, 2 blocks be gone.");
		var a2 = new AltGraph("Last block becomes modded 10.");
		
		a1.y = start_y;
		a2.y = a1.y + 2.5 * Auxi.tileSize;
		a1.t1.state = a1.t2.state = State.Selected;
		a2.t1.visible = a2.t2.visible = false;
		a2.t3.value = 7;
		
		addChild(a1);
		addChild(a2);
		
		// PASTA!
		var format = new TextFormat(Auxi.latoFont.fontName, 32, Auxi.fontColor);
		format.align = TextFormatAlign.LEFT;
		
		var last = new TextField();
		Auxi.set_field(last, format);
		last.autoSize = TextFieldAutoSize.LEFT;
		last.text = "  Puzzle : Combo by grouping adjacent +10s.\n  Zen : Fixed amount of blocks.";
		last.y = a2.y + 2.5 * Auxi.tileSize;
		addChild(last);
		
		x = -Auxi.screenWidth * 2;
		this.mouseEnabled = false;
		this.mouseChildren = false;
	}
	
	public function resize(sWidth:Int, sHeight:Int) {
		// PASTA
		var scale = 1.0;
		var w = width;
		var h = height;
		if (w > sWidth || h > sHeight) {
			// add a padding to width
			var new_scale_x = sWidth / w;
			var new_scale_y = sHeight / h;
			scale = Math.min(new_scale_x, new_scale_y);
			scaleX = scaleY = scale;
		}
		// TODO this does not match, which is weird...
		//x = Math.round( (sWidth - width) / 2 );
		y = Math.round( (sHeight - height) / 2 );
	}
}
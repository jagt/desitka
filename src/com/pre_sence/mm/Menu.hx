package com.pre_sence.mm;
import nme.display.SimpleButton;
import nme.display.Sprite;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.TextFieldAutoSize;
import nme.net.SharedObject;

/**
 * ...
 * @author lilo
 */

class Menu extends Sprite
{
	public var logo:TextField;
	public var puzzleMode:TextField;
	public var zenMode:TextField;
	public var help:TextField;
	public var shared:SharedObject;
	public var puzzleHi:TextField;
	public var zenHi:TextField;
	
	public function new() 
	{
		super();
		var logoFormat = new TextFormat(Auxi.latoFont.fontName,
			100, Auxi.fontColor);
		logo = new TextField();
		logo.defaultTextFormat = logoFormat;
		logo.text = "desitka";
		logo.embedFonts = true;
		logo.autoSize = TextFieldAutoSize.LEFT;
		logo.selectable = false;

		puzzleMode = Auxi.make_button("Puzzle Mode");
		zenMode = Auxi.make_button("Zen Mode");
		help = Auxi.make_button("Help");
		
		addChild(logo);
		addChild(puzzleMode);
		addChild(zenMode);
		addChild(help);
		
		shared = SharedObject.getLocal("disatka-shared");
		if (shared.data.puzzle_high == null) {
			shared.data.puzzle_high = 0;
		}
		if (shared.data.zen_high == null) {
			shared.data.zen_high = 0;
		}
		
		var hiFormat = new TextFormat(Auxi.latoBoldFont.fontName,
			16, Auxi.fontColor);
		hiFormat.align = TextFormatAlign.LEFT;
		
		puzzleHi = new TextField();
		zenHi = new TextField();
		Auxi.set_field(puzzleHi, hiFormat);
		Auxi.set_field(zenHi, hiFormat);
		puzzleHi.autoSize = TextFieldAutoSize.LEFT;
		zenHi.autoSize = TextFieldAutoSize.LEFT;
		puzzleHi.text = "High Score : " + shared.data.puzzle_high;
		zenHi.text = "High Score : " + shared.data.zen_high;
		addChild(puzzleHi);
		addChild(zenHi);
		
		flush_shared();
	}
	
	public function set_score(is_puzzle:Bool, n:Int) {
		if (is_puzzle) {
			if (n > shared.data.puzzle_high) {
				shared.data.puzzle_high = n;
				puzzleHi.text = "High Score : " + n;
			} else {
				return;
			}
		} else {
			if (n > shared.data.zen_high) {
				shared.data.zen_high = n;
				zenHi.text = "High Score : " + n;
			} else {
				return;
			}
		}
		flush_shared();
	}
	
	private function flush_shared():Void {
		// flush and center
		try {
			shared.flush() ;      // Save the object
		} catch ( e:Dynamic ) {
			trace("shared object flushing error");
		}
		puzzleHi.x = Auxi.center(puzzleHi.width, Auxi.screenWidth);
		zenHi.x = Auxi.center(zenHi.width, Auxi.screenWidth);
	}

	public function resize(sWidth:Int, sHeight:Int) {
		logo.x = Auxi.center(logo.width, sWidth);
		puzzleMode.width = zenMode.width = help.width = 0.6 * sWidth;
		puzzleMode.x = Auxi.center(puzzleMode.width, sWidth);
		zenMode.x = Auxi.center(zenMode.width, sWidth);
		help.x = Auxi.center(help.width, sWidth);
		
		// vertical TODO use elastic layout someday..
		// very stupid vertical layout trying to fill
		// up the whole screen
		logo.y = 64;
		var remain = sHeight - logo.y - logo.height - 64;
		var gap = (remain - 60 * 3) / 4;
		trace(remain);
		trace(gap);
		puzzleMode.y = logo.y + logo.height + gap;
		zenMode.y = puzzleMode.y + 60 + gap;
		help.y = zenMode.y + 60 + gap;
		
		// layout high scores
		puzzleHi.y = puzzleMode.y + puzzleMode.height + 2;
		zenHi.y = zenMode.y + zenMode.height + 2;
		
	}
	
}
package com.pre_sence.mm;
import nme.display.SimpleButton;
import nme.display.Sprite;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.TextFieldAutoSize;

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
		
	}
	
}
package com.pre_sence.mm;

import nme.Assets;
import nme.media.Sound;
import nme.text.Font;
import nme.text.TextFormat;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.TextFieldAutoSize;

/**
 * ...
 * @author lilo
 */

class Auxi 
{

	static public var latoFont:Font;
	static public var latoBoldFont:Font;
	static public var buttonFormat:TextFormat;
	// japan pallete form ColourLovers
	static public var fontColor:Int = 0xE5E7BF;
	static public var borderColor:Int = 0xDDDFB8;
	static public var selectedColor:Int = 0x7C9997;
	static public var backColor:Int = 0x3B4970;
	static public var summedColor:Int = 0xEFBAC2;
	static public var dropColor:Int = 0xEFE3E5;
	static public var popColor:Int = 0x845567;
	static public var markColor:Int = 0xFBC058;
	
	static public var tileSize:Int = 62;
	
	static public var screenWidth:Int;
	static public var screenHeight:Int;
	
	static public var selectSnd:Sound;
	static public var deselectSnd:Sound;
	static public var sumSnd:Sound;
	static public var clearSnd:Sound;
	static public var overSnd:Sound;

	static public function static_init():Void {
		latoFont = Assets.getFont("assets/Lato-Lig.ttf");
		latoBoldFont = Assets.getFont("assets/Lato-Bol.ttf");
		
		screenWidth = Lib.current.stage.stageWidth;
		screenHeight = Lib.current.stage.stageHeight;
		
		buttonFormat = new TextFormat(Auxi.latoFont.fontName,
			40, Auxi.backColor);
		buttonFormat.align = TextFormatAlign.CENTER;
		
		// load sounds
		selectSnd = Assets.getSound("assets/select.wav");
		deselectSnd = Assets.getSound("assets/deselect.wav");
		sumSnd = Assets.getSound("assets/sum.wav");
		clearSnd = Assets.getSound("assets/clear.wav");
		overSnd = Assets.getSound("assets/over.wav");
	}
	
	static public function assert(cond:Bool, msg:String = "assert error") {
		#if release
		return; // reality check bitch!
		#end
		if (!cond) {
			throw msg;
		}
	}
	
	static inline public function int_max(a:Int, b:Int):Int {
		return a > b ? a : b;
	}
	
	static inline public function int_abs(a:Int):Int {
		return a > 0 ? a : -a;
	}
	
	static inline public function center(target:Float, parent:Float):Float {
		return (parent - target) / 2;
	}
	
	static public function make_button(text:String):TextField {
		var but = new TextField();
		but.defaultTextFormat = buttonFormat;
		but.background = true;
		but.backgroundColor = Auxi.fontColor;
		but.embedFonts = true;
		but.text = text;
		but.height = 60;
		but.selectable = false;
		return but;
	}
	
	static public function set_field(field:TextField, format:TextFormat):Void {
		field.defaultTextFormat = format;
		field.embedFonts = true;
		field.selectable = false;
	}
}
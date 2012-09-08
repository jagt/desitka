package com.pre_sence.mm;

import nme.Assets;
import nme.text.Font;
import nme.text.TextFormat;
import nme.Lib;

/**
 * ...
 * @author lilo
 */

class Auxi 
{

	static public var latoFont:Font;
	
	// japan pallete form ColourLovers
	static public var fontColor:Int = 0xE5E7BF;
	static public var borderColor:Int = 0xDDDFB8;
	static public var selectedColor:Int = 0x7C9997;
	static public var backColor:Int = 0x3B4970;
	
	static public var tileSize:Int = 42;
	
	static public var screenWidth:Int;
	static public var screenHeight:Int;
	

	static public function static_init():Void {
		latoFont = Assets.getFont("assets/Lato-Lig.ttf");
		
		screenWidth = Lib.current.stage.stageWidth;
		screenHeight = Lib.current.stage.stageHeight;
	}
	
	static public function assert(cond:Bool, msg:String="assert error") {
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
}
package com.pre_sence.mm;
import nme.geom.Point;
import nme.display.Sprite;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.text.TextFieldAutoSize;
import com.eclecticdesignstudio.motion.Actuate;

/**
 * ...
 * @author lilo
 */

class Popup
{
	private static var CAP:Int = 10;
	private static var format:TextFormat;
	public var texts:Array<TextField>;
	
	public static function static_init():Void {
		format = new TextFormat(Auxi.latoBoldFont.fontName,
			32, Auxi.popColor);
		format.align = TextFormatAlign.LEFT;
	}
	
	public function new(parent:Sprite) 
	{
		texts = new Array<TextField>();
		for (ix in 0...CAP) {
			var field = new TextField();
			field.embedFonts = true;
			field.selectable = false;
			field.defaultTextFormat = format;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.visible = false;
			field.mouseEnabled = false;
			texts.push(field);
			parent.addChild(field);
		}
	}
	
	public function get_first_avail():TextField {
		for (field in texts) {
			if (!field.visible) {
				return field;
			}
		}
		throw "not enough textfields";
	}
	
	public function show_at_tile(tile:Tile, value:String) {
		var field = get_first_avail();
		field.visible = true;
		field.text = value;
		var globpos = tile.localToGlobal(new Point(0, 0));
		field.x = globpos.x + Auxi.center(field.width, Auxi.tileSize);
		field.y = globpos.y;
		var dist = Auxi.tileSize * 0.7;
		Actuate.tween(field, 1.0, { y:field.y - dist } ).onComplete(function():Void {
			Actuate.apply(field, { visible:false } );
		});
	}
}
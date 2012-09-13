package com.pre_sence.mm;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;
import nme.display.BitmapData;
import nme.display.Sprite;

/**
 * ...
 * @author lilo
 */

class Background extends Sprite
{
	private var tile:BitmapData;
	public function new(tile_:BitmapData) 
	{
		super();
		var w = Auxi.screenWidth * 2;
		var h = Auxi.screenHeight * 2;
		tile = tile_;
		
		Auxi.assert(w % tile.width == 0);
		Auxi.assert(h % tile.height == 0);
		
		graphics.beginBitmapFill(tile, true);
		graphics.drawRect(0, 0, w, h);
		graphics.endFill();
		
		x = -Auxi.screenWidth;
		y = -Auxi.screenHeight;
		
		Actuate.tween(this, 60, { x:0, y:0 } )
			   .repeat()
			   .ease(Linear.easeNone);
	}

	
}
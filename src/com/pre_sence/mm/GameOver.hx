package com.pre_sence.mm;
import nme.events.MouseEvent;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.display.Sprite;
import nme.text.TextFormat;
import nme.system.System;

/**
 * ...
 * @author lilo
 */

class GameOver extends Sprite
{
	public var gameOver:TextField;
	public var score:TextField;
	public var back:TextField;
	
	public function new() 
	{
		super();
		var format = new TextFormat(Auxi.latoFont.fontName,
			40, Auxi.fontColor);
		gameOver = new TextField();
		Auxi.set_field(gameOver, format);
		gameOver.text = "Game Over.";
		gameOver.autoSize = TextFieldAutoSize.LEFT;
		
		score = new TextField();
		Auxi.set_field(score, format);
		score.text = "Score :";
		score.autoSize = TextFieldAutoSize.LEFT;
		
		back = Auxi.make_button("Back");
		
		addChild(gameOver);
		addChild(score);
		addChild(back);
		
		x = -Auxi.screenWidth;
		
		back.addEventListener(MouseEvent.CLICK, back_onClick);
	}
	
	public function resize(sWidth:Int, sHeight:Int) {
		gameOver.x = Auxi.center(gameOver.width, sWidth);
		score.x = Auxi.center(score.width, sWidth);
		back.x = Auxi.center(back.width, sWidth);
		
		var mid = sHeight / 2;
		gameOver.y = mid - gameOver.height - 48;
		score.y = mid;
		back.y = score.y + score.height + 48;
	}
	
	// handlers
	private function back_onClick(event:MouseEvent):Void {
		// Hacky way to avoid player click on Back too early
		if (Main.instance.game != null) {
			Main.instance.game.destroy();
		}
		Main.instance.transit(this, Main.instance.menu, true);
		trace(Main.instance.numChildren);
		trace("Mem:"+System.totalMemory);
		System.gc();
		trace("Mem:"+System.totalMemory);
	}
	
}
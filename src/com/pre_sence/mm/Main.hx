package com.pre_sence.mm;
import nme.Assets;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.events.MouseEvent;
import com.eclecticdesignstudio.motion.Actuate;

class Main extends Sprite 
{
	var game:Game;
	var bg:Background;
	
	public function new() 
	{
		super();

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(e)
	{
		// entry point
		// do static inits
		Auxi.static_init();
		Tile.static_init();
		Popup.static_init();
		
		bg = new Background(Assets.getBitmapData("assets/tile.png"));
		addChild(bg);
		
		game = new ChainGame();
		game.resize(Auxi.screenWidth, Auxi.screenHeight);
		addChild(game);
		
		bg.addEventListener(MouseEvent.CLICK, game.click_final);
		
		Lib.current.stage.addEventListener(Event.ACTIVATE, stage_on_activate);		
		Lib.current.stage.addEventListener(Event.DEACTIVATE, stage_on_deactivate);
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		//stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());

	}
	
	// handlers
	private function stage_on_activate(event:Event):Void {
		Actuate.resumeAll();
	}
	
	private function stage_on_deactivate(event:Event):Void {
		Actuate.pauseAll();
	}
	
}

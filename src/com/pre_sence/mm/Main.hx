package com.pre_sence.mm;
import nme.Assets;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.events.MouseEvent;
import nme.ui.Multitouch;
import nme.ui.MultitouchInputMode;
import com.eclecticdesignstudio.motion.Actuate;

class Main extends Sprite 
{
	public static var instance:Main;
	var game:Game;
	var menu:Menu;
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
		
		menu = new Menu();
		menu.resize(Auxi.screenWidth, Auxi.screenHeight);
		addChild(menu);
		
		Lib.current.stage.addEventListener(Event.ACTIVATE, stage_on_activate);		
		Lib.current.stage.addEventListener(Event.DEACTIVATE, stage_on_deactivate);
		menu.puzzleMode.addEventListener(MouseEvent.CLICK, puzzle_click_puzzle);
	}
	
	public function transit(from:Sprite, to:Sprite, backward:Bool = false) {
		if (!backward) {
			to.x = Auxi.screenWidth;
			Actuate.tween(from, 1.0, { x: -Auxi.screenWidth } );
			Actuate.tween(to, 1.0, { x: 0 } );
		} else {
			to.x = -Auxi.screenWidth;
			Actuate.tween(from, 1.0, { x: Auxi.screenWidth } );
			Actuate.tween(to, 1.0, { x: 0 } );
		}
	}

	
	// handlers
	private function stage_on_activate(event:Event):Void {
		Actuate.resumeAll();
	}
	
	private function stage_on_deactivate(event:Event):Void {
		Actuate.pauseAll();
	}
	
	private function puzzle_click_puzzle(event:Event):Void {
		game = new ChainGame(120);
		game.resize(Auxi.screenWidth, Auxi.screenHeight);
		addChild(game);
		bg.addEventListener(MouseEvent.CLICK, game.click_final);
		transit(menu, game);
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		//stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		
		instance = new Main();
		Lib.current.addChild(instance);
	}
}

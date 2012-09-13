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
	public var game:Game;
	public var menu:Menu;
	public var over:GameOver;
	public var help:Help;
	public var bg:Background;
	
	private var is_helping:Bool;
	
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
		
		over = new GameOver();
		over.resize(Auxi.screenWidth, Auxi.screenHeight);
		addChild(over);
		
		help = new Help();
		help.resize(Auxi.screenWidth, Auxi.screenHeight);
		addChild(help);
		is_helping = false;
		
		Lib.current.stage.addEventListener(Event.ACTIVATE, stage_on_activate);		
		Lib.current.stage.addEventListener(Event.DEACTIVATE, stage_on_deactivate);
		menu.puzzleMode.addEventListener(MouseEvent.CLICK, puzzle_click_puzzle);
		menu.zenMode.addEventListener(MouseEvent.CLICK, zen_click_zen);
		menu.help.addEventListener(MouseEvent.CLICK, help_click_help);
		bg.addEventListener(MouseEvent.CLICK, bg_on_click);
	}
	
	public function transit(from:Sprite, to:Sprite, ?cb:Void->Void, backward:Bool = false) {
		if (!backward) {
			to.x = Auxi.screenWidth;
			Actuate.tween(from, 1.0, { x: -Auxi.screenWidth } );
			Actuate.tween(to, 1.0, { x: 0 } ).onComplete(cb);
		} else {
			to.x = -Auxi.screenWidth;
			Actuate.tween(from, 1.0, { x: Auxi.screenWidth } );
			Actuate.tween(to, 1.0, { x: 0 } ).onComplete(cb);
		}
	}
	
	public function game_over() {
		transit(game, over, game.destroy);
		over.score.text = "Score : " + game.score;
		over.score.x = Auxi.center(over.score.width, Auxi.screenWidth);
	}

	
	// handlers
	private function stage_on_activate(event:Event):Void {
		Actuate.resumeAll();
	}
	
	private function stage_on_deactivate(event:Event):Void {
		Actuate.pauseAll();
	}
	
	private function puzzle_click_puzzle(event:Event):Void {
		Auxi.assert(game == null);
		game = new ChainGame(180);
		game.resize(Auxi.screenWidth, Auxi.screenHeight);
		addChild(game);
		transit(menu, game);
	}
	
	private function help_click_help(event:Event):Void {
		transit(menu, help);
		is_helping = true;
	}
	
	private function zen_click_zen(event:Event):Void {
		Auxi.assert(game == null);
		game = new PeaceGame();
		game.resize(Auxi.screenWidth, Auxi.screenHeight);
		addChild(game);
		transit(menu, game);
	}
	
	private function bg_on_click(event:MouseEvent):Void {
		// avoid handlers to avoid memleak
		if (game != null) {
			game.click_final(event);
		}
		
		if (is_helping) {
			transit(help, menu, true);
			is_helping = false;
		}
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

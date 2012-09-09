package com.pre_sence.mm;

import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;


class Main extends Sprite 
{
	var game:Game;
	
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
		
		game = new ChainGame();
		game.resize(Auxi.screenWidth, Auxi.screenHeight);
		addChild(game);
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		//stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
}

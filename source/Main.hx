package;

import flixel.FlxGame;
import funkin.backend.FPS_Mem;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		addChild(new FlxGame(0, 0, InitState, 200, 200, true));

		#if !mobile
		addChild(new FPS_Mem(10, 3, 0xFFFFFF));
		#end
	}
}

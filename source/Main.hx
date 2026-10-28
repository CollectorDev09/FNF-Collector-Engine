package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import funkin.game.PlayState;
import funkin.backend.modding.Mods;

class Main extends Sprite
{
	public function new()
	{
		super();

		Mods.init();

		addChild(new FlxGame(0, 0, PlayState, 120, 120, true));

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end
	}
}

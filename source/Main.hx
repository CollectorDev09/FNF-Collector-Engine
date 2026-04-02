package;

import flixel.FlxGame;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.display.Sprite;
import funkin.menus.TitleState;

class Main extends Sprite
{
	public static var fnfVer:String = "0.2.7";
	public static var cdevVer:String = "0.0.1";

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState, 120, 120));

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end
	}
}

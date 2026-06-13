package funkin.config;

import flixel.FlxG.stage;
import openfl.events.KeyboardEvent;
import flixel.addons.ui.FlxUIState;
import openfl.ui.Keyboard;
import openfl.events.EventType;

class Controls extends FlxUIState
{
	public static var gameBinds:Array<Int> = [87, 69, 73, 79];

	public static var keyPressed:Int;

	public static var UP:Bool;

	public static var ACCEPT:Bool;

	public function getKeyPress()
	{

	}

	public function onKeyDown(e:KeyboardEvent):Void
	{
		keyPressed = e.keyCode;
	}

	public function onKeyUp(e:KeyboardEvent):Void
	{
		keyPressed = 0;
	}
}
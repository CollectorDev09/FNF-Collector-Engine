package funkin.game;

import flixel.FlxG.stage;
import flixel.input.keyboard.FlxKey;
import openfl.events.EventType;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class InputSystem
{
	// Input System stuff
	var justPressed:Bool;
	static var keysPressed:Array<Bool> = [for (i in 0...4) false];
	var keys:Array<Int>;
    public static var isNoteDirection:Bool = false;
    public static var keyID:Int = -1;

    public static function checkInputPress(e:KeyboardEvent):Void 
    {
        final id:Int = convertStrumKey(keysPressed.length, e.keyCode);
        if (keysPressed[id]) return;
        keysPressed[id] = true;

        var k = e.keyCode;
		
        // trace('just pressed: $id');

        keyID = id;

		if (id == -1)
        {
            isNoteDirection = false;
        }
        else
        {
            isNoteDirection = true;
        }
    }

    @:noDebug @:pure public static function convertStrumKey(keyAmount:Int, key:FlxKey):Int 
    {
        if (key == NONE) return -1;
        for (i in 0...keyAmount) 
        {
			var possibleKey = Controls.gameBinds[i];
			if (key == possibleKey) return i;
        }

        return -1;
    }

    public static function checkInputRelease(e:KeyboardEvent):Void 
    {
        final id:Int = convertStrumKey(keysPressed.length, e.keyCode);
        keysPressed[id] = false;
        // trace('released: $id');

        keyID = id;

		if (id == -1) return;
    }
}
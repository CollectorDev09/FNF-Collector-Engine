package funkin.backend;

import flixel.input.FlxKeyManager;
import flixel.input.keyboard.FlxKey;

class Controls
{
    public static var gameBinds:Array<Int> = [87, 69, 73, 79];

    public static var keyBinds:Map<String, Int> = ["ACCEPT" => 13];

    public static function keybindPressed(keybind:String)
    {
        var bind:Int = keyBinds.get(keybind);

        var key:FlxKey = bind;
        
        if (!FlxG.keys.anyPressed([key]))
        {
            return false;
        }

        return true;
    }

    public static function keybindJustPressed(keybind:String)
    {
        var bind:Int = keyBinds.get(keybind);

        var key:FlxKey = bind;
        
        if (!FlxG.keys.anyJustPressed([key]))
        {
            return false;
        }

        return true;
    }
}
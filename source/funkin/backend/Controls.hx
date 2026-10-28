package funkin.backend;

import flixel.input.FlxKeyManager;
import flixel.input.keyboard.FlxKey;

class Controls
{
    public static var gameBinds:Array<Int> = [87, 69, 73, 79];

    public static var keyBinds:Map<String, Array<FlxKey>> = ["ACCEPT" => [ENTER, SPACE], "UP" => [UP, W], "DOWN" => [DOWN, S], "LEFT" => [LEFT, A], "RIGHT" => [RIGHT, D]];

    public static function keybindPressed(keybind:String)
    {
        var binds:Array<FlxKey> = keyBinds.get(keybind);
        
        if (!FlxG.keys.anyPressed(binds))
        {
            return false;
        }

        return true;
    }

    public static function keybindJustPressed(keybind:String)
    {
        var binds:Array<FlxKey> = keyBinds.get(keybind);
        
        if (!FlxG.keys.anyJustPressed(binds))
        {
            return false;
        }

        return true;
    }
}
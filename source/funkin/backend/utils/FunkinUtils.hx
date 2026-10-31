package funkin.backend.utils;

import lime.utils.Assets;
import haxe.DynamicAccess;
import haxe.Json;
import funkin.backend.modding.Mods;

class FunkinUtils
{
    public static function parseJSON(path:String)
    {
        var json = Json.parse(Assets.getText('$path'));
        return json;
    }

    public static function parseText(path:String)
    {
        var text = Assets.getText('$path');
        text = Mods.appendText(text, path);
        return text;
    }

    public static function getAverage(array:Array<Float>) 
    {
        var sum:Float = 0;
        var average:Float = 0;

        for (number in array)
        {
            sum += number;
        }

        average = sum/array.length;
        return average;
    }

    public static function playMenuSound(sound:String)
    {
        FlxG.sound.play(Paths.sound('${sound}Menu'));
    }
}
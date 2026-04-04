package utils;

import lime.utils.Assets;
import funkin.menus.TitleState;
import haxe.Json;

class Paths
{
    public static function song(key:String)
    {
        return 'assets/songs/$key' + TitleState.soundExt;
    }

    public static function sound(key:String)
    {
        return 'assets/sounds/$key' + TitleState.soundExt;
    }

    public static function json(key:String)
    {
        return Json.parse(Assets.getText('assets/data/$key.json'));
    }

    public static function getInst(key:String)
    {
        return song('$key/Inst');
    }
    
    public static function getVoices(key:String)
    {
        return song('$key/Voices');
    }

    public static function img(key:String, ?type:String)
    {
        if (type == null)
        {
            return 'assets/images/$key.png';
        }
        else
        {
            return 'assets/images/$key.$type';
        }
    }
}
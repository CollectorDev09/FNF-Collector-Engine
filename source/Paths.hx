package;

import lime.utils.Assets;
import haxe.Json;
import sys.io.File.*;

class Paths
{
    static public var soundExt:String = '.ogg';

    public static function mods(key:String) 
    {
        return 'mods/$key';
    }

    public static function song(key:String)
    {
        return 'assets/songs/$key$soundExt';
    }

    public static function sound(key:String)
    {
        return 'assets/sounds/$key$soundExt';
    }

    public static function music(key:String)
    {
        return 'assets/music/$key$soundExt';
    }

    public static function json(key:String)
    {
        return Json.parse(getContent('assets/data/$key.json'));
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

    public static function images(key:String, ?type:String)
    {
        if (type == null)
        {
            return Paths.img(key);
        }
        else
        {
            return Paths.img(key, type);
        }
    }
}
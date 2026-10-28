package funkin.backend.utils;

import lime.utils.Assets;
import haxe.Json;

using StringTools;

class Paths
{
    static public var soundExt:String = '.ogg';

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
        return 'assets/data/$key.json';
    }

    public static function txt(key:String)
    {
        return 'assets/data/$key.txt';
    }

    public static function getInst(key:String)
    {
        trace('Inst: $key');
        return song('${key}/Inst');
    }
    
    public static function getVoiceTrack(songName:String, trackName:String)
    {
        return song('${songName}/Voices-${trackName}');
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

    public static function image(key:String, ?type:String)
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

    public static function sparrow(key:String)
    {
        return FlxAtlasFrames.fromSparrow(Paths.img(key), Paths.img(key, 'xml'));
    }
}
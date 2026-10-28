package funkin.backend.utils;

import funkin.backend.modding.Mods;
import haxe.Json;
import lime.utils.Assets;
import sys.FileSystem;

using StringTools;

class Paths
{
    static public var soundExt:String = '.ogg';

    public static function getPath(key:String)
    {
        var path:String = null;

        if (Assets.exists('assets/$key'))
        {
            path = 'assets/$key';
        }

        path = Mods.getModPath('assets/$key');

        return path;
    }

    public static function song(key:String)
    {
        return getPath('songs/$key$soundExt');
    }

    public static function sound(key:String)
    {
        return getPath('sounds/$key$soundExt');
    }

    public static function music(key:String)
    {
        return getPath('music/$key$soundExt');
    }

    public static function json(key:String)
    {
        return getPath('data/$key.json');
    }

    public static function txt(key:String)
    {
        return getPath('data/$key.txt');
    }

    public static function getInst(songName:String)
    {
        return song('${songName}/Inst');
    }
    
    public static function getVoiceTrack(songName:String, trackName:String)
    {
        return song('${songName}/Voices-${trackName}');
    }

    public static function img(key:String, ?type:String)
    {
        if (type == null)
        {
            return getPath('images/$key.png');
        }
        else
        {
            return getPath('images/$key.$type');
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
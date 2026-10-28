package funkin.backend.modding;

import openfl.Assets;
import sys.FileSystem;

class Mods
{
    public static function init() 
    {
        if (!FileSystem.isDirectory('mods'))
        {
            trace('Creating mod folder');
            FileSystem.createDirectory('mods');
        }
    }

    public static function loadMods()
    {
        
    }

    public static function getModPath(path:String)
    {
        
    }

    public static function appendText()
    {
        
    }
}
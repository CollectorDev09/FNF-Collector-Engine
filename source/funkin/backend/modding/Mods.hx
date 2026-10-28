package funkin.backend.modding;

import openfl.Assets;
import sys.FileSystem;

class Mods
{
    static var modFolders:Array<String> = [];

    public static function init() 
    {
        if (!FileSystem.isDirectory('mods/'))
        {
            trace('Creating mod folder');
            FileSystem.createDirectory('mods/');
        }

        loadMods();
    }

    public static function loadMods()
    {
        var modsDirectory = FileSystem.readDirectory('mods/');

        for (i=>item in modsDirectory)
        {
            if (FileSystem.isDirectory('mods/${modsDirectory[i]}'))
            {
                modFolders.push(item);
            }
        }

        trace(modFolders);
    }

    public static function getModPath(path:String)
    {
        if (modFolders.length == 0 || !StringTools.startsWith(path, 'assets/')) return path;

        for (mod in modFolders)
        {
            var modPath:String = StringTools.replace(path, 'assets/', 'mods/$mod/');
            if (FileSystem.exists(modPath))
            {
                return modPath;
            }
        }

        return path;
    }

    public static function appendText(text:String, path:String):String
    {
        if (modFolders.length == 0 || !StringTools.startsWith(path, 'assets/')) return text;

        for (mod in modFolders)
        {
            path = StringTools.replace(path, 'assets/', 'mods/$mod/_append/');
            var append = Assets.getText('$path');
            trace(path);
            if (append != null)
            {
                text += '\n${append}';
            }
        }

        trace(text);

        return text;
    }
}
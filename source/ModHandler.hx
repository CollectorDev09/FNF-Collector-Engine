package;

import sys.FileSystem;
import sys.io.File.*;
import haxe.Json;
import lime.app.Application;

class ModHandler
{
	public static function getAllMods()
	{
		var modsPath:Array<String> = FileSystem.readDirectory('mods');

		var mods:Array<String> = [];

		for (i in 0...modsPath.length)
		{
			if (FileSystem.isDirectory(Paths.mods(modsPath[i])))
			{
				mods.push(modsPath[i]);
			}
		}

		return mods;
	}

	public static function getMetadata(mod:String)
	{
		var daMeta:Array<String> = [];
		if (FileSystem.exists(Paths.mods(mod + '/meta.json')))
		{
			trace('Metadata found for: $mod');
			daMeta = Json.parse(getContent(Paths.mods('$mod/meta.json')));
		}
		else
		{
			Application.current.window.alert('Could not find metadata for: $mod', 'Error');
		}

		return daMeta;
	}

	public static function getModContent(key:String)
	{
		var modArray = getAllMods();
		var contentArray:Array<String> = [];
		
		for (i in 0...modArray.length)
		{
			trace(Paths.mods(modArray[i] + '/$key'));
			if (FileSystem.exists(Paths.mods(modArray[i] + '/$key')))
			{
				var content = getContent(Paths.mods(modArray[i] + '/$key'));
				contentArray.push(content);
			}
		}

		return contentArray;
	}
}
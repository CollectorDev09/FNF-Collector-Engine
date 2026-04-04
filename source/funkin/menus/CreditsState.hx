package funkin.menus;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import funkin.music.MusicBeatState;

class CreditsState extends MusicBeatState
{
    override function create()
    {
        var text = new FlxText(0, FlxG.height - 18, 0, "This is a work in progress...");
        text.scrollFactor.set();
        text.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.antialiasing = true;
        add(text);
    }

    override function update(elapsed:Float)
    {
    	if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}    
    }
}
package funkin.menus;

import utils.Paths;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import funkin.music.MusicBeatState;

using StringTools;

class CreditsState extends MusicBeatState
{
    var credits:Array<String>;
    var curSelected:Int = 0;
    var creditGroup:FlxTypedGroup<Alphabet>;

    override function create()
    {
        credits = ["#Funkin Crew Inc", "Ninjamuffin99", "PhantomArcade", "KawaiSprite", "Evilsker", "#Collector Engine", "CollectorDev"];
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.img('menus/menuBGBlue'));
		add(bg);
        var text = new FlxText(0, FlxG.height - 18, 0, "This is a work in progress...");
        text.scrollFactor.set();
        text.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.antialiasing = true;
        add(text);

        var bold:Bool;

        creditGroup = new FlxTypedGroup<Alphabet>();
        add(creditGroup);

        for (i in 0...credits.length)
        {
            var credit:Alphabet;
            if (credits[i].charAt(0) == "#")
            {
                credit = new Alphabet(0, (50 * i) + 40, credits[i], true);
            }
            else
            {
                credit = new Alphabet(0, (60 * i), credits[i], false);
            }
            credit.isMenuItem = true;
            credit.targetY = i;
            credit.screenCenter(X);
            creditGroup.add(credit);
        }

        super.create();
    }

    function changeSelection(change:Int)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        curSelected += change;

		if (curSelected < 0)
			curSelected = credits.length - 1;
		if (curSelected >= credits.length)
			curSelected = 0;

        var bullShit:Int = 0;

		for (item in creditGroup.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

    	if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
        if (controls.UP_P)
        {
            changeSelection(-1);
        }
        else if (controls.DOWN_P)
        {
            changeSelection(1);
        }
    }
}
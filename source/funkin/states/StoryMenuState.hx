package funkin.states;

import funkin.music.MusicBeatState;
import funkin.states.MainMenuState;

class StoryMenuState extends MusicBeatState
{
    var storyMenuBG:FlxSprite;

    override public function create()
    {
        super.create();

        storyMenuBG = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);
        add(storyMenuBG);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.switchState(()->new MainMenuState());
        }
    }

    override function beatHit() 
    {
        super.beatHit();
    }
}
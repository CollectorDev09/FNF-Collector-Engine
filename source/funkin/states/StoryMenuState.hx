package funkin.states;

import funkin.music.MusicBeatState;
import funkin.states.MainMenuState;
import funkin.data.storymode.Level;

class StoryMenuState extends MusicBeatState
{
    var storyMenuBG:FlxSprite;

    var weeks:String;

    var weekList:Array<String> = [];

    var weekData:FlxTypedGroup<Level>;

    override public function create()
    {
        super.create();

        parseWeekData();

        storyMenuBG = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);
        add(storyMenuBG);
    }

    private function parseWeekData() 
    {
        var weeks = Paths.txt('levels/weekList');

        weekList = weeks.split('\n');

        for (week in weekList)
        {
            week = StringTools.trim(week).trim();
            trace(week);
            var parsedWeek = Paths.json('levels/$week');

            if (parsedWeek != null)
            {

            }
        }
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
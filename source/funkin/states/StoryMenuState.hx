package funkin.states;

import funkin.music.MusicBeatState;
import funkin.states.MainMenuState;
import funkin.data.storymode.Level;
import funkin.game.PlayState;

class StoryMenuState extends MusicBeatState
{
    var storyMenuBG:FlxSprite;

    var weeks:String;

    var weekList:Array<String> = [];

    var weekData:FlxTypedGroup<Level>;

    var currentSelection:Int = 0;

    override public function create()
    {
        super.create();

        weekData = new FlxTypedGroup<Level>();
        add(weekData);

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
            var parsedWeek = Paths.json('levels/$week');

            if (parsedWeek != null)
            {
                var level:Level = new Level();
                level.name = parsedWeek.name;
                level.songs = parsedWeek.songs;

                trace('${week}:\nname: ${level.name}\nsongs: ${level.songs}');

                weekData.add(level);
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

        if (FlxG.keys.justPressed.ENTER)
        {
            FlxG.switchState(()->new PlayState());
        }
    }

    override function beatHit() 
    {
        super.beatHit();
    }
}
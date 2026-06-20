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

    var weekSprite:FlxSprite;

    override public function create()
    {
        super.create();

        weekData = new FlxTypedGroup<Level>();
        add(weekData);

        parseWeekData();

        storyMenuBG = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);
        add(storyMenuBG);
        changeItem(0);
    }

    private function parseWeekData() 
    {
        var weeks = Paths.txt('levels/weekList');

        weekList = weeks.split('\n');

        for (i in 0...weekList.length)
        {
            weekList[i] = StringTools.trim(weekList[i]).trim();
            trace(weekList[i]);
            var parsedWeek = Paths.json('levels/${weekList[i]}');

            if (parsedWeek != null)
            {
                var img:String = Paths.img('menus/storymenu/titles/${weekList[i]}');
                var level:Level = new Level(0, 500, i, img);
                level.y += ((level.height + 20) * i);
                level.name = parsedWeek.name;
                level.songs = parsedWeek.songs;

                trace('${weekList[i]}:\nname: ${level.name}\nsongs: ${level.songs}');

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
            // FlxG.switchState(()->new PlayState());
        }

        if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W)
        {
            changeItem(-1);
        }

        if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)
        {
            changeItem(1);
        }
    }

    function changeItem(id:Int) 
    {
        currentSelection += id;

        FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);

        if (currentSelection >= weekData.members.length)
			currentSelection = 0;
        if (currentSelection < 0)
            currentSelection = weekData.members.length - 1;

        FlxG.log.add(Paths.img('menus/storymenu/titles/${weekList[currentSelection]}'));
    }

    override function beatHit() 
    {
        super.beatHit();
    }
}
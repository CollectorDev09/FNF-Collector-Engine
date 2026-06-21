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

    var currentWeek:Int = 0;

    var weekSprite:FlxSprite;

    var selectedWeek:Bool = false;

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

        if (FlxG.keys.justPressed.ENTER && !selectedWeek)
        {
            selectedWeek = true;
            selectItem();
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

    function selectItem()
    {
        FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
            PlayState.currentSong = weekData.members[currentWeek].songs[0];
            FlxG.sound.music.stop();
			FlxG.switchState(()->new PlayState());
		});
    }

    function changeItem(id:Int) 
    {
        currentWeek += id;

        if (currentWeek >= weekData.members.length)
			currentWeek = 0;
        if (currentWeek < 0)
            currentWeek = weekData.members.length - 1;

        var number:Int = 0;

        for (item in weekData.members)
        {
            item.targetY = number - currentWeek;

			number++;
        }

        trace(weekData.members[0].y);
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
    }

    override function beatHit() 
    {
        super.beatHit();
    }
}
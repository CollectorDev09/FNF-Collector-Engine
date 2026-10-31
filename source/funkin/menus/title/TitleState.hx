package funkin.menus.title;

class TitleState extends ConductorState
{
    var pressedEnter:Bool;

    var intro:Map<Int, Map<String, Dynamic>> = [
        1 => ["createText" => "CollectorDev"],
        3 => ["addText" => "Presents"],
        4 => ["clearText" => ""],
        5 => ["createText" => "Not Associated\nWith"],
        7 => ["addText" => "Newgrounds"],
        8 => ["clearText" => ""],
        9 => ["parseRandomTexts" => 0],
        11 => ["getRandomTexts" => 1],
        12 => ["clearText" => ""],
        13 => ["createText" => "FNF"],
        14 => ["addText" => "Collector"],
        15 => ["addText" => "Engine"],
    ];

    var textGroup:Null<FlxGroup> = null;

    override public function create()
    {
        setBPM(102);
        FlxG.sound.playMusic(Paths.music('freaky-menu'), 1, false);

        textGroup = new FlxGroup();
        add(textGroup);

        super.create();
    }

    override public function update(elapsed:Float)
    {
        if (Controls.keybindJustPressed("ACCEPT") && !pressedEnter)
        {
            FunkinUtils.playMenuSound("confirm");
            pressedEnter = true;
        }

        ConductorState.songTime = FlxG.sound.music.time;

        super.update(elapsed);
    }

    var thisBeat:Int = 0;

    var currentMap:Map<String, Dynamic>;
    var currentFunc:String = "";
    var currentParameter:Dynamic;

    override public function beatHit()
    {
        thisBeat = ConductorState.beat;

        if (intro.exists(thisBeat))
        {
            currentMap = intro.get(thisBeat);

            for (key=>value in currentMap)
            {
                currentFunc = key;
                currentParameter = value;
            }

            trace(currentFunc);
        }
    }
}
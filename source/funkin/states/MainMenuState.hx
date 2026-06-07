package funkin.states;

import funkin.music.MusicBeatState;

class MainMenuState extends MusicBeatState
{
    var currentSelection:Int = 0;
    var menuItems:FlxTypedGroup<FlxSprite>;
    var menuOptions:Array<String> = [];

    var bg:FlxSprite;
    var magenta:FlxSprite;
    var bgSprites:Array<FlxSprite>;
    var bgAssets:Array<String>;

    override public function create() 
    {
        persistentUpdate = persistentDraw = true;

        bgSprites = [bg, magenta];

        bgAssets = ['', 'Desat'];

        for (i in 0...bgSprites.length)
        {
            bgSprites[i] = new FlxSprite(-80).loadGraphic(Paths.img('menus/menuBG${bgAssets[i]}'));
            bgSprites[i].scrollFactor.set(0, 0.18);
            bgSprites[i].setGraphicSize(Std.int(bgSprites[i].width * 1.1));
            bgSprites[i].updateHitbox();
            bgSprites[i].screenCenter();
            bgSprites[i].antialiasing = true;
            add(bgSprites[i]);

            if (i == 1)
            {
                bgSprites[i].color = 0xFFfd719b;
                bgSprites[i].visible = false;
            }

            add(bgSprites[i]);
        }

        super.create();
    }

    override public function update(elapsed:Float) 
    {
        super.update(elapsed);    
    }
}
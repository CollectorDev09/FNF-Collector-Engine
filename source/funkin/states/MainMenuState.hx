package funkin.states;

import funkin.music.MusicBeatState;

class MainMenuState extends MusicBeatState
{
    var currentSelection:Int = 0;
    var menuItems:FlxTypedGroup<FlxSprite>;
    var menuOptions:Array<String> = [];
    var optionsData:String;

    var bg:FlxSprite;
    var magenta:FlxSprite;
    var bgSprites:Array<FlxSprite>;
    var bgAssets:Array<String>;

    var camFollow:FlxObject;
    var leftWatermark:FlxText;

    override public function create() 
    {
        persistentUpdate = persistentDraw = true;

        bgSprites = [bg, magenta];

        bgAssets = ['', 'Desat'];

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

        for (i in 0...bgSprites.length)
        {
            bgSprites[i] = new FlxSprite(-80).loadGraphic(Paths.img('menus/menuBG${bgAssets[i]}'));
            bgSprites[i].scrollFactor.set(0, 0.18);
            bgSprites[i].setGraphicSize(Std.int(bgSprites[i].width * 1.2));
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

        menuOptions = Paths.txt('menus/mainmenu/menuOptions').split('\n');

        menuItems = new FlxTypedGroup();
        add(menuItems);

        for (i in 0...menuOptions.length)
        {
            menuOptions[i] = StringTools.trim(menuOptions[i]).trim();
            var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = Paths.sparrow('menus/mainmenu/${menuOptions[i]}');
			menuItem.animation.addByPrefix('idle', '${menuOptions[i]} idle', 24);
			menuItem.animation.addByPrefix('selected', '${menuOptions[i]} selected', 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItem.scrollFactor.x = 0;
			menuItem.scrollFactor.y = 0.32;
			menuItems.add(menuItem);
			menuItem.antialiasing = true;
        }

        FlxG.camera.follow(camFollow, null, 0.06);

        changeItem(0);

        leftWatermark = new FlxText(5, FlxG.height - 18, 0, "Collector Engine - v" + Application.current.meta.get('version'));
		leftWatermark.scrollFactor.set();
		leftWatermark.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		leftWatermark.antialiasing = true;
		add(leftWatermark);

        super.create();
    }

    public function changeItem(id:Int)
    {
        currentSelection += id;

        FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);

        if (currentSelection >= menuItems.length)
			currentSelection = 0;
		if (currentSelection < 0)
			currentSelection = menuItems.length - 1;

        menuItems.forEach(function(sprite:FlxSprite)
        {
            sprite.animation.play('idle');

            if (sprite.ID == currentSelection)
            {
                sprite.animation.play('selected');
                camFollow.setPosition(sprite.getGraphicMidpoint().x, sprite.getGraphicMidpoint().y);
            }
            sprite.updateHitbox();
        });
    }

    override public function update(elapsed:Float) 
    {
        super.update(elapsed);

        menuItems.forEach(function(sprite:FlxSprite)
        {
            sprite.screenCenter(X);
        });

        if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W)
        {
            changeItem(-1);
        }

        if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)
        {
            changeItem(1);
        }
    }
}
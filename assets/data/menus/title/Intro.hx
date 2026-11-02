import flixel.FlxSprite;

var danceLeft:Bool = false;

function onCreate()
{
    intro = parseRandomIntro();

    logo = new FlxSprite(-150, -100);
    logo.frames = Paths.sparrow('menus/title/logoBumpin');
	logo.animation.addByPrefix('bump', 'logo bumpin', 24, false);
    logo.animation.play('bump');
	logo.updateHitbox();
    logo.antialiasing = true;
    logo.visible = false;

	gf = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
	gf.frames = Paths.sparrow('menus/title/gfDanceTitle');
	gf.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
	gf.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	gf.antialiasing = true;
    gf.visible = false;

    titleText = new FlxSprite(100, FlxG.height * 0.8);
	titleText.frames = Paths.sparrow('menus/title/titleEnter');
	titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
	titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
	titleText.antialiasing = true;
	titleText.animation.play('idle');
	titleText.updateHitbox();
    titleText.visible = false;

	add(logo);
    add(gf);
    add(titleText);
}

function onBeatHit(curBeat:Int)
{
    if (!skippedIntro)
    {
        switch (curBeat)
        {
            case 1:
                createText(["CollectorDev"]);
            case 3:
                addText("Presents");
            case 4:
                clearText();
            case 5:
                createText(["Not Associated", "With"]);
            case 7:
                addText("Newgrounds");
            case 8:
                clearText();
            case 9:
                createText([intro[0]]);
            case 11:
                addText(intro[1]);
            case 12:
                clearText();
            case 13:
                createText(["FNF"]);
            case 14:
                addText("Collector");
            case 15:
                addText("Engine");
        }
    }

    danceLeft = !danceLeft;
    gf.animation.play(danceLeft ? 'danceRight' : 'danceLeft', true);
    logo.animation.play('bump', true);
}

function onSkipIntro()
{
    logo.visible = true;
    gf.visible = true;
    titleText.visible = true;
}

function onPressedEnter()
{
    titleText.animation.play('press');
}
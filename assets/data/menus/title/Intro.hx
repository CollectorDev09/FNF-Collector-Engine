var logo:FlxSprite;

function onCreate()
{
    intro = parseRandomIntro();

    logo = new FlxSprite();
    logo.frames = Paths.sparrow('menus/title/logoBumpin');
	logo.animation.addByPrefix('bump', 'logo bumpin', 24, false);
    logo.animation.play('bump');
	logo.updateHitbox();
    logo.visible = false;
	instance.add(logo);
}

function onBeatHit(curBeat:Int)
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

    logo.animation.play('bump', true);
}

function onSkipIntro()
{
    logo.visible = true;
}
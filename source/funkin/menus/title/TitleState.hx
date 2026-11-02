package funkin.menus.title;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import funkin.game.PlayState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.*;

class TitleState extends ConductorState
{
    var pressedEnter:Bool;

    var textGroup:Null<FlxGroup> = null;
    var myScript:Iris;

    var intro:Array<String> = [];
    var finalBeat = 16;

    var skippedIntro:Bool = false;

    override public function create()
    {
        setBPM(102);
        FlxG.sound.playMusic(Paths.music('freaky-menu'), 0, true);
        FlxG.sound.music.fadeIn(4, 0, 0.7);

        textGroup = new FlxGroup();
        add(textGroup);

		final rules:RawIrisConfig = {name: "Intro Script", autoRun: true, autoPreset: true};
		myScript = new Iris(FunkinUtils.parseText(Paths.data("menus/title/Intro.hx")), rules);

        myScript.set("createText", createText);
        myScript.set("addText", addText);
        myScript.set("clearText", clearText);
        myScript.set("intro", intro);
        myScript.set("parseRandomIntro", parseRandomIntro);
        myScript.set("finalBeat", finalBeat);
        myScript.set("Paths", funkin.backend.utils.Paths);
        myScript.set("FunkinUtils", funkin.backend.utils.FunkinUtils);
        myScript.set("FlxSprite", flixel.FlxSprite);
        myScript.set("FlxG", flixel.FlxG);
        myScript.set("StringTools", StringTools);
        myScript.set("skippedIntro", skippedIntro);

        myScript.set("add", add);

        myScript.call("onCreate");

        persistentUpdate = persistentDraw = true;

        super.create();
    }

    override public function update(elapsed:Float)
    {
        if (Controls.keybindJustPressed("ACCEPT"))
        {
            if (!skippedIntro)
            {
                skipIntro();
            }
            else if (!pressedEnter && skippedIntro)
            {
                FunkinUtils.playMenuSound("confirm");
                pressedEnter = true;
                setupTransition();

                myScript.call("onPressedEnter");

                new FlxTimer().start(2.0, function(tmr:FlxTimer){
                    FlxG.switchState(new PlayState());
                });
            }
            else
            {

            }
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

        if (thisBeat == finalBeat && !skippedIntro)
        {
            skipIntro();
        }

        myScript.call("onBeatHit", [thisBeat]);
    }

    function skipIntro()
    {
        skippedIntro = true;
        myScript.set("skippedIntro", skippedIntro);
        textGroup.destroy();
        FlxG.camera.flash(FlxColor.WHITE, 4);
        myScript.call("onSkipIntro");
    }

    function createText(textArray:Array<String>):Void
    {
        if (textGroup == null) return;

        textGroup.clear();

        for (i in 0...textArray.length)
        {
            var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
            money.screenCenter(FlxAxes.X);
            money.y += (i * 60) + 200;
            // credGroup.add(money);
            textGroup.add(money);
        }
    }

    function addText(text:String):Void
    {
        if (textGroup == null) return;

        var coolText:Alphabet = new Alphabet(0, 0, text.trim(), true);
        coolText.screenCenter(FlxAxes.X);
        coolText.y += (textGroup.length * 60) + 200;
        textGroup.add(coolText);
    }

    function clearText():Void
    {
        if (textGroup == null) return;

        textGroup.clear();
    }

    function parseRandomIntro():Array<String>
    {
        var intros:Array<String> = FunkinUtils.parseText(Paths.txt("menus/title/introText")).split("\n");

        for (i=>item in intros)
        {
            intros.remove("");
        }

        var text:String = FlxG.random.getObject(intros);
        var daIntro:Array<String> = text.split("--");

        return daIntro;
    }

    function createRandomIntro(i:Int):Void
    {
        createText([intro[i]]);
    }

    function addRandomIntro(i:Int):Void
    {
        addText(intro[i]);
    }

	public function setupTransition()
	{
        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);

		diamond.persist = true;
		diamond.destroyOnNoUse = false;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
			new FlxRect(0, 0, FlxG.width, FlxG.height));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
			{asset: diamond, width: 32, height: 32}, new FlxRect(0, 0, FlxG.width, FlxG.height));

		FlxTransitionableState.defaultTransIn.tileData = {asset: diamond, width: 32, height: 32};
		FlxTransitionableState.defaultTransOut.tileData = {asset: diamond, width: 32, height: 32};

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;    	
	}
}
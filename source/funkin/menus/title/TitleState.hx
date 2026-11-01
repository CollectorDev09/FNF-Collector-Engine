package funkin.menus.title;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import funkin.game.PlayState;

class TitleState extends ConductorState
{
    var pressedEnter:Bool;

    var textGroup:Null<FlxGroup> = null;
    var myScript:Iris;

    var intro:Array<String> = [];
    var finalBeat = 16;

    override public function create()
    {
        setBPM(102);
        FlxG.sound.playMusic(Paths.music('freaky-menu'), 0, false);
        FlxG.sound.music.fadeIn(4, 0, 0.7);

        textGroup = new FlxGroup();
        add(textGroup);

		final rules:RawIrisConfig = {name: "TitleState Script", autoRun: true, autoPreset: true};
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

        myScript.set("instance", this);

        myScript.call("onCreate");

        super.create();
    }

    override public function update(elapsed:Float)
    {
        if (Controls.keybindJustPressed("ACCEPT") && !pressedEnter)
        {
            FunkinUtils.playMenuSound("confirm");
            pressedEnter = true;

            new FlxTimer().start(3.0, function(tmr:FlxTimer){
                FlxG.switchState(new PlayState());
            });
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

        if (thisBeat == finalBeat)
        {
            skipIntro();
        }

        myScript.call("onBeatHit", [thisBeat]);
    }

    function skipIntro()
    {
        textGroup.destroy();
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
}
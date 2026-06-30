package funkin.states;

import funkin.music.MusicBeatState;
import funkin.music.Conductor;
import funkin.game.PlayState;
import funkin.states.MainMenuState;

class TitleState extends MusicBeatState
{
	var logo:FlxSprite = new FlxSprite(-150, -100);
	var gfTitle:FlxSprite;
	var titleText:FlxSprite;
	var danceLeft:Bool = false;
	var transitioning:Bool = false;
	public static var initialized:Bool = false;
	var text:Alphabet;

	var stupid:Float = 4;
	var tail:FlxSprite;
	var piece:FlxSprite;

    override public function create():Void
    {
		persistentUpdate = persistentDraw = true;

		text = new Alphabet(0, 120, "Text", true);

		if (!initialized)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			Conductor.changeBPM(102);
        	FlxG.sound.music.fadeIn(4, 0, 0.7);

			initialized = true;
		}

		super.create();
		
		setupTransition();

		logo.antialiasing = true;
		logo.frames = Paths.sparrow('menus/titlescreen/logoBumpin');
		logo.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logo.updateHitbox();
		add(logo);

		gfTitle = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfTitle.antialiasing = true;
		gfTitle.frames = Paths.sparrow('menus/titlescreen/gfDanceTitle');
		gfTitle.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfTitle.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfTitle.updateHitbox();
		add(gfTitle);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.sparrow('menus/titlescreen/titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		add(titleText);

		tail = new FlxSprite(400, 400);
		tail.frames = Paths.sparrow('game/notes/default');
		tail.animation.addByPrefix('greenhold', 'green hold piece');
		tail.animation.play('greenhold');
		tail.scale.set(0.7, stupid);
		tail.updateHitbox();
		tail.antialiasing = false;
		add(tail);

		piece = new FlxSprite(400, 400);
		piece.frames = Paths.sparrow('game/notes/default');
		piece.animation.addByPrefix('greenpiece', 'green hold end');
		piece.animation.play('greenpiece');
		piece.scale.set(0.7, 0.7);
		piece.updateHitbox();
		piece.antialiasing = false;
		add(piece);
    }

	override function beatHit() 
	{
		super.beatHit();

		FlxG.log.add(curBeat);

		logo.animation.play('bump', true);

		danceLeft = !danceLeft;

		if (!danceLeft)
		{
			gfTitle.animation.play('danceRight');
		}
		else
		{
			gfTitle.animation.play('danceLeft');
		}
	}

	override public function update(elapsed:Float) 
	{
		stupid -= 0.01;
		if (stupid <= 0)
		{
			stupid = 0;
			piece.destroy();
		}
		else
		{
			tail.scale.set(0.7, stupid);
			tail.updateHitbox();
			piece.y = (tail.y + tail.height) - tail.scale.y;
		}
		
		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		if (FlxG.keys.justPressed.ENTER && !transitioning)
		{
			transitioning = true;
			titleText.animation.play('press');
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				FlxG.switchState(()->new MainMenuState());
			});
		}

		Conductor.songPosition = FlxG.sound.music.time;
		super.update(elapsed);
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
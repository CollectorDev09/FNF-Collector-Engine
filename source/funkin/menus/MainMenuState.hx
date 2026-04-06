package funkin.menus;

// import js.html.CharacterData;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionableState;
import utils.Paths;
import funkin.music.MusicBeatState;
import funkin.menus.OptionsState;
import funkin.menus.StoryMenuState;
import assets.data.Script;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['storymode', 'freeplay', 'options', 'credits'];
	#else
	var optionShit:Array<String> = ['storymode', 'freeplay'];
	#end

	var bg:FlxSprite;
	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
		}

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-80).loadGraphic(Paths.img('menus/menuBG'));
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.img('menus/menuDesat'));
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		for(bg in [bg, magenta]) {
			bg.scrollFactor.set(0, 0.18);
			bg.scale.set(1.15, 1.15);
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = true;
		}

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = FlxAtlasFrames.fromSparrow(Paths.img('menus/mainmenu/' + optionShit[i], 'png'), Paths.img('menus/mainmenu/' + optionShit[i], 'xml'));
			menuItem.animation.addByPrefix('idle', optionShit[i] + " idle", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " selected", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItem.scrollFactor.x = 0;
			menuItem.scrollFactor.y = 0.32;
			menuItems.add(menuItem);
			// menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		var leftWatermarkText:FlxText = new FlxText(5, FlxG.height - 36, 0, "Collector Engine - v" + Main.cdevVer, 12);
		leftWatermarkText.text += "\nFriday Night Funkin' - v" + Main.fnfVer;
		leftWatermarkText.scrollFactor.set();
		leftWatermarkText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		leftWatermarkText.antialiasing = true;
		add(leftWatermarkText);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		var script = new Script();

		if (FlxG.mouse.overlaps(menuItems))
		{
			FlxG.mouse.load(Paths.img("cursors/cursorGrab", "png"));
		}
		else
		{
			FlxG.mouse.load(Paths.img("cursors/cursorSelect", "png"));
		}

		script.update(elapsed);
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'storymode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");

									case 'options':
										FlxG.switchState(new OptionsState());
									
									case 'credits':
										FlxG.switchState(new CreditsState());
								}
							});
						}
					});
				}
			}
		}


		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new EditorState());
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}

package funkin.game;

import haxe.Json;
import funkin.editors.ChartingState;
import funkin.editors.AnimationState;
import flixel.FlxG.stage;
import funkin.song.Section.SwagSection;
import funkin.song.Song.Song;
import funkin.song.Song.SongMeta;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.ui.FlxBar;
import flixel.util.FlxSort;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.events.EventType;
import Std.*;
import flixel.input.keyboard.FlxKey;
// import lime.utils.Assets;
// import funkin.ui.game.HealthIcon;
// import funkin.game.Strumline;

class PlayState extends MusicBeatState
{
	var justPressed:Bool;
	var TextMS:FlxText = new FlxText();
	var keysPressed:Array<Bool> = [for (i in 0...4) false];
	var strumline:FlxSprite;

	override public function create()
	{
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

		TextMS.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		TextMS.antialiasing = true;
		TextMS.y = FlxG.height - 18;
		add(TextMS);

		strumline = new FlxSprite();
		strumline.makeGraphic(FlxG.width, 20);
		strumline.y = 50;
		add(strumline);

		var noteData = Paths.json('songs/gabz/gabz-chart');

		for (n in 0...(noteData.notes.hard.length:Int))
		{
			var note = new Note(noteData.notes.hard[n].t, noteData.notes.hard[n].d);
			add(note);
		}


		super.create();
		trace("Hello World! This is a playstate.");
		Conductor.songPosition = 0;
	}

    public function onKeyDown(e:KeyboardEvent):Void 
    {
        final id:Int = convertStrumKey(keysPressed.length, e.keyCode);
        if (keysPressed[id]) return;
        keysPressed[id] = true;

        var k = e.keyCode;
        
        trace('just pressed: $id');
    }

    @:noDebug @:pure public static function convertStrumKey(keyAmount:Int, key:FlxKey):Int 
    {
        if (key == NONE) return -1;
        for (i in 0...keyAmount) 
        {
			var possibleKey = Controls.gameBinds[i];
			if (key == possibleKey) return i;
        }

        return -1;
    }

    public function onKeyUp(e:KeyboardEvent):Void 
    {
        final id:Int = convertStrumKey(keysPressed.length, e.keyCode);
        keysPressed[id] = false;
        trace('released: $id');
    }

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		// trace(Conductor.songPosition);
		Conductor.songPosition += elapsed * 1000;
		TextMS.text = string(Conductor.songPosition);
	}
}

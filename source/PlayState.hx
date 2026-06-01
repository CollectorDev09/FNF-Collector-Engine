package;

import haxe.Json;
import flixel.FlxG.stage;
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
	var lastOffsetText:FlxText = new FlxText();
	var keysPressed:Array<Bool> = [for (i in 0...4) false];
	var strumline:FlxSprite;

	var currentSong:String = 'Fresh';

	var opponentNotes:FlxTypedGroup<Note>;
	var playerNotes:FlxTypedGroup<Note>;

	private var inst:FlxSound;
	private var vocals:FlxSound;

	override public function create()
	{
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

		TextMS.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		TextMS.antialiasing = true;
		TextMS.y = FlxG.height - 18;
		add(TextMS);

		lastOffsetText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		lastOffsetText.antialiasing = true;
		lastOffsetText.y = FlxG.height - 38;
		lastOffsetText.text = 'Last Offset: ';

		strumline = new FlxSprite();
		strumline.makeGraphic(FlxG.width, 20);
		strumline.y = 50;
		add(strumline);

		loadSongAudio();
		loadChart(currentSong);

		super.create();
		trace("Hello World! This is a playstate.");
		Conductor.songPosition = 0;
	}

	public function loadChart(name:String) 
	{
		var noteData = Paths.json('songs/${name.toLowerCase()}/${name.toLowerCase()}-chart');

		opponentNotes = new FlxTypedGroup();
		playerNotes = new FlxTypedGroup();

		for (n in 0...(noteData.notes.hard.length:Int))
		{
			var note = new Note(noteData.notes.hard[n].t, noteData.notes.hard[n].d);
			if (note.noteData < 4)
			{
				playerNotes.add(note);
			}
			else
			{
				opponentNotes.add(note);
			}
		}

		add(playerNotes);
		add(opponentNotes);
	}

	public function loadSongAudio()
	{
		inst = new FlxSound().loadEmbedded(Paths.getInst(currentSong.toLowerCase()));

		vocals = new FlxSound().loadEmbedded(Paths.getVoices(currentSong.toLowerCase()));

		// inst.play();
		// vocals.play();
	}

    public function onKeyDown(e:KeyboardEvent):Void 
    {
        final id:Int = convertStrumKey(keysPressed.length, e.keyCode);
        if (keysPressed[id]) return;
        keysPressed[id] = true;

        var k = e.keyCode;
        
        trace('just pressed: $id');

		if (playerNotes.members[0] != null && playerNotes.members[0].strumTime - Conductor.songPosition >= -150 && playerNotes.members[0].strumTime - Conductor.songPosition <= 150 && id == playerNotes.members[0].noteData)
		{
			playerNotes.remove(playerNotes.members[0], true);
			trace('Pressed a note: ${playerNotes.members[0].strumTime - Conductor.songPosition}');
		}
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
		Conductor.songPosition += elapsed * 1000;
		TextMS.text = string(Conductor.songPosition);

		if (playerNotes.members[0] != null && playerNotes.members[0].strumTime - Conductor.songPosition <= -2000)
		{
			playerNotes.remove(playerNotes.members[0], true);
			trace('Note Removed');
		}

		if (opponentNotes.members[0] != null && opponentNotes.members[0].strumTime <= Conductor.songPosition)
		{
			opponentNotes.remove(opponentNotes.members[0], true);
			trace('Note Removed');
		}
	}
}

package funkin.game;

import flixel.FlxG.stage;
import flixel.input.keyboard.FlxKey;
import funkin.backend.FunkinMath;
import funkin.music.ConductorState;
import funkin.music.Song;
import haxe.DynamicAccess;
import haxe.Json;
import openfl.events.EventType;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class PlayState extends ConductorState
{
	var text:FlxText;

	var number:Int;

	var songData:Song;

	// Input System stuff
	var justPressed:Bool;
	var keysPressed:Array<Bool> = [for (i in 0...4) false];
	var keys:Array<Int>;

	// Strumline stuff
	var strumline:FlxSprite;
	var opponentNotes:FlxTypedGroup<Note>;
	var playerNotes:FlxTypedGroup<Note>;
	public var strumlineNotes = new FlxTypedGroup<FlxSprite>(8);
	static var noteDirections:Array<String>;

	override public function create() 
	{
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

		text = new FlxText(200, 200);
		add(text);

		loadSong('bopeebo');

		text.text = 'BPM: ${ConductorState.bpm}\nBeats: ${ConductorState.beat}';
		text.size = 24;

		var noteOffsets:Array<Float> = [120.6, 33.4, 114.2, 50.5, 2.0, 2.2, 20.8, 40.01];
		var averageOffsets = FunkinMath.getAverage(noteOffsets);

		var notesMissed = 8;
		var notesTotal = noteOffsets.length + notesMissed;

		var missRatio = notesMissed/notesTotal;

		var accuracy = FunkinMath.getAverage([100 - (averageOffsets/160), (100 - missRatio)]);

		trace('Accuracy: $accuracy');

		strumline = new FlxSprite();
		strumline.makeGraphic(FlxG.width, 20);
		strumline.y = 50;

		noteDirections = ['Left', 'Down', 'Up', 'Right'];

		for (n in 0...8)
        {
            var strumNote = new FlxSprite();
			strumNote.y = strumline.y;
			strumNote.x -= 25;
			strumNote.frames = Paths.sparrow('game/notestyles/default');
			strumNote.setGraphicSize(Std.int(strumNote.width * 0.7));
			strumNote.antialiasing = true;

			for (i in noteDirections)
			{
				strumNote.animation.addByPrefix('arrow$i', 'arrow${i.toUpperCase()}', 24, false);
				strumNote.animation.addByPrefix('${i}Press', '${i.toLowerCase()} press', 24, false);
				strumNote.animation.addByPrefix('${i}Hit', '${i.toLowerCase()} confirm', 24, false);
			}

			if (n < 4)
			{
				strumNote.x += Note.noteWidth * n + 700;
				strumNote.animation.play('arrow${noteDirections[n]}');
			}
			else
			{
				strumNote.x += Note.noteWidth * (n - 3) - 45;
				strumNote.animation.play('arrow${noteDirections[n - 4]}');
			}

			strumlineNotes.add(strumNote);
        }

		add(strumlineNotes);

		super.create();
	}

    public function onKeyDown(e:KeyboardEvent):Void 
    {
        final id:Int = convertStrumKey(keysPressed.length, e.keyCode);
        if (keysPressed[id]) return;
        keysPressed[id] = true;

        var k = e.keyCode;
		
        trace('just pressed: $id');

		if (id == -1) return;

		strumlineNotes.members[id].animation.play('${noteDirections[id]}Press');
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

		if (id == -1) return;

		strumlineNotes.members[id].animation.play('arrow${noteDirections[id]}');
    }

	public function loadSong(name:String)
	{
		songData = new Song(name);

		setBPM(songData.bpm);
		FlxG.sound.playMusic(Paths.getInst(name), 1, false);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		ConductorState.songTime = Std.int(FlxG.sound.music.time);
	}

	override public function beatHit() 
	{
		text.text = 'BPM: ${ConductorState.bpm}\nBeats: ${ConductorState.beat}';
	}
}
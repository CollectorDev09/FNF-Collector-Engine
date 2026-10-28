package funkin.game;

import flixel.FlxG.stage;
import flixel.input.keyboard.FlxKey;
import flixel.sound.FlxSoundGroup;
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
	var song:FlxSoundGroup;
	var voicesPlayer:FlxSound;
	var voicesOpp:FlxSound;

	// Strumline stuff
	var strumline:FlxSprite;
	var opponentNotes:FlxTypedGroup<Note>;
	var playerNotes:FlxTypedGroup<Note>;
	var opponentSustains:FlxTypedGroup<Sustain>;
	var playerSustains:FlxTypedGroup<Sustain>;
	public var strumlineNotes = new FlxTypedGroup<FlxSprite>(8);
	static var noteDirections:Array<String>;

	override public function create() 
	{
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

		text = new FlxText(200, 200);
		add(text);

		text.text = 'BPM: ${ConductorState.bpm}\nBeats: ${ConductorState.beat}';
		text.size = 24;

		var noteOffsets:Array<Float> = [120.6, 33.4, 114.2, 50.5, 2.0, 2.2, 20.8, 40.01];
		var averageOffsets = FunkinUtils.getAverage(noteOffsets);

		var notesMissed = 8;
		var notesTotal = noteOffsets.length + notesMissed;

		var missRatio = notesMissed/notesTotal;

		var accuracy = FunkinUtils.getAverage([100 - (averageOffsets/160), (100 - missRatio)]);

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

		var text = FunkinUtils.parseText(Paths.txt('stuff'));

		loadSong('frontline');

		super.create();
	}

	public function onKeyDown(e:KeyboardEvent):Void
	{
		InputSystem.checkInputPress(e);

		var id = InputSystem.keyID;
		var strumNote = strumlineNotes.members[id];

		if (id != -1 && @:privateAccess strumNote.animation.get_name() != '${noteDirections[id]}Press') strumNote.animation.play('${noteDirections[id]}Press');
	}

	public function onKeyUp(e:KeyboardEvent):Void
	{
		InputSystem.checkInputRelease(e);

		var id = InputSystem.keyID;
		var strumNote = strumlineNotes.members[id];

		if (id != -1) strumNote.animation.play('arrow${noteDirections[id]}');
	}

	public function loadSong(name:String)
	{
		songData = new Song(name);
		
		voicesPlayer = new FlxSound().load(Paths.getVoiceTrack(name, songData.playerVocals));
		voicesOpp = new FlxSound().load(Paths.getVoiceTrack(name, songData.opponentVocals));
		FlxG.sound.list.add(voicesPlayer);
		FlxG.sound.list.add(voicesOpp);

		FlxG.sound.playMusic(Paths.getInst(name), 1, false);
		voicesPlayer.play();
		voicesOpp.play();

		FlxG.sound.music.time = 0;
		voicesPlayer.time = FlxG.sound.music.time;
		voicesOpp.time = FlxG.sound.music.time;

		setBPM(songData.bpm);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.keybindJustPressed("ACCEPT"))
		{
			trace("Ur Gay");
		}

		ConductorState.songTime = FlxG.sound.music.time;
	}

	override public function beatHit() 
	{
		text.text = 'BPM: ${ConductorState.bpm}\nBeats: ${ConductorState.beat}';
	}
}
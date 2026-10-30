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
			strumNote.frames = Paths.sparrow('game/notestyles/default');
			strumNote.setGraphicSize(Std.int(strumNote.width * 0.7));
			strumNote.updateHitbox();
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
				strumNote.x += Note.noteWidth * (n - 4) + 50;
				strumNote.animation.play('arrow${noteDirections[n - 4]}');
			}

			strumlineNotes.add(strumNote);
        }

		add(strumlineNotes);

		var text = FunkinUtils.parseText(Paths.txt('stuff'));

		var currentSong = FunkinUtils.parseText(Paths.txt('currentSong'));

		StringTools.trim(currentSong);
		
		loadSong(currentSong);

		super.create();
	}

	public function onKeyDown(e:KeyboardEvent):Void
	{
		InputSystem.checkInputPress(e);

		var id = InputSystem.keyID;
		var strumNote = strumlineNotes.members[id];

		if (id != -1 && @:privateAccess strumNote.animation.get_name() != '${noteDirections[id]}Press') strumNote.animation.play('${noteDirections[id]}Press');

        var chartNote = playerNotes.members[0];
        if (chartNote == null)
        {
            trace("chart note is null");
            return;
        }

		var canBeHit:Bool = Math.abs(chartNote.time - ConductorState.songTime) <= 160;
		var targetPlayerNote:Note = playerNotes.getFirst((note) -> Math.abs(note.time - ConductorState.songTime) <= 160 && note.direction == id && note.alive);

		if (targetPlayerNote == null)
	    {
            trace("no note is reachable at this point");
            return;
        }

		trace(targetPlayerNote.time - ConductorState.songTime);

		targetPlayerNote.kill();
		playerNotes.remove(targetPlayerNote);

		// playerNotes.sort((Order,a,b) -> { return FlxSort.byValues(Order, a.time, b.time); });
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

		playerNotes = new FlxTypedGroup();
		opponentNotes = new FlxTypedGroup();

		add(playerNotes);
		add(opponentNotes);
		
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
		poolNotes();

		super.update(elapsed);
		ConductorState.songTime = FlxG.sound.music.time;

		if (opponentNotes != null)
		{
			var targetNote:Note = opponentNotes.getFirst((note) -> true);
			if (targetNote != null && targetNote.time - ConductorState.songTime <= -2000)
			{
				targetNote.kill();
				opponentNotes.remove(targetNote);
				trace('Note Removed');
			}
		}

		if (playerNotes != null)
		{
			var targetNote:Note = opponentNotes.getFirst((note) -> true);
			if (targetNote != null && targetNote.time - ConductorState.songTime <= -2000)
			{
				playerNotes.remove(targetNote);
				trace('Note Removed');
			}
		}
	}

	public function poolNotes()
	{
		if (songData.notes.length != 0)
		{
			var timeWindow:Float = 2000;
			// if (scrollSpeed < 1)
			// 	timeWindow /= scrollSpeed;
			
			if (songData.notes[0].time - ConductorState.songTime < timeWindow)
			{
				if (songData.notes[0].strumline == 0)
				{
					playerNotes.insert(0, songData.notes[0]);
				}
				else
				{
					opponentNotes.insert(0, songData.notes[0]);
				}

				songData.notes.shift();
			}
		}
	}

	override public function beatHit() 
	{
		text.text = 'BPM: ${ConductorState.bpm}\nBeats: ${ConductorState.beat}';
	}
}
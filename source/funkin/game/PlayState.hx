package funkin.game;

import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.effects.FlxTrail;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG.stage;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.input.keyboard.FlxKey;
import flixel.sound.FlxSoundGroup;
import flixel.ui.FlxBar;
import flixel.util.FlxSort;
import funkin.config.Controls;
import funkin.game.Scoring;
import funkin.music.Conductor;
import funkin.music.MusicBeatState;
import funkin.states.StoryMenuState;
import haxe.Json;
import openfl.events.EventType;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
// import lime.utils.Assets;
// import funkin.ui.game.HealthIcon;
// import funkin.game.Strumline;

class PlayState extends MusicBeatState
{
	var justPressed:Bool;
	var TextMS:FlxText = new FlxText();
	var lastOffsetText:FlxText = new FlxText();
	var keysPressed:Array<Bool> = [for (i in 0...4) false];
	var keys:Array<Int>;
	var strumline:FlxSprite;

	public static var scrollSpeed:Float = 1;

	var song:FlxSoundGroup;

	public static var currentSong:String;

	var opponentNotes:FlxTypedGroup<Note>;
	var playerNotes:FlxTypedGroup<Note>;

	public var strumlineNotes = new FlxTypedGroup<FlxSprite>(8);

	var rating:FlxSprite;

	private var inst:FlxSound;
	private var vocals:FlxSound;

	var chartData:Dynamic;
	var metadata:Dynamic;

	public static var gameBinds:Array<Int> = [87, 69, 73, 79];

	var score:Float = 0;

	// THE FOLLOWING VARIABLES THAT START WITH PBOT1 ARE FROM V-SLICE!!!

	/**
	 * The maximum score a note can receive.
	 */
	public static final PBOT1_MAX_SCORE:Int = 500;

	/**
	 * The threshold at which a note hit is considered perfect and always given the max score.
	 */
	public static final PBOT1_PERFECT_THRESHOLD:Float = 5.0; // 5ms

	/**
	 * The threshold at which a note hit is considered missed.
	 * `160ms`
	 */
	public static final PBOT1_MISS_THRESHOLD:Float = 160.0;

	/**
	 * The time within which a note is considered to have been hit with the Killer judgement.
	 * `~7.5% of the hit window, or 12.5ms`
	 */
	public static final PBOT1_KILLER_THRESHOLD:Float = 12.5;

	/**
	 * The time within which a note is considered to have been hit with the Sick judgement.
	 * `~25% of the hit window, or 45ms`
	 */
	public static final PBOT1_SICK_THRESHOLD:Float = 45.0;

	/**
	 * The time within which a note is considered to have been hit with the Good judgement.
	 * `~55% of the hit window, or 90ms`
	 */
	public static final PBOT1_GOOD_THRESHOLD:Float = 90.0;

	/**
	 * The time within which a note is considered to have been hit with the Bad judgement.
	 * `~85% of the hit window, or 135ms`
	 */
	public static final PBOT1_BAD_THRESHOLD:Float = 135.0;

	/**
	 * The time within which a note is considered to have been hit with the Shit judgement.
	 * `100% of the hit window, or 160ms`
	 */
	public static final PBOT1_SHIT_THRESHOLD:Float = 160.0;

	static var noteDirections:Array<String>;

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
		lastOffsetText.text = 'Score: ';
		add(lastOffsetText);

		strumline = new FlxSprite();
		strumline.makeGraphic(FlxG.width, 20);
		strumline.y = 50;

		noteDirections = ['Left', 'Down', 'Up', 'Right'];

		for (n in 0...8)
        {
            var strumNote = new FlxSprite();
			strumNote.y = strumline.y;
			strumNote.x -= 25;
			strumNote.frames = Paths.sparrow('game/notes/default');
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
				strumNote.x += Note.swagWidth * n + 700;
				strumNote.animation.play('arrow${noteDirections[n]}');
			}
			else
			{
				strumNote.x += Note.swagWidth * (n - 3) - 45;
				strumNote.animation.play('arrow${noteDirections[n - 4]}');
			}

			strumlineNotes.add(strumNote);
        }

		add(strumlineNotes);

		song = new FlxSoundGroup();
		song.volume = 1;

		opponentNotes = new FlxTypedGroup();
		playerNotes = new FlxTypedGroup();

		loadChart(currentSong);

		add(playerNotes);
		add(opponentNotes);

		loadSongAudio();

		rating = new FlxSprite(100, 400);
		rating.setGraphicSize(Std.int(rating.width * 0.5));
		rating.loadGraphic(Paths.img('game/ui/popup/combo'));
		add(rating);

		Conductor.songPosition = 0;

		super.create();
	}

	public function loadChart(name:String) 
	{
		chartData = Paths.json('songs/${currentSong.toLowerCase()}/${currentSong.toLowerCase()}-chart');

		metadata = Paths.json('songs/${currentSong.toLowerCase()}/${currentSong.toLowerCase()}-metadata');

		trace('songs/${currentSong.toLowerCase()}/${currentSong.toLowerCase()}-chart');

		scrollSpeed = chartData.scrollSpeed.hard;

		Conductor.changeBPM(metadata.timeChanges[0].bpm);

		for (n in 0...chartData.notes.hard.length)
		{
			var note = new Note(chartData.notes.hard[n].t, chartData.notes.hard[n].d);
			if (note.noteData < 4)
			{
				playerNotes.add(note);
			}
			else
			{
				opponentNotes.add(note);
			}
		}
	}

	public function loadSongAudio()
	{
		vocals = new FlxSound().loadEmbedded(Paths.getVoices(currentSong.toLowerCase()), false, true);

		FlxG.sound.playMusic(Paths.getInst(currentSong.toLowerCase()), 1, false);
		vocals.play();

		FlxG.sound.music.onComplete = songEnd;
	}

    public function onKeyDown(e:KeyboardEvent):Void 
    {
		if (!Std.isOfType(FlxG.state, PlayState)) return;

        final id:Int = convertStrumKey(keysPressed.length, e.keyCode);
        if (keysPressed[id]) return;
        keysPressed[id] = true;

        var k = e.keyCode;
		
        trace('just pressed: $id');

		if (id == -1) return;

		strumlineNotes.members[id].animation.play('${noteDirections[id]}Press');

		for (i in 0...playerNotes.members.length)
		{
			if (playerNotes.members[i] == null) return;
			var offset = playerNotes.members[i].strumTime - Conductor.songPosition;
			var noteDirection = playerNotes.members[i].noteData;

			if (offset >= -PBOT1_SHIT_THRESHOLD && offset <= PBOT1_SHIT_THRESHOLD && id == noteDirection)
			{
				onNoteHit(offset, i);
			}
		}
    }

	public function songEnd()
	{
		trace('Song Ended');
		FlxG.sound.music.stop();
		FlxG.switchState(()->new StoryMenuState());
	}

	override function beatHit()
	{
		trace('Beat: ${totalBeats}');
		super.beatHit();
	}

	public function onNoteHit(offset:Float, note:Int)
	{
		lastOffsetText.text = 'Score: ${score}';

		var noteScore:Float = Scoring.scoreNote(offset);

		score += noteScore;

		if (offset >= -PBOT1_SICK_THRESHOLD && offset <= PBOT1_SICK_THRESHOLD)
		{
			rating.loadGraphic(Paths.img('game/ui/popup/sick'));
		}
		else if (offset >= -PBOT1_GOOD_THRESHOLD && offset <= PBOT1_GOOD_THRESHOLD)
		{
			rating.loadGraphic(Paths.img('game/ui/popup/good'));
		}
		else if (offset >= -PBOT1_BAD_THRESHOLD && offset <= PBOT1_BAD_THRESHOLD)
		{
			rating.loadGraphic(Paths.img('game/ui/popup/bad'));
			if (playerNotes.members[note].alpha > 0.3)
				playerNotes.members[note].alpha = 0.3;
		}
		else if (offset >= -PBOT1_SHIT_THRESHOLD && offset <= PBOT1_SHIT_THRESHOLD)
		{
			rating.loadGraphic(Paths.img('game/ui/popup/shit'));
			if (playerNotes.members[note].alpha > 0.3)
				playerNotes.members[note].alpha = 0.3;
		}

		playerNotes.remove(playerNotes.members[note], true);
	}

    @:noDebug @:pure public static function convertStrumKey(keyAmount:Int, key:FlxKey):Int 
    {
        if (key == NONE) return -1;

        for (i in 0...keyAmount) 
        {
			var possibleKey = gameBinds[i];
			if (key == possibleKey) return i;
        }

        return -1;
    }

    public function onKeyUp(e:KeyboardEvent):Void 
    {
		if (!Std.isOfType(FlxG.state, PlayState)) return;

        final id:Int = convertStrumKey(keysPressed.length, e.keyCode);
        keysPressed[id] = false;
        trace('released: $id');

		if (id == -1) return;

		strumlineNotes.members[id].animation.play('arrow${noteDirections[id]}');
    }

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		Conductor.songPosition = FlxG.sound.music.time;
		TextMS.text = Std.string(Conductor.songPosition);

		if (playerNotes != null)
		{
			if (playerNotes.members[0] != null && playerNotes.members[0].strumTime - Conductor.songPosition <= -2000)
			{
				playerNotes.remove(playerNotes.members[0], true);
				trace('Note Removed');
			}
		}

		if (opponentNotes != null)
		{
			if (opponentNotes.members[0] != null && opponentNotes.members[0].strumTime <= Conductor.songPosition)
			{
				opponentNotes.remove(opponentNotes.members[0], true);
				trace('Note Removed');
			}
		}
	}
}
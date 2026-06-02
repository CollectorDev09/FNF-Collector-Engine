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

	var currentSong:String;

	var opponentNotes:FlxTypedGroup<Note>;
	var playerNotes:FlxTypedGroup<Note>;

	var rating:FlxSprite;

	private var inst:FlxSound;
	private var vocals:FlxSound;

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

	override public function create()
	{
		super.create();

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
		add(lastOffsetText);

		strumline = new FlxSprite();
		strumline.makeGraphic(FlxG.width, 20);
		strumline.y = 50;
		add(strumline);

		currentSong = 'Gabz';

		loadSongAudio();
		loadChart(currentSong);

		rating = new FlxSprite(100, 400);
		rating.setGraphicSize(Std.int(rating.width * 0.5));
		rating.loadGraphic(Paths.img('game/ui/popup/combo'));
		add(rating);

		Conductor.songPosition = 0;
	}

	public function loadChart(name:String) 
	{
		var chartData:Dynamic = Paths.json('songs/${name.toLowerCase()}/${name.toLowerCase()}-chart');

		opponentNotes = new FlxTypedGroup();
		playerNotes = new FlxTypedGroup();

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

	public function onNoteHit(offset:Float, note:Int)
	{
		lastOffsetText.text = 'Last Offset: ${Conductor.songPosition - playerNotes.members[note].strumTime}';
		playerNotes.remove(playerNotes.members[note], true);

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
		}
		else if (offset >= -PBOT1_SHIT_THRESHOLD && offset <= PBOT1_SHIT_THRESHOLD)
		{
			rating.loadGraphic(Paths.img('game/ui/popup/shit'));
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

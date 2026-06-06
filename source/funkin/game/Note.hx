package funkin.game;

import funkin.music.Conductor;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	var scrollSpeed = 2.5;

	var speed:Float;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();

		speed = 0.45 * FlxMath.roundDecimal(scrollSpeed, 2);

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x = 0;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		this.strumTime = strumTime;

		this.noteData = noteData;

		frames = FlxAtlasFrames.fromSparrow(Paths.images('game/notes/default'), Paths.images('game/notes/default', 'xml'));

		var noteArray:Map<String, Int> = ["purple" => 0, "blue" => 1, "green" => 2, "red" => 3];

		for (key => value in noteArray)
		{
			animation.addByPrefix('${key}Scroll', '${key}0');
			animation.addByPrefix('${key}hold', '${key} hold piece');
			animation.addByPrefix('${key}holdend', '${key} hold end');
			if (value == noteData || value == (noteData - 4))
			{
				if (isSustainNote && prevNote != null)
				{
					animation.play('${key}holdend');
				}
				else if (prevNote.isSustainNote)
				{
					animation.play('${key}hold');
				}
				else
				{
					animation.play('${key}Scroll');
				}
			}
		}
		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
		antialiasing = true;

		if (noteData < 4)
		{
			x += swagWidth * noteData + 700;
		}
		else
		{
			x += swagWidth * (noteData - 3) - 45;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		this.y = 50 - (speed * (Conductor.songPosition - strumTime));
	}
}
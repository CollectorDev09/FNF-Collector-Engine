package funkin.game.note;

import funkin.music.ConductorState;

class Note extends FlxSprite
{
    public var time:Float;
    public var length:Float;
    public var direction:Int;
    public var strumline:Int;
    public static var noteWidth:Float = 160 * 0.7;

    public function new(time:Float, length:Float, direction:Int, strumline:Int) 
    {
        super(x, y);

        this.time = time;
        this.length = length;
        this.direction = direction;
        this.strumline = strumline;

        this.frames = Paths.sparrow('game/notestyles/default');

		var noteArray:Map<String, Int> = ["purple" => 0, "blue" => 1, "green" => 2, "red" => 3];

		for (key => value in noteArray)
		{
			animation.addByPrefix('${key}', '${key}0');
			animation.addByPrefix('${key}hold', '${key} hold piece');
			animation.addByPrefix('${key}holdend', '${key} hold end');

            if (value == direction)
            {
                animation.play(key);
            }
		}
		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
		antialiasing = true;

        x += noteWidth * direction;
    }

    override function update(elapsed:Float)
	{
		super.update(elapsed);

		this.y = 50 - (1.2 * (ConductorState.songTime - time));
    }
}
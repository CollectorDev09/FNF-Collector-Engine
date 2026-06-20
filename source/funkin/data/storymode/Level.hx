package funkin.data.storymode;

class Level extends FlxSpriteGroup
{
    public var name:String;
    public var songs:Array<String>;
    public var targetY:Float = 0;
    public var sprite:FlxSprite;

    public function new(x:Float, y:Float, id:Float, image:String)
    {
        super(x, y);

        sprite = new FlxSprite();
        sprite.loadGraphic(image);
        sprite.antialiasing = true;
        sprite.screenCenter(X);
        targetY = id;
        add(sprite);
    }

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		y = FlxMath.lerp(y, (targetY * 120) + 480, 0.17);
	}
}
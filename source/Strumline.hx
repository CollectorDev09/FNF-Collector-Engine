package;

class Strumline extends FlxSprite
{
    public static var Y:Float = 50;
    public function new()
    {
        super(x, y);
        makeGraphic(FlxG.width, 20);
    }
}
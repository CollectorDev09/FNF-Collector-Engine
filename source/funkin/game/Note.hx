package funkin.game;

class Note extends FlxSprite
{
    var time:Float;
    var length:Float;
    var direction:Int;
    var strumline:Int;

    public function new(time:Float, length:Float, direction:Int, strumline:Int) 
    {
        super(x, y);

        this.time = time;
        this.length = length;
        this.direction = direction;
        this.strumline = strumline;
    }
}
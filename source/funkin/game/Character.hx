package funkin.game;

class Character extends FlxSprite
{
    public function new(x:Float, y:Float, name:String) 
    {
        this.x = x;
        this.y = y;
        super(this.x, this.y);
    }
}
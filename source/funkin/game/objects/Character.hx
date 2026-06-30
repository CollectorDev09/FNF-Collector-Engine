package funkin.game.objects;

class Character extends FlxAnimate
{
    public function new(x:Float, y:Float, name:String) 
    {
        this.x = x;
        this.y = y;
        trace('assets/images/characters/$name');
        this.frames = FlxAnimateFrames.fromAnimate('assets/images/characters/$name');
        this.anim.addBySymbol("idle", 'Idle', 24);
        this.anim.play('idle', true, false);
        super(x, y);
    }
}
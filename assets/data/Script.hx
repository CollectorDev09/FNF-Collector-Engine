package assets.data;

import flixel.FlxG;
import flixel.FlxState;

class Script extends FlxState
{
    public static function act()
    {
        trace("Hello! This is a script!");
    }

    override public function create()
    {
        trace("Yessss");
    }

    override public function update(elapsed:Float)
    {
        trace("Balls");
        super.update(elapsed);
    }
}
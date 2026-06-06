package funkin.game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class StrumGraphic extends FlxSprite
{
    public var note_offset:Int; // This is the offset for the notes to put the player notes on one side and the opponent's on the other side
    public static var swagWidth:Float = 160 * 0.7;


    public function new(x:Float, y:Float, g:Int)
    {
        if (g < 4)
        {
            x += swagWidth * g + 700;
        }
        else if (g > 3)
        {
            x += swagWidth * (g - 3) - 45;
        }

	    this.frames = Paths.sparrow('game/notes/default');

        animation.addByPrefix('arrowLeft', 'arrowLEFT', 24, false);
        animation.addByPrefix('arrowDown', 'arrowDOWN', 24, false);
        animation.addByPrefix('arrowUp', 'arrowUP');
        animation.addByPrefix('arrowRight', 'arrowRIGHT', 24, false);

        animation.addByPrefix("leftPress", "left press", 24, false);
        animation.addByPrefix("downPress", "down press", 24, false);
        animation.addByPrefix("upPress", "up press", 24, false);
        animation.addByPrefix("rightPress", "right press", 24, false);

        trace(g);
        switch (g)
        {
            case 0:
                animation.play('arrowLeft');
            case 1:
                animation.play('arrowDown');
            case 2:
                animation.play('arrowUp');
            case 3:
                animation.play('arrowRight');
            case 4:
                animation.play('arrowLeft');
            case 5:
                animation.play('arrowDown');
            case 6:
                animation.play('arrowUp');
            case 7:
                animation.play('arrowRight');
        }
        setGraphicSize(Std.int(width * 0.7));
        updateHitbox();

        super(x, y);
    }
    
    public function inputAnim(note:String)
    {
        if (this.animation.name == note + "Scroll")
        {
            animation.play(note + "Press");
        }
    }
}
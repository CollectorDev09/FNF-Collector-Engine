package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import polymod.format.ParseRules.TargetSignatureElement;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxState;

using StringTools;

class StageProp extends FlxSprite
{
    public var stageProp:FlxSprite;
    public function new(x:Float, y:Float, graphic:String, id:String, scrollX:Float, scrollY:Float, sizeX:Float, sizeY:Float, antialias:Bool)
    {
        stageProp = new FlxSprite(x, y);
        stageProp.loadGraphic("assets/images/" + graphic + ".png");
        stageProp.scrollFactor.set(scrollX, scrollY);
        stageProp.setGraphicSize(Std.int(stageProp.width * sizeX), Std.int(stageProp.height * sizeY));
        stageProp.antialiasing = antialias;
        stageProp.updateHitbox();
        super(x, y);
    }
}
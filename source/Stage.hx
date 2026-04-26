package;

// import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;

class Stage extends FlxSprite
{
    public var data:String;
    public var name:String;
    var daData:Dynamic;
    public function new(name:String);
    {
        super(x, y);
    }
}
package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import flixel.FlxSprite;

class Stage extends FlxSprite
{
    public var data:String;
    public var name:String;
    public function new(name:String);
    {
        var data = Json.parse(Assets.getText('assets/data/stages/stage.json'));
        trace(data.props.length);
        super(x, y);
    }
}
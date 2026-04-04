package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import flixel.FlxSprite;

class Stage extends FlxSprite
{
    public var data:String;
    public var name:String;
    public var daStage = new FlxTypedGroup<FlxSprite>();
    public function new(name:String);
    {
		var daData = Json.parse(Assets.getText("assets/data/stages/" + curStage + ".json"));
		for (i in 0...(daData.props.length))
		{
			var prop:StageProp = new StageProp(daData.props[i].position[0], daData.props[i].position[1], daData.props[i].assetPath, daData.props[i].name, daData.props[i].scroll[0], daData.props[i].scroll[1], daData.props[i].scale[0], daData.props[i].scale[1], daData.props[i].isPixel);
			daStage.add(prop.stageProp);
		}
        super(x, y);
    }
}
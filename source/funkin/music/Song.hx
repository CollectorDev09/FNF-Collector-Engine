package funkin.music;

import funkin.game.Note;
import haxe.DynamicAccess;
import haxe.Json;
import lime.utils.Assets;

typedef SongChart = {
    var notes:Array<Note>;
}

class Song
{
    public var name:String;
    public var bpm:Float;
    public function new(name:String) 
    {
        var chartFile:DynamicAccess<Dynamic> = Json.parse(Assets.getText('assets/data/$name/$name-chart.json'));
        var metaFile:Dynamic = Json.parse(Assets.getText('assets/data/$name/$name-metadata.json'));

        var difficulty:String = "hard";
        var charts:DynamicAccess<Dynamic> = chartFile['notes'];
        var currentChart:Array<Dynamic> = charts[difficulty];

        trace(currentChart[1].l);

        this.bpm = metaFile.bpm;
    }
}
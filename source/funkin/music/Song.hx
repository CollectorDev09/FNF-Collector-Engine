package funkin.music;

import funkin.game.note.Note;
import haxe.DynamicAccess;
import haxe.Json;
import lime.utils.Assets;

class Song
{
    public var name:String;
    public var bpm:Float;
    public var notes:Array<Note>;
    public var strumlines:Int;

    public var playerVocals:String;
    public var opponentVocals:String;

    public function new(name:String) 
    {
        var chartFile:DynamicAccess<Dynamic> = FunkinUtils.parseJSON(Paths.json('songs/$name/$name-chart'));
        var metaFile:Dynamic = FunkinUtils.parseJSON(Paths.json('songs/$name/$name-metadata'));

        var difficulty:String = "hard";
        var charts:DynamicAccess<Dynamic> = chartFile['notes'];
        var currentChart:Array<Dynamic> = charts[difficulty];

        notes = [];

        for (note in currentChart)
        {
            var direction = note.d;
            var strumline = 0;

            if (direction > 3)
            {
                direction -= 4;
                strumline = 1;
            }
            var daNote = new Note(note.t, note.l, direction, strumline);
            notes.push(daNote);
        }

        trace('Loaded ${notes.length} notes');

        this.bpm = metaFile.playData.bpm;
        this.strumlines = metaFile.playData.strumlines;
        this.playerVocals = metaFile.playData.characters.playerVocals;
        this.opponentVocals = metaFile.playData.characters.opponentVocals;
    }
}
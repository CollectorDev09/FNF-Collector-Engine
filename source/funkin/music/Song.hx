package funkin.music;

import funkin.game.Note;
import haxe.DynamicAccess;
import haxe.Json;
import lime.utils.Assets;

class Song
{
    public var name:String;
    public var bpm:Float;
    public var notes:FlxTypedGroup<Note>;

    public function new(name:String) 
    {
        var chartFile:DynamicAccess<Dynamic> = Paths.json('$name/$name-chart');
        var metaFile:Dynamic = Paths.json('$name/$name-metadata');

        var difficulty:String = "hard";
        var charts:DynamicAccess<Dynamic> = chartFile['notes'];
        var currentChart:Array<Dynamic> = charts[difficulty];

        notes = new FlxTypedGroup();

        for (note in currentChart)
        {
            var direction = note.d;
            var strumline = 0;

            if (direction > 3)
            {
                direction -= 3;
                strumline = 1;
            }
            var daNote = new Note(note.t, note.l, direction, strumline);
            notes.add(daNote);
        }

        trace('Loaded ${notes.members.length} notes');

        this.bpm = metaFile.bpm;
    }
}
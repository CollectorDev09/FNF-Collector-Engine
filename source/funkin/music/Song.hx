package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import sys.io.File.*;

using StringTools;

typedef SongMeta =
{
	var songName:String;
	var bpm:Int;
	var sections:Int;
	var sectionLengths:Array<Dynamic>;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
}

typedef SongChart = 
{
	var notes:Dynamic;
}

typedef SongNote = 
{
	var time:Float;
	var length:Float;
	var direction:Int;
	var strumline:Int;
}

typedef SongEvent = 
{
	var time:Array<Float>;
	var event:String;
}

class Song
{
	public var song:String;
	public var bpm:Int;
	public var sections:Int;
	public var sectionLengths:Array<Dynamic> = [];
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';

	public static function loadSongData(name:String)
	{
		var chart:SongChart = {};

		var chartData:Dynamic = Paths.json('songs/${name.toLowerCase()}/${name.toLowerCase()}-chart');
		var songData:Dynamic = Paths.json('songs/${name.toLowerCase()}/${name.toLowerCase()}-metadata');

		chart.notes = chartData.notes.hard;

		return chart;
	}
}

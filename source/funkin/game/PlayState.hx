package funkin.game;

import haxe.Json;
import funkin.editors.ChartingState;
import funkin.editors.AnimationState;
import funkin.song.Section.SwagSection;
import funkin.song.Song.Song;
import funkin.song.Song.SongMeta;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.ui.FlxBar;
import flixel.util.FlxSort;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.events.EventType;
import lime.utils.Assets;
import funkin.ui.game.HealthIcon;
import funkin.game.Strumline;

class PlayState extends MusicBeatState
{
	var Strum:Strumline;

	override public function create()
	{
		// Strum = new Strumline();
		// add(Strum);
		super.create();
		trace("Hello World! This is a playstate.");
	}
}

package funkin.game;

import funkin.music.ConductorState;
import funkin.backend.FunkinMath;

class PlayState extends ConductorState
{
	var text:FlxText;

	var number:Int;

	override public function create() 
	{
		text = new FlxText(200, 200);
		add(text);

		setBPM(154);
		FlxG.sound.playMusic(Paths.getInst('frontline'), 1, false);

		text.text = 'BPM: ${ConductorState.bpm}\nBeats: ${ConductorState.beat}';
		text.size = 24;

		var testArray:Array<Float> = [12.6, 3.4, 14.2, 20.5, 2.0, 2.2, 20.8, 40.01];
		var testAverage = FunkinMath.getAverage(testArray);

		trace(testAverage);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		ConductorState.songTime = Std.int(FlxG.sound.music.time);
	}

	override public function beatHit() 
	{
		text.text = 'BPM: ${ConductorState.bpm}\nBeats: ${ConductorState.beat}';
	}
}
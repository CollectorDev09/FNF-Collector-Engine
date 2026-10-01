package funkin.game;

import funkin.music.ConductorState;

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
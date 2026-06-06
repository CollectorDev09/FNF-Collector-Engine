package funkin.states;

import funkin.music.MusicBeatState;
import funkin.music.Conductor;

class TitleState extends MusicBeatState
{
    override public function create():Void
    {
        super.create();

        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);

		diamond.persist = true;
		diamond.destroyOnNoUse = false;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
			new FlxRect(0, 0, FlxG.width, FlxG.height));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
			{asset: diamond, width: 32, height: 32}, new FlxRect(0, 0, FlxG.width, FlxG.height));

		FlxTransitionableState.defaultTransIn.tileData = {asset: diamond, width: 32, height: 32};
		FlxTransitionableState.defaultTransOut.tileData = {asset: diamond, width: 32, height: 32};

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

        FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

        FlxG.sound.music.fadeIn(4, 0, 0.7);
    }
}
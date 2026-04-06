package;

import flixel.FlxSprite;
import utils.Paths;

class HealthIcon extends FlxSprite
{
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.img('game/ui/icons/icon-$char'), true, 150, 150);

		antialiasing = true;
		animation.add('char', [0, 1]);
		animation.play(char);
		scrollFactor.set();
	}
}

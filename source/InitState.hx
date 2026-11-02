package;

import funkin.game.PlayState;
import funkin.menus.title.TitleState;
import funkin.backend.modding.Mods;

class InitState extends FlxState
{
    override public function create()
    {
        Mods.init();

        super.create();

        FlxG.switchState(new TitleState());
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}
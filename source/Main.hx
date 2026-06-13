package;

import flixel.FlxGame;
import funkin.states.TitleState;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

       	var modDir:String = 'mods'; // change this if you prefer
        // find mods inside of the mod folder you specified above
        var modList = Polymod.scan({
			modRoot: modDir
		});

		var modIDS:Array<String> = [];
        // get the foldername of the mods polymod found and add them to the modIDS list
		for (mod in modList )
			if (mod != null)
				modIDS.push(mod.id);
  
       //initialize polymod with our found mods
		Polymod.init({
			modRoot: modDir,
			dirs: modIDS
		});

		addChild(new FlxGame(0, 0, TitleState, 120, 120, true));

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end
	}
}

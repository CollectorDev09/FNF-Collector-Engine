package funkin.editors;

import funkin.play.Character;
import flixel.FlxState;
import flixel.FlxG;

class AnimationState extends FlxState
{
    var char:Character;
    public override function create() 
    {
        FlxG.sound.music.stop();
        var text:Alphabet = new Alphabet(0, 20, 'Animation Editor', true, false);
        text.x += 20;
        add(text);
        char = new Character(450, 300, "bf", true);
        add(char);
        super.create();
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);    
    }
}
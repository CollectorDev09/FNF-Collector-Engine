package funkin.music;

class ConductorState extends FlxState
{
    public static var songTime = 0;
    public static var bpm:Float = 100;
    public static var beat:Int = 0;
    public static var step:Int = 0;

    var beatTime:Float = 0;
    var stepTime:Float = 0;

    var stupidNumber = 0;

    override public function create()
    {
        super.create();

        trace('This is a Conductor State');
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        step = Std.int(Math.floor(songTime / (stepTime * 1000)));
        beat = Math.floor(step/4);

        if (step % 4 == 0)
        {
            if (stupidNumber == 0)
            {
                stupidNumber++;
                beatHit();
            }
        }
        else
        {
            stupidNumber = 0;
        }
    }

    public function beatHit():Void
    {
        // Don't do anything lmaoo
    }

    function setBPM(targetBpm:Float) 
    {
        bpm = targetBpm;
        beatTime = 60/bpm;
        stepTime = beatTime/4;
        trace('BPM is now $targetBpm');
        trace('A beat should occur every $beatTime seconds.');
        trace('A step should occur every $stepTime seconds.');
    }
}
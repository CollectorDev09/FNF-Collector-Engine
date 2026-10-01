package funkin.backend;

class FunkinMath
{
    public static function getAverage(array:Array<Float>) 
    {
        var sum:Float = 0;
        var average:Float = 0;

        for (number in array)
        {
            sum += number;
        }

        average = sum/array.length;
        return average;
    }
}
package library
{
    import flash.display.Sprite;

    public class Chars extends Sprite
    {
        static public function getName():String { return "Chars"; }

        [Embed(source = "../../lib/Chars/0.png")]
        static private var Chars0Image:Class;
        [Embed(source = "../../lib/Chars/1.png")]
        static private var Chars1Image:Class;

    }
}

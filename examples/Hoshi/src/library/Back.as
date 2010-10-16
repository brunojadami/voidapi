package library
{
    import flash.display.Sprite;

    public class Back extends Sprite
    {
        static public function getName():String { return "Back"; }

        [Embed(source = "../../lib/Back/0.jpg")]
        static private var Back0Image:Class;
        [Embed(source = "../../lib/Back/1.jpg")]
        static private var Back1Image:Class;
        [Embed(source = "../../lib/Back/2.png")]
        static private var Back2Image:Class;

    }
}

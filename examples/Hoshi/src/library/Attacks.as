package library
{
    import flash.display.Sprite;

    public class Attacks extends Sprite
    {
        static public function getName():String { return "Attacks"; }

        [Embed(source = "../../lib/Attacks/Star.png")]
        static private var AttacksStarImage:Class;

    }
}

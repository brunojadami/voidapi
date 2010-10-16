package library
{
    import flash.display.Sprite;

    public class Images extends Sprite
    {
        static public function getName():String { return "Images"; }

        [Embed(source = "../../lib/Images/Black.png")]
        static private var ImagesBlackImage:Class;
        [Embed(source = "../../lib/Images/Board.png")]
        static private var ImagesBoardImage:Class;
        [Embed(source = "../../lib/Images/Health.png")]
        static private var ImagesHealthImage:Class;
        [Embed(source = "../../lib/Images/Life.png")]
        static private var ImagesLifeImage:Class;
        [Embed(source = "../../lib/Images/Over.jpg")]
        static private var ImagesOverImage:Class;

    }
}

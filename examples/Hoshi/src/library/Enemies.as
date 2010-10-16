package library
{
    import flash.display.Sprite;

    public class Enemies extends Sprite
    {
        static public function getName():String { return "Enemies"; }

        [Embed(source = "../../lib/Enemies/Bird.png")]
        static private var EnemiesBirdImage:Class;
        [Embed(source = "../../lib/Enemies/Bubble0.png")]
        static private var EnemiesBubble0Image:Class;
        [Embed(source = "../../lib/Enemies/Bubble1.png")]
        static private var EnemiesBubble1Image:Class;
        [Embed(source = "../../lib/Enemies/Bubble2.png")]
        static private var EnemiesBubble2Image:Class;
        [Embed(source = "../../lib/Enemies/Bubble3.png")]
        static private var EnemiesBubble3Image:Class;
        [Embed(source = "../../lib/Enemies/Bubble4.png")]
        static private var EnemiesBubble4Image:Class;
        [Embed(source = "../../lib/Enemies/Bubble5.png")]
        static private var EnemiesBubble5Image:Class;
        [Embed(source = "../../lib/Enemies/Evil.png")]
        static private var EnemiesEvilImage:Class;
        [Embed(source = "../../lib/Enemies/Minirock.png")]
        static private var EnemiesMinirockImage:Class;
        [Embed(source = "../../lib/Enemies/Rock.png")]
        static private var EnemiesRockImage:Class;
        [Embed(source = "../../lib/Enemies/Skull.png")]
        static private var EnemiesSkullImage:Class;
        [Embed(source = "../../lib/Enemies/Splash.png")]
        static private var EnemiesSplashImage:Class;
        [Embed(source = "../../lib/Enemies/Water.png")]
        static private var EnemiesWaterImage:Class;

    }
}

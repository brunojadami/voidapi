package dv.changeables
{
    import dv.gears.Gear;
	import dv.gears.TransitionGear;
	import fight.game.gears.GameGear;
	import flash.display.Sprite;
	import dv.utils.Library;
	import flash.display.StageQuality;
	import flash.events.Event;
	import dynamix.utils.SWFProfiler;

	/**
	 * Main class, behave similar of the java main class, but its not static!
	 * @author brunoja
	 */
    public dynamic class Main extends Sprite
    {
		static public var main:Main;
		static public var debug:Boolean = false;
		private var inited:Boolean = false;
		
		/**
		 * Constructor. Starting up.
		 */
        public function Main()
        {
			debug = true; // Comment this to remove debug parts
			trace("Void API 0.2 Beta");
			main = this;
			addEventListener(Event.ENTER_FRAME, start, false, 0, true);	
        }
		
		/**
		 * Starting up, after the swf is fully loaded.
		 */
		private function start(e:Event):void
		{
			if (!stage)
				return;
			if (!inited)
			{
				inited = true;
				if (debug)
					SWFProfiler.init(stage, this);
				Library.init();
				Fonts.prepareFonts();
				root.stage.showDefaultContextMenu = false;
				root.stage.stageFocusRect = false;
				root.stage.quality = StageQuality.BEST;
			}
			else if (Library.getDone())
			{
				//if (!debug)
					new TransitionGear(null, GameGear); // Change for your initial gear
				//else
					//new TransitionGear(null, MenuGear);
				removeEventListener(Event.ENTER_FRAME, start);
			}
		}
		
		/**
		 * @return the url where this swf is from
		 */
		public function getUrl():String
		{
			return root.loaderInfo.loaderURL;
		}
    }
}

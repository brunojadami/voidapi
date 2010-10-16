package dv.utils 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * The library containing all the resources.
	 * @author brunoja
	 */
	public class Library
	{
		[Embed(source="../../../bin/Library.swf")]
		static private var Lib:Class;
		static private var lib:Sprite;
		static private var loader:Loader;
		static private var done:Boolean = false;
		
		/**
		 * Starting the library.
		 */
		static public function init():void
		{
			lib = new Lib();
			lib.addEventListener(Event.COMPLETE, completed, false, 0, true);
		}
		
		/**
		 * Library is loaded.
		 */
		static private function completed(e:Event):void
		{
			loader = e.target.getChildAt(0);
			Resources.setLib(loader);
			done = true;
		}
		
		/**
		 * Main will call this.
		 * @return if its loaded
		 */
		static public function getDone():Boolean
		{
			return done;
		}
	}

}
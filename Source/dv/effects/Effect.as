package dv.effects 
{
	import dv.graphic.VGraphic;
	import flash.events.Event;
	
	/**
	 * Base class of the effects.
	 * @author brunoja.
	 */
	public class Effect extends VGraphic
	{
		/**
		 * Constructor.
		 */
		public function Effect() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destructor, false, 0, true);
		}
		
		/**
		 * Added to stage event. Starting logic.
		 */
		protected function added(e:Event):void
		{
			addEventListener(Event.ENTER_FRAME, logic, false, 0, true);
		}
		
		/**
		 * Removed from the stage event, clearing events and display list.
		 */
		protected function destructor(e:Event):void
		{
			clearEvents();
			clearDisplayList();
		}
		
		/**
		 * Clearing events.
		 */
		private function clearEvents():void
		{
			removeEventListener(Event.ENTER_FRAME, logic);
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(Event.REMOVED_FROM_STAGE, destructor);
		}
		
		/**
		 * Logic.
		 */
		protected function logic(e:Event):void
		{
			
		}
		
	}

}
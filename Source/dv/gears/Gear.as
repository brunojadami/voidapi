package dv.gears 
{
	import dv.objects.GameObject;

	/**
	 * Base class for the Gears classes. The Gears are the hearth of the game state.
	 * @author brunoja
	 */
	public class Gear extends GameObject
	{
		protected var go:Boolean = false;
		protected var done:Boolean = false;
		protected var state:int;
		
		/**
		 * Constructor.
		 */
		public function Gear() 
		{
			super();
		}
		
		/**
		 * @return the done flag, telling transition gear to fade out
		 */
		public function getDone():Boolean
		{
			return done;
		}
		
		/**
		 * Setting go, the transition gear will set this to true when it fades out.
		 * @param value the go value
		 */
		public function setGo(value:Boolean):void
		{
			go = value;
		}
		
	}

}
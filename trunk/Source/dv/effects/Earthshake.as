package dv.effects 
{
	import dv.changeables.Main;
	import dv.graphic.VGraphic;
	import flash.events.Event;

	/**
	 * Does the earthshake effect, shaking the screen. (changing main positioning)
	 * @author brunoja
	 */
	public class Earthshake extends Effect
	{
		static public var earthshaking:Boolean = false;
		private var mag:int;
		private var time:int;
		private var count:int = 0;
		
		/**
		 * Creating the earthshake. Use the static function "startEffect".
		 * @param mag the magnitude
		 * @param time the duration
		 */
		public function Earthshake(mag:int, time:int) 
		{
			super();
			this.mag = mag;
			this.time = time;
		}
		
		/**
		 * Starts the earthshake effect. Parameters are the same of the constructor.
		 */
		static public function startEffect(mag:int = 5, time:int = 100):void
		{
			Main.main.addChild(new Earthshake(mag, time));
			earthshaking = true;
		}
		
		/**
		 * Logic of the earthshake.
		 */
		override protected function logic(e:Event):void
		{
			if (VGraphic.paused)
				return;
				
			++count;
			Main.main.x = Math.random() * (mag * 2) - mag;
			Main.main.y = Math.random() * (mag * 2) - mag;
			if (count == time)
			{
				Main.main.x = 0;
				Main.main.y = 0;
				Main.main.removeChild(this);
				earthshaking = false;
			}
		}
	}

}
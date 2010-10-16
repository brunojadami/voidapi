package dv.effects 
{
	import dv.changeables.Global;
	import dv.changeables.Main;
	import dv.graphic.VGraphic;
	import flash.events.Event;

	/**
	 * Fog effect. It moves an image over the screen slowly.
	 * @author brunoja
	 */
	public class Fog extends Effect
	{
		static public var fogging:Boolean = false;
		private var sprite:VGraphic;
		private var count:int = 0;
		private var state:int = 0;
		private var right:Boolean = true;
		private var tin:Number;
		private var tout:Number;
		
		/**
		 * Creating the effect. Use the "startEffect" static method.
		 * @param sprite the fog sprite
		 * @param tin time fade int
		 * @param tout time fade out
		 * @param count duration
		 */
		public function Fog(sprite:VGraphic, tin:Number, tout:Number, count:int) 
		{
			super();
			this.sprite = sprite;
			addChild(sprite);
			this.alpha = 0;
			this.count = count;
			this.tin = tin;
			this.tout = tout;
			x = Global.WINDOW_WIDTH - width;
		}
		
		/**
		 * Starts the effect. Parameters = contructor.
		 */
		static public function startEffect(sprite:VGraphic, tin:Number = 0.01, tout:Number = 0.01, count:int = 100):void
		{
			Main.main.addChild(new Fog(sprite, tin, tout, count));
			fogging = true;
		}
		
		/**
		 * Fog logic.
		 */
		override protected function logic(e:Event):void
		{
			if (VGraphic.paused)
				return;
			
			moveIt();
			if (state == 0)
			{
				state = 1;
				fadeIn(tin);
			}
			else if (state == 1)
			{
				if (--count <= 0 && finishedFades())
					state = 2;
			}
			else if (state == 2)
			{
				fadeOut(tout);
				state = 3;
			}
			else if (state == 3 && finishedFades())
			{
				fogging = false;
				Main.main.removeChild(this);
			}
		}
		
		/**
		 * Moving the fog.
		 */
		private function moveIt():void
		{
			if (right)
				++x;
			else
				--x;
			if (x > 0)
			{
				x = -1;
				right = false;
			}
			else if (x < Global.WINDOW_WIDTH - width)
			{
				x = Global.WINDOW_WIDTH - width + 1;
				right = true;
			}
		}
	}

}
package dv.effects 
{
	import dv.changeables.Main;
	import dv.graphic.VGraphic;
	import flash.events.Event;

	/**
	 * Flasing effect, its just a fade in and out effect, that in high speed can cause flash effect!
	 * @author brunoja
	 */
	public class Flashing extends Effect
	{
		private var sprite:VGraphic;
		private var tin:Number;
		private var tout:Number;
		private var tmiddle:int;
		private var count:int = 0;
		
		/**
		 * Creating the effect. Use the "startEffect" static method.
		 * @param sprite the sprite to flash
		 * @param tin time for the fadein
		 * @param tout time for the fadeout
		 * @param tmiddle time for the middle term
		 */
		public function Flashing(sprite:VGraphic, tin:Number, tout:Number, tmiddle:int) 
		{
			super();
			this.tin = tin;
			this.tout = tout;
			this.tmiddle = tmiddle;
			this.sprite = sprite;
			addChild(sprite);
			this.alpha = 0;
		}
		
		/**
		 * Starts the flash effect. The parameters = constructor.
		 */
		static public function startEffect(sprite:VGraphic, tin:Number = 0.1, tout:Number = 0.1, tmiddle:int = 0):void
		{
			Main.main.addChild(new Flashing(sprite, tin, tout, tmiddle));
		}
		
		/**
		 * Flashing logic.
		 */
		override protected function logic(e:Event):void
		{
			if (VGraphic.paused)
				return;
				
			if (count == 0)
			{
				count = 1;
				fadeIn(tin);
			}
			else if (count == 1 && finishedFades())
				count = 2;
			else if (count > 1)
			{
				++count;
				if (count - 2 > tmiddle)
				{
					count = -1;
					fadeOut(tout);
				}
			}
			else if (count == -1 && finishedFades())
				Main.main.removeChild(this);
		}
	}

}
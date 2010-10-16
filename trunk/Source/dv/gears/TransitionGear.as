package dv.gears 
{
	import dv.changeables.Main;
	import dv.component.VSprite;
	import flash.events.Event;
	import flash.system.System;
	
	/**
	 * The Gear to make the transistion between gears.
	 * @author brunoja
	 */
	public class TransitionGear extends Gear
	{
		private var sprite:VSprite;
		
		private var STATE_BEGIN:int = 0;
		private var STATE_REMOVE:int = 1;
		private var STATE_GC:int = 2;
		private var STATE_NEXT:int = 3;
		private var STATE_WAIT:int = 4;
		private var STATE_OUT:int = 5;
		
		private var from:Gear;
		private var to:Class;
		private var newOne:Gear;
		
		/**
		 * Creating the Transition gear.
		 * @param from from gear instance
		 * @param to to gear class
		 * @param fade uses the fade effect
		 */
		public function TransitionGear(from:Gear, to:Class, fade:Boolean = true) 
		{
			super();
			state = STATE_BEGIN;
			this.from = from;
			this.to = to;
			sprite = new VSprite("ImagesBlack");
			addChild(sprite);
			if (fade)
				fadeIn(0.1);
			Main.main.addChild(this);
		}
		
		/**
		 * Executing the transistion logic.
		 */
		override protected function logic(e:Event):void
		{
			if (state == STATE_BEGIN)
			{
				if (finishedFades())
					state = STATE_REMOVE;
			}
			else if (state == STATE_REMOVE)
			{
				if (from)
				{
					Main.main.removeChild(from);
					from = null;
				}
				state = STATE_GC;
			}
			else if (state == STATE_GC)
			{
				try
				{
					System.gc();
				}
				catch (e:Error)
				{
					trace("Flash version is older than 10 on TG gc state!");
				}
				state = STATE_NEXT;
			}
			else if (state == STATE_NEXT)
			{
				newOne = new to() as Gear;
				Main.main.addChildAt(newOne, Main.main.getChildIndex(this));
				state = STATE_WAIT;
				
			}
			else if (state == STATE_WAIT)
			{
				if (newOne.getDone())
				{
					fadeOut(0.1);
					state = STATE_OUT;
				}
			}
			else
			{
				if (finishedFades())
				{
					Main.main.removeChild(this);
					newOne.setGo(true);
				}
			}
		}
		
	}

}
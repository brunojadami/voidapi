package dv.graphic
{
	import dv.graphic.VGraphic;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	/**
	 * Focusable class. Extend this to make your display a rect to show that its focusable.
	 * @author brunoja
	 */
	public class Focusable extends VGraphic
	{
		private var bmp:VGraphic;
		
		/**
		 * Constructor.
		 */
		public function Focusable():void
		{
			super();
			tabEnabled = true;
			addEventListener(FocusEvent.FOCUS_IN, focusIn, false, 0, true);
			addEventListener(FocusEvent.FOCUS_OUT, focusOut, false, 0, true);
		}
		
		/**
		 * Focus in event.
		 */
		private function focusIn(e:Event):void
		{
			bmp = new VGraphic();
			bmp.graphics.lineStyle(1, 0x008888, 0.4);
			bmp.graphics.drawRect(1, 1, width-3, height-3);
			addChild(bmp);
			bmp.tabEnabled = false;
		}
		
		/**
		 * Focus out event.
		 */
		private function focusOut(e:Event):void
		{
			removeChild(bmp);
		}
	}
	
}
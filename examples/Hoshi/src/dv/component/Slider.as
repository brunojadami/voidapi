package dv.component
{
	import dv.sound.VSound;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * Simple slider bar. Usefull for volume controlling.
	 * @author brunoja
	 */
	public class Slider extends VGraphic
	{
		private var bar:VSprite = new VSprite();
		private var ctrl:VSprite = new VSprite();
		static public const DRAG:String = MouseEvent.MOUSE_MOVE;
		private var outSound:VSound;
		private var dragging:Boolean = false;
		
		/**
		 * Constructor, creating the slider.
		 * @param symbol the image symbol, symbol+Bar, symbol+Ctrl
		 * @param pos number of positions
		 */
		public function Slider(symbol:String, pos:int = 100)
		{
			super();
			load(symbol, pos);
		}
		
		/**
		 * Loading the bar, the parameters are the same of the constructor.
		 */
		private function load(symbol:String, pos:int = 100):void
		{
			bar.load(symbol + "Bar");
			ctrl.load(symbol + "Ctrl");
			addChild(bar);
			addChild(ctrl);
			ctrl.x = (bar.width - ctrl.width) * pos / 100;
			ctrl.y = - (ctrl.height - bar.height) / 2;
			addEventListener(MouseEvent.MOUSE_DOWN, dragOn, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, dragOff, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, dragOff, false, 0, true);
		}
		
		/**
		 * Assigning a sound when the user stops dragging.
		 * @param symbol the sound symbol
		 */
		public function assignOutSound(symbol:String):void
		{
			outSound = new VSound();
			outSound.load(symbol);
		}
		
		/**
		 * Drag on event.
		 */
		private function dragOn(e:Event):void
		{
			ctrl.startDrag(false, new Rectangle(0, - (ctrl.height - bar.height) / 2, bar.width - ctrl.width, 0));
			dragging = true;
		}
		
		/**
		 * Drag off event.
		 */
		private function dragOff(e:Event):void
		{
			ctrl.stopDrag();
			if (outSound && dragging)
				outSound.play();
			dragging = false;
		}
		
		/**
		 * @return the position of the slider
		 */
		public function getSlided():int
		{
			return (ctrl.x - bar.x) * 100 / (bar.width - ctrl.width);
		}
	}
	
}
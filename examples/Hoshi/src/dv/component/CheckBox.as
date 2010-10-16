package dv.component
{
	import dv.graphic.Focusable;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * Class that implements a simple checkbox.
	 * @author brunoja
	 */
	public class CheckBox extends Focusable
	{
		private var checkImg:VSprite;
		private var image:VSprite;
		private var checked:Boolean = false;
		
		/**
		 * Constructor. Creating the checkbox.
		 * @param symbol the symbol for the images, symbol+Up and symbol+Check
		 * @param vtext the text near the checkbox
		 */
		public function CheckBox(symbol:String, vtext:Text = null)
		{
			super();
			this.buttonMode = true;
			load(symbol, vtext);
		}
		
		/**
		 * Loading things. The parameters are the same as the constructor.
		 */
		private function load(symbol:String, vtext:Text = null):void
		{
			image = new VSprite(symbol + "Up");
			checkImg = new VSprite(symbol + "Check");
			addChild(image);
			if (vtext)
			{
				vtext.x += image.width;
				addChild(vtext);
			}
			addEventListener(MouseEvent.MOUSE_UP, mouseClick, false, 0, true);
			addEventListener(KeyboardEvent.KEY_DOWN, keyClick, false, 0, true);
		}
		
		/**
		 * Checking or unchecking the box, mouse click event.
		 */
		private function mouseClick(e:Event):void
		{
			checked = !checked;
			if (checked)
			{
				removeChild(image);
				addChild(checkImg);
			}
			else
			{
				removeChild(checkImg);
				addChild(image);
			}
		}
		
		/**
		 * If key pressed and is enter key, click it.
		 */
		private function keyClick(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
				mouseClick(e);
		}
		
		/**
		 * @return if its checked
		 */
		public function isChecked():Boolean
		{
			return checked;
		}
		
		/**
		 * Checking the box, if its check will do nothing.
		 */
		public function check():void
		{
			if (!checked)
				mouseClick(null);
		}
		
		/**
		 * Unchecking the box, if its uncheck will do nothing.
		 */
		public function uncheck():void
		{
			if (checked)
				mouseClick(null);
		}
	}
	
}
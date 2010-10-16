package dv.component
{
	import dv.graphic.Focusable;
	import dv.sound.VSound;
	import dv.utils.Resources;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * Base class for the ImageButton and TextButton.
	 * @author brunoja
	 */
	public class Button extends Focusable
	{
		private var button:SimpleButton;
		private var clickSound:VSound;
		
		/**
		 * Constructor. Should instantiate ImageButton or TextButton only!
		 */
		public function Button()
		{
			super();
			addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
		}
		
		/**
		 * If key pressed and is enter key, dispatch click event.
		 */
		private function keyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		/**
		 * Assigning a click sound to the button.
		 * @param symbol the sound symbol
		 */
		public function assignClickSound(symbol:String):void
		{
			clickSound = new VSound(symbol);
			button.addEventListener(MouseEvent.MOUSE_UP, playClick, false, 0, true);
		}
		
		/**
		 * The click event, to play the assigned sound.
		 */
		private function playClick(e:Event):void
		{
			clickSound.play();
		}
		
		/**
		 * Setting the text color. Its only implemented by TextButton.
		 * @param color the color
		 */
		public function setColor(color:uint):void
		{
			
		}
	}
	
}
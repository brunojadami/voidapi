package dv.component 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * The text button implements a component to be used as a text button.
	 * @author brunoja
	 */
	public class TextButton extends Button
	{
		private var text:Text;
		private var color:uint;
		private var useBack:Boolean;
		static private var overColor:uint;
		static private var backColor:uint;
		static private var space:int;
		
		/**
		 * Setting buttons style. Only for created as text.
		 * @param overColor the color when the mouse over it
		 * @param backColor the color of the background
		 * @param spacement the spacement of the text inside of the button
		 */
		static public function setStyle(overCol:uint, backCol:uint, spacement:int):void
		{
			overColor = overCol;
			backColor = backCol;
			space = spacement;
		}
		
		/**
		 * Constructor. Creating the button.
		 * @param text the button text
		 * @param useBack if it uses background
		 */
		public function TextButton(text:Text, useBack:Boolean = true) 
		{
			super();
			createAsText(text, useBack);
		}
		
		/**
		 * Setting the text color.
		 * @param color the color
		 */
		override public function setColor(color:uint):void
		{
			this.color = color;
			text.setColor(color);
		}
		
		/**
		 * Create the button from a simple text. Parameters = constrcutor.
		 */
		private function createAsText(text:Text, useBack:Boolean = true):void
		{
			color = text.getTextField().textColor;
			this.text = text;
			this.useBack = useBack;
			addChild(text);
			if (useBack)
			{
				drawBack();
				addEventListener(MouseEvent.MOUSE_OVER, mouseOver, false, 0, true);
				addEventListener(MouseEvent.MOUSE_OUT, mouseOut, false, 0, true);
				buttonMode = true;
				mouseChildren = false;
			}
			else
			{
				text.addEventListener(MouseEvent.MOUSE_OVER, mouseOver, false, 0, true);
				text.addEventListener(MouseEvent.MOUSE_OUT, mouseOut, false, 0, true);
				text.buttonMode = true;
				text.mouseChildren = false;
			}
			text.center();
		}
		
		/**
		 * Draws the back of the button.
		 */
		private function drawBack():void
		{
			if (useBack)
			{
				graphics.clear();
				graphics.beginFill(backColor);
				graphics.drawRoundRect(0, 0, width + space * 2, height + space * 2, 10);
				graphics.endFill();
			}
		}
		
		/**
		 * @return the text button
		 */
		public function getButtonText():Text
		{
			return text;
		}
		
		/**
		 * Updating the text and the button background.
		 * @param text the text string
		 */
		public function updateText(text:String):void
		{
			this.text.updateText(text);
			drawBack();
		}
		
		/**
		 * Mouse over event.
		 */
		private function mouseOver(e:Event):void
		{
			text.setColor(overColor);
		}
		
		/**
		 * Mouse out event.
		 */
		private function mouseOut(e:Event):void
		{
			text.setColor(color);
		}
		
	}

}
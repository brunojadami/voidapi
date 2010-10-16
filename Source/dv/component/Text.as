package dv.component
{
	import dv.graphic.VGraphic;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * A simple text. Like a label.
	 * @author brunoja
	 */
    public class Text extends VGraphic
    {
        private var string:String;
        private var textField:TextField;
		private var color:uint;
		private var overColor:uint;

		/**
		 * Constructor.
		 * @param string the text string
		 * @param format the format, use Fonts class
		 * @param color the text color
		 * @param selecatable if the text is selectable
		 * @param usesMouse if it uses the mouse for events
		 */
        public function Text(string:String, format:TextFormat, color:uint = 0x000000, 
			selectable:Boolean = false, usesMouse:Boolean = false)
        {
			super();
			createText(string, format, color, selectable, usesMouse);
        }
		
		/**
		 * Creating the text. Parameters are the same as the constructor.
		 */
		private function createText(string:String, format:TextFormat, color:uint, selectable:Boolean, usesMouse:Boolean):void
		{
			this.string = string;
            textField = createTextField(string, format, selectable);
			this.color = color;
            setColor(color);
			textField.mouseEnabled = usesMouse;
            addChild(textField);
			if (!usesMouse)
			{
				mouseEnabled = false;
				mouseChildren = false;
			}
			if (!selectable || !usesMouse)
				tabEnabled = false;
		}

		/**
		 * Sets the color of the text.
		 * @param color the text color
		 */
        public function setColor(color:uint):void
        {
            textField.textColor = color;
        }
		
		/**
		 * @return the TextField related to this component.
		 */
		public function getTextField():TextField
		{
			return textField;
		}

		/**
		 * Creating the TextField.
		 */
        private function createTextField(text:String, format:TextFormat, selectable:Boolean):TextField
        {
            var result:TextField = new TextField();
            result.x = result.y = 0;
            result.embedFonts = true;
            result.gridFitType = GridFitType.PIXEL;
            result.antiAliasType = AntiAliasType.ADVANCED;
            result.defaultTextFormat = format;
            result.autoSize = TextFieldAutoSize.LEFT;
            result.selectable = selectable;
            result.text = text;
            return result;
        }

		/**
		 * Updates the text.
		 * @param string the string
		 */
        public function updateText(string:String):void
        {
			if (string != textField.text)
			{
				this.string = string;
				textField.text = string;
			}
        }
		
		/**
		 * @return the text
		 */
		public function getString():String
		{
			return string;
		}
    }

}

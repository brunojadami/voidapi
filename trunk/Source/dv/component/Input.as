package dv.component 
{
	import dv.graphic.VGraphic;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * The ImageInput and NormalInput base class.
	 * @author brunoja
	 */
	public class Input extends VGraphic
	{
		protected var bg:VGraphic;
		private var tf:TextField;
		
		/**
		 * Constructor. This class must not be instantiated, use ImageInput or NormalInput instead.
		 */
		public function Input() 
		{
			super();
			bg = new VGraphic();
		}
		
		/**
		 * @return the TextField related to the input
		 */
		public function getTextField():TextField
		{
			return tf;
		}
		
		/**
		 * Creating the input.
		 * @param format the text format
		 * @param password if its passworded
		 * @param maxChars the max chars
		 * @param restrict the restrict string
		 */
		protected function load(format:TextFormat, password:Boolean = false, maxChars:int = 100, 
			restrict:String = null):void
		{
			addChild(bg);
			var text:Text = new Text("", format, 0, false, true);
			tf = text.getTextField();
			tf.selectable = true;
			tf.autoSize = TextFieldAutoSize.NONE;
			tf.type = TextFieldType.INPUT;
			tf.wordWrap = true;
			tf.width = bg.width - NormalInput.getSpacement();
			tf.height = (format.size as int) + 4;
			tf.multiline = false;
			tf.maxChars = maxChars;
			tf.x = NormalInput.getSpacement();
			tf.y = (height - tf.height) / 2;
			tf.restrict = restrict;
			tf.displayAsPassword = password;
			if (password)
				tf.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			addChild(tf);
		}
		
		/**
		 * Hacky way to not allow control+c on the password.
		 */
		private function keyDown(e:KeyboardEvent):void
		{
			if (e.ctrlKey)
				tf.text = "";
		}
		
		/**
		 * @return the input text
		 */
		public function getText():String
		{
			return tf.text;
		}
		
		/**
		 * Setting the input text.
		 * @param text the text string
		 */
		public function setText(text:String):void
		{
			tf.text = text;
		}
		
	}

}
package dv.component 
{
	import dv.objects.GameObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * A box, text area, to type text.
	 * @author brunoja
	 */
	public class Memo extends GameObject
	{
		private var tf:TextField;
		private var up:Button = new Button();
		private var down:Button = new Button();
		private var downCount:int = -1;
		private var upCount:int = -1;
		private var lines:int = 0;
		public var id:String;
		private var maxLines:int;
		
		/**
		 * Constructor. Creating the memo.
		 * @param format the text format
		 * @param width the memo width
		 * @param height the memo height
		 * @param editable if its read only
		 * @param color the background color
		 * @param maxLines maximum lines
		 * @param maxChars maximum number of chars
		 * @param restrict the restrict string
		 */
		public function Memo(format:TextFormat, width:int, height:int, editable:Boolean, color:uint, maxLines:int, 
			maxChars:int = -1, restrict:String = null) 
		{
			super(true, false);
			create(format, width, height, editable, color, maxLines, maxChars, restrict);
		}
		
		/**
		 * Creating, the parameters are the same of the contructor.
		 */
		private function create(format:TextFormat, width:int, height:int, editable:Boolean, color:uint, maxLines:int, maxChars:int = -1, restrict:String = null):void
		{
			this.maxLines = maxLines;
			// Body
			graphics.beginFill(color);
			graphics.drawRoundRect(0, 0, width, height, 10);
			graphics.endFill();
			// Up and Down button
			var temp:Text = new Text("U", format, 0, false, true);
			up = new TextButton(temp, false); up.x = width - up.width;
			addChild(up);
			temp = new Text("D", format, 0, false, true);
			down = new TextButton(temp, false); down.x = width - down.width - 1; down.y = height - down.height;
			addChild(down);
			up.addEventListener(MouseEvent.MOUSE_DOWN, upDown, false, 0, true);
			down.addEventListener(MouseEvent.MOUSE_DOWN, downDown, false, 0, true);
			up.addEventListener(MouseEvent.MOUSE_UP, upUp, false, 0, true);
			down.addEventListener(MouseEvent.MOUSE_UP, downUp, false, 0, true);
			// Edit
			var text:Text = new Text("", format, 0, false, true);
			tf = text.getTextField();
			tf.selectable = true;
			tf.mouseEnabled = true;
			tf.autoSize = "none";
			tf.maxChars = maxChars;
			tf.restrict = restrict;
			if (editable)
				tf.type = TextFieldType.INPUT;
			else
			{
				tf.type = TextFieldType.DYNAMIC;
				tf.tabEnabled = false;
			}
            tf.mouseWheelEnabled = true;
            tf.wordWrap = true;
            tf.multiline = true;
            tf.width = width - up.width * 3 / 2;
            tf.height = height - up.height;
			tf.addEventListener(Event.SCROLL, scrolled, false, 0, true);
			tf.x = up.width / 2;
			tf.y = up.height / 2;
			addChild(tf);
		}
		
		/**
		 * Button up was pressed event.
		 */
		private function upDown(e:Event):void
		{
			upCount = 5;
		}
		
		/**
		 * Button up was released event.
		 */
		private function upUp(e:Event):void
		{
			upCount = -1;
		}
		
		/**
		 * Button down was pressed event.
		 */
		private function downDown(e:Event):void
		{
			downCount = 5;
		}
		
		/**
		 * Button up was released event.
		 */
		private function downUp(e:Event):void
		{
			downCount = -1;
		}
		
		/**
		 * Scroll event.
		 */
		private function scrolled(e:Event):void
		{
			colorUpDown();
		}
		
		/**
		 * The logic of the memo, updating the scroll stuff.
		 */
		override protected function logic(e:Event):void 
		{
			if (downCount > -1 && ++downCount > 4)
			{
				downCount = 0;
				++tf.scrollV;
				colorUpDown();
			}
			if (upCount > -1 && ++upCount > 4)
			{
				upCount = 0;
				--tf.scrollV;
				colorUpDown();
			}
		}
		
		/**
		 * Color the up and down button according to the scroll.
		 */
		public function colorUpDown(doesBlink:Boolean = false):void
		{
			if (tf.scrollV != 1)
				up.setColor(0xff0000);
			else
				up.setColor(0x000000);
			if (tf.maxScrollV == tf.scrollV)
				down.setColor(0x000000);
			else
			{
				if (doesBlink)
					down.blink(8, 0.1);
				down.setColor(0xff0000);
			}
		}
		
		/**
		 * Adding html line.
		 * @param str the html text
		 * @param color the color string, ex: "ff0000" (red)
		 * @param useDate if display the date
		 */
		public function addHtmlTextLine(str:String, color:String, useDate:Boolean = true):void
		{
			var scrollDown:int;
			if (tf.maxScrollV - tf.scrollV == 0)
				scrollDown = -1;
			else
				scrollDown = tf.scrollV;
			tf.htmlText += "<font face='Small' size='8' color='#" + color + "'>";
			if (useDate)
			{
				var date:Date = new Date();
				tf.htmlText += '[' + date.toTimeString().substr(0, 5) + ']';
			}
			tf.htmlText += str + " < br > < / font > ";
			if (scrollDown == -1)
				scrollDown = tf.maxScrollV;
			tf.scrollV = scrollDown;
			++lines;
			if (lines > maxLines)
			{
				tf.htmlText = tf.htmlText.slice(tf.htmlText.search("</P>") + 4);
				tf.scrollV = scrollDown;
			}
			colorUpDown(true);
		}
		
		/**
		 * Clearing the memo.
		 */
		public function clearMemo():void
		{
			lines = 0;
			tf.htmlText = "";
		}
		
		/**
		 * @return the TextField related to the memo
		 */
		public function getTextField():TextField
		{
			return tf;
		}
	}

}
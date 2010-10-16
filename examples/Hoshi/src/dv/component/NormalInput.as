package dv.component 
{
	import dv.graphic.VGraphic;
	import flash.text.TextFormat;
	
	/**
	 * The NormalInput is an input created with some graphic drawn background.
	 * @author brunoja
	 */
	public class NormalInput extends Input
	{
		static private var color:uint;
		static private var space:int;
		
		/**
		 * Setting the inputs style.
		 * @param col the background color
		 * @param spacement the TextField spacement, centralization
		 */
		static public function setStyle(col:uint, spacement:int):void
		{
			color = col;
			space = spacement;
		}
		
		/**
		 * @return the style spacement
		 */
		static public function getSpacement():int
		{
			return space;
		}
		
		/**
		 * Constructor. Creating the input.
		 * @param format the text format
		 * @param width the width of the input
		 * @param maxChars the maximum number of chars
		 * @param password if its passworded
		 * @param restrict the restrict string
		 */
		public function NormalInput(format:TextFormat, width:int, maxChars:int, password:Boolean = false, 
			restrict:String = null) 
		{
			super();
			createNormal(format, width, maxChars, password, restrict);
		}
		
		/**
		 * Creating the normal input, the parameters are the same of the constructor.
		 */
		private function createNormal(format:TextFormat, width:int, maxChars:int, password:Boolean = false, restrict:String = null):void
		{
			// Background
			bg = new VGraphic();
			bg.graphics.beginFill(NormalInput.color);
			bg.graphics.drawRoundRect(0, 0, width, (format.size as int) + NormalInput.space, 10);
			bg.graphics.endFill();
			// Creating
			load(format, password, maxChars, restrict);
		}
		
	}

}
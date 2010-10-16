package dv.component 
{
	import flash.text.TextFormat;
	
	/**
	 * The ImageInput class creates an input with some image as the background.
	 * @author brunoja
	 */
	public class ImageInput extends Input
	{
		/**
		 * Constructor. Creating the image input.
		 * @param image the image symbol, to be used as the background
		 * @param format the text format
		 * @param password if its passworded
		 * @param maxChars the max chars
		 * @param restrict the restrict string
		 */
		public function ImageInput(image:String, format:TextFormat, password:Boolean = false, 
			maxChars:int = 100, restrict:String = null) 
		{
			super();
			bg = new VSprite(image);
			load(format, password, maxChars, restrict);
		}
		
	}

}
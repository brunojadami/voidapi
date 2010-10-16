package dv.component 
{
	/**
	 * The ImageButton class is a button created with images, a up image, over image and down image.
	 * @author brunoja
	 */
	public class ImageButton 
	{
		private var over:VSprite = new VSprite();
		private var up:VSprite = new VSprite();
		private var down:VSprite = new VSprite();
		
		/**
		 * Constructor. Creating the button.
		 * @param symbol the symbol for the images, symbol+Up, symbol+Over, symbol+Down, if over and/or down
		 * are not found they are replaced by the up image.
		 */
		public function ImageButton(symbol:String) 
		{
			super();
			load(symbol);
		}
		
		/**
		 * Loading stuff, the parameter is the same as the constructor.
		 */
		private function load(symbol:String):void
		{
			up.load(symbol + "Up");
			if (Resources.hasSymbol(symbol + "OverImage"))
				over.load(symbol + "Over");
			else
				over = up;
			if (Resources.hasSymbol(symbol + "DownImage"))
				down.load(symbol + "Down");
			else
				down = up;
			button = new SimpleButton(up, over, down, over);
			button.useHandCursor = true;
			addChild(button);
		}
		
	}

}
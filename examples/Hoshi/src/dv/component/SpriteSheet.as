package dv.component 
{
	import dv.graphic.VGraphic;
	import dv.utils.Resources;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Class to manipulate sprite sheets, images inside images.
	 * @author brunoja
	 */
	public class SpriteSheet
	{
		private var spriteSheet:Bitmap;
		private var tileWidth:int;
		private var tileHeight:int;
		
		/**
		 * Constructor. Creating the sheet.
		 * @param sprite the sprite symbol
		 * @param tileWidth the width of each image, if 0 the width is the sheet height
		 * @param tileHeight the height of each image, if 0 the width is the sheet height
		 */
		public function SpriteSheet(sprite:String, tileWidth:int = 0, tileHeight:int = 0) 
		{
			load(sprite, tileWidth, tileHeight);
		}
		
		/**
		 * @return getting each image width
		 */
		public function getWidth():int
		{
			return tileWidth;
		}
		
		/**
		 * Loading sheet, paramters = contructor.
		 */
		private function load(sprite:String, tileWidth:int = 0, tileHeight:int = 0):void
		{
			spriteSheet = Resources.getSymbol(sprite + "Image");
			if (tileWidth == 0)
				this.tileWidth = spriteSheet.height;
			else
				this.tileWidth = tileWidth;
			if (tileHeight == 0)
				this.tileHeight = spriteSheet.height;
			else
				this.tileHeight = tileHeight;
		}
		
		/**
		 * @return the VSprite related to the sheet
		 */
		public function getSheet():Bitmap
		{
			return spriteSheet;
		}
		
		/**
		 * @param x position of the image
		 * @param y position of the image
		 * @return the image from the parameter coordinates
		 */
		public function getSprite(x:int, y:int):VGraphic
		{
			var bitmapData:BitmapData = new BitmapData(tileWidth, tileHeight);
			var rectangle:Rectangle = new Rectangle(x * tileWidth, y * tileHeight, tileWidth, tileHeight);
			
			bitmapData.copyPixels(spriteSheet.bitmapData, rectangle, new Point());
			
			var sprite:VGraphic = new VGraphic();
			sprite.graphics.beginBitmapFill(bitmapData);
			sprite.graphics.drawRect(0, 0, bitmapData.width, bitmapData.height);
			sprite.graphics.endFill();
			
			return sprite;
		}
	}
}
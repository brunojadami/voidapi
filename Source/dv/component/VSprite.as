package dv.component
{
	import dv.changeables.Main;
	import dv.graphic.VGraphic;
	import dv.utils.Resources;
	import flash.display.Bitmap;
	import flash.system.System;
	import flash.utils.getTimer;
	
	/**
	 * An sprite, png, jpg, bmp, whatever flash supports :)
	 * @author brunoja
	 */
	public class VSprite extends VGraphic
	{
		/**
		 * Constructor. Creating the sprite.
		 * @param symbol the symbol to be loaded
		 */
		public function VSprite(symbol:String)
		{
			super();
			load(symbol);
		}
		
		/**
		 * Loading image. Parameter is the same as the constructor.
		 */
		private function load(symbol:String):void
		{
			var memoryNow:int;
			var timeNow:int;
			if (Main.debug)
			{
				memoryNow = System.totalMemory;
				timeNow = getTimer();
			}
			var bitmap:Bitmap = Resources.getSymbol(symbol + "Image");
			graphics.beginBitmapFill(bitmap.bitmapData);
			graphics.drawRect(0, 0, bitmap.width, bitmap.height);
			graphics.endFill();
			if (Main.debug)
			{
				trace("Memory usage for sprite " + symbol + " is aprox: " + int((System.totalMemory - memoryNow) / 1000) / 1000 + 
					  " MBs, time to load: " + (getTimer() - timeNow) + " ms");
			}
		}
	}
	
}
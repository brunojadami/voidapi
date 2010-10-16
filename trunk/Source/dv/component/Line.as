package dv.component
{
	import flash.display.Sprite;
	
	/**
	 * A line, drawn with graphics.
	 * @author brunoja
	 */
	public class Line extends VGraphic
	{
		private var sprite:Sprite = new Sprite();
		
		/**
		 * Contructor. Creating line.
		 * @param x start posX
		 * @param y start posY
		 * @param toX end posX
		 * @param toY end posY
		 * @param thickness the thickness of the line
		 * @param color the color of the line
		 */
		public function Line(x:int, y:int, toX:int, toY:int, thickness:Number = 1, color:uint = 0x000000)
		{
			super();
			this.x = x;
			this.y = y;
			sprite.graphics.lineStyle(thickness, color);
			sprite.graphics.lineTo(toX, toY);
			addChild(sprite);
		}
	}
	
}
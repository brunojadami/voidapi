package dv.objects 
{
	import dv.changeables.Global;
	
	/**
	 * An extension of the GameObject class, the TileObject, based on tiles.
	 * @author brunoja
	 */
	public class TileObject extends GameObject
	{
		static public const DIR_NONE:int = -1;
		static public const DIR_NORTH:int = 0;
		static public const DIR_EAST:int = 1;
		static public const DIR_SOUTH:int = 2;
		static public const DIR_WEST:int = 3;
		static public const START_X:int = 0;
		static public const START_Y:int = 0;
		
		protected var id:int;
		protected var stackPos:int = 0;
		
		/**
		 * Constructor. For paramters see the GameObject class.
		 */
		public function TileObject(useLogicEvent:Boolean = true, useAutoDestructor:Boolean = false) 
		{
			super(useLogicEvent, useAutoDestructor);
		}
		
		/**
		 * Sets the stack position.
		 * @param stackPos the pos
		 */
		public function setStack(stackPos:int):void
		{
			this.stackPos = stackPos;
		}
		
		/**
		 * @return the position on the display stack
		 */
		public function getStack():int
		{
			return stackPos;
		}
		
		/**
		 * Updating the position on the screen.
		 * @param ux the zoomx position
		 * @param uy the zoomy position
		 */
		public function updateScreenPos(ux:int, uy:int):void
		{
			x = ux * Global.SQM + START_X;
			y = uy * Global.SQM + START_Y;
		}
		
		/**
		 * @param viewX the zoomx position
		 * @param viewY the zoomy position
		 * @return if its visible on the screen
		 */
		public function isVisible(viewX:int, viewY:int):Boolean
		{
			return posX >= viewX - 1 && posX <= viewX + Global.TILES_V_WIDTH && posY >= viewY - 1 && posY <= viewY + Global.TILES_V_HEIGHT;
		}
		
		/**
		 * Moving function, to be implemented if you want to add some animation while moving.
		 * @param dir the direction
		 */
		public function move(dir:int):void
		{
			
		}
		
		/**
		 * @return the tile id
		 */
		public function getId():int
		{
			return id;
		}
		
		/**
		 * Maximum from horizontal or vertical distance from another tileobject.
		 * @param to the other object
		 * @return the distance
		 */
		public function rangeFrom(to:TileObject):int
		{
			var absX:int = Math.abs(to.posX - posX);
			var absY:int = Math.abs(to.posY - posY);
			return Math.max(absX, absY);
		}
	}

}
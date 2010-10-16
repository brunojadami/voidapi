package dv.objects
{
	import dv.changeables.Global;
	import dv.graphic.VGraphic;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Usefull to extend. It will represent objects of the game.
	 * @author brunoja
	 */
	public class GameObject extends VGraphic
	{	
		protected var posX:int;
		protected var posY:int;
		protected var bounded:Boolean = false;
		
		/**
		 * Constructor.
		 * @param useLogicEvent if it uses the logic event function
		 * @param useAutoDestructor if when it is removed from the display list the destructor is called
		 */
		public function GameObject(useLogicEvent:Boolean = true, useAutoDestructor:Boolean = true) 
		{
			super();
			if (useLogicEvent)
				addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			if (useAutoDestructor)
				addEventListener(Event.REMOVED_FROM_STAGE, destructor, false, 0, true);
		}
		
		/**
		 * Setting the logic function, after its been added to a container.
		 */
		protected function added(e:Event):void
		{
			addEventListener(Event.ENTER_FRAME, logic, false, 0, true);
		}
		
		/**
		 * Clears the events and the display list.
		 */
		public function destructor(e:Event):void
		{
			clearEvents();
			clearDisplayList();
		}
		
		/**
		 * Cleaning events.
		 */
		protected function clearEvents():void
		{
			removeEventListener(Event.ENTER_FRAME, logic);
			removeEventListener(Event.ADDED_TO_STAGE, added);
			removeEventListener(Event.REMOVED_FROM_STAGE, destructor);
		}
		
		/**
		 * Logic to be implemented (override).
		 */
		protected function logic(e:Event):void
		{
			
		}
		
		/**
		 * Setting the relative position.
		 * @param x horizontal position
		 * @param y vertical position
		 */
		public function setOnlyPos(x:int, y:int):void
		{
			posX = x;
			posY = y;
		}
		
		/**
		 * Setting the relative position and screen position.
		 * @param x horizontal position
		 * @param y vertical position
		 */
		override public function setPos(x:int, y:int):void
		{
			super.setPos(x, y);
			posX = x;
			posY = y;
		}
		
		/**
		 * Setting the relative and screen pos x.
		 * @param x horizontal position
		 */
		public function setPosX(x:int):void
		{
			posX = x;
			this.x = x;
		}
		
		/**
		 * Setting the relative and screen pos y.
		 * @param y vertical position
		 */
		public function setPosY(y:int):void
		{
			posY = y;
			this.y = y;
		}
		
		/**
		 * @return the horizontal relative position
		 */
		public function getPosX():int
		{
			return posX;
		}
		
		/**
		 * @return the vertical relative position
		 */
		public function getPosY():int
		{
			return posY;
		}
		
		/**
		 * Incs the relative and screen y position.
		 */
		public function incPosY():void
		{
			++y;
			++posY;
		}
		
		/**
		 * @return if this object is out of the screen bounds.
		 */
		public function isOutOfScreen():Boolean
		{
			if (posX - width > Global.WINDOW_WIDTH)
				return true;
			else if (posX + width < 0)
				return true;
			else if (posY - height > Global.WINDOW_HEIGHT)
				return true;
			else if (posY + height < 0)
				return true;
			return false;
		}
		
		/**
		 * Adding a green rect to see the bounds of the object.
		 */
		protected function addBoundTest():void
		{
			if (width == 0)
				return;
			var rect:Sprite = new Sprite();
			bounded = true;
			rect.graphics.lineStyle(3,0x00ff00);
			rect.graphics.beginFill(0, 0);
			rect.graphics.drawRect( -getWidth() / 2, -getHeight() / 2, getWidth(), getHeight());
			rect.graphics.endFill();
			rect.x = getPosX() - posX;
			rect.y = getPosY() - posY;
			addChild(rect);
		}
		
		/**
		 * @return the width
		 */
		public function getWidth():Number
		{
			return width;
		}
		
		/**
		 * @return the height
		 */
		public function getHeight():Number
		{
			return height;
		}
	}

}
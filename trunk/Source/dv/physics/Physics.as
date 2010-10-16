package dv.physics 
{
	import dv.changeables.Global;
	import dv.objects.GameObject;
	
	/**
	 * Some physics functions. Old class.
	 * @author brunoja
	 */
	public class Physics
	{
	
		public function Physics() 
		{
			
		}
		
		/**
		 * Square 2D colission.
		 * @param a the first object
		 * @param b the second object
		 * @return if it collides
		 */
		static public function squareCollision(a: GameObject, b: GameObject):Boolean
		{
			return squareTest(a, b) || squareTest(b, a);
		}
		
		/**
		 * Doing the square colission test.
		 * @return if it collides
		 */
		static private function squareTest(a: GameObject, b: GameObject):Boolean
		{
			var aX: int = a.getPosX();
			var aY: int = a.getPosY();
			var aW: int = a.getWidth();
			var aH: int = a.getHeight();
			var bX: int = b.getPosX();
			var bY: int = b.getPosY();
			var bW: int = b.getWidth();
			var bH: int = b.getHeight();
			
			// The coords are the center, lets fix it
			aX -= aW / 2;
			aY -= aH / 2;
			bX -= bW / 2;
			bY -= bH / 2;
			
			// Checking for collision
			if ((((aX >= bX) && (aX <= bX + bW)) || ((aX + aW >= bX) && (aX + aW <= bX + bW)))&&
			   (((aY >= bY) && (aY <= bY + bH)) || ((aY + aH >= bY) && (aY + aH <= bY + bH))))
			{
				return true;
			}
			return false;
		}
		
		/**
		 * Checks if it will collide with the screen on the next step using 2D square collision.
		 * @param obj the object
		 * @param stepX the next step x
		 * @param stepY the next step y
		 * @return if collides
		 */
		static public function nextStepScreenCollision(obj:GameObject, stepX:int, stepY:int):Boolean
		{
			var ret:Boolean = false;
			obj.x += stepX;
			obj.y += stepY;
			if (obj.x + obj.width / 2 >= Global.WINDOW_WIDTH)
				ret = true;
			else if (obj.x - obj.width / 2 < 0)
				ret = true;
			else if (obj.y + obj.height / 2 >= Global.WINDOW_HEIGHT)
				ret = true;
			else if (obj.y - obj.height / 2 < 0)
				ret = true;
			obj.x -= stepX;
			obj.y -= stepY;
			return ret;
		}
		
		/**
		 * Checks if it will collide with the screen bottom on the next step using 2D square collision.
		 * @param obj the object
		 * @param stepY the next step y
		 * @return if collides
		 */
		static public function nextStepBottomScreenCollision(obj:GameObject, stepY:int):Boolean
		{
			var ret:Boolean = false;
			obj.y += stepY;
			if (obj.y + obj.height / 2 >= Global.WINDOW_HEIGHT)
				ret = true;
			obj.y -= stepY;
			return ret;
		}
		
		/**
		 * Checks if it will collide with the screen right on the next step using 2D square collision.
		 * @param obj the object
		 * @param stepX the next step x
		 * @return if collides
		 */
		static public function nextStepHorizontalScreenCollision(obj:GameObject, stepX:int):Boolean
		{
			var ret:Boolean = false;
			obj.x += stepX;
			if (obj.x + obj.width / 2 >= Global.WINDOW_WIDTH)
				ret = true;
			else if (obj.x - obj.width / 2 < 0)
				ret = true;
			obj.x -= stepX;
			return ret;
		}
	}

}
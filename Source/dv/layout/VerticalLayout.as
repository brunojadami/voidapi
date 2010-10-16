package dv.layout 
{
	import dv.graphic.VGraphic;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * Vertical layout. A layout must be inside another container or layout before adding children.
	 * @author brunoja
	 */
	public class VerticalLayout extends Layout
	{
		/**
		 * Constructor.
		 * @param w the minimum width
		 * @param h the minimum height
		 */
		public function VerticalLayout(w:int, h:int) 
		{
			super(w, h);
		}
		
		/**
		 * Reworking the layout, because some components may be higher than the width.
		 */
		override public function reworkLayout(e:Event):void
		{
			var startY:int = getMinVerSpacement();
			var vborder:int = startY;
			for (var i:int = 0; i < numChildren; ++i)
			{
				var object:DisplayObject = getChildAt(i);
				if (!object.visible)
					continue;
				object.x = (width - object.width) / 2;
				object.y = startY;
				startY += object.height + vborder;
			}
			super.reworkLayout(e);
		}
		
	}

}
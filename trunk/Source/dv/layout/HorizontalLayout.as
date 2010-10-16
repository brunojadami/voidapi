package dv.layout 
{
	import dv.graphic.VGraphic;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * Horizontal layout. A layout must be inside another container or layout before adding children.
	 * @author brunoja
	 */
	public class HorizontalLayout extends Layout
	{
		/**
		 * Constructor.
		 * @param w the minimum width
		 * @param h the minimum height
		 */
		public function HorizontalLayout(w:int, h:int) 
		{
			super(w, h);
		}
		
		/**
		 * Reworking the layout, because some components may be higher than the height.
		 */
		override public function reworkLayout(e:Event):void
		{
			var startX:int = getMinHorSpacement();
			var hborder:int = startX;
			for (var i:int = 0; i < numChildren; ++i)
			{
				var object:DisplayObject = getChildAt(i);
				if (!object.visible)
					continue;
				object.x = startX;
				object.y = (height - object.height) / 2;
				startX += object.width + hborder;
			}
			super.reworkLayout(e);
		}
		
	}

}
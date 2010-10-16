package dv.layout 
{
	import dv.graphic.VGraphic;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	/**
	 * Layout class, used as base class. A layout must be inside another container or layout before adding children.
	 * @author brunoja
	 */
	public class Layout extends VGraphic
	{
		protected var type:int;
		protected var bmp:Bitmap;
		
		/**
		 * Constructor.
		 * @param w the minimum width
		 * @param h the minimum height
		 */
		public function Layout(w:int, h:int) 
		{
			if (w < 1)
				w = 1;
			if (h < 1)
				h = 1;
			bmp = new Bitmap(new BitmapData(w, h, true, 0));
			addChild(bmp);
			bmp.visible = false;
			addEventListener(Event.ADDED, reworkLayout, true, 0, true);
			this.tabEnabled = false;
		}
		
		/**
		 * Getting the minimum horizontal spacement to add components.
		 * @return the minimum spacement
		 */
		public function getMinHorSpacement():int
		{
			var totalWidth:int;
			for (var i:int = 0; i < numChildren; ++i)
			{
				var object:DisplayObject = getChildAt(i);
				if (!object.visible)
					continue;
				totalWidth += object.width;
			}
			var ret:int = (width - totalWidth) / numChildren;
			if (ret < 0)
				return 0;
			return ret;
		}
		
		/**
		 * Getting the minimum vertical spacement to add components.
		 * @return the minimum spacement
		 */
		public function getMinVerSpacement():int
		{
			var totalHeight:int;
			for (var i:int = 0; i < numChildren; ++i)
			{
				var object:DisplayObject = getChildAt(i);
				if (!object.visible)
					continue;
				totalHeight += object.height;
			}
			var ret:int = (height - totalHeight) / numChildren;
			if (ret < 0)
				return 0;
			return ret;
		}
		
		/**
		 * Reworking the layout, must call after adding childs.
		 */
		public function reworkLayout(e:Event):void
		{
			if (parent && parent is Layout)
				(parent as Layout).reworkLayout(e);
		}
		
	}

}
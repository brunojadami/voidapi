package dv.graphic
{
	import dv.changeables.Global;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	/**
	 * Every graphic component should extend this class, it offers everything to a visual component.
	 * Remember that by default this is not tab enabled!
	 * @author brunoja
	 */
	public class VGraphic extends Sprite
	{
		static public var paused:Boolean; // Pause var, used by the animations and effects
		private var fNum:Number;
        private var fIn:Boolean;
		private var fOut:Boolean;
		private var fadeSafeWait:Boolean;
		private var blinking:Boolean;
		private var blinkCount:int;
		private var bounds:Rectangle;
		private var lockCenter:Boolean;
		private var blinkTime:Number;
		private var graphicStart:VGraphic;
		private var graphicStop:VGraphic;
		private var remove:Boolean;
		static public const FINISHED_BLINKING:String = "FinishedBlinking";
		static private var nColor:ColorTransform = new ColorTransform(1, 1, 1);
		static private var dColor:ColorTransform = new ColorTransform(1, 1, 1);
		
		/**
		 * Setting the drag style.
		 * @param normalColor the normal color transform
		 * @param dragColor the drag color transform
		 */
		static public function setStyle(normalColor:ColorTransform, dragColor:ColorTransform):void
		{
			nColor = normalColor;
			dColor = dragColor;
		}
		
		/**
		 * Constructor.
		 */
		public function VGraphic()
		{
			super();
			tabEnabled = false;
		}
		
		/**
		 * Adding the drag support.
		 * @param lockCenter startDrag lockCenter parameter
		 * @param graphicStart the drag start on this sprite mouse down
		 * @param graphicStop the drag stop on this sprite mouse up
		 * @param bounds the drag bounds
		 */
		public function addDragSupport(lockCenter:Boolean = false, graphicStart:VGraphic = null, 
			graphicStop:VGraphic = null, bounds:Rectangle = null):void
		{
			this.lockCenter = lockCenter;
			this.bounds = bounds;
			if (!graphicStart)
				graphicStart = this;
			if (!graphicStop)
				graphicStop = this;
			this.graphicStart = graphicStart;
			this.graphicStop = graphicStop;
			graphicStart.addEventListener(MouseEvent.MOUSE_DOWN, enableDrag, false, 0, true);
			graphicStop.addEventListener(MouseEvent.MOUSE_UP, disableDrag, false, 0, true);
		}
		
		/**
		 * Removing the drag support.
		 */
		public function removeDragSupport():void
		{
			graphicStart.removeEventListener(MouseEvent.MOUSE_DOWN, enableDrag);
			graphicStop.removeEventListener(MouseEvent.MOUSE_UP, disableDrag);
			graphicStart = null;
			graphicStop = null;
		}
		
		/**
		 * Enable the drag event.
		 */
		private function enableDrag(e:Event):void
		{
			startDrag(lockCenter, bounds);
			this.transform.colorTransform = dColor;
		}
		
		/**
		 * Disable the drag event.
		 */
		private function disableDrag(e:Event):void
		{
			stopDrag();
			this.transform.colorTransform = nColor;
		}
		
		/**
		 * @return if its inside a container
		 */
		public function isInsideContainer():Boolean
		{
			return this.parent != null;
		}
		
		/**
		 * Setting the position.
		 * @param x horizontal position
		 * @param y vertical position
		 */
		public function setPos(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * Fade in effect. If its already fading or blinking, will do nothing.
		 * @param num speed of the fade
		 */
		public function fadeIn(num:Number):void
        {
			if (!fIn && !fOut)
			{
				fNum = num;
				this.alpha = 0;
				fIn = true;
				fadeSafeWait = true;
				addEventListener(Event.ENTER_FRAME, fadeFunc, false, 0, true);
			}
        }
		
		/**
		 * Fade out effect. If its already fading or blinking, will do nothing.
		 * @param num speed of the fade
		 * @param remove if after the fade remove it from its parent display container
		 */
		public function fadeOut(num:Number, remove:Boolean = false):void
        {
			if (!fIn && !fOut)
			{
				this.remove = remove;
				fNum = num;
				this.alpha = 1;
				fOut = true;
				fadeSafeWait = true;
				addEventListener(Event.ENTER_FRAME, fadeFunc, false, 0, true);
			}
        }
		
		/**
		 * Fade function logic.
		 */
		private function fadeFunc(e:Event):void
		{
			if (paused)
				return;
			if (fIn)
            {
                if (alpha < 1) 
				{
					alpha = alpha + fNum;
				}
                if (alpha >= 1 && fadeSafeWait)
				{
					alpha = 1;
					fadeSafeWait = false;
				}
				else if (!fadeSafeWait)
				{
					fIn = false;
					removeEventListener(Event.ENTER_FRAME, fadeFunc);
					if (blinking)
					{
						--blinkCount;
						if (blinkCount == 0)
						{
							blinking = false;
							dispatchEvent(new Event(FINISHED_BLINKING));
						}
						else
							fadeOut(blinkTime);
					}
				}
            } 
			else if (fOut) 
			{
				if (alpha > 0) 
					alpha -= fNum; 
				if (alpha <= 0 && fadeSafeWait)
				{
					alpha = 0;
					fadeSafeWait = false;
				}
				else if (!fadeSafeWait)
				{
					fOut = false;
					removeEventListener(Event.ENTER_FRAME, fadeFunc);
					if (remove)
						parent.removeChild(this);
					if (blinking)
					{
						--blinkCount;
						if (blinkCount == 0)
						{
							blinking = false;
							dispatchEvent(new Event(FINISHED_BLINKING));
						}
						else
							fadeIn(blinkTime);
					}
				}
			}
		}
		
		/**
		 * @return if its blinking
		 */
		public function isBlinking():Boolean
		{
			return blinking;
		}
		
		/**
		 * Blinking. If its already fading or blinking, will do nothing.
		 * @param times the times to blink
		 * @param fadeTime the fadeTime
		 * @param fOut if it will fade out
		 */
		public function blink(times:int, fadeTime:Number, fOut:Boolean = true):void
		{
			if (blinking || this.fIn || this.fOut)
				return;
			blinkCount = times * 2;
			blinkTime = fadeTime;
			blinking = true;
			if (fOut)
				fadeOut(blinkTime);
			else
				fadeIn(blinkTime);
		}
		
		/**
		 * @return if finished the fades
		 */
		public function finishedFades():Boolean
		{
			return !fIn && !fOut;
		}
		
		/**
		 * Center x on parent. If there is no parent it will center on screen.
		 */
		public function centerX():void
		{
			if (parent)
				x = (parent.width - width) / 2;
			else
				x = (Global.WINDOW_WIDTH - width) / 2;
		}
		
		/**
		 * Center y on parent. If there is no parent it will center on screen.
		 */
		public function centerY():void
		{
			if (parent)
				y = (parent.height - height) / 2;
			else
				y = (Global.WINDOW_HEIGHT - height) / 2;
		}
		
		/**
		 * Center on parent. If there is no parent it will center on screen.
		 */
		public function center():void
		{
			centerX();
			centerY();
		}
		
		/**
		 * Center on point.
		 * @param posX horizontal position
		 * @param posy vertical position
		 */
		public function centerOn(posX:int, posy:int):void
		{
			x = -width / 2 + posX;
			y = -height / 2 + posy;
		}
		
		/**
		 * Removes everyone from this object displaylist.
		 */
		public function clearDisplayList():void
		{
			while (numChildren > 0)
				removeChildAt(0);
		}
	}
	
}
package dv.component
{
	import dv.changeables.Global;
	import dv.graphic.VGraphic;
	import dv.objects.GameObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	/**
	 * A Box container. You can add other components inside it to create windows and etc..
	 * @author brunoja
	 */
	public class Box extends GameObject
	{
		protected var frame:VGraphic;
		protected var closeB:Button;
		protected var minimizeB:Button;
		protected var text:Text;
		protected var body:VGraphic;
		private var willHide:Boolean;
		private var willClose:Boolean;
		protected var minimized:Boolean;
		private var movable:Boolean;
		private var minimizing:Boolean;
		private var addY:Number = 0;
		static protected var frameColor:uint;
		static protected var bodyColor:uint;
		static protected var descColor:uint;
		static protected var exitColor:uint;
		static protected var bAlpha:Number;
		static protected var format:TextFormat;
		
		/**
		 * Sets the box style.
		 * @param frameCol the frame color
		 * @param bodyCol the body color
		 * @param descCol the title color
		 * @param exitCol the exit button text color
		 * @param bodyAlpha the body alpha
		 * @param txtFormat the format of the body texts
		 */
		static public function setStyle(frameCol:uint, bodyCol:uint, descCol:uint, exitCol:uint, bodyAlpha:Number, txtFormat:TextFormat):void
		{
			frameColor = frameCol;
			bodyColor = bodyCol;
			descColor = descCol;
			exitColor = exitCol;
			bAlpha = bodyAlpha;
			format = txtFormat;
		}
		
		/**
		 * Constructor. Creating the box.
		 * @param width the box width
		 * @param height the box height
		 * @param string the title
		 * @param visible if its visible by default
		 * @param canClose if its closable
		 * @param movable if its movable
		 * @param minimizable if its minimizable
		 */
		public function Box(width:int, height:int, string:String, visible:Boolean = true, 
			canClose:Boolean = true, movable:Boolean = true, minimizable:Boolean = true) 
		{
			super();
			tabEnabled = false;
			if (!visible)
			{
				this.visible = false;
				this.alpha = 0;
			}
			create(width, height, string, canClose, movable, minimizable);
		}
		
		/**
		 * Creating the box, the parameters are the same as the constructor.
		 */
		private function create(width:int, height:int, string:String, canClose:Boolean = true, movable:Boolean = true, minimizable:Boolean = true):void
		{
			body = new VGraphic();
			frame = new VGraphic();
			// Creating the body
			body.graphics.beginFill(bodyColor, bAlpha);
			body.graphics.drawRoundRect(0, 0, width, height, 10);
			body.graphics.endFill();
			addChild(body);
			// Creating the north frame, the title
			frame.graphics.beginFill(frameColor);
			frame.graphics.drawRoundRect(0, 0, width, 12, 10);
			frame.graphics.endFill();
			addChild(frame);
			this.movable = movable;
			if (movable)
				addDragSupport(false, frame, this, new Rectangle(0, 0, Global.WINDOW_WIDTH - width, Global.WINDOW_HEIGHT - height));
			text = new Text(string, format, descColor);
			frame.addChild(text);
			// Creating the close and minimize buttons
			var temp:Text;
			if (canClose)
			{
				temp = new Text("X", format, exitColor, false, true);
				closeB = new TextButton(temp, false);
				closeB.addEventListener(MouseEvent.MOUSE_UP, closeClick, false, 0, true);
				closeB.x = width - closeB.width;
				closeB.tabEnabled = false;
				addChild(closeB);
			}
			else
				closeB = null;
			if (minimizable)
			{
				temp = new Text("-", format, exitColor, false, true);
				minimizeB = new TextButton(temp, false);
				minimizeB.addEventListener(MouseEvent.MOUSE_UP, minimizeClick, false, 0, true);
				minimizeB.x = width - minimizeB.width; 
				if (closeB)
					minimizeB.x -= closeB.width * 3 / 2;
				addChild(minimizeB);
				minimizeB.tabEnabled = false;
			}
			else
				minimizeB = null;
			if (canClose)
			{
				body.doubleClickEnabled = true;
				body.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClick, false, 0, true);
			}
			if (minimizable)
			{
				frame.doubleClickEnabled = true;
				frame.addEventListener(MouseEvent.DOUBLE_CLICK, minimizeClick, false, 0, true);
			}
		}
		
		/**
		 * Minimizing the box event, clicked on the minimize button.
		 */
		private function minimizeClick(e:Event):void
		{
			if (!minimizing)
			{
				minimizing = true;
				if (minimized)
				{
					body.visible = true;
					addY = (Global.WINDOW_HEIGHT - (y + height)) * 0.1;
					if (addY > 0)
						addY = 0;
				}
				if (movable)
					removeDragSupport();
			}
		}
		
		/**
		 * Blinking the box frame title, description.
		 * @param times the number of times to blink
		 * @param time the speed of the blinks
		 */
		public function blinkDescription(times:int, time:Number):void
		{
			text.blink(times, time);
		}
		
		/**
		 * Double click to hide box event.
		 */
		protected function doubleClick(e:Event):void
		{
			hide();
		}
		
		/**
		 * Click to close box event.
		 */
		private function closeClick(e:Event):void
		{
			hide();
		}
		
		/**
		 * Hiding the box, it is not destroyed.
		 */
		public function hide():void
		{
			if (finishedFades())
			{
				fadeOut(0.1);
				willHide = true;
			}
		}
		
		/**
		 * @return if its minimized
		 */
		public function isMinimized():Boolean
		{
			return minimized;
		}
		
		/**
		 * Close and destroy the box.
		 */
		public function close():void
		{
			if (finishedFades())
			{
				fadeOut(0.1);
				willClose = true;
			}
		}
		
		/**
		 * Showing the box.
		 * @param x position x to show
		 * @param y position y to show
		 */
		public function show(x:int, y:int):void
		{
			if (finishedFades())
			{ 
				this.x = x;
				this.y = y;
				visible = true;
				willHide = false;
				fadeIn(0.1);
			}
		}
		
		/**
		 * Logic to hide, minimize and etc the box.
		 */
		override protected function logic(e:Event):void 
		{
			// Hiding
			if (willHide && finishedFades())
			{
				if (stage.focus == this)
					stage.focus = parent;
				visible = false;
				willHide = false;
			}
			else if (willClose && finishedFades())
			{
				if (stage.focus == this)
					stage.focus = parent;
				parent.removeChild(this);
			}
			// Minimizing
			if (minimizing)
			{
				if (!minimized) // Minimize
				{
					body.alpha -= 0.1;
					if (body.alpha <= 0)
					{
						minimizing = false;
						minimized = true;
						body.mouseEnabled = false;
						body.visible = false;
						if (movable)
							addDragSupport(false, frame, this, new Rectangle(0, 0, Global.WINDOW_WIDTH - frame.width, Global.WINDOW_HEIGHT - frame.height));
					}
				}
				else // Maximize
				{
					body.alpha += 0.1;
					if (body.alpha >= 1)
					{
						minimizing = false;
						body.alpha = 1;
						minimized = false;
						body.mouseEnabled = true;
						if (movable)
							addDragSupport(false, frame, this, new Rectangle(0, 0, Global.WINDOW_WIDTH - width, Global.WINDOW_HEIGHT - height));
					}
					else
						y += addY;
				}
			}
		}
		
		/**
		 * Disable body mouse events.
		 */
		public function disableBodyMouse():void
		{
			body.mouseChildren = false;
		}
		
		/**
		 * Enable body mouse events.
		 */
		public function enableBodyMouse():void
		{
			body.mouseChildren = true;
		}
		
		/**
		 * Sets the frame title.
		 * @param title the title
		 */
		public function setTitle(title:String):void
		{
			text.updateText(title);
		}
	}

}
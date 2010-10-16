package dv.component
{
	import dv.changeables.Main;
	import dv.utils.Resources;
	import dv.utils.StringStream;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.getTimer;

	/**
	 * An Swf class for loading swfs and playing them.
	 * @author brunoja
	 */
	public class Swf extends VGraphic
	{
		private var repeat:Boolean;
		private var autoPlay:Boolean;
		private var reverse:Boolean;
		private var frames:Array;
		private var total:int;
		private var currFrame:int;
		private var symbol:String;
		private var count:int;
		private var delay:int;
		private var loaded:Boolean;
		private var twidth:Number;
		private var theight:Number;
		private var real:Boolean;
		private var mc:MovieClip;
		private var smoothing:Boolean;
		private var object:Object;
		static public const FINISHED_LOADING:String = "Finishedloading";
		
		/**
		 * Its not 100% functional, need to redo it.
		 */
		public function Swf(symbol:String, autoPlay:Boolean = true, repeat:Boolean = true, 
			reverse:Boolean = false, real:Boolean = false)
		{
			super();
			addEventListener(Event.REMOVED_FROM_STAGE, destructor, false, 0, true);
			load(symbol, autoPlay, repeat, reverse, real);
		}
		
		/**
		 * Destructor when its removed from the stage. Just stop the animation.
		 */
		private function destructor(e:Event):void
		{
			stop();
		}
		
		/**
		 * Enabled frames smoothing.
		 */
		public function enableSmoothing():void
		{
			smoothing = true;
		}
		
		/**
		 * Loading swf, parameters = contructor.
		 */
		private function load(symbol:String, autoPlay:Boolean, repeat:Boolean, reverse:Boolean, real:Boolean):void
		{
			object = Resources.getSymbol(symbol + "Swf");
			object.addEventListener(Event.COMPLETE, completed, false, 0, true);
			this.autoPlay = autoPlay;
			this.repeat = repeat;
			this.reverse = reverse;
			this.symbol = symbol;
			this.real = real;
			loadInfo();
		}
		
		/**
		 * Loading information from file. symbol+Info (width, height, delay)
		 */
		private function loadInfo():void
		{
			var content:String = Resources.getSymbol(symbol + "Info");
			var stream:StringStream = new StringStream(content, "\n");
			twidth = stream.getVal();
			theight = stream.getVal();
			delay = stream.getVal();
			count = 0;
		}
		
		/**
		 * Setting the animation delay.
		 * @param delay the speed
		 */
		public function setDelay(delay:int):void
		{
			this.delay = delay;
		}
		
		/**
		 * Preparing the swf movie clip.
		 */
		private function prepare(mc:MovieClip):void
		{
			var bitmap:Bitmap;
			var displayObject:DisplayObject;
			var memoryNow:int;
			var timeNow:int;
			if (Main.debug)
			{
				memoryNow = System.totalMemory;
				timeNow = getTimer();
			}
			frames = new Array();
			findTotalFrames(mc);
			for (var i:int = 1; i <= total; ++i)
			{
				bitmap = new Bitmap(new BitmapData(twidth, theight));
				bitmap.bitmapData.fillRect(bitmap.bitmapData.rect, 0);
				bitmap.bitmapData.draw(mc);
				frames.push(bitmap);
				deepNextFrame(mc);
			}
			if (Main.debug)
			{
				trace("Memory usage for swf " + symbol + " is aprox: " + int((System.totalMemory - memoryNow) / 1000) / 1000 + 
					  " MBs, time to load: " + (getTimer() - timeNow) + " ms");
			}
			object = null;
			mc = null;
		}
		
		/**
		 * Finding the frames.
		 */
		private function findTotalFrames(mc:MovieClip):void
		{
			if (total < mc.totalFrames)
				total = mc.totalFrames;
			for (var i:int = 0; i < mc.numChildren; ++i)
			{
				var child:Object = mc.getChildAt(i);
				if (child is MovieClip)
					findTotalFrames(child as MovieClip);
			}
		}
		
		/**
		 * Going to next frame.
		 */
		private function deepNextFrame(mc:MovieClip):void
		{
			if (mc.currentFrame == mc.totalFrames)
				mc.gotoAndStop(1);
			else
				mc.nextFrame();
			for (var i:int = 0; i < mc.numChildren; ++i)
			{
				var child:Object = mc.getChildAt(i);
				if (child is MovieClip)
					deepNextFrame(child as MovieClip);
			}
		}
		
		/**
		 * Completed.
		 */
		private function completed(e:Event):void
		{
			mc = e.target.getChildAt(0).content;
			loaded = true;
			if (!real)
			{
				prepare(mc);
				addChild(frames[0]);
				if (autoPlay)
					play(repeat, reverse);
				else
				{
					if (reverse)
						currFrame = total - 1;
					else
						currFrame = 0;
				}
			}
			else
			{
				addChild(mc);
				if (autoPlay)
					mc.gotoAndPlay(0);
				else
					mc.gotoAndStop(0);
			}
			dispatchEvent(new Event(FINISHED_LOADING));
		}
		
		/**
		 * Update the animation.
		 */
		private function update(e:Event):void
		{
			if (++count < delay)
				return;
			count = 0;
			
			if (reverse)
			{
				--currFrame;
				if (currFrame == -1)
				{
					dispatchEvent(new Event(Event.COMPLETE));
					if (!repeat)
						stop();
					else
					{
						currFrame = total - 1;
						removeChildAt(0);
						addChild(frames[currFrame]);
					}
				}
				else 
				{
					removeChildAt(0);
					addChild(frames[currFrame]);
				}
			}
			else
			{
				++currFrame;
				if (currFrame == total)
				{
					dispatchEvent(new Event(Event.COMPLETE));
					if (!repeat)
						stop();
					else
					{
						currFrame = 0;
						removeChildAt(0);
						addChild(frames[currFrame]);
					}
				}
				else 
				{
					removeChildAt(0);
					addChild(frames[currFrame]);
				}
			}
			if (smoothing)
				frames[currFrame].smoothing = true;
		}
		
		/**
		 * Playing the animation.
		 * @param repeat if it loops forever
		 * @param reverse if it plays backward
		 */
		public function play(repeat:Boolean = true,reverse:Boolean = false):void
		{
			if (!real)
			{
				this.reverse = reverse;
				this.repeat = repeat;
				if (reverse)
					currFrame = total - 1;
				else
					currFrame = 0;
				removeChildAt(0);
				addChild(frames[currFrame]);
				if (smoothing)
					frames[currFrame].smoothing = true;
				if (total > 1)
					addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			}
			else
				mc.gotoAndPlay(0);
		}
		
		/**
		 * @return if its playing
		 */
		public function isPlaying():Boolean
		{
			if (!real)
				return hasEventListener(Event.ENTER_FRAME);
			return mc.currentFrame != mc.totalFrames;
		}
		
		/**
		 * Stops the animation.
		 */
		public function stop():void
		{
			if (!real)
				removeEventListener(Event.ENTER_FRAME, update);
			else
				mc.stop();
		}
		
		/**
		 * @return the current frame
		 */
		public function getFrame():int
		{
			return currFrame + 1;
		}
		
		/**
		 * @return the total frames
		 */
		public function totalFrames():int
		{
			return total;
		}
		
		/**
		 * Goes to frame x.
		 * @param frame the frame, starting at 1.
		 */
		public function gotoFrame(frame:int):void
		{
			if (loaded)
			{
				--frame;
				currFrame = frame;
				removeChildAt(0);
				addChild(frames[currFrame]);
			}
		}
		
		/**
		 * Going to next frame.
		 */
		public function nextFrame():void
		{
			if (currFrame + 2 > total)
				gotoFrame(1);
			else
				gotoFrame(currFrame + 2);
		}
		
		/**
		 * @return the animation width
		 */
		override public function getWidth():Number
		{
			if (loaded)
				return super.width;
			return twidth;
		}
		
		/**
		 * @return the animation height
		 */
		override public function getHeight():Number
		{
			if (loaded)
				return super.height;
			return theight;
		}
	}
	
}
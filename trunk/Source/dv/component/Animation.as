package dv.component
{
	import dv.changeables.Main;
	import dv.graphic.VGraphic;
	import dv.utils.Resources;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.getTimer;

	/**
	 * Animation class. Its created using a sprite sheet, several images inside a image,
	 * doing an animation. Every image is a frame.
	 * @author brunoja
	 */
	public class Animation extends VGraphic
	{
		private var line:String;
		private var total:int;
		private var delay:int;
		private var count:int;
		private var frames:Array;
		private var loaded:int = 0;
		private var currFrame:int = 0;
		private var repeat:Boolean;
		private var file:String;
		private var autoPlay:Boolean;
		private var reverse:Boolean;
		private var repeatKill:int = -1;
		private var completed:int = 0;
		
		/**
		 * Creating the animation.
		 * @param symbol the symbol of the spritesheet
		 * @param dimX the dimension of each frame, 0 means the width is equal of the sheet height
		 * @param delay the speed of the animation, how many flash frames to update an animation frame
		 * @param autoDestructor if this is removed from stage, it will be destroyed (stop animation)
		 */
		public function Animation(symbol:String, dimX:int, delay:int, autoDestructor:Boolean = true)
		{
			super();
			if (autoDestructor)
				addEventListener(Event.REMOVED_FROM_STAGE, destructor, false, 0, true);
			load(symbol, dimX, delay);
		}
		
		/**
		 * The destructor. It will stop the animation.
		 */
		private function destructor(e:Event):void
		{
			stop();
		}
		
		/**
		 * Auto destroy when completes x animations.
		 * @param repeat the x animations
		 */
		public function autoKillOn(repeat:int):void
		{
			repeatKill = repeat;
		}
		
		/**
		 * Assembling the animation, using SpriteSheet. The parameters are the same of the constructor.
		 */
		private function load(symbol:String, dimX:int, delay:int):void
		{
			var memoryNow:int;
			var timeNow:int;
			if (Main.debug)
			{
				memoryNow = System.totalMemory;
				timeNow = getTimer();
			}
			var sheet:SpriteSheet = new SpriteSheet(symbol, dimX);
			if (dimX == 0)
				dimX = sheet.getWidth();
			total = sheet.getSheet().width / dimX;
			this.delay = delay;
			frames = new Array();
			for (var i:int = 0; i < total; ++i)
				frames.push(sheet.getSprite(i, 0));
			if (Main.debug)
			{
				trace("Memory usage for ani " + symbol + " is aprox: " + int((System.totalMemory - memoryNow) / 1000) / 1000 + 
					  " MBs, time to load: " + (getTimer() - timeNow) + " ms");
			}
			addChild(frames[0]);
		}
		
		/**
		 * Updating the animation.
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
					++completed;
					if (!repeat)
						stop();
					else
					{
						currFrame = total - 1;
						removeChildAt(0);
						addChild(frames[currFrame]);
					}
					dispatchEvent(new Event(Event.COMPLETE));
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
					++completed;
					if (!repeat)
						stop();
					else
					{
						currFrame = 0;
						removeChildAt(0);
						addChild(frames[currFrame]);
					}
					dispatchEvent(new Event(Event.COMPLETE));
				}
				else 
				{
					removeChildAt(0);
					addChild(frames[currFrame]);
				}
			}
			// If its autoKillOn
			if (repeatKill == completed)
			{
				stop();
				parent.removeChild(this);
			}
		}
		
		/**
		 * Playing animation.
		 * @param repeat if it plays forever
		 * @param reverse if it plays backwards
		 */
		public function play(repeat:Boolean = true,reverse:Boolean = false):void
		{
			if (reverse)
				currFrame = total - 1;
			else
				currFrame = 0;
			removeChildAt(0);
			addChild(frames[currFrame]);
			this.reverse = reverse;
			this.repeat = repeat;
			if (total > 1)
				addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		
		/**
		 * @return returns if the animation is playing
		 */
		public function isPlaying():Boolean
		{
			return hasEventListener(Event.ENTER_FRAME);
		}
		
		/**
		 * Stops the animation.
		 */
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, update);
		}
		
		/**
		 * Going to specific frame, it starts with 1.
		 * @param frame the frame to go
		 */
		public function gotoFrame(frame:int):void
		{
			--frame;
			if (currFrame != frame)
			{
				currFrame = frame;
				removeChildAt(0);
				addChild(frames[currFrame]);
			}
		}
		
		/**
		 * @return the current frame
		 */
		public function getFrame():int
		{
			return currFrame + 1;
		}
		
		/**
		 * @return the number of frames
		 */
		public function totalFrames():int
		{
			return total;
		}
		
		/**
		 * Goes to next frame.
		 */
		public function nextFrame():void
		{
			if (currFrame + 2 > total)
				gotoFrame(1);
			else
				gotoFrame(currFrame + 2);
		}
		
		/**
		 * Goes to previous frame.
		 */
		public function previousFrame():void
		{
			if (currFrame - 1 < 0)
				gotoFrame(total);
			else
				gotoFrame(currFrame);
		}
		
		/**
		 * @param frame the frame to search
		 * @return if the animation contains the sprite, frame
		 */
		public function hasFrame(frame:VSprite):Boolean
		{
			return frames.indexOf(frame) != -1;
		}
	}
	
}
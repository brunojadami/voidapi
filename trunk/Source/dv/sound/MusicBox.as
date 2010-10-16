package dv.sound
{
	import dv.changeables.Global;
	import dv.changeables.Main;
	import dv.utils.Resources;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.system.System;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * Music box, containing musics to be played while the game is played.
	 */
	public class MusicBox
	{
		static public var musicVolume:Number = 0.8;
		private var autoPlay:Boolean;
		private var updater:Timer = new Timer(Global.TIMER_SUPDATE);
		private var channel:SoundChannel;
		private var volume:Number;
		private var maxVolume:Number = 1;
		private var sound:Sound;
		private var index:int = 0;
		private var files:Array = new Array();
		private var playing:Boolean = false;
		private var loop:Boolean;
		private var ambienceVol:SoundTransform;
		
		/**
		 * Constructor.
		 */
		public function MusicBox()
		{
			super();
			updater.addEventListener(TimerEvent.TIMER, adjustVolume, false, 0, true);
		}
		
		/**
		 * Adding an event listener for song completion.
		 * @param listener the function listener
		 */
		public function addCompleteListener(listener:Function):void
		{
			channel.addEventListener(Event.SOUND_COMPLETE, listener, false, 0, true);
		}
		
		/**
		 * Loading the music and adding to the playlist.
		 * @param file the file symbol
		 */
		public function load(file:String):void
		{
			var memoryNow:int;
			var timeNow:int;
			if (Main.debug)
			{
				memoryNow = System.totalMemory;
				timeNow = getTimer();
			}
			if (Resources.hasSymbol(file + "Music"))
				files.push(Resources.getSymbol(file + "Music"));
			else
				files.push(Resources.getSymbol(file + "Sound"));
			if (Main.debug)
			{
				trace("Memory usage for music " + file + " is aprox: " + int((System.totalMemory - memoryNow) / 1000) / 1000 + 
					  " MBs, time to load: " + (getTimer() - timeNow) + " ms");
			}
		}
		
		/**
		 * Start playing.
		 * @param loop if plays forever
		 */
		public function play(loop:Boolean = true):void
		{
			this.loop = loop;
			if (!playing)
			{
				playing = true;
				sound = files[0];
				adjustVolume(null);
				channel = sound.play(0, 0, ambienceVol);
				channel.addEventListener(Event.SOUND_COMPLETE, completed, false, 0, true);
				updater.start();
			}
			else
				maxVolume = musicVolume;
		}
		
		/**
		 * Music completed event.
		 */
		private function completed(e:Event):void
		{
			if (!loop)
			{
				stop();
				return;
			}
			++index;
			if (index >= files.length)
				index = 0;
			sound = files[index];
			adjustVolume(null);
			channel = sound.play(0, 0, ambienceVol);
			channel.addEventListener(Event.SOUND_COMPLETE, completed, false, 0, true);
		}
		
		/**
		 * Stop the playlist.
		 */
		public function stop():void
		{
			playing = false;
			if (channel)
				channel.stop();
			updater.stop();
		}
		
		/**
		 * Adjusting the volume.
		 */
		private function adjustVolume(e:Event):void
		{  
			if (musicVolume < maxVolume)
				volume = musicVolume;
			else
				volume = maxVolume;
			ambienceVol = new SoundTransform(volume);
			if (channel)
				channel.soundTransform = ambienceVol;
		}
		
		/**
		 * Setting the volume.
		 * @param num the volume
		 */
		public function setVolume(num:Number):void
		{
			maxVolume = num;
			adjustVolume(null);
		}
	}
	
}
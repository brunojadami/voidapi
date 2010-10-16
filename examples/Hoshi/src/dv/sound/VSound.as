package dv.sound
{
	import dv.changeables.Main;
	import dv.utils.Resources;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.system.System;
	import flash.utils.getTimer;
	
	/**
	 * Class to play mp3 sounds. Flash should support midi and wav :/
	 * @author brunoja
	 */
	public class VSound
	{
		static public var soundVolume:Number = 1;
		private var autoPlay:Boolean;
		private var channel:SoundChannel;
		private var volume:Number;
		private var sound:Sound;
		private var symbol:String;
		
		/**
		 * Creating the sound.
		 * @param symbol the sound symbol
		 */
		public function VSound(symbol:String)
		{
			super();
			load(symbol);
		}
		
		/**
		 * @return the sound dymbol
		 */
		public function getSoundName():String
		{
			return symbol;
		}
		
		/**
		 * Loading the sound. Parameter = constructor.
		 */
		private function load(symbol:String):void
		{
			this.symbol = symbol;
			var memoryNow:int;
			var timeNow:int;
			if (Main.debug)
			{
				memoryNow = System.totalMemory;
				timeNow = getTimer();
			}
			sound = Resources.getSymbol(symbol + "Sound");
			if (Main.debug)
			{
				trace("Memory usage for sound " + symbol + " is aprox: " + int((System.totalMemory - memoryNow) / 1000) / 1000 + 
					  " MBs, time to load: " + (getTimer() - timeNow) + " ms");
			}
		}
		
		/**
		 * Playing the sound.
		 * @param startTime the soundPosition
		 */
		public function play(startTime:int = 0):void
		{
			channel = sound.play(startTime, 0, new SoundTransform(soundVolume))
		}
		
		/**
		 * Mutting everything.
		 */
		static public function muteSound():void
		{
			SoundMixer.soundTransform = new SoundTransform(0);
		}
		
		/**
		 * Unmutting everything.
		 */
		static public function unmuteSound():void
		{
			SoundMixer.soundTransform = new SoundTransform(1);
		}
	}
	
}
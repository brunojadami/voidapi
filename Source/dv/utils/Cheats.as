package dv.utils 
{
	import dv.sound.VSound;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	
	/**
	 * Static class to do cheats for the game :p
	 * @author brunoja
	 */
	public class Cheats
	{
		static private const KEYS_DELAY:int = 1500;
		
		static private var cheats:Object = new Object();
		static private var sounds:Object = new Object();
		static private var comboString:String = "";
		static private var lastCheat:int = 0;
		static private var cstage:Stage;
		
		/**
		 * Enable cheating.
		 * @param stage the main stage
		 */
		static public function enableCheating(stage:Stage):void
		{
			cstage = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, comboCheck, false, 0, true);
		}
		
		/**
		 * Disables cheating.
		 */
		static public function disableCheating():void
		{
			cstage.removeEventListener(KeyboardEvent.KEY_DOWN, comboCheck);
		}
		
		/**
		 * Adding a cheat.
		 * @param combo the keys combo
		 * @param soundSymbol the cheat done sound symbol
		 */
		static public function addCheat(combo:String, soundSymbol:String):void
		{
			var sound:VSound = new VSound();
			sound.load(soundSymbol);
			cheats[combo] = false;
			sounds[combo] = sound;
		}
		
		/**
		 * @param cheatId the combo string
		 * @return if the combo was typed
		 */
		static public function hasCheat(cheatId:String):Boolean
		{
			return cheats[cheatId] == true;
		}
		
		/**
		 * Checking if the combo was completed and updating the cheats array.
		 */
		static private function comboCheck(e:KeyboardEvent):void
		{
			if (getTimer() - lastCheat > KEYS_DELAY)
				comboString = new String();
			lastCheat = getTimer();
			comboString += String.fromCharCode(e.charCode);
			if (cheats[comboString] != null)
			{
				cheats[comboString] = true;
				sounds[comboString].play();
				comboString = new String();
			}
		}
	}

}
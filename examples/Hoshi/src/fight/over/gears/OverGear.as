package fight.over.gears
{
	import dv.component.VSprite;
	import dv.gears.Gear;
	import dv.gears.TransitionGear;
	import dv.sound.MusicBox;
	import dv.sound.VSound;
	import fight.game.gears.GameGear;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class OverGear extends Gear
	{
		static private const STATE_LOADING:int = 0;
		static private const STATE_OVER:int = 1;
		static private const STATE_KILL:int = 2;
		
		static public var good:Boolean;
		
		private var back:VSprite;
		private var overMusic:MusicBox;
		
		/* Criando classe do gameover, ta tudo nesta classe pq o over eh bem simplinho... */
		public function OverGear() 
		{
			super();
			state = STATE_LOADING;
			VSound.unmuteSound();
			MusicBox.musicVolume = 0.2;
		}
		
		/* Comecando o over, carregando coisas. */
		private function loading():void
		{
			// Se o transition gear ainda deve esperar
			if (!done)
			{
				done = true;
				// Carregando coisas
				//if (!good)
					back = new VSprite("ImagesOver");
				//else
					//back.load("ImagesGood");
				back.buttonMode = true;
				//overMusic.load("AudioOver");
				// Adicionando
				addChild(back);
				// Adicionando eventos
				addEventListener(MouseEvent.MOUSE_UP, endClick, false, 0, true);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, endClick, false, 0, true);
			}
			else if (go)
			{
				// Indo para o over
				//overMusic.play(false);
				state = STATE_OVER;
			}
		}
		
		/* Ir para o menu de volta. */
		private function endClick(e:Event):void
		{
			//overMusic.stop();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, endClick);
			new TransitionGear(this, GameGear);
		}
		
		/* Logica do over. */
		private function over():void
		{
			
		}
		
		/* Logica do over, loop principal. */
		override protected function logic(e:Event):void
		{
			if (state == STATE_LOADING)
				loading();
			else if (state == STATE_OVER)
				over();
		}
		
	}

}
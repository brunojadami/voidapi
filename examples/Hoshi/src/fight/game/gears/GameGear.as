package fight.game.gears 
{	
	import dv.changeables.Fonts;
	import dv.component.Text;
	import dv.gears.Gear;
	import dv.gears.TransitionGear;
	import dv.graphic.VGraphic;
	import dv.utils.Saver;
	import fight.game.stage.Stage;
	import fight.over.gears.OverGear;
	import flash.events.Event;
	
	public class GameGear extends Gear
    {
		static private const STATE_LOADING:int = 0;
		static private const STATE_LEVELX:int = 1;
		static private const STATE_GAME:int = 2;
		static private const STATE_KILL:int = 3;
		static private const STATE_COMPLETED:int = 4;
		static private const STATE_FAIL:int = 5;
		static private const STATE_OVER:int = 6;
		
		private var counter:int = 0;
		private var gameStage:Stage;
		private var level:int = 1;
		private var auxText:Text;
		
		public function GameGear()
        {
			state = STATE_LOADING;
        }
		
		/* Comecando o game, carregando coisas. */
		private function loading():void
		{
			// Se o transition gear ainda deve esperar
			if (!done)
			{
				Saver.init("Fight");
				done = true;
				// Criando coisas
				gameStage = new Stage();
				auxText = new Text("", Fonts.scriFormat, 0x008800);
				// Adicionando
				addChild(gameStage);
				stage.focus = this;
			}
			else if (go)
			{
				// Indo para o jogo
				counter = 0;
				state = STATE_LEVELX;
				gameStage.setKeyboardEvents();
			}
		}
		
		/* Mostrando o level. */
		private function levelX():void
		{
			if (counter++ == 0)
			{
				auxText.updateText("LEVEL " + level);
				auxText.center();
				addChild(auxText);
				auxText.fadeIn(0.1);
			}
			else if (counter >= 100)
			{
				counter = 0;
				auxText.fadeOut(0.1, true);
				gameStage.unlockStuff();
				state = STATE_GAME;
			}
		}
		
		/* Logica principal. */
		private function game():void
		{
			// Acabou
			if (gameStage.endedLevel())
			{
				counter = 0;
				state = STATE_COMPLETED;
				gameStage.lockStuff();
			}
			// Perdeu todas as vidas
			if (gameStage.lostAllHealth())
			{
				counter = 0;
				gameStage.lockStuff();
				// Se deu game over
				if (gameStage.lostAllLives())
					state = STATE_OVER;
				else
					state = STATE_FAIL;
			}
		}
		
		/* Completou. */
		private function completed():void
		{
			if (counter++ == 0)
			{
				auxText.updateText("COMPLETED");
				auxText.center();
				auxText.fadeIn(0.1);
				addChild(auxText);
			}
			else if (counter == 100)
				++level;
			else if (counter > 100 && auxText.isInsideContainer())
				auxText.fadeOut(0.1, true);
			else if (!auxText.isInsideContainer())
			{
				counter = 0;
				state = STATE_LEVELX;
			}
		}
		
		/* Game over. */
		private function over():void
		{
			if (counter++ == 0)
			{
				auxText.updateText("GAME OVER");
				auxText.center();
				addChild(auxText);
				auxText.fadeIn(0.1);
			}
			else if (counter >= 100)
			{
				state = STATE_KILL;
				var gear:TransitionGear = new TransitionGear(this, OverGear);
			}
		}
		
		/* Falhou, perdeu as vidas. */
		private function failed():void
		{
			if (counter++ == 0)
			{
				auxText.updateText("FAILED");
				auxText.center();
				auxText.fadeIn(0.1);
				addChild(auxText);
			}
 			else if (counter == 100)
				auxText.fadeOut(0.1, true);
			else if (!auxText.isInsideContainer())
			{
				counter = 0;
				state = STATE_LEVELX;
			}
		}
		
		/* Logica do game, loop principal. */
		override protected function logic(e:Event):void
		{
			stage.focus = this;
			if (VGraphic.paused)
				return;
			if (state == STATE_LOADING)
				loading();
			else if (state == STATE_LEVELX)
				levelX();
			else if (state == STATE_GAME)
				game();
			else if (state == STATE_COMPLETED)
				completed();
			else if (state == STATE_FAIL)
				failed();
			else if (state == STATE_OVER)
				over();
		}
	}
}
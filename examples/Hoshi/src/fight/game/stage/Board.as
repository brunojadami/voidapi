package fight.game.stage 
{
	import dv.changeables.Fonts;
	import dv.component.Text;
	import dv.component.VSprite;
	import dv.objects.GameObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Board extends GameObject
	{
		static public const MAX_HEALTH:int = 7;
		
		private var healthPoints:int = 5;
		private var health:Object = new Object();
		private var livesPoints:int = 5;
		private var lives:Object = new Object();
		private var time:int = 0;
		private var score:int = 0;
		private var timeText:Text;
		private var scoreText:Text;
		private var timer:Timer = new Timer(1000);
		private var locked:Boolean;
		private var back:VSprite;
		private var levelText:Text;
		
		/* Criando o board. */
		public function Board() 
		{
			super();
			createHealthAndLives();
			back = new VSprite("ImagesBoard");
			back.setPos(360, 3);
			addChild(back);
			timeText = new Text("TIME:0", Fonts.smallFormat, 0x00ff00); timeText.setPos(370, 14);
			addChild(timeText);
			levelText = new Text("LVL:1", Fonts.smallFormat, 0xff0000); levelText.setPos(435, 14);
			addChild(levelText);
			scoreText = new Text("SCORE:0", Fonts.smallFormat, 0x0000ff); scoreText.setPos(370, 29);
			addChild(scoreText);
			timer.addEventListener(TimerEvent.TIMER, timerFunc, false, 0, true);
			timer.start();
		}
		
		/* Contando tempo. */
		private function timerFunc(e:Event):void
		{
			if (!locked)
			{
				++time;
				timeText.updateText("TIME:" + time);
			}
		}
		
		/* Pegando tempo. */
		public function getTime():int
		{
			return time;
		}
		
		/* Tirando evento do timer. */
		override public function destructor(e:Event):void 
		{
			super.destructor(e);
			timer.removeEventListener(TimerEvent.TIMER, timerFunc);
		}
		
		/* Criando vidae continues. */
		private function createHealthAndLives():void
		{
			health.lenght = healthPoints;
			for (var i:int = 0; i < healthPoints; ++i)
			{
				health[i] = new VSprite("ImagesHealth");
				health[i].setPos(i * health[i].width + health[i].width / 2, health[i].height / 2);
				addChild(health[i]);
			}
			lives.lenght = livesPoints;
			for (i = 0; i < livesPoints; ++i)
			{
				lives[i] = new VSprite("ImagesLife");
				lives[i].setPos(i * lives[i].width + lives[i].width / 2, lives[i].height * 3 / 2);
				addChild(lives[i]);
			}
		}
		
		/* Incrementando level. */
		public function setLevel(lvl:int):void
		{
			levelText.updateText("LVL:" + lvl);
			healthPoints = health.lenght;
			updateHealthAndLives();
		}
		
		/* Atualizando vida e continues. */
		private function updateHealthAndLives():void
		{
			for (var i:int = 0; i < health.lenght; ++i)
			{
				if (i >= healthPoints)
					health[i].visible = false;
				else
					health[i].visible = true;
			}
			for (i = 0; i < lives.lenght; ++i)
			{
				if (i >= livesPoints)
					lives[i].visible = false;
				else
					lives[i].visible = true;
			}
		}
		
		/* Adicionando pontos. */
		public function addPoints(points:int):void
		{
			score += points;
			scoreText.updateText("SCORE:" + score);
		}
		
		/* Removendo continue. */
		public function removeLives():void
		{
			--livesPoints;
			if (livesPoints >= 0)
			{
				healthPoints = health.lenght;
				updateHealthAndLives();
			}
		}
		
		/* Pegando total de continues. */
		public function getTotalLives():int
		{
			return livesPoints;
		}
		
		/* Travando board, para contar tempo, etc.. */
		public function lockBoard():void
		{
			locked = true;
		}
		
		/* Destravando board, para contar tempo, etc.. */
		public function unlockBoard():void
		{
			locked = false;
			time = 0;
			timeText.updateText("TIME:0");
		}
		
		/* Pegando o total de vidas. */
		public function getTotalHealth():int
		{
			return healthPoints;
		}
		
		/* Tirando vida. */
		public function removeHealth():void
		{
			if (healthPoints > 0)
			{
				--healthPoints;
				updateHealthAndLives();
			}
		}
		
		/* Adicionando vida. */
		public function addHealth():void
		{
			if (healthPoints < MAX_HEALTH)
			{
				++healthPoints;
				updateHealthAndLives();
			}
		}
	}

}
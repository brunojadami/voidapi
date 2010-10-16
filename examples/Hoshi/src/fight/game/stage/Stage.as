package fight.game.stage 
{
	import dv.objects.GameObject;
	import fight.game.chars.Char;
	import fight.game.chars.Hoshi;
	import fight.game.enemies.Bird;
	import fight.game.enemies.Bubble;
	import fight.game.enemies.Enemy;
	import fight.game.enemies.Evil;
	import fight.game.enemies.Rock;
	import fight.game.enemies.Skull;
	import fight.game.enemies.Water;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class Stage extends GameObject
	{
		static public const TOTAL_LEVELS:int = 100;
		
		private var player:Char;
		private var enemies:Array = new Array();
		private var scenario:Scenario;
		private var board:Board;
		private var waves:Object = new Object();
		private var ended:Boolean;
		private var lastAdded:int;
		private var level:int = 1;
		private var locked:Boolean = false;
		private var difficulty:int = 1;
		private var addDelay:int = 0;
		private var lastTime:int = 0;
		
		/* Criando o stage. */
		public function Stage() 
		{
			super();
			scenario = new Scenario();
			board = new Board();
			player = new Hoshi(0, enemies, board);
			addChild(scenario);
			addChild(board);
			addChild(player);
			createWaves();
			lockStuff();
		}
		
		/* Criando waves. */
		private function createWaves():void
		{
			for (var i:int = 1; i <= TOTAL_LEVELS; ++i)
			{
				waves[i] = new Object(); 
				waves[i][1] = new Object();
				waves[i][2] = new Object();
				waves[i][3] = new Object();
			}
			waves[1][1] = [0, 0];
			waves[2][1] = [0, 0, 1, 1];
			waves[3][1] = [2, 1, 2, 1];
			
			waves[4][1] = [1, 1, 1, 6, 2, 2, 0, 6, -7, 6];
			waves[5][1] = [1, 2, 3, 6, 2, 0, 0, 6, -3, 0, 0, 0, -1, 6];
			
			waves[6][1] = [0, 6, 8, 8, 8, -4, 1, 6, 2, -4, 8, 8, 5, -12, 6, -6, 6];
			waves[7][1] = [5, 0, 6, 8, 0, 8, 6, 8, 8, 8, 8, -5, 8, 8, 8, 8, -12, 6, 6, -12, 6];
			
			waves[8][1] = [0, -2, 8, 6, 10, 8, 6, 5, 10, -12, 6, -6, 6];
			waves[9][1] = [0, -1, 8, 8, 6, 10, 10, 6, 10, 8, 6, 5, -10, 10, 6, 10, 6];
			waves[10][1] = [0, 8, 8, 8, 6, 10, 6, 5, -14, 10, 10, 6, 10, 10, 6, -15, 6, 8, 6, 8, 6];
			
			waves[11][1] = [5, 7, -10, 6, 6, 6, 6, 6];
			waves[12][1] = [0, 0, 6, 0, 0, 6, 0, 0, 0, 7, 0, 0, 6, 0, 0, 8, 0, 0, 0, 0, 10, 0, 6, 0, 0, 7, 0, 0, 6, 0, 0, 10, 0];
			
			waves[13][1] = [7, 7, 7, 9, -5, 5, -10, 10, 10, 10, 8, 6, 6];
			waves[14][1] = [10, 10, 10, 6, 6, 10, 10, 10, 9, 10, 10, 10, 10, 10, 10, 10, 6, 6, 6, 10];
			waves[15][1] = [9, 8, 6, 8, 8, 8, 8, 8, 6, 8, 8, 8, 8, 8, 8, 6, 8, 8, 8, 8, 8, 8, 6, 8, 8, 8, 8, 8, 8, 8, 8, 6, 8, 8, 8, 8, 8, 8, 6, 8, 8, 8, 8, 8, 6, 8, 8, 8, 8, 8];
		}
		
		/* Acabou o level. */
		public function endedLevel():Boolean
		{
			var ret:Boolean = ended && enemies.length == 0;
			if (ret)
			{
				++level;
				board.setLevel(level);
				scenario.update(level);
			}
			return ret;
		}
		
		/* Acabou todas vidas. */
		public function lostAllHealth():Boolean
		{
			if (board.getTotalHealth() == 0)
			{
				board.removeLives();
				removeAllEnemies();
				ended = true;
				return true;
			}
			return false;
		}
		
		/* Acabou todos continues. */
		public function lostAllLives():Boolean
		{
			return board.getTotalLives() == -1;
		}
		
		/* Destravando as coisas para comecar. */
		public function unlockStuff():void
		{
			Char.immortal = false;
			board.unlockBoard();
			ended = false;
			lastAdded = -1;
			addDelay = 0;
			locked = false;
		}
		
		/* Travando as coisas. */
		public function lockStuff():void
		{
			Char.immortal = true;
			locked = true;
			board.lockBoard();
		}
		
		/* Setando eventos do teclado. */
		public function setKeyboardEvents():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, player.keyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, player.keyUp, false, 0, true);
		}
		
		/* Destrutor, remover eventos globais. */
		override public function destructor(e:Event):void 
		{
			super.destructor(e);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, player.keyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, player.keyUp);
		}
		
		/* Logica. */
		override protected function logic(e:Event):void 
		{
			// Limpando inimigos
			var len:int = enemies.length;
			for (var i:int = 0; i < len; ++i)
			{
				var enemy:Enemy = enemies[i];
				if (enemy.isDead() && enemy.finishedFades())
				{
					if (!locked)
						board.addPoints(enemy.getPoints());
					enemies.splice(i, 1);
					--i; --len;
				}
			}
			if (locked)
				return;
			// Adicionando inimigos
			if (lastTime != board.getTime())
			{
				--addDelay;
				lastTime = board.getTime();
				if (addDelay <= 0)
				{
					++lastAdded;
					if (waves[level][difficulty][lastAdded] != null)
						addMonster(waves[level][difficulty][lastAdded]);
					else
						ended = true;
				}
			}
		}
		
		/* Adicionando monstro. */
		private function addMonster(id:int):void
		{
			if (id < 0)
			{
				addDelay = -id;
				return;
			}
			var enemy:Enemy;
			// Bubble
			if (id >= 0 && id <= 5)
				enemy = new Bubble(id, enemies);
			// Bird
			else if (id == 6)
				enemy = new Bird(enemies);
			// Evil
			else if (id == 7)
				enemy = new Evil(enemies);
			// Water
			else if (id == 8)
				enemy = new Water(enemies);
			// Skull
			else if (id == 9)
				enemy = new Skull(enemies);
			// Rock
			else if (id == 10)
				enemy = new Rock(enemies);
			// Adicionando
			enemies.push(enemy);
			addChild(enemy);
		}
		
		/* Removendo inimigos. */
		private function removeAllEnemies():void
		{
			var len:int = enemies.length;
			for (var i:int = 0; i < len; ++i)
			{
				var enemy:Enemy = enemies[i];
				enemy.die();
				enemy.fadeOut(0.1);
			}
		}
	}

}
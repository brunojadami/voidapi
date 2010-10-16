package fight.game.chars
{
	import dv.changeables.Global;
	import dv.component.SpriteSheet;
	import dv.objects.GameObject;
	import dv.physics.Physics;
	import fight.game.enemies.Enemy;
	import fight.game.stage.Board;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class Char extends GameObject
	{
		static public const DIR_RIGHT:int = 0;
		static public const DIR_LEFT:int = 1;
		static public const MAX_Y:int = Global.WINDOW_HEIGHT - 20;
		static public const MOVE_WAIT:int = 5;
		static public const JUMP_VEL:int = 15;
		static public var BASE_Y:int;
		static public const ACTION_STAND:int = 1;
		static public const ACTION_WALK:int = 6;
		static public const ACTION_HIT:int = 2;
		static public const ACTION_JUMP:int = 9;
		
		static public var immortal:Boolean = false;
		
		private var actions:Object = new Object();
		private var images:Object;
		private var dir:int;
		private var pos:int = 1;
		private var aux:int = 1;
		private var counter:int = 0;
		private var move:int = 0;
		private var jump:int = 0;
		private var action:int = 1;
		private var hitCounter:int = 0;
		private var attackCounter:int = 0;
		private var attacking:Boolean = false;
		protected var enemies:Array;
		protected var moveSpeed:int;
		protected var attackSpeed:int;
		protected var board:Board;
		
		/* Cria o carinha, ja carregando imagens e etc.. */
		public function Char(id:int, pos:int, enemies:Array, board:Board) 
		{
			super();
			loadImages(id);
			updateImage();
			BASE_Y = MAX_Y - height / 2;
			if (pos == 0)
				setPos(width, BASE_Y);
			else
				setPos(Global.WINDOW_WIDTH - width, BASE_Y);
			BASE_Y += height / 2 - 2;
			actions[ACTION_STAND] = true;
			this.enemies = enemies;
			this.board = board;
		}
		
		/* Atualiza imagem. */
		private function updateImage():void
		{
			if (numChildren > 0)
				removeChildAt(0);
			addChildAt(images[dir][pos][action], 0);
		}
		
		/* Loadando imagens. */
		private function loadImages(id:int):void
		{
			// Criando objeto que tem as imagens
			images = new Object();
			images[0] = new Object(); // Direita
			images[0][0] = new Object(); // Posicao 0
			images[0][1] = new Object(); // Posicao 1
			images[0][2] = new Object(); // Posicao 2
			images[1] = new Object(); // Esquerda
			images[1][0] = new Object(); // Posicao 0
			images[1][1] = new Object(); // Posicao 1
			images[1][2] = new Object(); // Posicao 2
			// Carregando imagens
			var sheet:SpriteSheet = new SpriteSheet("Chars" + id, Global.SQM, Global.SQM);
			// Primeiro a esquerda, 10 posicoes
			for (var y:int = 0; y < 10; ++y)
			{
				images[DIR_LEFT][0][y] = sheet.getSprite(0, y); images[DIR_LEFT][0][y].centerOn(0, 0);
				images[DIR_LEFT][1][y] = sheet.getSprite(1, y); images[DIR_LEFT][1][y].centerOn(0, 0);
				images[DIR_LEFT][2][y] = sheet.getSprite(2, y); images[DIR_LEFT][2][y].centerOn(0, 0);
			}
			// Copiando flipando, 10 posicoes
			for (y = 0; y < 10; ++y)
			{
				images[DIR_RIGHT][0][y] = sheet.getSprite(0, y); images[DIR_RIGHT][0][y].scaleX = -1; 
				images[DIR_RIGHT][0][y].centerOn(0, 0); images[DIR_RIGHT][0][y].x += images[DIR_RIGHT][0][y].width;
				images[DIR_RIGHT][1][y] = sheet.getSprite(1, y); images[DIR_RIGHT][1][y].scaleX = -1; 
				images[DIR_RIGHT][1][y].centerOn(0, 0); images[DIR_RIGHT][1][y].x += images[DIR_RIGHT][1][y].width;
				images[DIR_RIGHT][2][y] = sheet.getSprite(2, y); images[DIR_RIGHT][2][y].scaleX = -1; 
				images[DIR_RIGHT][2][y].centerOn(0, 0); images[DIR_RIGHT][2][y].x += images[DIR_RIGHT][2][y].width;
			}
		}
		
		/* Funcao pra processar os eventos do teclado. */
		public function keyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.RIGHT) // Direita - Andar
			{
				dir = DIR_RIGHT;
				actions[ACTION_WALK] = true;
				move = 1;
			}
			else if (e.keyCode == Keyboard.LEFT) // Esquerda - Andar
			{
				dir = DIR_LEFT;
				actions[ACTION_WALK] = true;
				move = -1;
			}
			else if (e.keyCode == Keyboard.UP && !actions[ACTION_JUMP]) // Cima - Pulo
			{
				actions[ACTION_JUMP] = true;
				jump = -JUMP_VEL;
			}
			else if (e.charCode == Keyboard.SPACE) // Space
				attacking = true;
		}
		
		/* Funcao pra processar os eventos do teclado. */
		public function keyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.RIGHT && move == 1) // Direita
			{
				actions[ACTION_WALK] = false;
				move = 0;
			}
			else if (e.keyCode == Keyboard.LEFT && move == -1) // Esquerda
			{
				actions[ACTION_WALK] = false;
				move = 0;
			}
			else if (e.charCode == Keyboard.SPACE) // Space
				attacking = false;
		}
		
		/* Funcao pra criar o ataque, a ser implementada. */
		protected function createAttack():Attack
		{
			return null;
		}
		
		/* Logica. */
		override protected function logic(e:Event):void 
		{
			++counter;
			++attackCounter;
			// Atacando
			if (attacking && attackCounter >= attackSpeed)
			{
				var attack:Attack = createAttack();
				parent.addChild(attack);
				attackCounter = 0;
			}
			// Atualizando 3 imagens
			if (counter >= MOVE_WAIT)
			{
				counter = 0;
				if (pos == 2)
					aux = -1;
				else if (pos == 0)
					aux = 1;
				pos += aux;
			}
			// Parado
			if (actions[ACTION_STAND]) 
				action = ACTION_STAND;
			// Andando
			if (actions[ACTION_WALK]) 
			{
				action = ACTION_WALK;
				if (!Physics.nextStepScreenCollision(this, move * moveSpeed, 0))
					x += move * moveSpeed;
			}
			// Pulando
			if (actions[ACTION_JUMP])
			{
				action = ACTION_JUMP;
				++jump;
				if (jump > JUMP_VEL)
					jump = JUMP_VEL;
				if (jump <= 0)
					y += jump;
				else
				{
					y += (Global.WINDOW_HEIGHT - BASE_Y);
					if (Physics.nextStepScreenCollision(this, 0, jump))
					{
						actions[ACTION_JUMP] = false;
						y = BASE_Y;
					}
					else
						y += jump;
					y -= (Global.WINDOW_HEIGHT - BASE_Y);
				}
			}
			// Tomando porrada
			if (actions[ACTION_HIT])
			{
				action = ACTION_HIT;
				--hitCounter;
				if (hitCounter == 0)
					actions[ACTION_HIT] = false;
			}
			// Atualizar imagem e posicao
			posX = x;
			posY = y;
			updateImage();
			// Checando colisao
			var len:int = enemies.length;
			for (var i:int = 0; i < len; ++i)
			{
				var enemy:Enemy = enemies[i];
				if (!enemy.isDead())
				{
					if (Physics.squareCollision(this, enemy))
					{
						takeHit();
						break;
					}
				}
			}
		}
		
		/* Tomando pancada. */
		public function takeHit():void
		{
			if (!isBlinking() && !immortal)
			{
				actions[ACTION_HIT] = true;
				hitCounter = 3 * MOVE_WAIT;
				blink(5, 0.2);
				board.removeHealth();
			}
		}
		
		/* Diminuindo width. */
		override public function getWidth():Number 
		{
			return super.getWidth() / 2;
		}
		
		/* Diminuindo height. */
		override public function getHeight():Number 
		{
			return super.getHeight() / 2;
		}
	}

}
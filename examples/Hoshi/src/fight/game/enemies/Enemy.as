package fight.game.enemies 
{
	import dv.objects.GameObject;
	
	public class Enemy extends GameObject
	{
		protected var dead:Boolean = false;
		protected var velX:int;
		protected var velY:int;
		protected var maxVelX:int;
		protected var maxVelY:int;
		protected var enemies:Array;
		protected var speedDelay:int = 1;
		protected var speedCounter:int = 0;
		protected var points:int;
		protected var health:int;
		
		/* Criando inimigo. */
		public function Enemy(enemies:Array) 
		{
			super();
			this.enemies = enemies;
		}
		
		/* Pegando pontos. */
		public function getPoints():int
		{
			return points;
		}
		
		/* Se ta morto. */
		public function isDead():Boolean
		{
			return dead;
		}
		
		/* Tomo dano, deve ser implementado. */
		public function takeHit():void
		{
			
		}
		
		/* Setando velocidades x e y. */
		public function setVel(velX:int, velY:int):void
		{
			this.velX = velX;
			this.velY = velY;
		}
		
		/* Animacao de dano, a ser implementado. */
		public function addHitAnimation():void
		{
			
		}
		
		/* Morrer. */
		public function die():void
		{
			dead = true;
		}
	}

}
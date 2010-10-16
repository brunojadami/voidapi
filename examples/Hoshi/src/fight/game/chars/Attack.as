package fight.game.chars 
{
	import dv.component.Animation;
	import dv.objects.GameObject;
	import dv.physics.Physics;
	import fight.game.enemies.Enemy;
	import flash.events.Event;
	
	public class Attack extends GameObject
	{
		private var sprite:Animation;
		private var velX:int;
		private var velY:int;
		private var enemies:Array;
		
		/* Criando ataque. */
		public function Attack(img:String, velX:int, velY:int, enemies:Array) 
		{
			super();
			sprite = new Animation(img, 0, 1);
			sprite.centerOn(0, 0);
			sprite.play();
			addChild(sprite);
			this.velX = velX;
			this.velY = velY;
			this.enemies = enemies;
		}
		
		/* Logica. */
		override protected function logic(e:Event):void 
		{
			// Movimento
			x += velX;
			y += velY;
			posX = x;
			posY = y;
			// Saiu da tela
			if (isOutOfScreen())
			{
				parent.removeChild(this);
				return;
			}
			// Colisao com inimigos
			var len:int = enemies.length;
			for (var i:int = 0; i < len; ++i)
			{
				var enemy:Enemy = enemies[i];
				if (enemy.isDead())
					continue;
				if (Physics.squareCollision(this, enemy))
				{
					enemy.takeHit();
					parent.removeChild(this);
					return;
				}
			}
		}
		
	}

}
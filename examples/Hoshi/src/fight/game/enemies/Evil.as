package fight.game.enemies 
{
	import dv.changeables.Global;
	import dv.component.Animation;
	import dv.physics.Physics;
	import fight.game.chars.Char;
	import flash.events.Event;
	
	public class Evil extends Enemy
	{
		private var image:Animation;
		
		/* Criando Evil. */
		public function Evil(enemies:Array) 
		{
			super(enemies);
			health = 2;
			image = new Animation("EnemiesEvil", 0, 8);
			image.play();
			image.centerOn(0, 0);
			addChild(image);
			setPosAndVel();
			maxVelX = 4;
			maxVelY = 4;
		}
		
		/* Setando posicao e velocidades. */
		private function setPosAndVel():void
		{
			y = -height;
			x = int (Global.WINDOW_WIDTH * Math.random());
			if (x < Global.WINDOW_HALF_WIDTH)
				x += width;
			else
				x -= width;
			posX = x;
			posY = y;
		}
		
		/* Arrumando velocidade. */
		private function fixVel():void
		{
			// Setando velocidades
			if (x - width / 2 < 0)
				++velX;
			else if (x + width / 2 > Global.WINDOW_WIDTH)
				--velX;
			else
			{
				var tmp:int = Math.random() * 2;
				if (tmp == 0)
					++velX;
				else
					--velX;
			}
			if (y - height / 2 < 0)
				++velY;
			else if (y + height / 2 > Global.WINDOW_HEIGHT)
				--velY;
			else
			{
				tmp = Math.random() * 2;
				if (tmp == 0)
					++velX;
				else
					--velX;
			}
			// Parando na velocidade max
			if (velX > maxVelX)
				velX = maxVelX;
			else if (velX < -maxVelX)
				velX = -maxVelX;
			if (velY > maxVelY)
				velY = maxVelY;
			else if (velY < -maxVelY)
				velY = -maxVelY;
		}
		
		/* Logica. */
		override protected function logic(e:Event):void 
		{
			fixVel();
			++rotation;
			x += velX;
			y += velY;
			posX = x;
			posY = y;
		}
		
		/* Tomou um ataque, um dano. */
		override public function takeHit():void 
		{
			if (Char.immortal || isBlinking())
				return;
			--health;
			if (health == 0)
			{
				dead = true;
				fadeOut(0.1, true);
			}
			else
				blink(4, 0.1);
		}
		
		/* Pegando dimensoes corretas. */
		override public function getWidth():Number 
		{
			return super.getWidth() / 2;
		}
		
		/* Pegando dimensoes corretas. */
		override public function getHeight():Number 
		{
			return super.getHeight() / 2;
		}
	}

}
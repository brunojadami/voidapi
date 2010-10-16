package fight.game.enemies 
{
	import dv.changeables.Global;
	import dv.component.Animation;
	import dv.physics.Physics;
	import fight.game.chars.Char;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	public class Skull extends Enemy
	{
		private var image:Animation;
		private var wait:Boolean = true;
		
		/* Criando Skull. */
		public function Skull(enemies:Array) 
		{
			super(enemies);
			health = 10;
			image = new Animation("EnemiesSkull", 44, 4, false);
			image.play();
			image.centerOn(0, 0);
			image.gotoFrame(2);
			addChild(image);
			maxVelX = 10;
			maxVelY = 10;
			setPosAndVel();
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
			velX = Math.random() * maxVelX * 2 - maxVelX / 2;
			if (velX == 0)
				velX = 1;
		}
		
		/* Arrumando velocidade. */
		private function fixVel():void
		{
			// Setando velocidades
			if (x - width / 2 < 0)
				velX = Math.random() * maxVelX + 1;
			else if (x + width / 2 > Global.WINDOW_WIDTH)
				velX = - (Math.random() * maxVelX) - 1;
			if (y - height < 0)
				velY = Math.random() * maxVelY + 1;
			else if (y + height > Global.WINDOW_HEIGHT)
				velY = - (Math.random() * maxVelY) - 1;
		}
		
		/* Logica. */
		override protected function logic(e:Event):void 
		{
			if (!wait)
				fixVel();
			else if (!isOutOfScreen())
				wait = false;
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
			{
				image.play(false);
				blink(4, 0.1);
			}
			transform.colorTransform = new ColorTransform(1, health / 10, health / 10);
		}
		
		/* Animacao de dano. */
		override public function addHitAnimation():void 
		{
			var animation:Animation = new Animation("EnemiesSplash", 0, 1);
			animation.autoKillOn(1);
			animation.centerOn(x, y);
			animation.play();
			parent.addChild(animation);
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
package fight.game.enemies 
{
	import dv.changeables.Global;
	import dv.component.Animation;
	import dv.component.VSprite;
	import dv.physics.Physics;
	import fight.game.chars.Char;
	import flash.events.Event;
	
	public class Bubble extends Enemy
	{
		private var images:Object = new Object();
		private var size:int;
		
		/* Criando bolha. */
		public function Bubble(size:int, enemies:Array) 
		{
			super(enemies);
			loadImages(size);
			this.size = size;
			addChild(images[size]);
			setPosAndVel();
		}
		
		/* Setando velocidade de acordo com tamanho. */
		private function setBubbleVel():void
		{
			maxVelY = 15 - size * 3 / 2;
			speedDelay = size + 2;
			velY = maxVelY;
		}
		
		/* Setando posicao e velocidades. */
		private function setPosAndVel():void
		{
			setBubbleVel();
			y = -height;
			x = int (Global.WINDOW_WIDTH * Math.random());
			if (x < Global.WINDOW_HALF_WIDTH)
			{
				x += width;
				velX = 4;
			}
			else
			{
				x -= width;
				velX = -4;
			}
			posX = x;
			posY = y;
		}
		
		/* Carregando imagens. */
		private function loadImages(max:int):void
		{
			for (var x:int = 0; x <= max; ++x)
			{
				images[x] = new VSprite("EnemiesBubble" + x); 
				images[x].centerOn(0, 0);
			}
		}
		
		/* Logica. */
		override protected function logic(e:Event):void 
		{
			// Colisao
			if (Physics.nextStepBottomScreenCollision(this, velY))
				velY = -maxVelY;
			if (Physics.nextStepHorizontalScreenCollision(this, velX))
				velX = -velX;
			// Movimentando
			if (++speedCounter >= speedDelay)
			{
				++velY;
				speedCounter = 0;
			}
			if (velY > maxVelY)
				velY = maxVelY;
			x += velX;
			y += velY;
			posX = x;
			posY = y;
		}
		
		/* Tomou um ataque, um dano. */
		override public function takeHit():void 
		{
			if (Char.immortal)
				return;
			--size;
			if (size == -1)
			{
				dead = true;
				addHitAnimation();
				parent.removeChild(this);
			}
			else
			{
				setBubbleVel();
				removeChildAt(0);
				addChild(images[size]);
				var bubble:Bubble = new Bubble(size, enemies);
				bubble.setPos(x, y);
				velY = -maxVelY;
				bubble.setVel( -velX, -maxVelY);
				enemies.push(bubble);
				parent.addChild(bubble);
				addHitAnimation();
			}
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
	}

}
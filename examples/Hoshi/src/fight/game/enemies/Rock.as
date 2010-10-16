package fight.game.enemies 
{
	import dv.changeables.Global;
	import dv.component.Animation;
	import dv.component.VSprite;
	import dv.physics.Physics;
	import fight.game.chars.Char;
	import flash.events.Event;
	
	public class Rock extends Enemy
	{
		private var image:VSprite;
		
		/* Criando Rock. */
		public function Rock(enemies:Array, health:int = 2) 
		{
			super(enemies);
			this.health = health;
			if (health == 2)
				image = new VSprite("EnemiesRock");
			else
				image = new VSprite("EnemiesMinirock");
			image.centerOn(0, 0);
			addChild(image);
			maxVelY = 10;
			if (health == 2)
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
		}
		
		/* Logica. */
		override protected function logic(e:Event):void 
		{
			++velY;
			if (velY > maxVelY)
				velY = maxVelY;
			y += velY;
			x += velX;
			posY = y;
			posX = x;
			if (y - height / 2 > Global.WINDOW_HEIGHT)
			{
				if (health == 2)
					setPosAndVel();
				else
				{
					dead = true;
					parent.removeChild(this);
				}
			}
		}
		
		/* Tomou um ataque, um dano. */
		override public function takeHit():void 
		{
			if (Char.immortal)
				return;
			addHitAnimation();
			if (health == 2)
			{
				// Criando 4 preda
				var tmp:Rock = new Rock(enemies, 1);
				enemies.push(tmp);
				parent.addChild(tmp);
				tmp.setPos(x, y);
				tmp.setVel(2, -18);
				tmp = new Rock(enemies, 1);
				enemies.push(tmp);
				parent.addChild(tmp);
				tmp.setPos(x, y);
				tmp.setVel(4, -18);
				tmp = new Rock(enemies, 1);
				enemies.push(tmp);
				parent.addChild(tmp);
				tmp.setPos(x, y);
				tmp.setVel(-2, -18);
				tmp = new Rock(enemies, 1);
				enemies.push(tmp);
				parent.addChild(tmp);
				tmp.setPos(x, y);
				tmp.setVel(-4, -18);
			}
			dead = true;
			parent.removeChild(this);
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
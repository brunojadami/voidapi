package fight.game.enemies 
{
	import dv.changeables.Global;
	import dv.component.Animation;
	import fight.game.chars.Char;
	import flash.events.Event;
	
	public class Bird extends Enemy
	{
		private var animation:Animation;
		
		/* Criando passaro. */
		public function Bird(enemies:Array) 
		{
			super(enemies);
			animation = new Animation("EnemiesBird", 0, 3);
			animation.centerOn(0, 0);
			animation.play();
			addChild(animation);
			setPosition();
		}
		
		/* Setando posicao. */
		private function setPosition():void
		{
			var rand:int = Math.random() * 2;
			if (rand == 0)
			{
				velX = -5;
				setPos(Global.WINDOW_WIDTH + width, Char.BASE_Y - height / 2);
			}
			else
			{
				velX = 5;
				setPos( -width, Char.BASE_Y - height / 2);
			}
		}
		
		/* Logica. */
		override protected function logic(e:Event):void 
		{
			x += velX;
			posX = x;
			// Se saiu da tela
			if (velX > 0 && posX > Global.WINDOW_HALF_WIDTH && isOutOfScreen())
			{
				dead = true;
				parent.removeChild(this);
			}
			else if (velX < 0 && posX < Global.WINDOW_HALF_WIDTH && isOutOfScreen())
			{
				dead = true;
				parent.removeChild(this);
			}
		}
	}

}
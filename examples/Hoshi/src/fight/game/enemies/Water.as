package fight.game.enemies 
{
	import dv.changeables.Global;
	import dv.component.Animation;
	import dv.component.VSprite;
	import dv.physics.Physics;
	import fight.game.chars.Char;
	import flash.events.Event;
	
	public class Water extends Enemy
	{
		private var image:VSprite;
		
		/* Criando Water. */
		public function Water(enemies:Array) 
		{
			super(enemies);
			health = 2;
			image = new VSprite("EnemiesWater");
			image.centerOn(0, 0);
			addChild(image);
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
			velY = 10;
		}
		
		/* Logica. */
		override protected function logic(e:Event):void 
		{
			y += velY;
			posY = y;
			if (isOutOfScreen())
				setPosAndVel();
		}
		
		/* Tomou um ataque, um dano. */
		override public function takeHit():void 
		{
			if (Char.immortal)
				return;
			addHitAnimation();
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
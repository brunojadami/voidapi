package fight.game.stage 
{
	import dv.component.VSprite;
	import dv.objects.GameObject;
	
	public class Scenario extends GameObject
	{
		private var image:VSprite;
		
		/* Criando cenario. */
		public function Scenario() 
		{
			image = new VSprite("Back0");
			addChild(image);
		}
		
		/* Atualizando de acordo com o level. */
		public function update(level:int):void
		{
			var newBack:VSprite = null;
			if (level == 6)
				newBack = new VSprite("Back1");
			else if (level == 11)
				newBack = new VSprite("Back2");
			
			if (newBack != null)
			{
				addChild(newBack);
				image.fadeOut(0.1, true);
				newBack.fadeIn(0.1);
				image = newBack;
			}
		}
		
	}

}
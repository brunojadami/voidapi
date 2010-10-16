package fight.game.chars 
{
	import fight.game.stage.Board;
	
	public class Hoshi extends Char
	{
		static public const ATTACK_VEL:int = -10;
		
		/* Criando Hoshi. */
		public function Hoshi(pos:int, enemies:Array, board:Board) 
		{
			super(0, pos, enemies, board);
			attackSpeed = 10;
			moveSpeed = 5;
		}
		
		/* Criando ataque. */
		override protected function createAttack():Attack
		{
			var ret:Attack = new Attack("AttacksStar", 0, ATTACK_VEL, enemies);
			ret.setPos(x, y);
			return ret;
		}
		
	}

}
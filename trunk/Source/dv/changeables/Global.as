package dv.changeables
{
	/**
	 * Some usefull constants that may be used in the game. Constants like WINDOW_WIDTH
	 * should be updated on games, some dv classes may use them.
	 * @author brunoja
	 */
	public class Global
	{

	    public function Global()
	    {
	        throw new Error("Must not instantiate this class");
	    }

		static public const TIMER_SUPDATE:int = 100;
		static public const WINDOW_WIDTH:int = 500;
		static public const WINDOW_HEIGHT:int = 400;
		static public const WINDOW_HALF_WIDTH:int = int(WINDOW_WIDTH / 2);
		static public const WINDOW_HALF_HEIGHT:int = int(WINDOW_HEIGHT / 2);
		static public const FRAME_RATE:int = 30;
		static public const SQM:int = 48;
		static public const HALF_SQM:int = SQM / 2;
		static public const TILES_V_WIDTH:int = WINDOW_WIDTH / SQM;
		static public const TILES_V_HEIGHT:int = WINDOW_HEIGHT / SQM;
		static public const DATA_KEY:String = "BAFANALAWL";
		static public const RESTRICT_TEXT:String = "0-9 a-zA-Z\",.?!";
	}

}

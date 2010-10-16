package dv.utils
{
	/**
	 * Very usefull to parse strings.
	 * @author brunoja
	 */
	public class StringStream
	{
		private var s:String;
		private var stoken:String;
		private var utoken:String;

		/**
		 * Creating the stream.
		 * @param s the string
		 * @param stoken the token separator
		 * @param utoken the unify token (ex: stoken = "@" utoken = "!" s = "hello!@@haha@@!hello", 
		 * the getval will return = "hello", "@@haha@@", hello)
		 */
		public function StringStream(s:String, stoken:String, utoken:String = null)
		{
			this.s = s;
			this.stoken = stoken;
			this.utoken = utoken;
		}

		/**
		 * Sets the token separator.
		 * @param stoken the token separator
		 */
		public function setToken(stoken:String):void
		{
			this.stoken = stoken;
		}

		/**
		 * @return the next value from the stream
		 */
		public function getVal():*
		{
			var pos:int;
			if (utoken == null || s.indexOf(utoken) != 0)
				pos = s.indexOf(stoken);
			else
			{
				s = s.slice(utoken.length);
				pos = s.indexOf(utoken);
			}
			var ret:String;
			if (pos == -1)
			{
				ret = s;
				s = "";
				return ret;
			}
			if (pos == 0)
			{
				s = s.slice(pos + 1);
				return getVal();
			}
			ret = s.slice(0, pos);
			s = s.slice(pos + 1);
			return ret;
		}

		/**
		 * @return if the stream is empty
		 */
		public function isEmpty():Boolean
		{
			return s.length == 0;
		}
		
		/**
		 * @return the string used by the stream
		 */
		public function getString():String
		{
			return s;
		}
		
		/**
		 * @return the unify token, look at constructor for details
		 */
		public function getUnifyToken():String
		{
			return utoken;
		}
		
		/**
		 * Clean the stream, removing the initial tokens.
		 */
		public function clean():void
		{
			while (s.indexOf(stoken) == 0)
				s = s.slice(stoken.length);
		}
	}
}


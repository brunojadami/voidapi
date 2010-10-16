package dv.utils 
{
	import dv.changeables.Global;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;

	/**
	 * Static class to save and load game data. Using SharedObject.
	 * @author brunoja
	 */
	public class Saver
	{
		static private var sharedObject:SharedObject;
		static private var dataObject:Object;
		
		/**
		 * Init the saver.
		 * @param object the database name
		 */
		static public function init(object:String):void
		{
			sharedObject = SharedObject.getLocal(object);
			if (sharedObject.data.data && sharedObject.data.data.length > 0)
			{
				var array:ByteArray = Utils.copyFrom(sharedObject.data.data);
				try
				{
					array.inflate();
				}
				catch (e:Error)
				{
					trace("Flash version is older than 10 on Saver inflate!");
				}
				var len:int = array.length;
				for (var i:int = 0; i < len; ++i)
				{
					array[i] -= Global.DATA_KEY.charCodeAt(i % Global.DATA_KEY.length);
				}
				array.position = 0;
				dataObject = array.readObject();
			}
			else
			{
				sharedObject.data.data = new ByteArray();
				dataObject = new Object();
			}
		}
		
		/**
		 * Getting a data.
		 * @param symbol the data name
		 * @return the data
		 */
		static public function getData(symbol:String):*
		{
			return dataObject[symbol];
		}
		
		/**
		 * Saving a data.
		 * @param symbol data name
		 * @param data the data
		 * @param autoDump if automattically dumps to the hard disk
		 */
		static public function saveData(symbol:String, data:*, autoDump:Boolean = true):void
		{
			dataObject[symbol] = data;
			if (autoDump)
				dump();
		}
		
		/**
		 * Saving it now.
		 */
		static public function dump():void
		{
			var array:ByteArray = new ByteArray();
			array.writeObject(dataObject);
			var len:int = array.length;
			for (var i:int = 0; i < len; ++i)
			{
				array[i] += Global.DATA_KEY.charCodeAt(i % Global.DATA_KEY.length);
			}
			array.position = 0;
			try
			{
				array.deflate();
			}
			catch (e:Error)
			{
				trace("Flash version is older than 10 on Saver deflate!");
			}
			sharedObject.data.data = array;
		}
		
	}

}
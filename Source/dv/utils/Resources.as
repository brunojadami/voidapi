package dv.utils
{
	import flash.display.Loader;
	
	/**
	 * Class to load a resource from the Library.
	 * @author brunoja
	 */
	public class Resources
	{
		static private var lib:Loader;
		static private var libNames:Array = new Array();
		
		/**
		 * Setting the lib to be used. Called from Library.
		 * @param lib the lib
		 */
		static public function setLib(lib:Loader):void
		{
			var libName:String = lib.contentLoaderInfo.content.toString();
			libName = libName.replace("[", ""); libName = libName.replace("]", ""); libName = libName.replace("object ", "");
			libName = "library." + libName;
			Resources.lib = lib;
			libNames.push(libName);
			try
			{
				var cl:Class = lib.contentLoaderInfo.applicationDomain.getDefinition(libName) as Class;
				for each (var str:String in cl.classesNames)
					libNames.push("library." + str);
			}
			catch (e:Error)
			{
				
			}
		}
		
		/**
		 * Getting a class.
		 * @param symbol the class symbol
		 * @return the class
		 */
		static public function getClass(symbol:String):Class
		{
			return lib.contentLoaderInfo.applicationDomain.getDefinition(symbol) as Class;
		}
		
		/**
		 * @param symbol the symbol
		 * @return if the library has the symbol
		 */
		static public function hasSymbol(symbol:String):Boolean
		{
			for each (var str:String in libNames)
			{
				if (lib.contentLoaderInfo.applicationDomain.hasDefinition(str + "_" + symbol))
					return true;
			}
			return false;
		}
		
		/**
		 * @param symbol the symbol
		 * @return the resource
		 */
		static public function getSymbol(symbol:String):*
		{
			for each (var str:String in libNames)
			{
				if (lib.contentLoaderInfo.applicationDomain.hasDefinition(str + "_" + symbol))
					return new (lib.contentLoaderInfo.applicationDomain.getDefinition(str + "_" + symbol) as Class)();
			}
			trace("Resources warning:", symbol, "not found!");
			return null;
		}
	}
	
}
package dv.utils 
{
	import dv.changeables.Main;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * Sending a php request.
	 * @author brunoja
	 */
	public class PhpRequest extends URLLoader
	{
		private var proc:Boolean;
		private var url:String;
		
		/**
		 * Construct the object and send the request. Add Event.COMPLETE and IOErrorEvent.IO_ERROR events!
		 * @param url the php url
		 * @param variables the post variables
		 * @param session the php session, if there is none leave it null
		 * @param method the method of the request, default is POST
		 */
		public function PhpRequest(url:String, variables:URLVariables, session:String = null, method:String = "POST") 
		{
			super();
			var request:URLRequest = new URLRequest(url);
			request.method = method;
			if (session)
				variables.PHPSESSID = session;
			if (Main.debug)
			{
				addEventListener(Event.COMPLETE, debugRequest, false, 0, true);
				addEventListener(IOErrorEvent.IO_ERROR, errorRequest, false, 0, true);
				variables.XDEBUG_SESSION_START = "netbeans-xdebug";
			}
			request.data = variables;
			load(request);
			this.url = url;
			proc = false;
		}
		
		/**
		 * @return if the request response was processed.
		 */
		public function isProcessed():Boolean
		{
			return proc;
		}
		
		/**
		 * Sets if the request response was processed.
		 * @param val the value
		 */
		public function setProcessed(val:Boolean):void
		{
			proc = val;
		}
		
		/**
		 * Debug event function to trace all received data.
		 */
		private function debugRequest(e:Event):void
		{
			trace("Recieved: " + e.target.data + " From: " + url);
		}
		
		/**
		 * Debug error event function to trace all received data.
		 */
		private function errorRequest(e:Event):void
		{
			trace("IOError: " + e + " From: " + url);
		}
	}

}
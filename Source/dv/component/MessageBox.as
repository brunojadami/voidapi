package dv.component 
{
	
	/**
	 * A simple message box containing a message.
	 * @author bunoja
	 */
	public class MessageBox extends Box
	{
		/**
		 * Constructor. Creating the box.
		 * @param title the message title
		 * @param message the message to show
		 * @param color the message color
		 */
		public function MessageBox(title:String, message:String, color:uint) 
		{
			var text:Text = new Text(message, Box.format, color);
			super(text.width * 1.1, text.height * 1.1 + 12, title, true);
			body.addChild(text);
			text.center();
			text.y += frame.height / 2;
		}
		
	}

}
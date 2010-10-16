package dv.changeables
{
	import flash.text.CSMSettings;
	import flash.text.FontStyle;
	import flash.text.TextColorType;
	import flash.text.TextDisplayMode;
	import flash.text.TextFormat;
	import flash.text.TextRenderer;
	
	/**
	 * Use this class to embeed fonts to te project.
	 * @author brunoja
	 */
	public class Fonts
	{	
		[Embed(source = "../../../lib/Fonts/Small.ttf", fontFamily = "Small", advancedAntiAliasing = "false")]
		static private var smallFont:String;
		static public var smallFormat:TextFormat = new TextFormat("Small", 8);
		[Embed(source = "../../../lib/Fonts/Scribish.ttf", fontFamily = "Scribish", advancedAntiAliasing = "true")]
		static private var scriFont:String;
		static public var scriFormat:TextFormat = new TextFormat("Scribish", 50);
			
		public function Fonts() 
		{
			throw new Error("Must not instantiate this class.");
		}	
		
		/**
		 * Preparing some fonts, like bitmap fonts.
		 */
		static public function prepareFonts():void
		{
			// BITMAP FONTS, DONT DELETE!
			var arr:Array;
			TextRenderer.displayMode = TextDisplayMode.CRT;
            smallFormat.kerning = true;
            smallFormat.letterSpacing = .1;
			arr = [new CSMSettings(8, 0.0, 0.0)];
            TextRenderer.setAdvancedAntiAliasingTable("Small", FontStyle.REGULAR, TextColorType.DARK_COLOR, arr);
		}
	}
}
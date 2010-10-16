package dv.utils 
{
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Some usefull functions.
	 * @author brunoja
	 */
	public class Utils
	{
		/**
		 * Creates a object from the same class of the parameter.
		 * @param obj the object
		 * @return the instance
		 */
		static public function createObjectOfClass(obj:*):*
		{
			return new(Class(getDefinitionByName(getQualifiedClassName(obj))))();
		}
		
		/**
		 * Copying an array.
		 * @param array the ByteArray
		 * @return the copy
		 */
		static public function copyFrom(array:ByteArray):*
		{
			var copy:ByteArray = new ByteArray();
			copy.writeObject(array);
			copy.position = 0;
			return copy.readObject();
		}
	}

}
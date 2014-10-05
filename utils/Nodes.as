package core.utils 
{
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Nodes 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// stage instances
				
			
			// properties
				
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: nodes
		
			/**
			 * Find the first node matching the 
			 * @param	xml
			 * @param	expression
			 * @return
			 */
			public static function findNode(xml:XML, expression:String):XML
			{
				return new XML();
			}
			
			public static function findNodes(xml:XML, expression:String):XMLList
			{
				return new XMLList();
			}
			
			public static function filterNodes(nodes:XMLList):XMLList
			{
				return new XMLList();
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: attributes
		

		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: classes
		
			public static function getClasses(node:XML):Array
			{
				return node
					? String(node.attribute('class'))
						.replace(/^\s+|\s+$/g, '')
						.split(/\s+/)
					: [];
			}
			
			public static function hasClass(node:XML, className:String):Boolean
			{
				return getClasses(node).indexOf(className) !== -1;
			}
		

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers

			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}
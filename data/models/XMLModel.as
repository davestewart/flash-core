package core.data.models 
{
	
	/**
	 * A customized class that serves as a container and API for XML data
	 * 
	 * Allows you to use custom CSS-style queries on the loaded nodes:
	 * 
	 *    node          - retrieve nodes matching the node name
	 * 						i.e <foo />
	 *    #id           - retrieve nodes matching the "id" attribute
	 * 						i.e <node id="foo"/>
	 *    ~name         - retrieve nodes matching a preset attribute (defaults to "name", change by setting the class' .cust property)
	 * 						i.e <node name="foo" />
	 *    .class        - retrieve nodes matching the "class" attribute
	 * 						i.e <node class="foo" />
	 *    @attrname     - retrieve nodes that have the named attribute
	 * 						i.e <node someattribute="any value"/>
	 * 
	 *  You can also use traditional attribute selectors
	 * 
	 *    [name=foo]    - retrieve nodes matching an attribute value
	 * 						i.e <node name="foo"/>
	 *    [name!=foo]   - retrieve nodes not matching an attribute value
	 * 						i.e <node name="bar"/>
	 *    [name^=foo]   - retrieve nodes matching an attribute that starts with a value
	 * 						i.e <node name="football"/>
	 *    [name$=foo]   - retrieve nodes matching an attribute that ends with a value
	 * 						i.e <node name="snaffoo"/>
	 *    [name*=foo]   - retrieve nodes matching an attribute that contains a value 
	 * 						i.e <node name="i like food"/>
	 *    [name~=foo]   - retrieve nodes matching an attribute that contains a value within a space separated list
	 * 						i.e <node name="bar foo baz"/>
	 * 
	 * Selectors can also be chained:
	 *
	 *    authors ~shakespeare
	 *    books authors [name=shakespeare]
	 * 
	 * @author Dave Stewart
	 */
	public class XMLModel
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// properties
				public var xml				:XML;
				public var debug			:Boolean;
				
			// other properties
				public var cust				:String		= 'name';

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function XMLModel(xml:XML, debug:Boolean = false) 
			{
				this.xml		= xml;
				this.debug		= debug;
			}

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: main methods
		
			
			/**
			 * Method to retrieve nodes using a CSS-style selector such as "authors #shakespear ~romance ~romeoandjuliet"
			 * 
			 * Uses the following shorthand: #id or ~item
			 * 
			 * @param	expression
			 * @return
			 */
			public function getNode(expression:String):XML
			{
				var nodes:XMLList = find(xml, expression);
				return nodes && nodes.length()
						? nodes[0]
						:null;
			}
			
			/**
			 * 
			 * @param	selector
			 * @param	node
			 * @return
			 */
			public function getNodes(expression:String):XMLList
			{
				return find(xml, expression);
			}
			

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: helper methods
		
			/**
			 * Gets a single node by its id attribute
			 * @param	id
			 * @return
			 */
			public function getId(id:String):XML
			{
				return getNode('#' + id);
			}

			/**
			 * Gets a single node by its item attribute
			 * @param	item
			 * @return
			 */
			public function getItem(item:String):XML
			{
				return getNode('~' + item);
			}

			/**
			 * Gets a single node by its item attribute
			 * @param	item
			 * @return
			 */
			public function getItems(item:String):XMLList
			{
				return getNodes('~' + item);
			}
			

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			/**
			 * Finds nodes that match an expression
			 * @param	node
			 * @param	expression
			 * @return
			 */
			protected function find(node:XML, expression:String):XMLList
			{
				// variables
					var selectors	:Array		= expression.replace(/^\s+|\s+$/g, '').split(/\s+/);
					var selector	:String;
					var nodes		:XMLList;
					
				// find node
					while (selectors.length > 0) 
					{
						// selector
							selector	= selectors.shift();
							nodes		= filter(node, selector);
							
						// error if nothing found
							if (nodes.length() == 0)
							{
								var message:String = "The selector '" + selector + "' in expression '" + expression + "' did not match any nodes in node " + String(xml.toXMLString().match(/^<.*>/));
								trace(message);
								if (debug)
								{
									throw new Error(message);
								}
								return null;//<xml><error>{message}</error></xml>.error;
							}
							
						// grab first node
							node = nodes[0];
					}
					
				// return
					return nodes;
			}
			
			/**
			 * Finds nodes that match a selector
			 * @param	selector
			 * @param	node
			 * @return
			 */
			protected function filter(node:XML, selector:String):XMLList
			{
				// attempt match for attribute shorthand
					var matches:Array = selector.match(/^([#~@\.])(.+)|\[(\w+)(=|!=|^=|$=|*=|~=)(.+)\]/);
					
				// if matched, it must be an attribute selector
					if (matches)
					{
						// variables
							var attr	:String;
							var filter	:String;
							var value	:String;
							
						// shorthand attribute selector
							if (matches[1])
							{
								// extract match variables
									attr	= matches[1];
									value	= matches[2];
									
								// id="value"
									if (attr == '#')
									{
										return node..*.(attribute('id') == value);
									}
									
								// item="value"
									else if(attr == '~')
									{
										return node..*.(attribute(cust) == value);
									}
									
								// class contains value
									else if(attr == '.')
									{
										var rx:RegExp = new RegExp('\\b' + value + '\\b');
										return node..*.(rx.test(String(attribute('class'))));
									}
									
								// attr exists
									else if(attr == '@')
									{
										return node..*.(attribute(value) != undefined);
									}
							}
						
						
						// normal attribute selector
							else
							{
								// extract match variables
									attr	= matches[3];
									filter	= matches[4];
									value	= matches[5];
									
								// filter
									switch(filter)
									{
										case '=':
											return node..*.(attribute(attr) == value);
										break;
										
										case '!=':
											return node..*.(attribute(attr) != value);
										break;
										
										case '^=':
											return node..*.(String(attribute(attr)).substr(0, value.length) == value);
										break;
										
										case '$=':
											return node..*.(String(attribute(attr)).substr(-value.length) == value)
										break;
										
										case '*=':
											return node..*.(String(attribute(attr)).indexOf(value) != -1);
										break;
										
										case '~=':
											node..*.(String(attribute(attr)).split(' ').indexOf(value) != -1);
										break;
									}		
							}
					}
					
				// if not, it's a node name
					else
					{
						return node..*.(name() == selector);
					}
					
				// return null if not matched
					return null;
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			public function toString():String 
			{
				return '[object XMLModel childnodes="' +xml.children().length() + '"]';
			}
			
	}

}
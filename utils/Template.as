package core.utils 
{
	import core.utils.LayoutUtils;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Utility class to use one movieclip as a template to populate, layout, align and match other movieclips, from
	 * Didn't come out as easy-to-use / intuitive as I hoped it would :(
	 * @author Dave Stewart
	 */
	public class Template 
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// instances
				public var source			:DisplayObjectContainer;
				public var target			:DisplayObjectContainer;
				
			// elements
				protected var elements		:Vector.<DisplayObject>;
				protected var processed		:Vector.<DisplayObject>;
				
			// properties	
				protected var xml			:XML;
				protected var handlers		:Dictionary;
				protected var rules			:Object;

			// variables
				protected var layout		:LayoutUtils;
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			/**
			 * 
			 * @param	template	The template movieclip
			 * @param	target		The target movieclip
			 * @param	nodes		An XML list of nodes with optional CSS rules and additional data. nodes are matched to stage elements
			 */
			public function Template(template:DisplayObjectContainer, target:DisplayObjectContainer = null, xml:XML = null) 
			{
				// parameters
					setSource(template);
					setTarget(target);
					
				// properties
					this.xml			= xml;
					handlers			= new Dictionary(true);
					rules				= { };
					
				// initialize
					initialize();
					
				// start
					getElements();
					processElements();
			}
			
			protected function initialize():void
			{
				target.addChild(source);
				setClassHandler(TextField, addTextField);
			}

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function setSource(source:DisplayObjectContainer):Template
			{
				this.source = source;
				return this;
			}
		
			public function setTarget(target:DisplayObjectContainer):Template
			{
				this.target	= target;
				return this;
			}
		
			public function setClassHandler(ref:Class, handler:Function):Template
			{
				handlers[ref] = handler;
				processElements();
				return this;
			}
			
			public function setRuleHandler(rule:String, handler:Function):Template
			{
				rules[rule] = handler;
				return this;
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: layout methods
		
			/**
			 * Manual function to replace
			 * @param	source
			 * @param	placeholder
			 * @param	classes
			 * @return
			 */
			public function process(placeholder:*, element:DisplayObject, classes:* = null):*
			{
				// add child
					if ( ! element.parent )
					{
						target.addChild(element);
					}
					
				// grab placeholder
					placeholder = getPlaceholder(placeholder);
					
				// align
					LayoutUtils.grab(placeholder, element).align();
						
				// apply any layout rules
					processRules(placeholder, element, classes);
					
				// swap names
					try 
					{
						element.name = placeholder.name; 
						placeholder.parent.removeChild(placeholder);
					}
					catch (error:Error) { }
					
				// return
					return element;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
		
			protected function processElements():void
			{
				// return if no elements to process
					if ( ! elements )
					{
						return;
					}
					
				// debug
					//trace('processing elements');
				
				// instances
					var placeholder		:DisplayObject;
					var element			:DisplayObject;
					
				// variables
					var node			:XML;
					var classPath		:String;		
					var classRef		:Class;
					var handler			:Function;
					
				// loop over template children
					for each(placeholder in elements) 
					{
						// only process unprocessed placeholders 
							if (processed.indexOf(placeholder) == -1)
							{
								// debug
									//trace('processing ' + element.name);
								
								// variables
									classPath	= getQualifiedClassName(placeholder);
									classRef	= getDefinitionByName(classPath) as Class;
									handler		= handlers[classRef];
									
								// get an element by calling the creation handler
									if (handler !== null)
									{
										// grab associated layout node
											node		= getNode(placeholder.name);
											
										// variables
											processed.push(placeholder);
											element = handler(placeholder, node);
											
										// debug
											//trace('created ' + element);
											
										// process
											process(placeholder, element, node);
									}
									
								// otherwise
									else
									{
										
									}
									
							}
					}

			}
			
			protected function processRules(placeholder:DisplayObject, element:DisplayObject, rules:*):void 
			{
				rules = getRules(rules);
				for each(var rule:String in rules)
				{
					if (this.rules[rule])
					{
						this.rules[rule](placeholder, element);
					}
				}
				
				// parameters
					placeholder = getPlaceholder(placeholder);
				
				// scales to 75%
					if (rules.indexOf('small') !== -1)
					{
						element.scaleX = element.scaleY = 0.75;
					}
					
				// fits width of source to match template, scaling height proportionally
					if (rules.indexOf('fit') !== -1)
					{
						element.width = placeholder.width;
					}
					
				// center
					if (rules.indexOf('center') !== -1)
					{
						element.x = (target.stage.stageWidth / 2) - (element.width / 2)
					}
					
				// align right
					if (rules.indexOf('right') !== -1)
					{
						element.x = (placeholder.x + placeholder.width) - element.width;
					}
				
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers

			protected function addTextField(element:TextField, node:XML = null):TextField 
			{
				// add textfield to target 
					target.addChild(element);
					
				// set the text of the textfield
					if (node)
					{
						element.text = node;
					}
					
				// fix any issues with leading
					TextUtils.fix(element);
					
				// return
					return element;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function getElements():void 
			{
				// variables
					processed	= new Vector.<DisplayObject>;
					elements	= new Vector.<DisplayObject>;
					
				// grab all named instances
					for (var i:int = 0; i < source.numChildren; i++)
					{
						var element:DisplayObject = source.getChildAt(i);
						if ( ! /^instance\d+$/.test(element.name) )
						{
							elements.push(source.getChildAt(i));
						}
					}
			}
			
			/**
			 * Grabs a child from the template
			 * @param	ref
			 * @return
			 */
			protected function getPlaceholder(ref:*):DisplayObject
			{
				return ref is String 
					? source.getChildByName(ref) as DisplayObject 
					: ref;
			}
			
			protected function getRules(rules:*):Array 
			{
				// attempt to return an array of rules
					if (rules is Array)
					{
						return rules;
					}
					else if (rules is String)
					{
						return rules.replace(/^\s+|\s+$/g, '').split(/\s+/g);
					}
					else if (rules is XML)
					{
						return getRules(String(rules.attribute('class')));
					}
					
				// return
					return ['top left'];
			}
			
			/**
			 * Grabs the correct node in the source XML
			 * @param	nodes
			 * @param	value
			 * @param	attr
			 */
			protected function getNode(value:String):XML
			{
				var items:XMLList = xml..*.(attribute('item') == value);
				return items.length() ? items[0] : null;
			}
			
			public function getCode():void 
			{
				// variables
					var imports			:Array		= [];
					var declarations	:Array		= [];
					var assignments		:Array		= [];
					
				// generate code
					for each (var element:DisplayObject in elements) 
					{
						// variables
							var name			:String			= element.name;
							var classPath		:String			= getQualifiedClassName(element).replace('::', '.');
							var className		:String			= classPath.split('.').pop();
							var imp				:String			= 'import ' + classPath + ';';
							
						// assignments
							
							if (imports.indexOf(imp) == -1)
							{
								imports.push(imp);
							}
							declarations.push('public var ' +name+ '		:' +className+ ';');
							assignments.push(name+ '		= template.process(\'' +name+ '\', ' +name+ ');');
					}
					
				// output code
					trace();
					trace(imports.join('\n') + '\n');
					trace(declarations.join('\n') + '\n');
					trace(assignments.join('\n') + '\n');
			}
			
			
	}

}
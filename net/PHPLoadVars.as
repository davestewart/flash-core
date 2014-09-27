/**
 * @name		PHPLoadVars
 * @type		AS2 Class
 * version		1.0
 * @desc		Send complex datatypes (arrays, objects) to a PHP script, as serialized name/value pairs
 * @example		
 				// Flash
					var data	:Object		= {data:[1,2,{sub_object:{name:'Dave',age:33,gender:'male'}},3,4,5]}
					var lv		:LoadVars	= new PHPLoadVars;
					lv.serialize(obj)
					lv.send('process.php')
									
				// PHP
					Array
					(
						[data] => Array
							(
								[0] => 1
								[1] => 2
								[2] => Array
									(
										[sub_object] => Array
											(
												[gender] => male
												[age] => 33
												[name] => Dave
											)
					
									)
					
								[3] => 3
								[4] => 4
								[5] => 5
							)
					
					)

 * @author		Dave Stewart
 * @date		28th Feb 2008
 * @email		dev@davestewart.co.uk
 * @web			www.davestewart.co.uk

 */

 class uk.co.davestewart.data.PHPLoadVars extends LoadVars{
	
	function PHPLoadVars(){
		}
		
	function serialize(obj:Object, path:String){
			
		// prepare
			path = path || '';
		
		// iteration
			// undefined
				if(obj == undefined){
					// fail gracefully
					}
					
			// array
				else if(obj.constructor == Array){
					// flash iterates from most recently-created property first, 
					// so iterate through array backwards for correct output
					for(var i = obj.length - 1; i >=0 ; i--){
						var name = path + '[' +i+']';
						serialize(obj[i], name);
						}
					}
					
			// object
				else if(obj.constructor == Object){
					// no such joy for objects - properties will be reversed!
					// Could do a pre-emptive collection loop, but why bother...?
					for(var prop:String in obj){
						var name = path + (path == '' ? prop : '[' +prop+ ']');
						serialize(obj[prop], name);
						}
					}
					
			// value
				else{
					this[path] = obj;
					};
	
		};	
	
	}
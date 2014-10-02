package core.data.variables 
{
	import flash.external.ExternalInterface;
	
	/**
	 * Cookies class, ported from https://developer.mozilla.org/en-US/docs/Web/API/document.cookie
	 * @author Dave Stewart
	 */
	public class Cookies 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var _cookie	:String;
				protected var _status	:String;
				
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Cookies() 
			{
				
			}
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function get(name:String):String
			{
				var rx:RegExp = new RegExp("(?:(?:^|.*;)\\s*" + encodeURIComponent(name).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=\\s*([^;]*).*$)|^.*$");
				return decodeURIComponent(cookie.replace(rx, "$1")) || null;
			}

			public function set(name:String, value:*, end:* = null, path:String = null, domain:String = null, secure:Boolean = false):void
			{
				if(/^(?:expires|max\-age|path|domain|secure)$/i.test(name)) 
				{
					throw new Error('Cookies cannot be named "' +name+ '"');
				}
				
				var expires:String = "";
				if(end) 
				{
					if (end is Number)
					{
						expires = end === Infinity 
							? "; expires=Fri, 31 Dec 9999 23:59:59 GMT" 
							: "; max-age=" + end;
					}
					else if (end is String)
					{
						expires = "; expires=" + end;
					}
					if (end is Date)
					{
						expires = "; expires=" + end.toUTCString();
					}
				}
				
				cookie = encodeURIComponent(name) 
					+ "=" 
					+ encodeURIComponent(value) 
					+ expires 
					+ (domain ? "; domain=" + domain : "") 
					+ (path ? "; path=" + path : "") 
					+ (secure ? "; secure" : "");
			}

			public function remove(name:String, path:String = '', domain:String = ''):Boolean
			{
				if (this.has(name))
				{
					cookie = encodeURIComponent(name)
						+ "=; expires=Thu, 01 Jan 1970 00:00:00 GMT"
						+ (domain ? "; domain=" + domain : "")
						+ (path ? "; path=" + path : "");
				}
				return false;
			}

			public function has(name:String):Boolean
			{
				var rx:RegExp = new RegExp("(?:^|;\\s*)" + encodeURIComponent(name).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=");
				return rx.test(cookie);
			}

			public function keys():Array
			{
				var keys:Array = cookie.replace(/((?:^|\s*;)[^\=]+)(?=;|$)|^\s*|\s*(?:\=[^;]*)?(?:\1|$)/g, "").split(/\s*(?:\=[^;]*)?;\s*/);
				for(var len:int = keys.length, i:int = 0; i < len; i++) 
				{
					keys[i] = decodeURIComponent(keys[i]); 
				}
				return keys;
			}
			
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get cookie():String 
			{
				if (ExternalInterface.available)
				{
					try{ return ExternalInterface.call('eval', 'document.cookie'); }
					catch (error:Error)
					{
						_status = 'Cookies not available: ' + error.message;
						trace(status);
						return ''; 
					}
				}
				trace('Cookies: no external interface');
				return '';
			}

			public function set cookie(value:String):void 
			{
				if (ExternalInterface.available)
				{
					try{ ExternalInterface.call('eval', 'document.cookie = ' + value); }
					catch (error:Error)
					{
						_status = 'Cookies not available: ' + error.message;
						trace(status);
					}
				}
				trace('Cookies: no external interface');
			}
			
			public function get status():String { return _status; }

		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}
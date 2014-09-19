package core.utils 
{
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class StringUtils 
	{
		
		
		/**
		 * International HTML entities decode function
		 * 
		 * Works with entity numbers and entity names
		 * 
		 * @usage			htmlDecode('Hello &amp; w&#233;lcome to &lt;The &Omega; Show&gt;');
		 * 					Hello & wélcome to <The Ω Show>
		 * 
		 * @param	value	The string to decode
		 * @return			The decoded String
		 */
		public static function htmlDecode(value:String):String
		{
			// variables
				var entities:Object = 
				{
					'quot':0x0022, 'amp':0x0026, 'lt':0x003c, 'gt':0x003e, 'nbsp':0x00a0, 'iexcl':0x00a1, 
					'cent':0x00a2, 'pound':0x00a3, 'curren':0x00a4, 'yen':0x00a5, 'brvbar':0x00a6, 'sect':0x00a7, 
					'uml':0x00a8, 'copy':0x00a9, 'ordf':0x00aa, 'laquo':0x00ab, 'not':0x00ac, 'shy':0x00ad, 
					'reg':0x00ae, 'macr':0x00af, 'deg':0x00b0, 'plusmn':0x00b1, 'sup2':0x00b2, 'sup3':0x00b3, 
					'acute':0x00b4, 'micro':0x00b5, 'para':0x00b6, 'middot':0x00b7, 'cedil':0x00b8, 'sup1':0x00b9, 
					'ordm':0x00ba, 'raquo':0x00bb, 'frac14':0x00bc, 'frac12':0x00bd, 'frac34':0x00be, 'iquest':0x00bf, 
					'Agrave':0x00c0, 'Aacute':0x00c1, 'Acirc':0x00c2, 'Atilde':0x00c3, 'Auml':0x00c4, 'Aring':0x00c5, 
					'AElig':0x00c6, 'Ccedil':0x00c7, 'Egrave':0x00c8, 'Eacute':0x00c9, 'Ecirc':0x00ca, 'Euml':0x00cb, 
					'Igrave':0x00cc, 'Iacute':0x00cd, 'Icirc':0x00ce , 'Iuml':0x00cf, 'ETH':0x00d0, 'Ntilde':0x00d1, 
					'Ograve':0x00d2, 'Oacute':0x00d3, 'Ocirc':0x00d4, 'Otilde':0x00d5, 'Ouml':0x00d6, 'times':0x00d7, 
					'Oslash':0x00d8, 'Ugrave':0x00d9, 'Uacute':0x00da, 'Ucirc':0x00db, 'Uuml':0x00dc, 'Yacute':0x00dd, 
					'THORN':0x00de, 'szlig':0x00df, 'agrave':0x00e0, 'aacute':0x00e1, 'acirc':0x00e2, 'atilde':0x00e3, 
					'auml':0x00e4, 'aring':0x00e5, 'aelig':0x00e6, 'ccedil':0x00e7, 'egrave':0x00e8, 'eacute':0x00e9, 
					'ecirc':0x00ea, 'euml':0x00eb, 'igrave':0x00ec, 'iacute':0x00ed, 'icirc':0x00ee, 'iuml':0x00ef, 
					'eth':0x00f0, 'ntilde':0x00f1, 'ograve':0x00f2, 'oacute':0x00f3, 'ocirc':0x00f4, 'otilde':0x00f5, 
					'ouml':0x00f6, 'divide':0x00f7, 'oslash':0x00f8, 'ugrave':0x00f9, 'uacute':0x00fa, 'ucirc':0x00fb, 
					'uuml':0x00fc, 'yacute':0x00fd, 'thorn':0x00fe, 'yuml':0x00ff, 'OElig':0x0152, 'oelig':0x0153, 
					'Scaron':0x0160, 'scaron':0x0161, 'Yuml':0x0178, 'fnof':0x0192, 'circ':0x02c6, 'tilde':0x02dc, 
					'Alpha':0x0391, 'Beta':0x0392, 'Gamma':0x0393, 'Delta':0x0394, 'Epsilon':0x0395, 'Zeta':0x0396, 
					'Eta':0x0397, 'Theta':0x0398, 'Iota':0x0399, 'Kappa':0x039a, 'Lambda':0x039b, 'Mu':0x039c, 
					'Nu':0x039d, 'Xi':0x039e, 'Omicron':0x039f, 'Pi':0x03a0, 'Rho ':0x03a1, 'Sigma':0x03a3, 
					'Tau':0x03a4, 'Upsilon':0x03a5, 'Phi':0x03a6, 'Chi':0x03a7, 'Psi':0x03a8, 'Omega':0x03a9, 
					'alpha':0x03b1, 'beta':0x03b2, 'gamma':0x03b3, 'delta':0x03b4, 'epsilon':0x03b5, 'zeta':0x03b6, 
					'eta':0x03b7, 'theta':0x03b8, 'iota':0x03b9, 'kappa':0x03ba, 'lambda':0x03bb, 'mu':0x03bc, 
					'nu':0x03bd, 'xi':0x03be, 'omicron':0x03bf, 'pi':0x03c0, 'rho':0x03c1, 'sigmaf':0x03c2, 
					'sigma':0x03c3, 'tau':0x03c4, 'upsilon':0x03c5, 'phi':0x03c6, 'chi':0x03c7, 'psi':0x03c8, 
					'omega':0x03c9, 'thetasym':0x03d1, 'upsih':0x03d2, 'piv':0x03d6, 'ensp':0x2002, 'emsp':0x2003, 
					'thinsp':0x2009, 'zwnj':0x200c, 'zwj':0x200d, 'lrm':0x200e, 'rlm':0x200f, 'ndash':0x2013, 
					'mdash':0x2014, 'lsquo':0x2018, 'rsquo':0x2019, 'sbquo':0x201a, 'ldquo':0x201c, 'rdquo':0x201d, 
					'bdquo':0x201e, 'dagger':0x2020, 'Dagger':0x2021, 'bull':0x2022, 'hellip':0x2026, 'permil':0x2030, 
					'prime':0x2032, 'Prime':0x2033, 'lsaquo':0x2039, 'rsaquo':0x203a, 'oline':0x203e, 'frasl':0x2044, 
					'euro':0x20ac, 'image':0x2111, 'weierp':0x2118, 'real':0x211c, 'trade':0x2122, 'alefsym':0x2135, 
					'larr':0x2190, 'uarr':0x2191, 'rarr':0x2192, 'darr':0x2193, 'harr':0x2194, 'crarr':0x21b5, 
					'lArr':0x21d0, 'uArr':0x21d1, 'rArr':0x21d2, 'dArr':0x21d3, 'hArr':0x21d4, 'forall':0x2200, 
					'part':0x2202, 'exist':0x2203, 'empty':0x2205, 'nabla':0x2207, 'isin':0x2208, 'notin':0x2209, 
					'ni':0x220b, 'prod':0x220f, 'sum':0x2211, 'minus':0x2212, 'lowast':0x2217, 'radic':0x221a, 
					'prop':0x221d, 'infin':0x221e, 'ang':0x2220, 'and':0x2227, 'or':0x2228, 'cap':0x2229, 
					'cup':0x222a, 'int':0x222b, 'there4':0x2234, 'sim':0x223c, 'cong':0x2245, 'asymp':0x2248, 
					'ne':0x2260, 'equiv':0x2261, 'le':0x2264, 'ge':0x2265, 'sub':0x2282, 'sup':0x2283, 
					'nsub':0x2284, 'sube':0x2286, 'supe':0x2287, 'oplus':0x2295, 'otimes':0x2297, 'perp':0x22a5, 
					'sdot':0x22c5, 'lceil':0x2308, 'rceil':0x2309, 'lfloor':0x230a, 'rfloor':0x230b, 'lang':0x2329, 
					'rang':0x232a, 'loz':0x25ca, 'spades':0x2660, 'clubs':0x2663, 'hearts':0x2665, 'diams':0x2666
				};
			
			// replacement function
				function replace(match:String, name:String, num:int, index:int, original:String):String
				{
					var code:int = name ? entities[name] : num;
					return code ? String.fromCharCode(code) : '';
				}
				
			// replace and return
				return value.replace(/&([A-Za-z]+);|&#(\d+);/g, replace);
		}
		
		public static function phpSerialize(obj:Object, path:String = ''):String
		{
			// undefined
				if (obj == undefined)
				{
					// fail gracefully
				}

			// array
				else if (obj is Array)
				{
					// flash iterates from most recently-created property first, 
					// so iterate through array backwards for correct output
					for (var i:int = obj.length - 1; i >= 0; i--)
					{
						var name:String = path + '[' + i + ']';
						serialize(obj[i], name);
					}
				}

			// object
				else if (obj is Object)
				{
					// no such joy for objects - properties will be reversed!
					// Could do a pre-emptive collection loop, but why bother...?
					for (var prop:String in obj)
					{
						var name:String = path + (path == '' ? prop : '[' + prop + ']');
						serialize(obj[prop], name);
					}
				}

			// value
				else
				{
					this[path] = obj;
				};

		};			
	}

}
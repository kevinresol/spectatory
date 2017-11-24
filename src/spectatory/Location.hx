package spectatory;

import tink.Url;
import tink.state.*;
import js.Browser.*;

class Location {
	static public var href(default, null):Observable<Url> = {
		var s = new State<Url>(window.location.href);
		
		// polyfill Event on IE
		untyped __js__('
			(function () {

				if ( typeof window.CustomEvent === "function" ) return;

				function CustomEvent ( event, params ) {
					params = params || { bubbles: false, cancelable: false, detail: undefined };
					var evt = document.createEvent( "CustomEvent" );
					evt.initCustomEvent( event, params.bubbles, params.cancelable, params.detail );
					return evt;
				}

				CustomEvent.prototype = window.Event.prototype;

				window.CustomEvent = CustomEvent;
			})();
		');
		
		// listen to pushState() and replaceState()
		var oldPushState = window.history.pushState;
		untyped window.history.pushState = function(data, title, ?url) {
			oldPushState(data, title, url);
			s.set(window.location.href);
		}
		
		var oldReplaceState = window.history.replaceState;
		untyped window.history.replaceState = function(data, title, ?url) {
			oldReplaceState(data, title, url);
			s.set(window.location.href);
		}
		
		// listen to popstate event (browser's back/forward button)
		window.addEventListener('popstate', function() s.set(window.location.href));
		
		s.observe();
	}
	
	public static function push(url:String)
		js.Browser.window.history.pushState(null, null, url);
	
	public static function replace(url:String)
		js.Browser.window.history.replaceState(null, null, url);
}
package spectatory;

import tink.Url;
import tink.url.*;
import tink.pure.*;
import tink.state.*;
import js.Browser.*;

class Location {
	public static var href(default, null):Observable<String> = {
		var s = new State<String>(window.location.href);
		
		// polyfill Event on IE
		#if haxe4 js.Syntax.code #else untyped __js__ #end ('
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
		
		function update(href:String)
			if(href != s.value) s.set(href);
		
		// listen to pushState() and replaceState()
		var oldPushState = window.history.pushState;
		untyped window.history.pushState = function(data, title, ?url) {
			oldPushState(data, title, url);
			update(window.location.href);
		}
		
		var oldReplaceState = window.history.replaceState;
		untyped window.history.replaceState = function(data, title, ?url) {
			oldReplaceState(data, title, url);
			update(window.location.href);
		}
		
		// listen to popstate event (browser's back/forward button)
		window.addEventListener('popstate', function(_) update(window.location.href));
		
		// listen to hash change
		window.addEventListener('hashchange', function(e) update(e.newURL));
		
		s.observe();
	}
	
	public static var url(default, null):Observable<Url> =
		href.map(function(href) return Url.parse(href));
	
	public static var query(default, null):Observable<Mapping<String, Portion>> = 
		url.map(function(url) {
			var map = new Mapping();
			for(param in url.query) map = map.with(param.name, param.value);
			return map;
		});
	
	
	public static inline function back()
		js.Browser.window.history.back();
	
	public static inline function push(url:String)
		js.Browser.window.history.pushState(null, null, url);
	
	public static inline function replace(url:String)
		js.Browser.window.history.replaceState(null, null, url);
}
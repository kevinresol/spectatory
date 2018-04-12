package ;

import spectatory.*;
import tink.unit.*;
import tink.testrunner.*;
import js.Browser.*;

using tink.CoreApi;
using haxe.io.Path;

@:asserts
@:await
class RunTests {

  static function main() {
    Runner.run(TestBatch.make([
      new RunTests(),
    ])).handle(Runner.exit);
  }
  
  function new() {}
  
  @async public function test() {
    var expected:String;
    
    var prefix = Location.href.value.directory();
    expected = '$prefix/1.html';
    window.history.pushState(null, null, expected);
    @await delay(0);
    asserts.assert(Location.href.value == expected);
    
    expected = '$prefix/2.html';
    window.history.replaceState(null, null, expected);
    @await delay(0);
    asserts.assert(Location.href.value == expected);
    asserts.assert(Location.query.value.get('id') == null);
    
    expected = '$prefix/2.html?id=1';
    window.history.replaceState(null, null, expected);
    @await delay(0);
    asserts.assert(Location.query.value.get('id') == '1');
    
    window.location.hash = '#hash1';
    @await delay(0);
    asserts.assert(Location.url.value.hash == 'hash1');
    
    window.location.hash = '#hash2';
    @await delay(0);
    asserts.assert(Location.url.value.hash == 'hash2');
    
    return asserts.done();
  }
  
  function delay(ms:Int)
    return Future.async(function(cb) haxe.Timer.delay(cb.bind(Noise), ms));
}
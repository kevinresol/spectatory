package ;

import spectatory.*;
import tink.unit.*;
import tink.testrunner.*;

@:asserts
class RunTests {

  static function main() {
    Runner.run(TestBatch.make([
      new RunTests(),
    ])).handle(Runner.exit);
  }
  
  function new() {}
  
  public function test() {
    var expected:String;
    
    expected = 'http://www.example.com/1';
    js.Browser.window.history.pushState(null, null, expected);
    asserts.assert(Location.href.value.toString() == expected);
    
    expected = 'http://www.example.com/2';
    js.Browser.window.history.replaceState(null, null, expected);
    asserts.assert(Location.href.value.toString() == expected);
    
    return asserts.done();
  }
  
}
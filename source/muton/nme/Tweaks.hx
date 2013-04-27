package muton.nme;
import haxe.Log;
import haxe.PosInfos;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Tweaks {

	public static function redirectTrace() {
#if flash
		Log.trace = flashTrace;
#end
	}
	
#if flash
	static inline private function flashTrace( v:Dynamic, ?inf:PosInfos ) {
		untyped __global__["trace"]( v );		
	}
#end
	
}
package muton.ld26;
import org.flixel.FlxG;
import org.flixel.system.input.FlxKeyboard;

/**
 * ...
 * @author tim@muton.co.uk
 */

class CtrlState {
	public function new() {}
	public var up:Bool;
	public var down:Bool;
	public var left:Bool;
	public var right:Bool;
	public var fireA:Bool;
	public var fireB:Bool;
}
 
class Control {

	public static var touchState:CtrlState = new CtrlState();
	
	public static inline function state():CtrlState {
		var st:CtrlState = new CtrlState();
		st.up = pressedUp();
		st.down = pressedDown();
		st.left = pressedLeft();
		st.right = pressedRight();
		st.fireA = pressedFireA();
		st.fireB = pressedFireB();
		return st;
	}
	
	public static inline function pressedUp():Bool {
		return FlxG.keys.UP || FlxG.keys.W || touchState.up;
	}
	
	public static inline function pressedDown():Bool {
		return FlxG.keys.DOWN || FlxG.keys.S || touchState.down;
	}
	
	public static inline function pressedLeft():Bool {
		return FlxG.keys.LEFT || FlxG.keys.A || touchState.left;
	}
	
	public static inline function pressedRight():Bool {
		return FlxG.keys.RIGHT || FlxG.keys.D || touchState.right;
	}
	
	public static inline function pressedFireA():Bool {
		return FlxG.keys.CONTROL || FlxG.keys.M || touchState.fireA;
	}
	
	public static inline function pressedFireB():Bool {
		return FlxG.keys.SHIFT || FlxG.keys.N || touchState.fireB;
	}
	
}
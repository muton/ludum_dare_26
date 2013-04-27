package muton.ld26;

import muton.ld26.states.MenuState;
import nme.Lib;
import org.flixel.FlxGame;
	
class ProjectClass extends FlxGame {	
	
	public function new() {
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var ratioX:Float = stageWidth / 400;
		var ratioY:Float = stageHeight / 240;
		var ratio:Float = Math.min(ratioX, ratioY);
		super( Math.ceil( stageWidth / ratio ), Math.ceil( stageHeight / ratio ), MenuState, ratio, 30, 30 );
	}
}

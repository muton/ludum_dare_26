package muton.ld26.states;

import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;
import org.flixel.plugin.photonstorm.FlxDisplay;

class MenuState extends FlxState {
	
	override public function create():Void {
#if !neko
		FlxG.bgColor = 0xFFaaaaaa;
#else
		FlxG.camera.bgColor = {rgb: 0xaaaaaa, a: 0xff};
#end
#if !FLX_NO_MOUSE
		FlxG.mouse.show();
#end
		
		var startBtn = new FlxButton( 0, 0, "Start", function() { FlxG.switchState( new GameState() ); } );
		FlxDisplay.screenCenter( startBtn, true, true );
		add( startBtn );
	}
	
	override public function destroy():Void {
		super.destroy();
	}

	override public function update():Void {
		super.update();
	}	
}
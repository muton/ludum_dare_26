package muton.ld26.states;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.plugin.photonstorm.FlxDisplay;

/**
 * ...
 * @author tim@muton.co.uk
 */

class WinState extends FlxState {

	override public function create():Void {
		FlxG.bgColor = 0xFFFFFF00;
		FlxG.mouse.show();
		
		var label = new FlxText( 0, 50, 180, "THEY HATE IT HERE ON EARTH, AND HAVE BUGGERED OFF SOMEWHERE ELSE, YOU WIN!", 15, true );
		label.color = 0xFFC46200;
		label.alignment = "center";
		add( label );
		FlxDisplay.screenCenter( label, true );
		
		var startBtn = new FlxButton( 0, FlxG.height - 100, "Play again!", function() { FlxG.switchState( new GameState() ); } );
		FlxDisplay.screenCenter( startBtn, true );
		add( startBtn );
	}
	
	override public function destroy():Void {
		super.destroy();
	}

	override public function update():Void {
		super.update();
	}	
	
}
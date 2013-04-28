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

class LoseState extends FlxState {

	override public function create():Void {
		FlxG.bgColor = 0xFF6E6E6E;
		FlxG.mouse.show();
		
		var label = new FlxText( 0, 30, 250, "YOU FAILED TO DEFEAT THE TEDIOUS MINIMALIST ALIEN INVADERS. THEY LIKE IT HERE AND HAVE TOLD ALL THEIR MISERABLE ANNOYING FRIENDS ABOUT IT, EARTH IS DOOMED.\nNICE ONE.", 15, true );
		label.color = 0xFFD1D1D1;
		label.alignment = "center";
		add( label );
		FlxDisplay.screenCenter( label, true );
		
		var startBtn = new FlxButton( 0, FlxG.height - 80, "Try again", function() { FlxG.switchState( new GameState() ); } );
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
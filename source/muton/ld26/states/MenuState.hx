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
	
	private var title:FlxText;
	
	override public function create():Void {
#if !neko
		FlxG.bgColor = 0xFF707070;
#else
		FlxG.camera.bgColor = {rgb: 0xaaaaaa, a: 0xff};
#end
#if !FLX_NO_MOUSE
		FlxG.mouse.show();
#end
		title = new FlxText( 0, 20, FlxG.width, "MINIMALIST INVADERS FROM OUTER SPACE", 30, true );
		title.color = 0xFFFFFFFF;
		title.shadow = 0x99000000;
		title.useShadow = true;
		title.alignment = "center";
		add( title );
		
		var startBtn = new FlxButton( 0, title.y + title.height + 15, "Start", function() { FlxG.switchState( new GameState() ); } );
		FlxDisplay.screenCenter( startBtn, true );
		add( startBtn );
		
		var instructions = 'KEYS:    Up, Down, Left, Right, Ctrl    OR    W, S, A, D, M
An awful alien couple, DaYviDD and FiYoNAR, from the galactic megacity have invaded earth because property here is cheap. 
They are minimalists and hate mess and disorder of any kind. Convince them to leave by making their living conditions unacceptable!
Be careful, DaYviDD has a gun!
';
		
		var label = new FlxText( 0, startBtn.y + startBtn.height + 22, FlxG.width - 40, instructions, 8, true );
		label.color = 0xFFEEEEEE;
		label.alignment = "center";
		add( label );
		FlxDisplay.screenCenter( label, true );
		
	}
	
	override public function destroy():Void {
		super.destroy();
	}

	override public function update():Void {
		super.update();
		
		if ( FlxG.random() > 0.95 ) {
			title.color = Std.int( FlxG.random() * 0xffffff ) << 24 * 0xff;
			title.shadow = Std.int( FlxG.random() * 0xffffff ) << 24 * 0xff;
		}
	}	
}
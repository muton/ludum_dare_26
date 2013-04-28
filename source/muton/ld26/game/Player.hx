package muton.ld26.game;
import nme.utils.Timer;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxSound;
import org.flixel.FlxSprite;
import org.flixel.FlxTimer;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Player extends FlxSprite {

	private static inline var WALK_SPEED:Float = 80;
	
	private var facingAnims:IntHash<String>;
	private var interactFunc:FlxPoint->Void;
	private var checkFunc:FlxPoint->Bool;
	private var justInteracted:Bool;
	private var dontPlayIdeaSoundAgain:Bool;
	
	public function new( x:Float, y:Float, interactFunc:FlxPoint->Void, checkFunc:FlxPoint->Bool ) {
		super( x, y );
		this.interactFunc = interactFunc;
		this.checkFunc = checkFunc;
		
		facingAnims = new IntHash<String>();
		facingAnims.set( FlxObject.LEFT, "left" );
		facingAnims.set( FlxObject.RIGHT, "right" );
		facingAnims.set( FlxObject.UP, "up" );
		facingAnims.set( FlxObject.DOWN, "down" );
		
		loadGraphic( "assets/sprites/player_sheet.png", true, false, 27, 27 );
		addAnimation( "left", [1], 6, true );
		addAnimation( "right", [2], 6, true );
		addAnimation( "up", [1], 6, true );
		addAnimation( "down", [2], 6, true );
		addAnimation( "idea", [0], 6, true );
		play( "right" );
	}
	
	override public function update():Void {
		
		velocity.x = velocity.y = 0;
		
		var ctrl = Control.state();
		
		if ( ctrl.up ) { velocity.y -= WALK_SPEED; }
		if ( ctrl.down ) { velocity.y += WALK_SPEED; }
		if ( ctrl.left ) { velocity.x -= WALK_SPEED; }
		if ( ctrl.right ) { velocity.x += WALK_SPEED; }
		
		if ( velocity.x != 0 && velocity.y != 0 ) {
			velocity.x *= 0.75;
			velocity.y *= 0.75;
		}
		
		if ( velocity.x != 0 ) {
			facing = velocity.x < 0 ? FlxObject.LEFT : FlxObject.RIGHT;
			play( facingAnims.get( facing ) );
		} else if ( velocity.y != 0 ) {
			facing = velocity.y < 0 ? FlxObject.UP : FlxObject.DOWN;
			play( facingAnims.get( facing ) );
		} 
		
		if ( ctrl.fireA && !justInteracted ) { 
			justInteracted = true;
			var timer = new FlxTimer();
			timer.start( 0.5, 1, function( timer:FlxTimer ) { justInteracted = false; } );
			interactFunc( getInteractionPoint() );
			
		} else if ( !justInteracted && velocity.x == 0 && velocity.y == 0 ) {
			// we're stopped, we're not interacting and we want to check to see if we're in front of anything fun
			if ( checkFunc( getInteractionPoint() ) ) {
				play( "idea", true );
				if ( !dontPlayIdeaSoundAgain ) {
					FlxG.play( SFX.FX_IDEA );
					dontPlayIdeaSoundAgain = true;
				}
			} else {
				dontPlayIdeaSoundAgain = false;
			}
		}
		
		super.update();
	}
	
	private function getInteractionPoint():FlxPoint {
		var interactPt = new FlxPoint( x + origin.x, y + origin.y );
		
		switch ( facing ) {
			case FlxObject.LEFT: interactPt.x -= ( width / 2 + 5 );
			case FlxObject.RIGHT: interactPt.x += ( width / 2 + 5 );
			case FlxObject.UP: interactPt.y -= ( height / 2 + 5 );
			case FlxObject.DOWN: interactPt.y += ( height / 2 + 5 );
		}
		return interactPt;
	}
}

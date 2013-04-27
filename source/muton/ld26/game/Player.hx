package muton.ld26.game;
import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Player extends FlxSprite {

	private static inline var WALK_SPEED:Float = 80;
	
	private var facingAnims:IntHash<String>;
	private var attackFunc:FlxPoint->Void;
	
	public function new( x:Float, y:Float, attackFunc:FlxPoint->Void ) {
		super( x, y );
		this.attackFunc = attackFunc;
		
		facingAnims = new IntHash<String>();
		facingAnims.set( FlxObject.LEFT, "left" );
		facingAnims.set( FlxObject.RIGHT, "right" );
		facingAnims.set( FlxObject.UP, "up" );
		facingAnims.set( FlxObject.DOWN, "down" );
		
		loadGraphic( "assets/sprites/globbo.png", true, false, 12, 12 );
		addAnimation( "left", [0, 1, 2, 3, 4, 3, 2, 1], 10, true );
		addAnimation( "right", [0, 1, 2, 3, 4, 3, 2, 1], 10, true );
		addAnimation( "up", [0, 1, 2, 3, 4, 3, 2, 1], 6, true );
		addAnimation( "down", [0, 1, 2, 3, 4, 3, 2, 1], 6, true );
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
		
		if ( ctrl.fireA ) { 
			var attackPt:FlxPoint = new FlxPoint( x + origin.x, y + origin.y );
			switch ( facing ) {
				case FlxObject.LEFT: attackPt.x -= width;
				case FlxObject.RIGHT: attackPt.x += width;
				case FlxObject.UP: attackPt.y -= height;
				case FlxObject.DOWN: attackPt.y += height;
			}
			attackFunc( attackPt );
		}
		
		super.update();
	}
	
}
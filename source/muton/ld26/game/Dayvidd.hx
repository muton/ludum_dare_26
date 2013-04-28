package muton.ld26.game;
import org.flixel.FlxPoint;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Dayvidd extends Enemy {

	private var justRanHere:Bool;
	
	public function new() {
		super();
		whatFx = SFX.DA_WHATS_THAT;
		spotFx = SFX.DA_CLUTTER;
		clutterFx = SFX.DA_CLUTTER;
	}

	override private function setupRoutes():Dynamic {
		super.setupRoutes();
		routes.push( [ Places.diningRoom, Places.entropyCupboard, Places.diningRoom ] );
		routes.push( [ Places.livingRoom, Places.pondSouth ] ) ;
		routes.push( [ Places.bedroom, Places.kitchen, Places.entropyCupboard] );
	}
	
	override public function runTo(pt:FlxPoint):Dynamic {
		if ( super.runTo( pt ) ) {
			justRanHere = true;
		}
	}
	
	override private function moveToNextStage():Void {
		super.moveToNextStage();
		if ( justRanHere ) {
			speak( SFX.DA_STOP_BOTHERING_ME_WOMAN );
			justRanHere = false;
		}
	}
	
	override private function spookBehaviour( level:Int, playerX:Float, playerY:Float ) {
		if ( spookLevel > 50 ) {
			runTo( new FlxPoint( playerX, playerY ) );
			speak( spotFx );
			if ( spookLevel > spotThreshold ) {
				onSpotPlayer( this );
			}
		} else if ( spookLevel > 20 ) {
			waitHere( 3 );
			speak( whatFx );
		}
	}
	
	
	override public function update():Void {
		super.update();
	}
	
}
package muton.ld26.game;
import org.flixel.FlxPoint;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Dayvidd extends Enemy {

	private var justRanHere:Bool;
	private var isAttacking:Bool;

	public function new() {
		super();
		whatFx = SFX.DA_WHATS_THAT;
		spotFx = SFX.DA_CLUTTER;
		clutterFx = SFX.DA_CLUTTER;
		
		leftAnim = [0];
		rightAnim = [4];
		leftMoveAnim = [0,1,2,3];
		rightMoveAnim = [4,5,6,7];
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
		if ( justRanHere && !isAttacking ) {
			speak( SFX.DA_STOP_BOTHERING_ME_WOMAN );
			isAttacking = false;
			justRanHere = false;
		}
	}
	
	override private function spookBehaviour() {
		if ( spookLevel > 50 ) {
			if ( !isAttacking ) {
				isAttacking = true;
				runTo( playerLocationFunc() );
				speak( spotFx );
			}
			if ( spookLevel > spotThreshold ) {
				onSpotPlayer( this );
			}
		} else if ( spookLevel > 20 ) {
			isAttacking = false;
			waitHere( 3 );
			speak( whatFx );
		}
	}
	
	
	override public function update():Void {
		super.update();
		
	}
	
}
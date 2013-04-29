package muton.ld26.game;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Fiyonarr extends Enemy {

	public function new() {
		super();
		whatFx = SFX.FY_WHATS_THAT;
		spotFx = SFX.FY_HELP_DAYVIDD;
		clutterFx = SFX.FY_CLUTTER;
		spotThreshold = 60;
		
		leftAnim = [0];
		rightAnim = [3];
		leftMoveAnim = [0,1,2,0];
		rightMoveAnim = [3,4,5,3];
	}
	
	override private function setupRoutes():Dynamic {
		super.setupRoutes();
		
		routes.push( [ Places.bathroom, Places.bedroom, Places.diningRoom ] );
		routes.push( [ Places.livingRoom, Places.kitchen, Places.garbage ] );
		routes.push( [ Places.pondSouth, Places.spaceShip, Places.entropyCupboard ] );
		routes.push( [ Places.diningRoom, Places.kitchen, Places.diningRoom, Places.kitchen, Places.diningRoom, Places.kitchen ] );
	}
	
	override private function spookBehaviour( level:Int, playerX, playerY ) {
		if ( spookLevel > 20 ) {
			waitHere( 2 );
			if ( spookLevel > spotThreshold ) {
				speak( spotFx );
				onSpotPlayer( this );
			} else {
				speak( whatFx );
			}
		} 
	}
	
	
}
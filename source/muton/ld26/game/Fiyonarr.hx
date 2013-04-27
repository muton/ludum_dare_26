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
	}
	
	override private function setupRoutes():Dynamic {
		super.setupRoutes();
		
		routes.push( [ Places.bathroom, Places.bedroom, Places.diningRoom ] );
		routes.push( [ Places.livingRoom, Places.kitchen, Places.garbage ] );
		routes.push( [ Places.pondSouth, Places.spaceShip, Places.entropyCupboard ] );
		routes.push( [ Places.diningRoom, Places.kitchen, Places.diningRoom, Places.kitchen, Places.diningRoom, Places.kitchen ] );
	}
	
}
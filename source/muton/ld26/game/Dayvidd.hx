package muton.ld26.game;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Dayvidd extends Enemy {

	public function new() {
		super();
	}

	override private function setupRoutes():Dynamic {
		super.setupRoutes();
		routes.push( [ Places.diningRoom, Places.entropyCupboard, Places.diningRoom ] );
		routes.push( [ Places.livingRoom, Places.pondSouth ] ) ;
		routes.push( [ Places.bedroom, Places.kitchen, Places.entropyCupboard] );
	}
	
}
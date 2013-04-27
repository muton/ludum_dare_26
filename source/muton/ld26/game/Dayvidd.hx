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
		routes.push( [ [65, 5], [65, 55], [30, 15] ] );
	}
	
}
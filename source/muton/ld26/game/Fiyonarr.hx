package muton.ld26.game;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Fiyonarr extends Enemy {

	public function new() {
		super();
	}
	
	override private function setupRoutes():Dynamic {
		super.setupRoutes();
		
		routes.push( [ [40, 30], [28, 15], [65, 45] ] );
	}
	
}
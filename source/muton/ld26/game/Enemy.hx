package muton.ld26.game;
import muton.ld26.Config;
import muton.ld26.util.TileMapUtil;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import muton.ld26.Config.EnemyInfo;
import org.flixel.FlxTilemap;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Enemy extends FlxSprite {

	private var normSpeed = 30;
	private var fastSpeed = 45;
	
	public var info:EnemyInfo;

	private var routes:Array<Array<Array<Int>>>;
	private var currentRoute:FlxPath;
	
	private var routeFinderMap:FlxTilemap;
	
	public function new() {
		super( 0, 0 );
	}
	
	private function setupRoutes() {
		currentRoute = null;
		routes = new Array<Array<Array<Int>>>();
	}
	
	public function setRouteFinderMap( routeFinderMap:FlxTilemap ) {
		this.routeFinderMap = routeFinderMap;
	}
	
	public function lookBusy() {
		if ( null != currentRoute ) {
			return;
		}
		currentRoute = Config.routeToPath( routes[0], 9 );
		moveToNextStage();
	}
	
	public function runTo( pt:FlxPoint ) {
		currentRoute = null;
		var path = routeFinderMap.findPath( new FlxPoint( x, y ), pt );
		followPath( path, fastSpeed );
	}
	
	private function moveToNextStage():Void {
		if ( null == currentRoute || currentRoute.nodes.length == 0 ) { 
			trace( "Route finished" );
			return;
		}
		var path = routeFinderMap.findPath( new FlxPoint( x, y ), currentRoute.removeAt( 0 ) );
		followPath( path, normSpeed );
	}
	
	public function setup( info:EnemyInfo ) {
		this.info = info;
		setupRoutes();
		
		loadGraphic( info.spritePath, info.moveAnim.frameList.length > 1, false, info.spriteWidth, info.spriteHeight );
		addAnimation( "move", info.moveAnim.frameList, info.moveAnim.fps, info.moveAnim.loop != false );
		play( "move" );
	}
	
	override public function update():Void {
		super.update();
		
		if ( 0 == pathSpeed ) {
			moveToNextStage();
		}
	}
	
	
	
}
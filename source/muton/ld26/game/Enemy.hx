package muton.ld26.game;
import muton.ld26.Config;
import muton.ld26.util.TileMapUtil;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import muton.ld26.Config.EnemyInfo;
import org.flixel.FlxTilemap;
import org.flixel.plugin.photonstorm.FlxDelay;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Enemy extends FlxSprite {

	private var normSpeed = 50;
	private var fastSpeed = 75;
	
	public var info:EnemyInfo;
	private var onNothingToDo:Enemy->Void;
	
	private var routes:Array<Array<Array<Int>>>;
	private var currentRoute:FlxPath;
	
	private var routeFinderMap:FlxTilemap;
	private var delay:FlxDelay;
	
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
		cancelWait();
		currentRoute = Config.routeToPath( routes[Std.int( FlxG.random() * routes.length )], 9 );
		moveToNextStage();
	}
	
	public function runTo( pt:FlxPoint ) {
		currentRoute = null;
		cancelWait();
		var path = routeFinderMap.findPath( new FlxPoint( x, y ), pt );
		followPath( path, fastSpeed );
	}
	
	private function moveToNextStage():Void {
		trace( info.id + " moveToNextStage() " );
		if ( null == currentRoute || currentRoute.nodes.length == 0 ) { 
			currentRoute = null;
			trace( "Route finished" );
			onNothingToDo( this );
			return;
		}
		var path = routeFinderMap.findPath( new FlxPoint( x, y ), currentRoute.removeAt( 0 ) );
		followPath( path, normSpeed );
	}
	
	public function waitHere( numSecs:Float ):Void {
		trace( info.id + " is waiting here for " + numSecs + " seconds" );
		cancelWait();
		delay = new FlxDelay( Std.int( numSecs * 1000 ) );
		delay.callbackFunction = function() { cancelWait();  onNothingToDo( this ); }
		delay.start();
	}
	
	private function cancelWait():Void {
		if ( null != delay ) { 
			delay.abort();
			delay = null;
		}
	}
	
	public function setup( info:EnemyInfo, onNothingToDo:Enemy->Void ) {
		this.info = info;
		this.onNothingToDo = onNothingToDo;
		cancelWait();
		setupRoutes();
		
		loadGraphic( info.spritePath, info.moveAnim.frameList.length > 1, false, info.spriteWidth, info.spriteHeight );
		addAnimation( "move", info.moveAnim.frameList, info.moveAnim.fps, info.moveAnim.loop != false );
		play( "move" );
	}
	
	override public function update():Void {
		super.update();
		
		if ( null == delay && 0 == pathSpeed ) {
			//currentRoute = null;
			moveToNextStage();
		}
	}
	
	
	
}
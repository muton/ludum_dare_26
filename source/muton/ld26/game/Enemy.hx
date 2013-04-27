package muton.ld26.game;
import muton.ld26.Config;
import muton.ld26.Config.EnemyInfo;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import org.flixel.FlxSound;
import org.flixel.FlxSprite;
import org.flixel.FlxTilemap;
import org.flixel.FlxTimer;
import org.flixel.plugin.photonstorm.FlxDelay;
import org.flixel.plugin.photonstorm.FlxVelocity;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Enemy extends FlxSprite {

	private var normSpeed = 40;
	private var fastSpeed = 65;
	private var spotThreshold = 100;
	
	public var info:EnemyInfo;
	private var onNothingToDo:Enemy->Void;
	private var onSpotPlayer:Enemy->Void;
	
	private var routes:Array<Array<Array<Int>>>;
	private var currentRoute:FlxPath;
	
	private var routeFinderMap:FlxTilemap;
	private var delay:FlxDelay;
	
	private var voice:FlxSound;
	private var lastFxPath:String;
	
	private var currentClutterTarget:Scenery;
	private var dealingWithClutterTimer:FlxTimer;
	private var inARush:Bool;
	
	/** at 100, spots player */
	private var spookLevel:Int = 0;
	
	private var whatFx:String;
	private var spotFx:String;
	private var clutterFx:String;
	
	public function new() {
		super( 0, 0 );
		voice = new FlxSound();
	}
	
	public function speak( fxPath:String ) {
		if ( voice.playing && lastFxPath == fxPath ) {
			return;
		}
		lastFxPath = fxPath;
		voice.stop();
		voice.loadEmbedded( fxPath, false, false );
		voice.play( true );
	}
	
	private function setupRoutes() {
		currentRoute = null;
		routes = new Array<Array<Array<Int>>>();
	}
	
	public function setRouteFinderMap( routeFinderMap:FlxTilemap ) {
		this.routeFinderMap = routeFinderMap;
	}
	
	public function lookBusy() {
		if ( inARush || null != currentRoute ) {
			return;
		}
		cancelWait();
		currentRoute = Config.routeToPath( routes[Std.int( FlxG.random() * routes.length )], 9 );
		moveToNextStage();
	}
	
	public function runTo( pt:FlxPoint ):Bool {
		var path = findTheDamnPath( new FlxPoint( x, y ), pt );
		if ( null != path ) {
			trace( info.id + " running to " + pt.x + "," + pt.y + ", I am at " + x + "," + y ); 
			inARush = true;
			stopTidying();
			currentRoute = null;
			cancelWait();
			followPath( path, fastSpeed );
			return true;
		}
		trace( "couldn't find a way to run to " + pt );
		return false;
	}
	
	public function tidyClutter( clutteredThing:Scenery ):Void {
		if ( !inARush && !isTidying() && !clutteredThing.getBeingTidied() ) {
			
			// find a way to the clutter
			var path = findTheDamnPath( new FlxPoint( x, y ), clutteredThing.tidyLoc );
			if ( null == path ) {
				trace( "Failed to find path to " + (x / 9) + "," + (y / 9) );
				return;
			} 
			trace( info.id + " tidyClutter" );
			
			speak( clutterFx );
			
			currentClutterTarget = clutteredThing;
			clutteredThing.setBeingTidied( true );
			cancelWait();
			stopFollowingPath( true );
			currentRoute = null;
			
			followPath( path, normSpeed );
		}
	}
	
	private function stopTidying():Void {
		if ( isTidying() ) {
			currentClutterTarget.setBeingTidied( false );
		}
		if ( null != dealingWithClutterTimer ) {
			dealingWithClutterTimer.stop();
			dealingWithClutterTimer = null;
		}
	}
	
	public function isTidying():Bool {
		return null != currentClutterTarget;
	}
	
	private function moveToNextStage():Void {
		if ( null == currentRoute || currentRoute.nodes.length == 0 ) { 
			currentRoute = null;
			trace( info.id + " got nothing to do " );
			onNothingToDo( this );
			return;
		}
		var pt = currentRoute.removeAt( 0 );
		var path = findTheDamnPath( new FlxPoint( x, y ), pt );
		if ( path == null ) { 
			trace( info.id + " couldn't get route to " + pt.x + ", " + pt.y );
		} else {
			followPath( path, normSpeed );
		}
	}
	
	/** we'll multiply these and offset our position to try to get a bloody route! */
	private function findTheDamnPath( start:FlxPoint, target:FlxPoint ):FlxPath {
		var offsetsToTry:Array<Array<Int>> = [ [0, 0], [0, -1], [1, 0], [0, 1], [ -1, 0], [ -1, 1], [1, 1], [1, -1], [ -1, -1] ];
		
		var multW = width / 2;
		var multH = height / 2;
		
		for ( offset in offsetsToTry ) {
			var flxPath = routeFinderMap.findPath( new FlxPoint( start.x + offset[0] * multW, start.y + multH * offset[1] ), target );
			if ( null != flxPath ) { 
				return flxPath;
			}
		}
		for ( offset in offsetsToTry ) {
			var flxPath = routeFinderMap.findPath( start, new FlxPoint( target.x + offset[0] * multW, target.y + multH * offset[1] ) );
			if ( null != flxPath ) { 
				return flxPath;
			}
		}
		return null;
	}
	
	public function sawSomething( playerX:Float, playerY:Float ):Void {
		spookLevel += 10;
		trace( info.id + " saw something, spooklevel is " + spookLevel );
		
		if ( spookLevel > 50 ) {
			runTo( new FlxPoint( playerX, playerY ) );
			speak( spotFx );
			if ( spookLevel > spotThreshold ) {
				onSpotPlayer( this );
			}
		} else if ( spookLevel > 20 ) {
			waitHere( 1 );
			speak( whatFx );
		}
	}
	
	public function waitHere( numSecs:Float ):Void {
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
	
	public function setup( info:EnemyInfo, onNothingToDo:Enemy->Void, onSpotPlayer:Enemy->Void ) {
		this.info = info;
		this.onNothingToDo = onNothingToDo;
		this.onSpotPlayer = onSpotPlayer;
		cancelWait();
		setupRoutes();
		
		loadGraphic( info.spritePath, info.moveAnim.frameList.length > 1, false, info.spriteWidth, info.spriteHeight );
		addAnimation( "move", info.moveAnim.frameList, info.moveAnim.fps, info.moveAnim.loop != false );
		play( "move" );
	}
	
	override public function update():Void {
		super.update();
		spookLevel = Std.int( Math.max( 0, spookLevel - 1 ) );
		if ( null != currentClutterTarget ) {
			// we should be on route to clutter
			if ( null == dealingWithClutterTimer && FlxVelocity.distanceToPoint( this, currentClutterTarget.tidyLoc ) < 10 ) {
				trace( info.id + " starting to tidy " + currentClutterTarget.info.id );
				stopFollowingPath( true );
				dealingWithClutterTimer = new FlxTimer();
				dealingWithClutterTimer.start( currentClutterTarget.timeTakenToTidy, 1, function ( t:FlxTimer ) {
					trace( info.id + " finished dealing with clutter on " + currentClutterTarget.info.id );
					currentClutterTarget.setCluttered( false );
					currentClutterTarget.setBeingTidied( false );
					currentClutterTarget = null;
					dealingWithClutterTimer = null;
					onNothingToDo( this );
				} );
			}
		} else if ( null == delay && 0 == pathSpeed ) {
			//currentRoute = null;
			inARush = false;
			moveToNextStage();
		}
	}
	
	
	
}
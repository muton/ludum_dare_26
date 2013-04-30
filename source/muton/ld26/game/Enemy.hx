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
	private var fastSpeed = 70;
	private var agitatedSpeed = 60;
	private var agitated:Bool;
	
	private var spotThreshold = 100;
	
	public var info:EnemyInfo;
	private var onNothingToDo:Enemy->Void;
	private var onSpotPlayer:Enemy->Void;
	private var volFunction:FlxSprite-> Float;
	private var playerLocationFunc:Void->FlxPoint;
	
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
	
	private var leftAnim:Array<Int>;
	private var rightAnim:Array<Int>;
	private var leftMoveAnim:Array<Int>;
	private var rightMoveAnim:Array<Int>;
	
	public function new() {
		super( 0, 0 );
		voice = new FlxSound();
		
		leftAnim = [0];
		rightAnim = [1];
		leftMoveAnim = [0];
		rightMoveAnim = [1];
	}
	
	override public function destroy():Void {
		super.destroy();
		if ( null != voice ) {
			voice.stop();
			voice.destroy();
			voice = null;
		}
		currentRoute = null;
		routes = null;
		routeFinderMap = null;
		if ( null != delay ) {
			delay.abort();
			delay = null;
		}
		onNothingToDo = null;
		playerLocationFunc = null;
		onSpotPlayer = null;
		volFunction = null;
		currentClutterTarget = null;
		if ( dealingWithClutterTimer != null ) {
			dealingWithClutterTimer.stop();
			dealingWithClutterTimer.destroy();
			dealingWithClutterTimer = null;
		}
	}
	
	public function speak( fxPath:String ) {
		if ( voice.playing && lastFxPath == fxPath ) {
			return;
		}
		lastFxPath = fxPath;
		voice.stop();
		voice.loadEmbedded( fxPath, false, false );
		voice.volume = volFunction( this );
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
		trace( info.id + " lookBusy" );
		cancelWait();
		currentRoute = Config.routeToPath( routes[Std.int( FlxG.random() * routes.length )], 9 );
		moveToNextStage();
	}
	
	public function runTo( pt:FlxPoint ):Bool {
		if ( inARush ) { return false; }
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
			
			followPath( path, agitated ? normSpeed : agitatedSpeed );
		}
	}
	
	private function stopTidying():Void {
		trace( info.id + " stopTidying" );
		if ( isTidying() ) {
			currentClutterTarget.setBeingTidied( false );
			currentClutterTarget = null;
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
		trace( info.id + " moveToNextStage" );
		var pt = currentRoute.removeAt( 0 );
		var path = findTheDamnPath( new FlxPoint( x, y ), pt );
		if ( path == null ) { 
			trace( info.id + " couldn't get route to " + pt.x + ", " + pt.y );
		} else {
			followPath( path, agitated ? agitatedSpeed : normSpeed );
		}
	}
	
	/** we'll multiply these and offset our position to try to get a bloody route! */
	private function findTheDamnPath( start:FlxPoint, target:FlxPoint ):FlxPath {
		var offsetsToTry:Array<Array<Int>> = [ [0, 0], [0, -1], [1, 0], [0, 1], [ -1, 0], [ -1, 1], [1, 1], [1, -1], [ -1, -1] ];
		
		var multW = width / 2;
		var multH = height / 2;
		
		for ( offset in offsetsToTry ) {
			var flxPath = routeFinderMap.findPath( new FlxPoint( start.x + offset[0] * multW, start.y + multH * offset[1] ), target, true, false );
			if ( null != flxPath ) { 
				return flxPath;
			}
		}
		for ( offset in offsetsToTry ) {
			var flxPath = routeFinderMap.findPath( start, new FlxPoint( target.x + offset[0] * multW, target.y + multH * offset[1] ), true, false );
			if ( null != flxPath ) { 
				return flxPath;
			}
		}
		return null;
	}
	
	public function sawSomething():Void {
		spookLevel = Std.int( Math.min( 140, spookLevel + 10 ) );
	}
	
	private function spookBehaviour() {
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
	
	public function setup( info:EnemyInfo, onNothingToDo:Enemy->Void, onSpotPlayer:Enemy->Void, volFunction:FlxSprite-> Float,
		playerLocationFunc:Void->FlxPoint ) {

		this.info = info;
		this.onNothingToDo = onNothingToDo;
		this.onSpotPlayer = onSpotPlayer;
		this.volFunction = volFunction;
		this.playerLocationFunc = playerLocationFunc;
		agitated = false;
		
		cancelWait();
		setupRoutes();
		
		loadGraphic( info.spritePath, true, false, info.spriteWidth, info.spriteHeight );
		addAnimation( "left", leftAnim, 6, true );
		addAnimation( "right", rightAnim, 6, true );
		addAnimation( "leftMove", leftMoveAnim, 6, true );
		addAnimation( "rightMove", rightMoveAnim, 6, true );
		play( "left" );
	}
	
	override public function update():Void {
		super.update();
		spookLevel = Std.int( Math.max( 0, spookLevel - 1 ) );
		
		if ( spookLevel > 0 ) {
			spookBehaviour();
		}

		
		if ( null != currentClutterTarget ) {
			// we should be on route to clutter
			if ( null == dealingWithClutterTimer && FlxVelocity.distanceToPoint( this, currentClutterTarget.tidyLoc ) < 10 ) {
				trace( info.id + " starting to tidy " + currentClutterTarget.info.id );
				stopFollowingPath( true );
				dealingWithClutterTimer = new FlxTimer();
				dealingWithClutterTimer.start( currentClutterTarget.timeTakenToTidy, 1, function ( t:FlxTimer ) {
					if ( currentClutterTarget != null ) {
						trace( info.id + " finished dealing with clutter on " + currentClutterTarget.info.id );
						currentClutterTarget.setCluttered( false );
						currentClutterTarget.setBeingTidied( false );
					}
					currentClutterTarget = null;
					dealingWithClutterTimer = null;
					if ( onNothingToDo != null ) {
						onNothingToDo( this );
					}
				} );
			}
		} else if ( null == delay && 0 == pathSpeed ) {
			//currentRoute = null;
			inARush = false;
			moveToNextStage();
		}
		
		if ( velocity.x > 0 ) {
			play( "rightMove" );
		} else if ( velocity.x < 0 ) {
			play( "leftMove" );
		} else if ( velocity.x == 0 && velocity.y == 0 ) {
			play( curAnim == "rightMove" ? "right" : "left" );
		}
	}
	
}
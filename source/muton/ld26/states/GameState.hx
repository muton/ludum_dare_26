package muton.ld26.states;

import muton.ld26.CaptionPlayer;
import muton.ld26.Config;
import muton.ld26.CutScenePlayer;
import muton.ld26.game.Collectible;
import muton.ld26.game.Dayvidd;
import muton.ld26.game.Enemy;
import muton.ld26.game.Fiyonarr;
import muton.ld26.game.Places;
import muton.ld26.game.Player;
import muton.ld26.game.Scenery;
import muton.ld26.game.SFX;
import muton.ld26.game.StatusDisplay;
import muton.ld26.game.TouchUI;
import muton.ld26.util.TileMapUtil;
import nme.Assets;
import nme.display.BitmapData;
import nme.events.Event;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxSound;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxTilemap;
import org.flixel.FlxTypedGroup;
import org.flixel.FlxU;
import org.flixel.plugin.photonstorm.FlxCollision;
import org.flixel.plugin.photonstorm.FlxDelay;
import org.flixel.plugin.photonstorm.FlxVelocity;

class GameState extends FlxState {
	
	private static inline var TILE_WIDTH:Int = 9;
	private static inline var TILE_HEIGHT:Int = 9;
	
	public static inline var CAUGHT_RADIUS:Int = 150;
	public static inline var EYE_ANGLE:Float = 160;
	
	private var count:Int;
	private var livesLeft:Int;
	
	private var conf:Config;
	private var captions:CaptionPlayer;
	private var cutScenes:CutScenePlayer;
	
	private var curLevel:LevelInfo;
	
	private var floor:FlxTilemap;
	private var collisionMap:FlxTilemap;
	private var wallMap:FlxTilemap;
	
	private var collectibles:FlxTypedGroup<Collectible>;
	private var scenery:FlxTypedGroup<Scenery>;
	private var enemies:FlxTypedGroup<Enemy>;
	private var player:Player;
	private var dayvidd:Dayvidd;
	private var fiyonarr:Fiyonarr;
	private var overlay:FlxTypedGroup<FlxGroup>;
	private var statusDisplay:StatusDisplay;
	
	private var hiFi:Scenery;
	
	private var lastFloorTileX:Int;
	private var lastFloorTileY:Int;
	private var alreadyDying:Bool;
	
	override public function create():Void {
		super.create();

		FlxG.mouse.hide();
		FlxG.bgColor = 0xFF707070;
		
		conf = new Config( "assets/conf/config.json" );
		
		floor = new FlxTilemap();
		add( floor );
		
		collisionMap = new FlxTilemap();
		add( collisionMap );
		
		wallMap = new FlxTilemap();
		add( wallMap );
		
		scenery = new FlxTypedGroup<Scenery>( 30 );
		add( scenery);
		
		collectibles = new FlxTypedGroup<Collectible>( 20 );
		add( collectibles );
		
		enemies = new FlxTypedGroup<Enemy>( 2 );
		add( enemies );
		
		player = new Player( 0, 0, playerInteract, playerCheck );
		add( player );
		
		overlay = new FlxTypedGroup<FlxGroup>( 10 );
		add( overlay );
		
		captions = new CaptionPlayer( overlay );
		
		cutScenes = new CutScenePlayer( overlay );
		cutScenes.addEventListener( Event.COMPLETE, onCutSceneComplete, false, 0, true );
		
		statusDisplay = new StatusDisplay();
		add( statusDisplay );
		
#if mobile		
		add( new TouchUI( false ) );
#end		

		//FlxG.camera.setBounds( 0, 0, map.width, map.height, true );
		FlxG.camera.follow( player, FlxCamera.STYLE_TOPDOWN_TIGHT, null, 3 );
		
		curLevel = conf.levels[0];
		
		livesLeft = 3;
		
		resetLevel();
		
		captions.play( conf.capSequences.get( "intro" ) );
	}
	
	override public function destroy():Void {
		super.destroy();
		
		if ( null != FlxG.music ) {
			FlxG.music.stop();
			FlxG.music.kill();
		}
		
		if ( null != dayvidd ) {
			dayvidd.destroy();
			dayvidd = null;
		}
		if ( null != fiyonarr ) {
			fiyonarr.destroy();
			fiyonarr = null;
		}
		if ( null != player ) {
			player.destroy();
			player = null;
		}
		hiFi = null;
		floor = null;
		collisionMap = null;
		wallMap = null;
		scenery = null;
		collectibles = null;
		enemies = null;
		overlay = null;
		captions = null;
		if ( null != cutScenes ) {
			cutScenes.removeEventListener( Event.COMPLETE, onCutSceneComplete );
			cutScenes = null;
		}
		statusDisplay = null;
	}
	
	private function resetLevel() {
		
		if ( null == FlxG.music ) {
			FlxG.music = new FlxSound();
		}
		FlxG.music.loadStream( "soundtrack.mp3", true, true );
		FlxG.music.volume = 1;
		FlxG.music.play();		
		
		wallMap.loadMap( 
			TileMapUtil.bmpToTileMapAlphaBinary( Assets.getBitmapData( "assets/conf/mapdata_walls.png" ) ), 
			Assets.getBitmapData( "assets/tiles/autotiles_9x9_walls.png" ),
			9, 9, 0 );
		wallMap.follow( null, -10, true );	// causes camera bounds to be set too
		
		collisionMap.widthInTiles = wallMap.widthInTiles;
		collisionMap.heightInTiles = wallMap.heightInTiles;
		var blankArr = new Array<Int>();
		for ( i in 0...wallMap.totalTiles ) { blankArr.push( wallMap.getTileByIndex( i ) == 0 ? 0 : 1 ); }
		var bmpd:BitmapData = new BitmapData( TILE_WIDTH * 2, TILE_HEIGHT, true, 0xff000000 );
		collisionMap.loadMap( blankArr, bmpd, TILE_WIDTH, TILE_HEIGHT );
		
		//var colours = [0xffffff, 0x999999, 0xcccccc, 0x8888ff, 0xff8888];	// these are correct but it thinks they aren't
		var colours = [0xFEFEFE, 0x989898, 0xCBCBCB, 0x8787FE, 0xFE8787];	// so screw it
		floor.loadMap(
			TileMapUtil.bmpToTileMapColourIndices( Assets.getBitmapData( "assets/conf/mapdata_floor.png", false ), colours ), 
			Assets.getBitmapData( "assets/tiles/floor_tiles_9x9.png" ),
			TILE_WIDTH, TILE_HEIGHT, 0, 0, 0, 0 );
			
			
		// make the world bigger so tilemap collisions work, but camera doesn't stop at edge of play area
		//FlxG.worldBounds.copyFrom( new FlxRect( -100, -100, map.width + 100, map.height + 100 ) );
		
		Lambda.iter( scenery.members, iter_unexistSprite );
		
		for ( scp in conf.sceneryPlaces ) { 
			var inf = conf.scenery.get( scp.id );
			var chunk = scenery.recycle( Scenery );
			chunk.setup( inf, Config.tileCoordToPoint( scp.tidyLoc ) );
			chunk.x = scp.loc[0] * TILE_WIDTH;
			chunk.y = scp.loc[1] * TILE_HEIGHT;
			chunk.exists = true;
			for ( y in 0...inf.heightTiles ) {
				for ( x in 0...inf.widthTiles ) {
					collisionMap.setTile( scp.loc[0] + x, scp.loc[1] + y, 1, false );
				}
			}
			if ( inf.id == "hi_fi" ) {
				hiFi = chunk;
			}
		}
		
		//Lambda.iter( collectibles.members, iter_unexistSprite );
		//
		//for ( itm in curLevel.items ) {
			//var coll = collectibles.recycle( Collectible );
			//coll.setup( conf.collectibles.get( itm.id ) );
			//coll.x = itm.x;
			//coll.y = itm.y;
			//coll.exists = true;
			//coll.alive = true;
		//}
		
		Lambda.iter( enemies.members, iter_unexistSprite );
		enemies.callAll( "kill" );
		enemies.callAll( "destroy" );
		enemies.clear();
		
		for ( en in curLevel.enemies ) {
			var enemy:Enemy = null;
			if ( en.id=="dayvidd" ) {
				dayvidd = new Dayvidd();
				enemy = dayvidd;
			} else if ( en.id=="fiyonarr" ) {
				fiyonarr = new Fiyonarr();
				enemy = fiyonarr;
			}
			enemies.add( enemy );
			enemy.setRouteFinderMap( collisionMap );
			enemy.setup( conf.enemies.get( en.id ), onEnemyHasNothingToDo, onEnemySpottedPlayer, getVolForDistance, playerLocation );
			enemy.active = true;
			enemy.exists = true;
			enemy.alive = true;
			enemy.x = en.x;
			enemy.y = en.y;
			//enemy.followPath( Config.routeToPath( en.route ), 100, FlxObject.PATH_LOOP_BACKWARD );
			enemy.lookBusy();
		}
		
		trace( "just reset level, enemies members length is " + enemies.length );
		
		player.x = TILE_WIDTH * curLevel.startTile[0];
		player.y = TILE_HEIGHT * curLevel.startTile[1];
		
		statusDisplay.setLivesLeft( livesLeft );
		
		testRoutesToAllLocations();
	}
	
	private function playCutScene( sceneId:String ) {
		cutScenes.play( conf.cutScenes.get( sceneId ) );
		FlxG.timeScale = 0.001;
	}
	
	private function onCutSceneComplete( ev:Event ) {
		FlxG.timeScale = 1;
	}
	
	override public function update():Void {
		super.update();
		
		captions.update();
		FlxG.collide( player, collisionMap );
		
		//updateFloorLighting();
		
		FlxG.collide( player, collectibles, collide_collectItem );
		FlxG.collide( player, enemies, collide_hitEnemy );
		
		//Lambda.iter( enemies.members, iter_adjustSpriteBrightness );
		
		switch ( count++ % 3 ) {
			case 0: Lambda.iter( enemies.members, iter_canSeePlayer );
			case 1: 
				refreshDisorderScore();
				FlxG.music.volume = getVolForDistance( hiFi );
			case 2: Lambda.iter( enemies.members, iter_canSeeClutter );
		}
		
	}	
		
	//private function updateFloorLighting():Void {
		//var curTileX = Std.int( player.x / TILE_WIDTH );
		//var curTileY = Std.int( player.y / TILE_HEIGHT );
		//
		//if ( lastFloorTileX == curTileX && lastFloorTileY == curTileY ) { 
			//return;
		//}
		//
		//lastFloorTileX = curTileX;
		//lastFloorTileY = curTileY;
		//
		//for ( x in Std.int( Math.max( curTileX - 11, 0 ) )...Std.int( Math.min( curTileX + 12, floor.widthInTiles  ) ) ) {
			//for ( y in Std.int( Math.max( curTileY - 11, 0 ) )...Std.int( Math.min( curTileY + 12, floor.heightInTiles ) ) ) {
				//var dist = Math.sqrt( Math.pow( curTileX - x, 2 ) + Math.pow( curTileY - y, 2 ) );
				//var tileNum = Std.int( Math.ceil( 6 - Math.min( 6, dist ) ) );
				//floor.setTile( x, y, 
					//map.ray( new FlxPoint( player.x, player.y ), 
					//new FlxPoint( x * TILE_WIDTH + 8, y * TILE_HEIGHT + 8), null, 2 ) ? tileNum : 0, true );
			//}
		//}
		//Lambda.iter( collectibles.members, iter_adjustSpriteBrightness );
	//}
	
	private function playerInteract( hitPt:FlxPoint ) {
		Lambda.iter( scenery.members, function( sc:Scenery ) {
			if ( sc.exists && sc.info.interactive 
				&& sc.overlapsPoint( hitPt ) ) {
				sc.setCluttered( true );
			}
		} );
	}
	
	private function playerCheck( hitPt:FlxPoint ) {
		for ( sc in scenery.members ) {
			if ( sc.exists && sc.info.interactive && !sc.getCluttered() && sc.overlapsPoint( hitPt ) ) {
				return true;
			}
		}
		return false;
	}	
	
	private function playerLocation():FlxPoint {
		return new FlxPoint( player.x + player.origin.x, player.y + player.origin.y );
	}	
	
	private function onEnemyHasNothingToDo( en:Enemy ) {
		if ( FlxG.random() > 0.3 ) { 
			en.waitHere( 2 );
		} else {
			en.lookBusy();
		}
	}
	
	private function onEnemySpottedPlayer( en:Enemy ) {
		if ( en == fiyonarr ) {
			dayvidd.runTo( new FlxPoint( fiyonarr.x, fiyonarr.y ) );
		} else if ( en == dayvidd ) {
			playerKilled();
		}
	}
	
	private function playerKilled() {
		if ( alreadyDying ) { 
			return;
		}
		alreadyDying = true;
		livesLeft--;
		trace( "player killed! " + livesLeft + " lives left" );
		FlxG.timeScale = 0.5;
		FlxG.camera.color = 0x55ff6666;
		FlxG.play( SFX.FX_ZAP );
		var delay = new FlxDelay( 1000 );
		delay.callbackFunction = function() { 
			alreadyDying = false;
			FlxG.timeScale = 1;
			FlxG.camera.color = 0x00ffffff;
			if ( livesLeft >= 0 ) {
				resetLevel();
			} else {
				FlxG.music.stop();
				FlxG.switchState( new LoseState() );
			}
		}
		delay.start();
	}
	
	private function refreshDisorderScore() {
		var disorder = 0;
		for ( scn in scenery.members ) {
			if ( scn.exists && scn.info.interactive && scn.getCluttered() ) {
				disorder += scn.info.clutterVal;
			}
		}
		statusDisplay.setDisorderLevel( disorder );
		
		if ( disorder >= 100 ) {
			FlxG.music.stop();
			FlxG.switchState( new WinState() );
		}
	}
	
	//private function iter_adjustSpriteBrightness( coll:FlxSprite ) {
		//if ( coll.exists ) {
			//var factor:Int = Std.int( 0xff * floor.getTile( Std.int( coll.x / 16 ), Std.int( coll.y / 16 ) ) / 7 );
			//coll.color = 0xff << 25 | factor << 16 | factor << 8 | factor << 0;
		//}
	//}
	
	private function iter_unexistSprite( spr:FlxSprite ) {
		spr.exists = false;
	}
	
	private function iter_canSeePlayer( enemy:Enemy ) {
		if ( enemyCanSee( enemy, player ) ) {
			enemy.sawSomething();
		}
	}
	
	private function iter_canSeeClutter( enemy:Enemy ) {
		// don't look for more clutter if we're already charging towards some
		if ( enemy.isTidying() ) { return; }
		
		for ( sc in scenery.members ) {
			if ( sc.exists && sc.getCluttered() && enemyCanSee( enemy, sc ) ) {
				enemy.tidyClutter( sc );
				break;
			}
		}
	}
	
	private function collide_collectItem( objPlayer:FlxObject, objCollectible:FlxObject ) {
		objCollectible.exists = false;
		playCutScene( "demo" );
	}
	
	private function collide_hitEnemy( objPlayer:FlxObject, objEnemy:FlxObject ) {
		playerKilled();
	}
	
	private function enemyCanSee( enemy:Enemy, sprite:FlxSprite ):Bool {
		if ( FlxVelocity.distanceBetween( sprite, enemy ) <= CAUGHT_RADIUS ) {
			if ( wallMap.ray( new FlxPoint( enemy.x + enemy.origin.x, enemy.y + enemy.origin.y ),
				new FlxPoint( sprite.x + sprite.origin.x, sprite.y + sprite.origin.y ) ) ) {
				
				var directionFacing = Util.clampAngle( enemy.pathAngle );
				var directionOfSprite = Util.clampAngle( FlxVelocity.angleBetween( enemy, sprite, true ) + 90 );
				
				if ( Util.angleDifference( directionFacing, directionOfSprite ) < EYE_ANGLE / 2 ) {
					return true;
				}
			}
		}
		return false;
	}
	
	private function getVolForDistance( noisyThing:FlxSprite ):Float {
		var dist = FlxVelocity.distanceBetween( player, noisyThing );
		return 0.1 + 0.9 * ( 650 - dist ) / 650; //650 is roughly max dist
	}
	
	private function testRoutesToAllLocations() {
	
		var locations:Array<FlxPoint> = new Array();
		
		var namedplaces = Type.getClassFields( Places );
		for ( place in namedplaces ) {
			locations.push( Config.tileCoordToPoint( Reflect.field( Places, place ) ) );
		}
		
		for ( sp in conf.sceneryPlaces ) {
			var tl = sp.tidyLoc;
			if ( null != tl ) {
				locations.push( Config.tileCoordToPoint( tl ) );
			}
		}
		
		var dayvPt = new FlxPoint( dayvidd.x, dayvidd.y );
		var fiyPt = new FlxPoint( fiyonarr.x, fiyonarr.y );
		
		for ( fp in locations ) {
			var pathDayvidd = collisionMap.findPath( dayvPt, fp );
			var pathFiyonarr = collisionMap.findPath( fiyPt, fp );
			
			if ( null == pathDayvidd ) {
				trace( "NO PATH FOUND FOR DAYVIDD TO " + (fp.x / TILE_WIDTH) + "," + (fp.y / TILE_HEIGHT) );
			}
			if ( null == pathFiyonarr ) {
				trace( "NO PATH FOUND FOR FIYONAR TO " + (fp.x / TILE_WIDTH) + "," + (fp.y / TILE_HEIGHT) );
			}
		}
	}
}


class Util {
	
	public static inline function clampAngle( angle:Float ):Float {
		return ( angle % 360 ) + ( angle < 0 ? 360 : 0 );		
	}
	
	public static inline function angleDifference( angleA:Float, angleB:Float ):Float {
		var difference = angleB - angleA;
        while ( difference < -180 ) { difference += 360; }
        while ( difference > 180 ) { difference -= 360; }
        return Math.abs( difference );	
	}
}
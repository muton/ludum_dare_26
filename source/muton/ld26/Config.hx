package muton.ld26;
import haxe.Int32;
import haxe.Json;
import nme.Assets;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;

/**
 * ...
 * @author tim@muton.co.uk
 */

typedef GameConf = {
	enemies:Array<EnemyInfo>,
	levels:Array<LevelInfo>,
	collectibles:Array<CollectibleInfo>,
	capSequences:Array<CaptionSequence>,
	cutScenes:Array<CutScene>,
	sceneryPlaces:Array<SceneryPlace>
}

typedef AnimInfo = {
	frameList:Array<Int>,
	fps:Float,
	?loop:Bool
}

typedef EnemyInfo = {
	id:String,
	health:Float,
	mass:Float,
	spritePath:String,
	spriteWidth:Int,
	spriteHeight:Int,
	moveAnim:AnimInfo,
	deadFrame:Int
}

typedef LevelInfo = {
	id:String,
	mapPath:String,
	startTile:Array<Int>,
	items:Array<ItemPosition>,
	enemies:Array<EnemyPosition>
}

typedef CollectibleInfo = {
	id:String,
	spritePath:String,
	spriteWidth:Int,
	spriteHeight:Int,
	anim:AnimInfo
}

typedef ItemPosition = {
	id:String,
	x:Int,
	y:Int
}

typedef EnemyPosition = { > ItemPosition,
	route:Array<Array<Int>>
}

typedef Caption = {
	label:String,
	?time:Int,
	duration:Int,
	?placeId:String
}

typedef CaptionPlacement = { 
	id:String,
	x:Int,
	y:Int,
	width:Int,
	color:String,
	?fromRight:Bool,
	?fromBottom:Bool,
}

typedef CaptionSequence = {
	id:String,
	placements:Array<CaptionPlacement>,
	timeline:Array<Caption>
}

typedef CutScene = {
	id:String,
	timeline:Array<CutSceneFrame>
}

typedef CutSceneFrame = {
	duration:Int,
	imagePath:String,
	captions:Array<Caption>
}

typedef SceneryInfo = {
	id:String,
	assetPath:String,
	widthTiles:Int,
	heightTiles:Int,
	interactive:Bool,
	clutterVal:Int
}

typedef SceneryPlace = {
	id:String,
	loc:Array<Int>,
	?tidyLoc:Array<Int>
}

class Config {

	public var enemies:Hash<EnemyInfo>;
	public var levels:Array<LevelInfo>;
	public var collectibles:Hash<CollectibleInfo>;
	public var capSequences:Hash<CaptionSequence>;
	public var cutScenes:Hash<CutScene>;
	public var scenery:Hash<SceneryInfo>;
	public var sceneryPlaces:Array<SceneryPlace>;
	
	public function new( path:String ) {
		var conf:GameConf = Json.parse( Assets.getText( path ) );
		
		enemies = new Hash<EnemyInfo>(); 
		for ( ei in conf.enemies ) {
			enemies.set( ei.id, ei );
		}
		
		collectibles = new Hash<CollectibleInfo>();
		for ( ci in conf.collectibles ) {
			collectibles.set( ci.id, ci );
		}
		
		capSequences = new Hash<CaptionSequence>();
		for ( cs in conf.capSequences ) {
			capSequences.set( cs.id, cs );
		}
		
		cutScenes = new Hash<CutScene>();
		for ( cut in conf.cutScenes ) {
			cutScenes.set( cut.id, cut );
		}
		
		sceneryPlaces = conf.sceneryPlaces;
		levels = conf.levels;
		
		genScenery();
	}
	
	public static function routeToPath( route:Array<Array<Int>>, multiplicationFactor:Float = 1 ):FlxPath {
		var path = new FlxPath();
		for ( coord in route ) {
			path.add( coord[0] * multiplicationFactor, coord[1] * multiplicationFactor );
		}
		return path;
	}
	
	public static function tileCoordToPoint( tileCoord:Array<Int> ):FlxPoint {
		if ( null == tileCoord || tileCoord.length != 2 ) { 
			return null; 
		}
		return new FlxPoint( tileCoord[0] * 9, tileCoord[1] * 9 );
	}
	
	private function genScenery():Void {
		var colour = 0xFFF0F0F0;
		scenery = new Hash<SceneryInfo>();
		var itemList = [
			["spaceship", "4x13", "spaceship.png"],
			["pond", "5x45", "pond.png"],
			["outdoor_seat", "3x3", "outdoor_seat.png"],
			["bench", "15x4", "bench.png"],
			["dining_table", "6x14", "dining_table.png"],
			["dining_chair", "2x3", "dining_chair.png"],
			["kitchen_unit_h", "10x5", "kitchen_unit_h.png"],
			["kitchen_unit_v", "4x20", "kitchen_unit_v.png"],
			["shower", "13x5", "shower.png"],
			["dustbin", "3x3", "dustbin_sheet.png", "y", "7"],	// knock it over
			["toilet", "3x2", "toilet_sheet.png", "y", "10"],	// block it
			["basin", "2x3", "basin_sheet.png", "y", "8"],  // rearrange toiletries
			["bed", "15x10", "bed_sheet.png", "y", "9"], // unmake
			["entropy_stack", "4x4", "entropy_stack_sheet.png", "y", "7"], //special
			["kitchen_sink", "4x5", "sink_sheet.png", "y", "7"], // fill with pots and pans
			["hi_fi", "3x3", "hi_fi_sheet.png", "y", "12"], // change the music
			["bin", "2x2", "bin_sheet.png", "y", "6"] // tip
//			["dish_washer", "2x5", "", "y", "10"], // sabotage - skip it for now
		];
		
		for ( arr in itemList ) {
			var dim:Array<String> = arr[1].split( "x" );
			var scn:SceneryInfo = { "id":arr[0], "widthTiles":Std.parseInt( dim[0] ), "heightTiles":Std.parseInt( dim[1] ),
				"assetPath": arr[2] == "" ? "" : "assets/scenery/" + arr[2],
				"interactive": arr.length > 3 && arr[3] == "y", "clutterVal": Std.parseInt( arr.length > 4 ? arr[4] : "0" ) };
			//trace( "info: " + scn );
			scenery.set( scn.id, scn );
		}
	}
}
package muton.ld26;
import haxe.Int32;
import haxe.Json;
import nme.Assets;
import org.flixel.FlxPath;

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
	widthTiles:Int,
	heightTiles:Int,
	interactive:Bool
}

typedef SceneryPlace = {
	id:String,
	loc:Array<Int>
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
	
	private function genScenery():Void {
		var colour = 0xFFF0F0F0;
		scenery = new Hash<SceneryInfo>();
		var itemList = [
			["dustbin", "3x3", "y"],	// knock it over
			["spaceship", "4x13"],
			["pond", "5x45"],
			["outdoor_seat", "3x3"],
			["bench", "15x4"],
			["dining_table", "6x14"],
			["dining_chair", "2x3"],
			["kitchen_unit_h", "10x5"],
			["kitchen_unit_v", "4x20"],
			["toilet", "3x2", "y"],	// block it
			["shower", "13x5"],
			["basin", "3x2", "y"],  // rearrange toiletries
			["bed", "15x10", "y"], // unmake
			["entropy_stack", "4x4", "y"], //special
			["kitchen_sink", "4x5", "y"], // fill with pots and pans
			["hi_fi", "3x3", "y"], // change the music
			["dish_washer", "1x5", "y"], // sabotage
			["bin", "2x2", "y"] // tip
		];
		
		for ( arr in itemList ) {
			var dim:Array<String> = arr[1].split( "x" );
			var scn:SceneryInfo = { "id":arr[0], "widthTiles":Std.parseInt( dim[0] ), "heightTiles":Std.parseInt( dim[1] ),
				"interactive": arr.length > 2 && arr[2] == "y" };
			scenery.set( scn.id, scn );
		}
	}
}
package muton.ld26;
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
	cutScenes:Array<CutScene>
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

class Config {

	public var enemies:Hash<EnemyInfo>;
	public var levels:Array<LevelInfo>;
	public var collectibles:Hash<CollectibleInfo>;
	public var capSequences:Hash<CaptionSequence>;
	public var cutScenes:Hash<CutScene>;
	
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
		
		levels = conf.levels;
	}
	
	public static function routeToPath( route:Array<Array<Int>> ):FlxPath {
		var path = new FlxPath();
		for ( coord in route ) {
			path.add( coord[0], coord[1] );
		}
		return path;
	}
}
package muton.ld26.game;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import muton.ld26.Config.SceneryInfo;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Scenery extends FlxSprite {

	public var info:SceneryInfo;
	
	private var cluttered:Bool;
	private var beingTidied:Bool;
	public var tidyLoc:FlxPoint;
	public var timeTakenToTidy:Float = 8;
	
	public function new() {
		super( 0, 0 );
	}
	
	public function setup( info:SceneryInfo, tidyLoc:FlxPoint ) {
		this.info = info;
		this.tidyLoc = tidyLoc;
		//loadGraphic( info.spritePath, info.anim.frameList.length > 1, false, info.spriteWidth, info.spriteHeight );
		//addAnimation( "default", info.anim.frameList, info.anim.fps, info.anim.loop != false );
		//play( "default" );
		setCluttered( false );
	}
	
	public function getCluttered():Bool {
		return cluttered;
	}
	
	public function setCluttered( cluttered:Bool ) {
		this.cluttered = cluttered;
		var colour = info.interactive ? 0xFFFFFF80 : 0xFFAEAEAE;
		makeGraphic( info.widthTiles * 9, info.heightTiles * 9, cluttered ? 0xFFFF0000 : colour );
	}
	
	public function getBeingTidied():Bool {
		return beingTidied;
	}
	
	public function setBeingTidied( beingTidied:Bool ):Void {
		this.beingTidied = beingTidied;
	}
	
	override public function update():Void {
		super.update();
	}
	
}
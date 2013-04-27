package muton.ld26.game;
import org.flixel.FlxSprite;
import muton.ld26.Config.SceneryInfo;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Scenery extends FlxSprite {

	public var info:SceneryInfo;
	
	private var cluttered:Bool;
	
	public function new() {
		super( 0, 0 );
	}
	
	public function setup( info:SceneryInfo ) {
		this.info = info;
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
		makeGraphic( info.widthTiles * 9, info.heightTiles * 9, cluttered ? 0xFFFF0000 : 0xFFF0F0F0 );
	}
	
	override public function update():Void {
		super.update();
	}
	
}
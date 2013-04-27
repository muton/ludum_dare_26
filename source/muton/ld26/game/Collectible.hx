package muton.ld26.game;
import org.flixel.FlxSprite;
import muton.ld26.Config.CollectibleInfo;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Collectible extends FlxSprite {

	public var info:CollectibleInfo;
	
	public function new() {
		super( 0, 0 );
	}
	
	public function setup( info:CollectibleInfo ) {
		this.info = info;
		
		loadGraphic( info.spritePath, info.anim.frameList.length > 1, false, info.spriteWidth, info.spriteHeight );
		addAnimation( "default", info.anim.frameList, info.anim.fps, info.anim.loop != false );
		play( "default" );
	}
	
	override public function update():Void {
		super.update();
	}
	
}
package muton.ld26.game;
import org.flixel.FlxSprite;
import muton.ld26.Config.EnemyInfo;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Enemy extends FlxSprite {

	public var info:EnemyInfo;

	public function new() {
		super( 0, 0 );
	}
	
	public function setup( info:EnemyInfo ) {
		this.info = info;
		
		loadGraphic( info.spritePath, info.moveAnim.frameList.length > 1, false, info.spriteWidth, info.spriteHeight );
		addAnimation( "move", info.moveAnim.frameList, info.moveAnim.fps, info.moveAnim.loop != false );
		play( "move" );
	}	
	
}
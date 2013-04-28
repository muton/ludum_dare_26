package muton.ld26.game;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSound;
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
		if ( info.assetPath != "" ) {
			loadImages();
		}
		setCluttered( false );
	}
	
	public function loadImages() {
		if ( !info.interactive ) {
			loadGraphic( info.assetPath );
		} else {
			loadGraphic( info.assetPath, true, false, info.widthTiles * 9, info.heightTiles * 9 );
			addAnimation( "uncluttered", [0], 1 );
			addAnimation( "cluttered", [1], 1 );
		}
	}
	
	public function getCluttered():Bool {
		return cluttered;
	}
	
	public function setCluttered( cluttered:Bool ) {
		var statusChanged:Bool = this.cluttered != cluttered;
		this.cluttered = cluttered;
		if ( info.assetPath == "" ) {
			var colour = info.interactive ? 0xFFFFFF80 : 0xFFAEAEAE;
			makeGraphic( info.widthTiles * 9, info.heightTiles * 9, cluttered ? 0xFFFF0000 : colour );
		} else {
			play( cluttered ? "cluttered" : "uncluttered" );
		}
		
		if ( statusChanged && info.id == "hi_fi" ) {
			FlxG.music.stop();
			FlxG.music = new FlxSound();
			FlxG.music.loadStream( cluttered ? "cacophony.mp3" : "soundtrack.mp3", true, true );
			FlxG.music.volume = 1;
			FlxG.music.survive = true;
			FlxG.music.play();
		}
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
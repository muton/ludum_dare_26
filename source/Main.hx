package;

import muton.ld26.ProjectClass;
import muton.ld26.util.Lighting;
import muton.nme.Tweaks;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.Lib;
import nme.ui.Keyboard;
import org.flixel.FlxGame;
import org.flixel.FlxSprite;

class Main extends Sprite {
	
	public function new () {
		super();
		
		if (stage != null) {
			init();
		} else {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
	
	private function init( ?e:Event = null ):Void {
		
		if ( hasEventListener(Event.ADDED_TO_STAGE) ) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		initialize();
		
		var demo:FlxGame = new ProjectClass();
		addChild( demo );
		//var floorTile = Assets.getBitmapData( "assets/tiles/floor_tile_16x16.png" );
		//var bmpd = Lighting.genLightMapTileSet( 10, 16, 16, 0.65, floorTile );
		//addChild( new Bitmap( bmpd ) );
		
#if (cpp || neko)
		Lib.current.stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUP );
#end
	}
	
#if (cpp || neko)
	private function onKeyUP( e:KeyboardEvent ):Void {
		if ( e.keyCode == Keyboard.ESCAPE ) {
			Lib.exit();
		}
	}
#end
	
	private function initialize():Void {
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
	}
	
	// Entry point
	public static function main() {
		Tweaks.redirectTrace();
		Lib.current.addChild( new Main() );
	}
	
}
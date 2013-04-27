package muton.ld26.util;
import haxe.Timer;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxText;

/**
 * ...
 * @author tim@muton.co.uk
 */

class TextUtil {

	
	public static inline function genCaption( label:String, color:Int, x:Float, y:Float, w:Int, 
		fromRight:Bool = false, fromBottom:Bool = false, numSecs:Int = -1 ):FlxGroup {
		
		x = fromRight ? FlxG.width - w - x : x;	
			
		var group = new FlxGroup( 3 );
		
		var txt = new FlxText( x + 2, y + 2, w - 4, label, 10, true, true );
		txt.color = 0xffffff; 
		
		var border = new FlxSprite( x, y );
		border.makeGraphic( w, Std.int( txt.height ) + 4, 0xffffffff );
		
		var bg = new FlxSprite( x + 1, y + 1 );
		bg.makeGraphic( w - 2, Std.int( txt.height ) + 2, color + ( 0xff << 24 ) );
		
		if ( fromBottom ) {
			border.y = FlxG.height - border.height - border.y;
			bg.y = border.y + 1;
			txt.y = bg.y + 1;
		}
		
		group.add( border );
		group.add( bg );
		group.add( txt );
		
		noScroll( [border, bg, txt] );
		
		if ( numSecs > -1 ) {
			Timer.delay( group.kill, numSecs * 1000 );
		}
		
		return group;
	}
	
	public static inline function noScroll( sprites:Array<FlxSprite> ) {
		for ( sp in sprites ) {
			sp.scrollFactor.x = 0;
			sp.scrollFactor.y = 0;
			sp.active = false;
		}
	}
}
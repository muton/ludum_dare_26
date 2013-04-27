package muton.ld26.util;
import nme.display.BitmapData;
import nme.display.BlendMode;
import nme.display.GradientType;
import nme.display.Sprite;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;

/**
 * ...
 * @author tim@muton.co.uk
 */

class Lighting {

	private static var bgFill:BitmapData;
	private static var circSpriteCache:IntHash<Sprite>;

	public static inline function redrawBg( bg:FlxSprite, lightSources:Array<FlxPoint>, width:Float, height:Float ) {
		var flxScale = FlxG.camera.zoom;
		var radius:Float = 60 * flxScale;
		
		if ( null == bgFill ) {
			bgFill = new BitmapData( 4, 4, false, 0xFF100500 );
			bgFill.setPixel( 0, 0, 0xFF000000 );
			bgFill.setPixel( 1, 0, 0xFF000000 );
			bgFill.setPixel( 2, 0, 0xFF000000 );
			bgFill.setPixel( 3, 0, 0xFF000000 );
			bgFill.setPixel( 0, 1, 0xFF000000 );
			bgFill.setPixel( 0, 2, 0xFF000000 );
			bgFill.setPixel( 0, 3, 0xFF000000 );
		}
		
		bg.makeGraphic( Std.int( width ), Std.int( height ), 0xFF804000 );
		var bmpd = bg.pixels;
		bmpd.lock();
		
		var pt = new Point( 0, 0 );
		var numX = Std.int( bmpd.width / bgFill.width );
		var numY = Std.int( bmpd.height / bgFill.height );
		var srcRect = new Rectangle( 0, 0, bgFill.width, bgFill.height );
		
		for ( x in 0...numX ) {
			for ( y in 0...numY ) {
				pt.x = x * bgFill.width;
				pt.y = y * bgFill.height;
				bmpd.copyPixels( bgFill, srcRect,	pt );
			}
		}
		
		var circ = circSprite( Std.int( radius ) );
		var pm = new Matrix();
		
		for ( pt in lightSources ) {
			pm.translate( pt.x * flxScale, pt.y * flxScale );
			bmpd.draw( circ, pm, null, BlendMode.LIGHTEN );
		}
		bmpd.unlock();
	}
	
	public static inline function updateLighting( darkness:FlxSprite, movingLS:FlxSprite, lightSources:Array<FlxPoint> ) {
		
		//var screenXY = player.getScreenXY();
		//darkness.makeGraphic( FlxG.width, FlxG.height, 0xff000000, true );
		//darkness.stamp( lighting, Std.int( player.x - 45 ), Std.int( player.y - 45 ) );
		
	}
	
	public static inline function circSprite( radius:Int ):Sprite {
		var mtr = new Matrix();
		mtr.createGradientBox( radius * 2, radius * 2, 0, 0, 0 );
		var circ = new Sprite();
		circ.graphics.beginGradientFill( GradientType.RADIAL, [0xFFFF00, 0xFF8000], [0.7, 0], [0, 255], mtr );
		circ.graphics.drawCircle( radius, radius, radius );
		circ.graphics.endFill();
		return circ;
	}
	
	
	public static inline function genLightMapTileSet( numTiles:Int, tileWidth:Int, tileHeight:Int, 
		maxBrightness:Float, baseImage:BitmapData ):BitmapData {
			
		var bmpd = new BitmapData( numTiles * tileWidth, tileHeight, true, 0x00000000 );
		var increment = maxBrightness / numTiles;
		var rect:Rectangle = new Rectangle( 0, 0, tileWidth, tileHeight );
		var mtr = new Matrix();
		var baseColour = 0x00FFFFB9;
		for ( i in 0...numTiles ) {
			mtr.tx = i * tileWidth;
			bmpd.draw( baseImage, mtr, new ColorTransform( increment * i, increment * i, increment * i, 1 ) );
		}
		return bmpd;
	}
	
}
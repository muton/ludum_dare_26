package muton.ld26.util;
import haxe.Int32;
import flash.display.BitmapData;
import org.flixel.plugin.photonstorm.FlxColor;

/**
 * ...
 * @author tim@muton.co.uk
 */

class TileMapUtil 
{

	/** Returns a string suitable for feeding to FlxTileMap */
	public static function bmpToTileMapAlphaBinary( bmp:BitmapData ):String {
		
		var outStr:String = "";
		
		for ( y in 0...bmp.height ) {
			var lineArr:Array<Int> = new Array<Int>();
			for ( x in 0...bmp.width ) {
				var px:Int = bmp.getPixel32( x, y );
				lineArr.push( ( px >> 24 & 0xff ) > 0 ? 1 : 0 );
			}
			outStr += "\n" + lineArr.join( "," );
		}
		outStr += "\n";
		return outStr;
	}
	
	/** Returns a string suitable for feeding to FlxTileMap */
	public static function bmpToTileMapColourIndices( bmp:BitmapData, colourList:Array<Int> ):String {
		
		var colourMap:IntHash<Int> = new IntHash<Int>();
		for ( i in 0...colourList.length ) {
			colourMap.set( colourList[i], i );
		}

		for ( c in colourMap.keys() ) {
			trace( "c: " + FlxColor.RGBtoWebString( c ) + ": " + colourMap.get( c ) );
		}
		
		var outStr:String = "";
		
		for ( y in 0...bmp.height ) {
			var lineArr:Array<Int> = new Array<Int>();
			for ( x in 0...bmp.width ) {
				var px:UInt = bmp.getPixel32( x, y );
				if ( y % 10 == 0 && x % 10 == 0 ) {
					trace( "px: " + StringTools.hex( px, 8 ) );
					trace( "   alpha: " + ( (px >> 24) & 0xFF ) );
					
				}
				lineArr.push( colourMap.get( px ) );
			}
			outStr += "\n" + lineArr.join( "," );
		}
		outStr += "\n";
		//trace( "outStr: " + outStr );
		return outStr;
	}	
	
}
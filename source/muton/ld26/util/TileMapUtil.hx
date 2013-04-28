package muton.ld26.util;
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
	public static function bmpToTileMapColourIndices( bmp:BitmapData, colourList:Array<UInt> ):String {
		
		var colourMap = new Hash<Int>();
		for ( i in 0...colourList.length ) {
			colourMap.set( StringTools.hex( colourList[i], 6 ), i );
		}
		
		var outStr:String = "";
		
		for ( y in 0...bmp.height ) {
			var lineArr:Array<Int> = new Array<Int>();
			for ( x in 0...bmp.width ) {
				//var rgb = FlxColor.getRGB( bmp.getPixel32( x, y ) );
				//var px:Int = FlxColor.getColor24( rgb.red, rgb.green, rgb.blue );
				//if ( y % 6 == 0 && x % 6 == 0 ) {
					//trace( "px: " + StringTools.hex( px, 6 ) );
					//trace( "   alpha: " + ( (px >> 24) & 0xFF ) );
					//
				//}
				lineArr.push( colourMap.get( StringTools.hex( bmp.getPixel( x, y ), 6 ) ) );
			}
			outStr += "\n" + lineArr.join( "," );
		}
		outStr += "\n";
		//trace( "outStr: " + outStr );
		return outStr;
	}	
	
}
package muton.ld26.util;
import haxe.Int32;
import nme.display.BitmapData;

/**
 * ...
 * @author tim@muton.co.uk
 */

class TileMapUtil 
{

	/** Returns a string suitable for feeding to FlxTileMap */
	public static function bmpToTileMap( bmp:BitmapData ):String {
		
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
	
}
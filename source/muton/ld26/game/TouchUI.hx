package muton.ld26.game;
import nme.display.BitmapData;
import nme.display.BitmapInt32;
import nme.system.Capabilities;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxRect;
import org.flixel.FlxSprite;

/**
 * @author tim@muton.co.uk
 */

class TouchUI extends FlxGroup
{
	private static inline var EDGE_MARGIN_IN = 0.1;
	private static inline var BTN_GAP_IN = 0.12;
	private static inline var FIRE_WIDTH_IN = 0.4;
	private static inline var FIRE_HEIGHT_IN = 0.4;
	private static inline var MOVE_WIDTH_IN = 0.35;
	private static inline var MOVE_HEIGHT_IN = 0.35;

	private var showFire:Bool;
	
	private var edgeMargin:Int;
	private var btnGap:Int;
	private var fireWidth:Int;
	private var fireHeight:Int;
	private var moveWidth:Int;
	private var moveHeight:Int;
	
	private var leftBtn:FlxSprite;
	private var rightBtn:FlxSprite;
	private var upBtn:FlxSprite;
	private var downBtn:FlxSprite;
	private var fireBtnA:FlxSprite;
	private var fireBtnB:FlxSprite;
	
	public function new( showFire:Bool = true ) {
		super();
		
		this.showFire = showFire;
		
		convertMeasurements();
		
		if ( showFire ) {
			fireBtnA = addBtn( FlxG.width - fireWidth - edgeMargin, FlxG.height - fireHeight - edgeMargin, 
				fireWidth, fireHeight, 0x8800FF00 );
			fireBtnB = addBtn( fireBtnA.x - fireWidth - btnGap, fireBtnA.y, fireWidth, fireHeight, 0x880000FF );
		}
	
		leftBtn = addBtn( edgeMargin, FlxG.height - moveHeight - edgeMargin, moveWidth, moveHeight, 0x88FFFF80 );
		downBtn = addBtn( edgeMargin + moveWidth + btnGap, leftBtn.y, moveWidth, moveHeight, 0x88FFFF80 );
		rightBtn = addBtn( edgeMargin + ( moveWidth + btnGap ) * 2, leftBtn.y, moveWidth, moveHeight, 0x88FFFF80 );
		upBtn = addBtn( downBtn.x, downBtn.y - moveHeight - btnGap, moveWidth, moveHeight, 0x88FFFF80 );
	}
	
	private function convertMeasurements() {
		edgeMargin = inchesToFlxPx( EDGE_MARGIN_IN );
		btnGap = inchesToFlxPx( BTN_GAP_IN );
		fireWidth = inchesToFlxPx( FIRE_WIDTH_IN );
		fireHeight = inchesToFlxPx( FIRE_HEIGHT_IN );
		moveWidth = inchesToFlxPx( MOVE_WIDTH_IN );
		moveHeight = inchesToFlxPx( MOVE_HEIGHT_IN );
	}
	
#if flash
	private function addBtn( x:Float, y:Float, w:Int, h:Int, colour:UInt ):FlxSprite {
#else
	private function addBtn( x:Float, y:Float, w:Int, h:Int, colour:BitmapInt32 ):FlxSprite {
#end
		var btn = new FlxSprite( x, y );
		btn.makeGraphic( w, h, colour );
		btn.active = false;
		btn.scrollFactor.x = btn.scrollFactor.y = 0;
		add( btn );
		
		return btn;
	}
	
	private function inchesToFlxPx( inches:Float ):Int {
		return Std.int( inches * Capabilities.screenDPI / FlxG.camera.zoom );
	}
	
	override public function update() {
		
		var ctrl = Control.touchState;
		ctrl.up = ctrl.down = ctrl.left = ctrl.right = ctrl.fireA = ctrl.fireB = false;
		
		var touches = FlxG.touchManager.touches;
		
		for ( t in touches ) {
			if ( !t.isActive() ) { continue; };
			if ( showFire && fireBtnA.overlapsPoint( t, true ) ) {
				ctrl.fireA = true;
			} else if ( showFire && fireBtnB.overlapsPoint( t, true ) ) {
				ctrl.fireB = true;
			} else if ( leftBtn.overlapsPoint( t, true ) ) {
				ctrl.left = true;
			} else if ( rightBtn.overlapsPoint( t, true ) ) {
				ctrl.right = true;
			} else if ( upBtn.overlapsPoint( t, true ) ) {
				ctrl.up = true;
			} else if ( downBtn.overlapsPoint( t, true ) ) {
				ctrl.down = true;
			}
		}		
	}
	
}
package muton.ld26;
import muton.ld26.util.TextUtil;
import muton.ld26.Config.CaptionSequence;
import muton.ld26.Config.Caption;
import muton.ld26.Config.CaptionPlacement;
import nme.utils.Timer;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxTypedGroup;

/**
 * ...
 * @author tim@muton.co.uk
 */

class CaptionPlayer {

	private var capGroup:FlxTypedGroup<FlxGroup>;
	private var curSeq:CaptionSequence;
	private var places:Hash<CaptionPlacement>;
	private var displayedIndices:Array<Bool>;
	
	private var elapsed:Float;
	
	public function new( capGroup:FlxTypedGroup<FlxGroup> ) {
		this.capGroup = capGroup;
	}
	
	public function play( seq:CaptionSequence ) {
		curSeq = seq;
		elapsed = 0;
		
		places = new Hash<CaptionPlacement>();
		for ( pl in seq.placements ) {
			places.set( pl.id, pl );
		}
		
		displayedIndices = new Array<Bool>();
		for ( ca in seq.timeline ) {
			displayedIndices.push( false );
		}
	}
	
	/** call manually, flixel doesn't know me */
	public function update() {
		elapsed += FlxG.elapsed;
		if ( null == displayedIndices ) { return; };
		
		for ( i in 0...displayedIndices.length ) {
			if ( !displayedIndices[i] && elapsed  >= curSeq.timeline[i].time) {
				var cap:Caption = curSeq.timeline[i];
				var pl:CaptionPlacement = places.get( cap.placeId );
				var grp = TextUtil.genCaption( cap.label, Std.parseInt( pl.color ), pl.x, pl.y, pl.width, 
					pl.fromRight, pl.fromBottom, cap.duration );
				capGroup.add( grp );
				displayedIndices[i] = true;
			}
		}
		
	}
	
	public function cancel() {
		places = null;
		displayedIndices = null;
		curSeq = null;
	}
}
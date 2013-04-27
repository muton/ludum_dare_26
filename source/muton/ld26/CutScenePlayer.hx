package muton.ld26;
import muton.ld26.Config.CutScene;
import muton.ld26.Config.CutSceneFrame;
import nme.events.Event;
import nme.events.EventDispatcher;
import nme.events.TimerEvent;
import nme.utils.Timer;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.FlxTypedGroup;

/**
 * ...
 * @author tim@muton.co.uk
 */

class CutScenePlayer extends EventDispatcher {

	private var dispatcher:EventDispatcher;
	
	private var holderGroup:FlxTypedGroup<FlxGroup>;
	private var display:CutSceneDisplay;
	
	private var cutScene:CutScene;
	private var timer:Timer;
	
	private var curFrameNum:Int;
	private var curFrameStartTime:Int;
	private var curCaptionNum:Int;
	private var curCaptionStartTime:Int;
	
	private var showFirst:Bool;
	
	public function new( holderGroup:FlxTypedGroup<FlxGroup> ) {
		super();
		this.holderGroup = holderGroup;
	}
	
	public function play( cutScene:CutScene ) {
		this.cutScene = cutScene;
		curFrameNum = 0;
		curFrameStartTime = 0;
		curCaptionNum = 0;
		curCaptionStartTime = 0;
		showFirst = true;
		
		display = new CutSceneDisplay();
		holderGroup.add( display );
		
		timer = new Timer( 1000 );
		timer.addEventListener( TimerEvent.TIMER, tick, false, 1, true );
		timer.start();
		tick();
	}
	
	private function tick( ?e:TimerEvent ):Void {
		
		var frame = cutScene.timeline[curFrameNum];
		
		if ( showFirst ) {
			display.setFrame( frame );
			showFirst = false;
			return;
		}
		
		if ( timer.currentCount - curFrameStartTime > frame.duration ) {
			// next frame
			if ( curFrameNum + 1 < cutScene.timeline.length ) {
				curFrameNum++;
				curFrameStartTime = timer.currentCount;
				curCaptionNum = 0;
				display.setFrame( cutScene.timeline[curFrameNum] );
			} else {
				stop();
			}
		} else {
			var cap = frame.captions[curCaptionNum];
			if ( timer.currentCount - curCaptionStartTime > cap.duration ) {
				if ( curCaptionNum + 1 < frame.captions.length ) {
					curCaptionNum++;
					curCaptionStartTime = timer.currentCount;
					display.setCaption( frame.captions[curCaptionNum] );
				} else {
					display.setCaption( null );
				}
			}
		}
	}
	
	private function stop():Void {
		if ( null != display ) {
			holderGroup.remove( display );
			display = null;
			timer.stop();
			timer = null;
		}
		dispatchEvent( new Event( Event.COMPLETE ) );
	}
}

import org.flixel.FlxGroup;
import muton.ld26.Config.Caption;
import muton.ld26.Config.CutSceneFrame;

class CutSceneDisplay extends FlxGroup {
	
	private var background:FlxSprite;
	private var image:FlxSprite;
	private var label:FlxText;
	
	public function new() {
		super();
		
		background = new FlxSprite( 0, 0 );
		background.makeGraphic( FlxG.width, FlxG.height, 0xff000000 );
		add( background );
		
		image = new FlxSprite( 0, 20 );
		add( image );
		
		label = new FlxText( 10, FlxG.height - 70, FlxG.width - 20, "Label", 10 );
		label.color = 0xffffffff;
		add( label );
		
		background.scrollFactor.x = background.scrollFactor.y = 0;
		image.scrollFactor.x = image.scrollFactor.y = 0;
		label.scrollFactor.x = label.scrollFactor.y = 0;
	}
	
	public function setFrame( frame:CutSceneFrame ) {
		image.loadGraphic( frame.imagePath );
		if ( frame.captions.length > 0 ) {
			setCaption( frame.captions[0] );
		}
	}
	
	public function setCaption( caption:Caption ) {
		label.text = caption == null ? "" : caption.label;
	}
	
}


package muton.ld26.game;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.FlxTypedGroup;

/**
 * ...
 * @author tim@muton.co.uk
 */

class StatusDisplay extends FlxTypedGroup<FlxSprite> {

	private static inline var BAR_WIDTH:Int = 150;
	
	private var livesTxt:FlxText;
	private var disorderFgBar:FlxSprite;
	
	public function new() {
		super();
		createDisplay();
		this.setAll( "alive", false );
		this.setAll( "active", false );
	}
	
	private function createDisplay() {
		
		var livesLeftIcon:FlxSprite = new FlxSprite( 4, 1, "assets/lives_icon.png" );
		livesLeftIcon.scrollFactor.x = livesLeftIcon.scrollFactor.y = 0;
	
		livesTxt = new FlxText( 22, 2, 20, "0", 9, true );
		livesTxt.color = 0xfff26522;
		livesTxt.shadow = 0x66FFFFFF;
		livesTxt.useShadow = true;
		livesTxt.scrollFactor.x = livesTxt.scrollFactor.y = 0;
		
		disorderFgBar = new FlxSprite( FlxG.width - BAR_WIDTH - 4, 5 );
		disorderFgBar.scrollFactor.x = disorderFgBar.scrollFactor.y = 0;
		disorderFgBar.makeGraphic( BAR_WIDTH, 8, 0xFF0000FF );
		
		var disorderBgBar:FlxSprite = new FlxSprite( disorderFgBar.x - 1, disorderFgBar.y - 1 );
		disorderBgBar.scrollFactor.x = disorderBgBar.scrollFactor.y = 0;
		disorderBgBar.makeGraphic( BAR_WIDTH + 2, Std.int( disorderFgBar.height + 2 ), 0x99FFFFFF );
		
		var disorderLabel:FlxText = new FlxText( disorderBgBar.x - 54, 2, 50, "DISORDER", 8, true, false );
		disorderLabel.scrollFactor.x = disorderLabel.scrollFactor.y = 0;
		disorderLabel.color = 0x880000FF;
		disorderLabel.shadow = 0x66FFFFFF;
		disorderLabel.useShadow = true;
		
		add( livesLeftIcon );
		add( livesTxt );
		add( disorderLabel );
		add( disorderBgBar );
		add( disorderFgBar );
		
		setLivesLeft( 0 );
		setDisorderLevel( 0 );
	}
	
	public function setLivesLeft( numLives:Int ) {
		livesTxt.text = "" + numLives;
	}
	
	/** disorder in the range between 0-100 */
	public function setDisorderLevel( disorder:Float ) {
		var barWidth = Math.min( 100, disorder ) / 100 * BAR_WIDTH;
		if ( barWidth < 1 ) {
			disorderFgBar.visible = false;
		} else {
			disorderFgBar.visible = true;
			disorderFgBar.makeGraphic( Std.int( barWidth ), 8, 0xFF0000FF );
		}
	}
	
}



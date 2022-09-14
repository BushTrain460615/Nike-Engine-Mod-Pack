package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class StrumNotes extends FlxSprite
{
	public function new(x:Int, y:Int, player:Int)
	{
		super(x, y);
		var dadnote1:Array<Int> = [];
		var dadnote2:Array<Int> = [];
		var dadnote3:Array<Int> = [];
		var dadnote4:Array<Int> = [];

		var bfnote1:Array<Int> = [];
		var bfnote2:Array<Int> = [];
		var bfnote3:Array<Int> = [];
		var bfnote4:Array<Int> = [];
		var daStage:String = PlayState.curStage;

		for (i in 0...8) {
			switch (curStage)
			{
				case 'school' | 'schoolEvil' | 'starved-pixel':
					if (curStage == 'starved-pixel') {
						loadGraphic(Paths.image('mods/NOTE_assets', 'shared'), true, 17, 17);
					} else {
						loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					}
					animation.add('green', [6]);
					animation.add('red', [7]);
					animation.add('blue', [5]);
					animation.add('purplel', [4]);
	
					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();
					antialiasing = false;
					ID = i;
	
					switch (Math.abs(i))
					{
						case 0:
							x += Note.swagWidth * 0;
							animation.add('static', [0]);
							animation.add('pressed', [4, 8], 12, false);
							animation.add('confirm', [12, 16], 24, false);
						case 1:
							x += Note.swagWidth * 1;
							animation.add('static', [1]);
							animation.add('pressed', [5, 9], 12, false);
							animation.add('confirm', [13, 17], 24, false);
						case 2:
							x += Note.swagWidth * 2;
							animation.add('static', [2]);
							animation.add('pressed', [6, 10], 12, false);
							animation.add('confirm', [14, 18], 12, false);
						case 3:
							x += Note.swagWidth * 3;
							animation.add('static', [3]);
							animation.add('pressed', [7, 11], 12, false);
							animation.add('confirm', [15, 19], 24, false);
					}
	
				default:
					if (curStage != 'garrett-school') {
						frames = Paths.getSparrowAtlas('NOTE_assets');
					}
					else if (curStage == 'garrett-school') {
						frames = Paths.getSparrowAtlas('mods/NOTE_assets_3D');
					}
					animation.addByPrefix('green', 'arrowUP');
					animation.addByPrefix('blue', 'arrowDOWN');
					animation.addByPrefix('purple', 'arrowLEFT');
					animation.addByPrefix('red', 'arrowRIGHT');
	
					antialiasing = Settings.Antialiasing;
					setGraphicSize(Std.int(width * 0.7));
	
					switch (Math.abs(i))
					{
						case 0:
							x += Note.swagWidth * 0;
							animation.addByPrefix('static', 'arrowLEFT');
							animation.addByPrefix('pressed', 'left press', 24, false);
							animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							x += Note.swagWidth * 1;
							animation.addByPrefix('static', 'arrowDOWN');
							animation.addByPrefix('pressed', 'down press', 24, false);
							animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							x += Note.swagWidth * 2;
							animation.addByPrefix('static', 'arrowUP');
							animation.addByPrefix('pressed', 'up press', 24, false);
							animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							x += Note.swagWidth * 3;
							animation.addByPrefix('static', 'arrowRIGHT');
							animation.addByPrefix('pressed', 'right press', 24, false);
							animation.addByPrefix('confirm', 'right confirm', 24, false);
					}

					if (!PlayState.isStoryMode)
					{
						y -= 10;
						alpha = 0;
						FlxTween.tween(this, {y: y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
					}

					babyArrow.animation.play('static');
					babyArrow.x += 50;
					babyArrow.x += ((FlxG.width / 1.8) * player);
			}

			for (i in 0...8) {
				switch (i) {
					case 0:
						if (this.ID = i) {
							PlayState.opponentStrums.add(this);
						}
						dadnote1.push(x);
						dadnote1.push(y);
					case 1:
						if (this.ID = i) {
							PlayState.opponentStrums.add(this);
						}
						dadnote2.push(x);
						dadnote2.push(y);
					case 2:
						if (this.ID = i) {
							PlayState.opponentStrums.add(this);
						}
						dadnote3.push(x);
						dadnote3.push(y);
					case 3:
						if (this.ID = i) {
							PlayState.opponentStrums.add(this);
						}
						dadnote4.push(x);
						dadnote4.push(y);
					case 4:
						if (this.ID = i) {
							PlayState.playerStrums.add(this);
						}
						bfnote1.push(x);
						bfnote1.push(y);
					case 5:
						if (this.ID = i) {
							PlayState.playerStrums.add(this);
						}
						bfnote2.push(x);
						bfnote2.push(y);
					case 6:
						if (this.ID = i) {
							PlayState.playerStrums.add(this);
						}
						bfnote3.push(x);
						bfnote3.push(y);
					case 7:
						if (this.ID = i) {
							PlayState.playerStrums.add(this);
						}
						bfnote4.push(x);
						bfnote5.push(y);

				}
			}
		}

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
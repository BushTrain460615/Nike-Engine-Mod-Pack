package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var willMiss:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteStyle:String = 'normal';

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, noteStyle:String = 'normal')
	{
		super();
		this.noteStyle = noteStyle;
		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		switch (daStage)
		{
			case 'school' | 'schoolEvil' | 'starved-pixel':
				#if mods
				if (daStage == 'starved-pixel') {
					loadGraphic(Paths.image('mods/NOTE_assets', 'shared'), true, 17, 17);
				} else {
					loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
				}
				#else
				loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
				#end

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					#if mods
					if (daStage == 'starved-pixel') {
						loadGraphic(Paths.image('mods/NOTE_assetsENDS', 'shared'), true, 7, 6);
					} else {
						loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);
					}
					#else
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);
					#end

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			default:
				var daPath:String = 'NOTE_assets';
				switch (noteStyle) {
					case 'alt-anim':
						daPath = 'NOTE_assets';
					#if mods
					case 'magic':
					    daPath = 'mods/funnyAnimal/magicNote';
					case 'police':
						daPath = 'mods/funnyAnimal/palooseNote';
					case 'Static Note':
						daPath = 'mods/STATICNOTE_assets';
					#end
					default:
						#if mods
						if (PlayState.SONG.song == 'Algebra' || PlayState.SONG.song == 'Ferocious') {
							daPath = 'mods/NOTE_assets_3D';
						}
						else {
							daPath = 'NOTE_assets';
						}
						#else
						daPath = 'NOTE_assets';
						#end
				}
				frames = Paths.getSparrowAtlas(daPath);

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = Settings.Antialiasing;
		}

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				if (noteStyle != 'police') {
					animation.play('purpleScroll');

					#if mods
					if (noteStyle == 'Static Note') {
						animation.addByPrefix('lol', 'purple', 24, true);
						animation.play('lol');
					}
					#end
				}
				else {
					#if mods
					animation.addByPrefix('siren', 'JUNKING', 24, true);
					animation.play('siren');
					angle = -90;
					#end
				}
			case 1:
				x += swagWidth * 1;
				if (noteStyle != 'police') {
					animation.play('blueScroll');

					#if mods
					if (noteStyle == 'Static Note') {
						animation.addByPrefix('lol', 'blue', 24, true);
						animation.play('lol');
					}
					#end
				}
				else {
					#if mods
					animation.addByPrefix('siren', 'JUNKING', 24, true);
					animation.play('siren');
					flipY = true;
					#end
				}
			case 2:
				x += swagWidth * 2;
				if (noteStyle != 'police') {
					animation.play('greenScroll');

					#if mods
					if (noteStyle == 'Static Note') {
						animation.addByPrefix('lol', 'green', 24, true);
						animation.play('lol');
					}
					#end
				}
				else {
					#if mods
					animation.addByPrefix('siren', 'JUNKING', 24, true);
					animation.play('siren');
					#end
				}
			case 3:
				x += swagWidth * 3;
				if (noteStyle != 'police') {
					animation.play('redScroll');

					#if mods
					if (noteStyle == 'Static Note') {
						animation.addByPrefix('lol', 'red', 24, true);
						animation.play('lol');
					}
					#end
				}
				else {
					#if mods
					animation.addByPrefix('siren', 'JUNKING', 24, true);
					animation.play('siren');
					angle = 90;
					#end
				}
		}

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;

			flipY = Settings.Downscroll;

			if (PlayState.curStage.startsWith('school') || PlayState.curStage == 'starved-pixel')
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress) {
			if (willMiss && !wasGoodHit) {
				tooLate = true;
				canBeHit = false;
			}
			else {
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset) {
					if (strumTime < Conductor.songPosition + 0.5 * Conductor.safeZoneOffset)
						canBeHit = true;
				}
				else {
					willMiss = true;
					canBeHit = true;
				}
			}
		}
		else {
			canBeHit = false;
	
			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}
	
		if (tooLate) {
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
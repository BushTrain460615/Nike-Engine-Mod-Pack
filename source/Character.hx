package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var IsPixelChar:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	var NormalAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets', 'shared');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-tankmen':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/gfTankmen', 'shared');
				frames = tex;
				animation.addByIndices('sad', 'GF Crying at Gunpoint 0', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint0', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing at Gunpoint0', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
	
				playAnim('danceRight');
			case 'pico-speaker':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/picoSpeaker', 'shared');
				frames = tex;
				animation.addByPrefix('shoot1', 'Pico shoot 1', 24);
				animation.addByPrefix('shoot2', 'Pico shoot 2', 24);
				animation.addByPrefix('shoot3', 'Pico shoot 3', 24);
				animation.addByPrefix('shoot4', 'Pico shoot 4', 24);
		
				addOffset('shoot1', 0, 0);
				addOffset('shoot2', -1, -128);
				addOffset('shoot3', 412, -64);
				addOffset('shoot4', 439, -19);
		
				playAnim('shoot1');
			case 'nene':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/Nene', 'shared');
				frames = tex;
				animation.addByPrefix('danceLeft', 'Nene left', 24, false);
				animation.addByPrefix('danceRight', 'Nene right', 24, false);
						
				addOffset('danceLeft', 5 -13);
				addOffset('danceRight', 5 -13);
						
				playAnim('danceRight');
			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters/gfChristmas', 'shared');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-car':
				tex = Paths.getSparrowAtlas('characters/gfCar', 'shared');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel', 'shared');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				IsPixelChar = true;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'tankman':
				tex = Paths.getSparrowAtlas('characters/tankmanCaptain', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Tankman Idle Dance 1', 24);
				animation.addByPrefix('singUP', 'Tankman UP note 1', 24);
				animation.addByPrefix('singRIGHT', 'Tankman Note Left 1', 24);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note 1', 24);
				animation.addByPrefix('singLEFT', 'Tankman Right Note 1', 24);
				animation.addByPrefix('singUP-alt', 'TANKMAN UGH 1', 24);
				animation.addByPrefix('singDOWN-alt', 'PRETTY GOOD tankman 1', 24);
	
				addOffset('idle');
				addOffset("singUP", 48, 54);
				addOffset("singRIGHT", -21, -31);
				addOffset("singLEFT", 84, -14);
				addOffset("singDOWN", 76, -101);

				addOffset("singUP-alt", -15, -8);
				addOffset("singDOWN-alt", 1, 16);
	
				playAnim('idle');

				flipX = true;
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets', 'shared');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('characters/Mom_Assets', 'shared');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/momCar', 'shared');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('characters/Monster_Assets', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/monsterChristmas', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				playAnim('idle');

				flipX = true;

			case 'pico-player':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
			    animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);
	
				addOffset('idle');
				addOffset("singUP", 21, 27);
				addOffset("singRIGHT", -48, 2);
				addOffset("singLEFT", 85, -10);
				addOffset("singDOWN", 84, -80);
				addOffset("singUPmiss", 28, 67);
				addOffset("singRIGHTmiss", -45, -50);
				addOffset("singLEFTmiss", 83, 28);
				addOffset("singDOWNmiss", 80, -38);
	
				playAnim('idle');
			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');

				/*
				if (sys.FileSystem.exists('assets/editables/images/characters/BOYFRIEND.png') && sys.FileSystem.exists('assets/editables/images/characters/BOYFRIEND.xml')) {
					trace('Loading mod...');
					tex = Paths.getSparrowAtlas('characters/BOYFRIEND', 'editable');
					trace('Loaded mod!');
				}
				*/
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');
			case 'bf-holding-gf':
				var tex = Paths.getSparrowAtlas('characters/bfAndGF', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance w gf', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 10);
				addOffset("singRIGHT", -41, 23);
				addOffset("singLEFT", 12, 7);
				addOffset("singDOWN", -10, -10);
				addOffset("singUPmiss", -29, 10);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -10, -10);
	
				playAnim('idle');
			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('characters/bfChristmas', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				playAnim('idle');
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('characters/bfCar', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel', 'shared');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				IsPixelChar = true;

			case 'bf-holding-gf-dead':
				frames = Paths.getSparrowAtlas('characters/bfHoldingGF-DEAD', 'shared');
				animation.addByPrefix('firstDeath', "BF Dies with GF", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead with GF Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY confirm holding gf", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD', 'shared');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				IsPixelChar = true;
			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/senpai', 'shared');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				IsPixelChar = true;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai', 'shared');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				IsPixelChar = true;

			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit', 'shared');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				IsPixelChar = true;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets', 'shared');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');
			case 'darnell':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/darnell', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Darnell idle0', 24);
				animation.addByPrefix('singUP', 'Darnell up0', 24);
				animation.addByPrefix('singRIGHT', 'Darnell right0', 24);
				animation.addByPrefix('singDOWN', 'Darnell down0', 24);
				animation.addByPrefix('singLEFT', 'Darnell left0', 24);

				animation.addByPrefix('singUP-alt', 'Darnell laugh0', 24);

				addOffset('idle', 21, 275);
				addOffset("singUP", 31, 335);
				addOffset("singRIGHT", 32, 271);
				addOffset("singLEFT", 65, 249);
				addOffset("singDOWN", 34, 211);

				addOffset("singUP-alt", 19, 266);

				playAnim('idle');
			#if mods
			case '3d-bf-dead':
				var tex = Paths.getSparrowAtlas('characters/mods/3d_bf_dies', 'shared');
				frames = tex;
				animation.addByPrefix('firstDeath', "DIES0", 24, false);
				animation.addByPrefix('deathLoop', "DIE LOOP0", 24, true);
				animation.addByPrefix('deathConfirm', "DIE CONFIRM0", 24, false);

				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
			case '3d-bf':
				var tex = Paths.getSparrowAtlas('characters/mods/3D_BF', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE0', 24, false);
				animation.addByPrefix('singUP', 'UP0', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'MUP', 24, false);
				animation.addByPrefix('singLEFTmiss', 'MLEFT', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'MRIGHT', 24, false);
				animation.addByPrefix('singDOWNmiss', 'MDOWN', 24, false);

				addOffset('idle', 0, 0);
				addOffset("singUP", 74, 126);
				addOffset("singRIGHT", -58, 17);
				addOffset("singLEFT", -11, 13);
				addOffset("singDOWN", -8, -3);

				addOffset("singUPmiss", 74, 118);
				addOffset("singRIGHTmiss", 74, 118);
				addOffset("singLEFTmiss", 74, 118);
				addOffset("singDOWNmiss", 74, 118);

				playAnim('idle');
			case '3d-bf-flipped':
				var tex = Paths.getSparrowAtlas('characters/mods/3D_BF', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE0', 24, false);
				animation.addByPrefix('singUP', 'UP0', 24, false);
				animation.addByPrefix('singLEFT', 'RIGHT0', 24, false);
				animation.addByPrefix('singRIGHT', 'LEFT0', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'MUP', 24, false);
				animation.addByPrefix('singLEFTmiss', 'MLEFT', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'MRIGHT', 24, false);
				animation.addByPrefix('singDOWNmiss', 'MDOWN', 24, false);
	
				addOffset('idle', 0, 0);
				addOffset("singUP", 110, 126);
				addOffset("singLEFT", 58, 17);
				addOffset("singRIGHT", 11, 17);
				addOffset("singDOWN", 2, -3);
	
				addOffset("singUPmiss", 114, 118);
				addOffset("singRIGHTmiss", 114, 118);
				addOffset("singLEFTmiss", 114, 118);
				addOffset("singDOWNmiss", 114, 118);
	
				playAnim('idle');
	
				flipX = true;

			case 'agoti':
				// OMG AGOTI CODE
				tex = Paths.getSparrowAtlas('characters/mods/AGOTI', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Agoti_Idle', 24);
				animation.addByPrefix('singUP', 'Agoti_Up', 24);
				animation.addByPrefix('singRIGHT', 'Agoti_Right', 24);
				animation.addByPrefix('singDOWN', 'Agoti_Down', 24);
				animation.addByPrefix('singLEFT', 'Agoti_Left', 24);
	
				addOffset('idle', 0, 140);
				addOffset("singUP", 90, 220);
				addOffset("singRIGHT", 130, 90);
				addOffset("singLEFT", 240, 170);
				addOffset("singDOWN", 70, -50);

				playAnim('idle');

			case 'gf-rocks':
				// OMG AGOTI GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/mods/GF_assets', 'shared');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

	
			case 'og-dave':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/og_dave', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
				animation.addByPrefix('stand', 'STAND', 24, false);
			
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN", -82, -24);
				addOffset("stand", -87, -29);
	
				setGraphicSize(Std.int(width * 1.02),Std.int(height * 1.02));
				updateHitbox();
				antialiasing = false;
			
				playAnim('idle');
			case 'og-dave-angey':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/og_dave_angey', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
				animation.addByPrefix('stand', 'STAND', 24, false);
			
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("stand", -156, -45);
	
				setGraphicSize(Std.int(width * 1.02),Std.int(height * 1.02));
				updateHitbox();
				antialiasing = false;
			
				playAnim('idle');
			case 'garrett':
				// DAVE SHITE ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/garrett_algebra', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
				animation.addByPrefix('stand', 'STAND', 24, false);
				animation.addByPrefix('scared', 'SHOCKED', 24, false);
			
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT", -45, 3);
				addOffset("singLEFT");
				addOffset("singDOWN", -48, -46);
				addOffset("stand", 20);
				addOffset("scared");
	
				setGraphicSize(Std.int(width * 1.3),Std.int(height * 1.3));
				updateHitbox();
				antialiasing = false;
			
				playAnim('idle');
			case 'playrobot':
				frames = Paths.getSparrowAtlas('characters/mods/playrobot', 'shared');
	
				animation.addByPrefix('idle', 'Idle', 24, true);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
	
				addOffset('idle');
				addOffset('singLEFT', 110, -90);
				addOffset('singDOWN', -21, -218);
				addOffset('singUP');
				addOffset('singRIGHT', -55, -96);
	
				antialiasing = false;
	
				playAnim('idle');
			case 'playrobot-crazy':
				frames = Paths.getSparrowAtlas('characters/mods/ohshit', 'shared');
	
				animation.addByPrefix('idle', 'Idle', 24, true);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
	
				addOffset('idle');
				addOffset('singLEFT', 255);
				addOffset('singDOWN', 203, -50);
				addOffset('singUP', -19);
				addOffset('singRIGHT', -20, 38);
	
				antialiasing = false;
	
				playAnim('idle');
			case 'hall-monitor':
				frames = Paths.getSparrowAtlas('characters/mods/HALL_MONITOR', 'shared');
				animation.addByPrefix('idle', 'gdj', 24, false);
				for (anim in ['left', 'down', 'up', 'right']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}
	
				addOffset('idle');
				addOffset('singLEFT', 436, 401);
				addOffset('singDOWN', 145, 25);
				addOffset('singUP', -150, 62);
				addOffset('singRIGHT', 201, 285);
	
				antialiasing = false;
				scale.set(1.5, 1.5);
				updateHitbox();
	
				playAnim('idle');
			case 'diamond-man':
				frames = Paths.getSparrowAtlas('characters/mods/diamondMan', 'shared');
				animation.addByPrefix('idle', 'idle', 24, true);
				for (anim in ['left', 'down', 'up', 'right']) {
					animation.addByPrefix('sing${anim.toUpperCase()}', anim, 24, false);
				}
	
				addOffset('idle');
				addOffset('singLEFT', 610);
				addOffset('singDOWN', 91, -328);
				addOffset('singUP', -12, 338);
				addOffset('singRIGHT', 4);
	
				scale.set(1.3, 1.3);
				updateHitbox();
	
				antialiasing = false;
	
			    playAnim('idle');
			case 'garrett-animal':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/garrett', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle0', 24);
				animation.addByPrefix('singUP', 'up0', 24);
				animation.addByPrefix('singRIGHT', 'right0', 24);
				animation.addByPrefix('singDOWN', 'down0', 24);
				animation.addByPrefix('singLEFT', 'left0', 24);
	
				addOffset('idle');
				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
	
				playAnim('idle');
			case 'playtime':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/playtime', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle0', 24);
				animation.addByPrefix('singUP', 'up0', 24);
				animation.addByPrefix('singRIGHT', 'right0', 24);
				animation.addByPrefix('singDOWN', 'down0', 24);
				animation.addByPrefix('singLEFT', 'left0', 24);
				animation.addByPrefix('garrett pulls out ass', 'CHECK OUT MY LIL FRIENDO0', 24, false);
		
				addOffset('idle', 0, -1);
				addOffset("singUP", -1, -1);
				addOffset("singRIGHT", -1, -1);
				addOffset("singLEFT", -1, -1);
				addOffset("singDOWN", -1, -1);
				addOffset("garrett pulls out ass", 601, 352);
		
				playAnim('idle');
			case 'palooseMen':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/palooseMen', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle0', 24);
				animation.addByPrefix('singUP', 'up0', 24);
				animation.addByPrefix('singRIGHT', 'right0', 24);
				animation.addByPrefix('singDOWN', 'down0', 24);
				animation.addByPrefix('singLEFT', 'left0', 24);
			
				addOffset('idle', 0, 0);
				addOffset("singUP", -24, 107);
				addOffset("singLEFT", 580, -40);
				addOffset("singRIGHT", -41, -51);
				addOffset("singDOWN", -27, -230);
				
				scale.set(1.3, 1.3);
			
				playAnim('idle');

			case 'garrett-ipad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/future', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle0', 24);
				animation.addByPrefix('singUP', 'up0', 24);
				animation.addByPrefix('singRIGHT', 'right0', 24);
				animation.addByPrefix('singDOWN', 'down0', 24);
				animation.addByPrefix('singLEFT', 'left0', 24);
		
				addOffset('idle', -79, -144);
				addOffset("singUP", -77, -141);
				addOffset("singRIGHT", -56, -150);
				addOffset("singLEFT", -74, -150);
				addOffset("singDOWN", -78, -111);
		
				playAnim('idle');

			case 'bf-ipad':
				var tex = Paths.getSparrowAtlas('characters/mods/garrett_bf', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle0', 24, false);
				animation.addByPrefix('singUP', 'up0', 24, false);
				animation.addByPrefix('singLEFT', 'left0', 24, false);
				animation.addByPrefix('singRIGHT', 'right0', 24, false);
				animation.addByPrefix('singDOWN', 'down0', 24, false);
	
				addOffset('idle', -79, -144);
				addOffset("singUP", -50, -98);
				addOffset("singRIGHT", -77, -133);
				addOffset("singLEFT", 38, -112);
				addOffset("singDOWN", -96, -193);

				animation.addByPrefix('singUPmiss', 'up0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'left0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'right0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'down0', 24, false);
				addOffset("singUPmiss", -50, -98);
				addOffset("singRIGHTmiss", -77, -133);
				addOffset("singLEFTmiss", 38, -112);
				addOffset("singDOWNmiss", -96, -193);
	
				playAnim('idle');

				scale.set(0.6, 0.6);
			case 'wizard':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/wizard', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle0', 24);
				animation.addByPrefix('singUP', 'up0', 24);
				animation.addByPrefix('singRIGHT', 'right0', 24);
				animation.addByPrefix('singDOWN', 'down0', 24);
				animation.addByPrefix('singLEFT', 'left0', 24);
			
				addOffset('idle', 1, -1);
				addOffset("singUP", -1, -1);
				addOffset("singRIGHT", -42, -11);
				addOffset("singLEFT", -111, -21);
				addOffset("singDOWN", -1, -1);
			
				playAnim('idle');
			case 'piano-guy':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/mrMusic', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'YEA0', 24);
				animation.addByPrefix('singUP', 'up0', 24);
				animation.addByPrefix('singRIGHT', 'right0', 24);
				animation.addByPrefix('singDOWN', 'down0', 24);
				animation.addByPrefix('singLEFT', 'left0', 24);
				
				addOffset('idle', -79, -141);
				addOffset("singUP", -154, 48);
				addOffset("singRIGHT", -66, -162);
				addOffset("singLEFT", 182, -159);
				addOffset("singDOWN", 20, -240);
				
				scale.set(4, 4);

				playAnim('idle');

			case 'pedophile':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/do_you_accept', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle0', 24);
				animation.addByPrefix('singUP', 'up0', 24);
				animation.addByPrefix('singRIGHT', 'right0', 24);
				animation.addByPrefix('singDOWN', 'down0', 24);
				animation.addByPrefix('singLEFT', 'left0', 24);
					
				addOffset('idle', 0, 0);
				addOffset("singUP", -1, 1);
				addOffset("singRIGHT", 0, 0);
				addOffset("singLEFT", 0, -1);
				addOffset("singDOWN", 20, 0);
					
				playAnim('idle');

			case 'garrett-angry':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/garrett_piss', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle0', 24);
				animation.addByPrefix('singUP', 'up0', 24);
				animation.addByPrefix('singRIGHT', 'right0', 24);
				animation.addByPrefix('singDOWN', 'down0', 24);
				animation.addByPrefix('singLEFT', 'left0', 24);
			
				addOffset('idle', 0, 0);
				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 1, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
			
				playAnim('idle');

		    case 'garrett-car':
			    // DAD ANIMATION LOADING CODE
			    tex = Paths.getSparrowAtlas('characters/mods/carThing', 'shared');
			    frames = tex;
			    animation.addByPrefix('idle', 'idle0', 24);
			    animation.addByPrefix('singUP', 'up0', 24);
				animation.addByPrefix('singRIGHT', 'right0', 24);
				animation.addByPrefix('singDOWN', 'down0', 24);
				animation.addByPrefix('singLEFT', 'left0', 24);
			
				addOffset('idle', 0, 0);
				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
			
				playAnim('idle');
		
			case 'sonicexe':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/sonicexe', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'SONICmoveIDLE', 24);
				animation.addByPrefix('singUP', 'SONICmoveUP', 24);
				animation.addByPrefix('singRIGHT', 'SONICmoveRIGHT', 24);
				animation.addByPrefix('singDOWN', 'SONICmoveDOWN', 24);
				animation.addByPrefix('singLEFT', 'SONICmoveLEFT', 24);

				animation.addByPrefix('singLEFT-alt', 'SONIClaugh', 24);
				animation.addByPrefix('singDOWN-alt', 'SONIClaugh', 24);
				
				addOffset('idle', -60, -80);
				addOffset("singUP", 34, 31);
				addOffset("singRIGHT", -90, -16);
				addOffset("singLEFT", 110, -63);
				addOffset("singDOWN", 20, -160);

				addOffset("singLEFT-alt", 0, -40);
				addOffset("singDOWN-alt", 0, -40);
				
				playAnim('idle');

			case 'bf-encore':
				var tex = Paths.getSparrowAtlas('characters/mods/ENCORE_BF', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'idle instance', 24, false);
				animation.addByPrefix('singUP', 'up instance', 24, false);
				animation.addByPrefix('singLEFT', 'Left instance', 24, false);
				animation.addByPrefix('singRIGHT', 'right instance', 24, false);
				animation.addByPrefix('singDOWN', 'down instance', 24, false);
				animation.addByPrefix('singUPmiss', 'miss UP instance', 24, false);
				animation.addByPrefix('singLEFTmiss', 'miss LEFT instance', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'miss RIGHT instance', 24, false);
				animation.addByPrefix('singDOWNmiss', 'miss DOWN instance', 24, false);
	
				addOffset('idle', -5, 0);
				addOffset("singUP", -35, 37);
				addOffset("singRIGHT", -28, -27);
				addOffset("singLEFT", 105, -2);
				addOffset("singDOWN", -7, -56);
	
				addOffset("singUPmiss", -36, 27);
				addOffset("singRIGHTmiss", -24, -24);
				addOffset("singLEFTmiss", 107, -1);
				addOffset("singDOWNmiss", -7, -53);
	
				playAnim('idle');
			case 'sonic-running':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/running_sonic_sheet', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'sonic idle', 24, true);
				animation.addByPrefix('singUP', 'sonic sing up0', 24, false);
				animation.addByPrefix('singLEFT', 'sonic sing right0', 24, false);
				animation.addByPrefix('singDOWN', 'sonic sing down0', 24, false);
				animation.addByPrefix('singRIGHT', 'sonic left sing0', 24, false);
	
				animation.addByPrefix('singUPmiss', 'sonic up miss0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'sonic left miss0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'sonic right miss0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'sonic down miss0', 24, false);
				animation.addByPrefix('first', 'dialogue 1', 24, false);
									
				addOffset('idle', -240, -440);
				addOffset("singUP", -240, -440);
				addOffset("singRIGHT", -240, -440);
				addOffset("singLEFT", -240, -440);
				addOffset("singDOWN", -240, -440);
	
				addOffset("singUPmiss", -240, -440);
				addOffset("singRIGHTmiss", -240, -440);
				addOffset("singLEFTmiss", -240, -440);
				addOffset("singDOWNmiss", -240, -440);
				addOffset("first", -240, -434);
									
				playAnim('idle');
	
				scale.set(6, 6);
				IsPixelChar = true;	
			case 'sonic-running-fast':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/peelout_sonic_sheet', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'sonic idle', 24, true);
				animation.addByPrefix('singUP', 'sonic sing up0', 24, false);
				animation.addByPrefix('singLEFT', 'sonic sing right0', 24, false);
				animation.addByPrefix('singDOWN', 'sonic sing down0', 24, false);
				animation.addByPrefix('singRIGHT', 'sonic left sing0', 24, false);

				animation.addByPrefix('singUPmiss', 'sonic up miss0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'sonic left miss0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'sonic right miss0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'sonic down miss0', 24, false);
				animation.addByPrefix('taunt', 'dialogue peelout0', 24, false);
								
				addOffset('idle', -240, -440);
				addOffset("singUP", -240, -440);
				addOffset("singRIGHT", -240, -440);
				addOffset("singLEFT", -240, -440);
				addOffset("singDOWN", -240, -440);

				addOffset("singUPmiss", -240, -440);
				addOffset("singRIGHTmiss", -240, -440);
				addOffset("singLEFTmiss", -240, -440);
				addOffset("singDOWNmiss", -240, -440);
				addOffset("taunt", -240, -441);
								
				playAnim('idle');

				scale.set(6, 6);
				IsPixelChar = true;		
			case 'Furnace':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/Furnace_sheet', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Furnace idle', 24);
				animation.addByPrefix('singUP', 'Furnace up', 24);
				animation.addByPrefix('singRIGHT', 'Furnace right', 24);
				animation.addByPrefix('singDOWN', 'Furnace down', 24);
				animation.addByPrefix('singLEFT', 'Furnace left', 24);
								
				addOffset('idle', -240, -340);
				addOffset("singUP", -286, -280);
				addOffset("singRIGHT", -270, -333);
				addOffset("singLEFT", -202, -325);
				addOffset("singDOWN", -280, -319);
								
				playAnim('idle');

				scale.set(6, 6);
				IsPixelChar = true;
			case 'starved-pixel':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/mods/starved_sheet', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'starved idle', 24);
				animation.addByPrefix('singUP', 'starved up', 24);
				animation.addByPrefix('singRIGHT', 'starved right', 24);
				animation.addByPrefix('singDOWN', 'starved down', 24);
				animation.addByPrefix('singLEFT', 'starved left', 24);
				animation.addByPrefix('You dont even', 'starved dialogue', 24);
												
				addOffset('idle', -240, -340);
				addOffset("singUP", -240, -342);
				addOffset("singRIGHT", -234, -335);
				addOffset("singLEFT", -246,	-335);
				addOffset("singDOWN", -240, -329);
				addOffset("You dont even", -240, -341);
												
				playAnim('idle');
				
				scale.set(6, 6);
				IsPixelChar = true;
			#end
		}

		dance();

		if (isPlayer)
		{

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.contains('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	function quickAnimAdd(Name:String, Prefix:String) {
		animation.addByPrefix(Name, Prefix, 24, false);
	}

    /*
	function loadOffsetFile(char:String) {
		//I fucking hate converting JS code to regular code (this is week 8 code)
		var offsets = CoolUtil.coolTextFile(Paths.getPath("images/characters/" + char + "Offsets.txt", 'shared'));
		var g = 0;
		while (g < offsets.length) {
			var i = offsets[g];
			++g;
			var split = i.split(" ");
			addOffset(split[0], Std.parseInt(split[1]), Std.parseInt(split[2]));
		}
	}
	*/ //broken somehow

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad' || curCharacter == 'Furnace' || curCharacter == 'starved-pixel')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;
	var canIdle:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'starved-pixel':
					if (animation.curAnim.name == 'You dont even') {
						trace('Preventing starved from going idle.');
					}
					else {
						playAnim('idle');
					}
				case 'tankman':
				    if (animation.curAnim.name == 'singDOWN-alt') {
						trace('Preventing tankman from going idle.');
					}
					else {
						playAnim('idle');
					}
				case 'gf' | 'gf-car' | 'gf-christmas' | 'gf-pixel' | 'gf-tankmen' | 'nene':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				/*
				case 'pico-speaker':
					danced = !danced;
	
					if (danced)
						playAnim('shoot1');
					else
						playAnim('shoot1');
				*/
				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}

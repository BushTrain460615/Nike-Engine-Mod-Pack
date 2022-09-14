package;

import flixel.FlxSprite;

#if sys
import sys.FileSystem;
import sys.io.File;
#else
import openfl.utils.Assets as FileSystem;
#end

using StringTools;

class HealthIcon extends FlxSprite
{
	//should be sum like ['idle', 'losing', 'winning'] //winning if there is a winning icon lol
	public var animationsBase:Array<String> = [];
	public var sprTracker:FlxSprite;
	public var hasWinningIcon:Bool;
	public var char:String;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		if (char == 'bf-car' || char == 'bf-christmas' || char == 'bf-holding-gf' || char == 'bf-encore') {
			char = 'bf';
		} else if (char == 'gf-car' || char == 'gf-christmas') {
			char = 'gf';
		} else if (char == 'pico-player') {
			char = 'pico';
		} else if (char == 'mom-car') {
			char = 'mom';
		} else if (char == 'senpai') {
			char = 'senpai-pixel';
		} else if (char == 'senpai-angry') {
			char = 'senpai-pixel';
		} else if (char == 'spirit') {
			char = 'spirit-pixel';
		}#if mods else if (char == '3d-bf-flipped' || char == 'bf-ipad') {
			char = '3d-bf';
		} else if (char == 'og-dave-angey') {
			char = 'og-dave';
		} else if (char == 'garrett-angry' || char == 'garrett-ipad' || char == 'garrett-car') {
			char = 'garrett-animal';
		} else if (char == 'sonic-running-fast') {
			char = 'sonic-running';	
		}
		#end

		this.char = char;

		if (!FileSystem.exists('assets/images/icons/icon-' + char + '.png')) {
			char = 'face';
			trace('Null char image!');
		}

		var balls = loadGraphic(Paths.image('icons/icon-' + char));

		if (balls.width == 450) {
			hasWinningIcon = true;
		} else if (balls.width != 300 && balls.width != 450) {
			trace('Stupid icon width for ' + char);
		}

		trace(char + ' - Has Winning Icon = ' + hasWinningIcon);

		switch (char) {
			case 'custom':
				//custom icon code!!!
				hasWinningIcon = true; //if the game can't detect it lol
				//THIS IS AN IMAGE WITH XML CODE LOL
				frames = Paths.getSparrowAtlas("icons/ICON NAME");
				animation.addByPrefix('balls-idle', 'BASE XML CODE', 24, true);
				animationsBase.push('balls-idle');
				animation.addByPrefix('balls-losing', 'BASE XML LOSING CODE', 24, true);
				animationsBase.push('balls-losing');

				if (hasWinningIcon) {
					animation.addByPrefix('balls-winning', 'BASE XML WINNING CODE', 24, true);
					animationsBase.push('balls-winning');
				}
				animation.play('balls-idle');
			default:
				loadGraphic(Paths.image('icons/icon-' + char), true, 150, 150);

				animation.add(char + '-idle', [0, 24], 0, false, isPlayer);
				animationsBase.push(char + '-idle');
				animation.add(char + '-losing', [1, 24], 0, false, isPlayer);
				animationsBase.push(char + '-losing');
				if (hasWinningIcon) {
					animation.add(char + '-winning', [2, 24], 0, false, isPlayer);
					animationsBase.push(char + '-winning');
				}

				animation.play(char + '-idle');
		}

		antialiasing = Settings.Antialiasing;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	
		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}

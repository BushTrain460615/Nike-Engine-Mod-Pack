package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

using StringTools;

/**
 * Loosley based on FlxTypeText lolol
 */
class Checkbox extends FlxSprite
{
	// for menu shit
	public var targetY:Float = 0;
	public var isMenuItem:Bool = false;

	public function new(x:Float, y:Float, isMenuItem:Bool)
	{
		super(x, y);

		var tex = Paths.getSparrowAtlas('checkboxThingie');
		frames = tex;
		animation.addByPrefix('selected', 'Check Box Selected Static0', 24, false);
		animation.addByPrefix('unselected', 'Check Box unselected0', 24, false);
		animation.addByPrefix('selecting animation', 'Check Box selecting animation0', 24, false);

		this.isMenuItem = isMenuItem;
	}

	override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);
	
			y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.16);
			x = FlxMath.lerp(x, (targetY * 20) + 90, 0.16);
		}
	
		super.update(elapsed);
	}
}
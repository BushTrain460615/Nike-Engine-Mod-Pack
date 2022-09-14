package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class NoteSplash extends FlxSprite
{
	public function new(x:Float, y:Float, note:Note)
	{
		super(x, y);
		frames = Paths.getSparrowAtlas('noteSplashes');
		animation.addByPrefix('note1-0', 'note impact 1  blue', 24, false);
		animation.addByPrefix('note1-1', 'note impact 2 blue', 24, false);
		animation.addByPrefix('note2-0', 'note impact 1 green', 24, false);
		animation.addByPrefix('note2-1', 'note impact 2 green', 24, false);
		animation.addByPrefix('note0-0', 'note impact 1 purple', 24, false);
		animation.addByPrefix('note0-1', 'note impact 2 purple', 24, false);
		animation.addByPrefix('note3-0', 'note impact 1 red', 24, false);
		animation.addByPrefix('note3-1', 'note impact 2 red', 24, false);
		scale.set(0.85, 0.85);
		antialiasing = Settings.Antialiasing;
	    switch (note.noteData) {
			case 0:
				animation.play('note0-' + FlxG.random.int(0, 1), true);
			case 1:
				animation.play('note1-' + FlxG.random.int(0, 1), true);
			case 2:
				animation.play('note2-' + FlxG.random.int(0, 1), true);
			case 3:
				animation.play('note3-' + FlxG.random.int(0, 1), true);
		}
	}

	/*
	Cool functions to remember! -Junior
	This - Gets the name for this bullshit!
	I forgot lol - Junior is stupid
	*/

	override public function update(elapsed:Float)
	{
		FlxTween.tween(this, {alpha: 0}, 0.2, {
			startDelay: 0.05,
			onComplete: function(tween:FlxTween)
			{
				if (animation.curAnim.finished)
					kill();
			},
		});
		
		super.update(elapsed);
	}
}
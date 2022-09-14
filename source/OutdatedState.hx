package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import openfl.Assets;

class OutdatedState extends MusicBeatState
{
	var txt:FlxText;
	public static var alreadySeen:Bool = false;

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		txt = new FlxText(0, 64, FlxG.width, "", 32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		add(txt);

		txt.text = 
		"Yo!, You are running an outdated version of
		\n
		Nike Engine (" + Startup.curVersion + "),
		\n
		You should update to the latest github version of 
		\n
		Nike Engine (" + Startup.onlineVer + ").
		\n
		Thank you for using Nike Engine!
		\n
		\n
		\n
		\n
		Press ESCAPE to leave.";
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT) {
			#if linux
			Sys.command('/usr/bin/xdg-open', ["https://github.com/JuniorNovoa1/Nike-Engine/releases", "&"]);
			#else
			FlxG.openURL('https://github.com/JuniorNovoa1/Nike-Engine/releases');
			#end
		}

		if (controls.ACCEPT || controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
			alreadySeen = true;
		}
		super.update(elapsed);
	}
}

package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import lime.app.Application;
import flixel.system.FlxSound;
#if sys
import sys.FileSystem;
import sys.io.File;
#else
import openfl.utils.Assets as FileSystem;
#end

using StringTools;

class FreeplaySelect extends MusicBeatState
{
	var menu:Array<MenuDeta> = [];

	var selector:FlxText;
	var curSelected:Int = 0;

	var bg:FlxSprite;

	private var grpSongs:FlxTypedGroup<Alphabet>;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		addMenu('Main Songs');
		addMenu('Mod Songs');
		addMenu('Misc Songs');

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...menu.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menu[i].menuName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
		}

		changeSelection();

		super.create();
	}

	public function addMenu(MenuName:String)
	{
		menu.push(new MenuDeta(MenuName));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (FlxG.mouse.wheel != 0)
			changeSelection(-Math.round(FlxG.mouse.wheel / 4));


		if (controls.BACK) {
			FlxG.switchState(new MainMenuState());
		}

		if (accepted) {
			if (curSelected == 0) {
				FreeplayState.modSongs = false;
				FreeplayState.miscSongs = false;
			} else if (curSelected == 1) {
				FreeplayState.modSongs = true;
				FreeplayState.miscSongs = false;
			} else if (curSelected == 2) {
				FreeplayState.modSongs = false;
				FreeplayState.miscSongs = true;
			}

			#if html5
			FlxG.switchState(new FreeplayState());
			#else
			LoadingState.loadAndSwitchState(new FreeplayState());
			#end
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = menu.length - 1;
		if (curSelected >= menu.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class MenuDeta
{
	public var menuName:String = "";

	public function new(menu:String)
	{
		this.menuName = menu;
	}
}

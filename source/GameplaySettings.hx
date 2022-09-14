package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.FlxCamera;

using StringTools;

class GameplaySettings extends MusicBeatSubstate
{
	var menu:Array<MenuOptions> = [];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var grpCheckboxes:FlxTypedGroup<Checkbox>;

	private var camGame:FlxCamera;

	private static var curSelected:Int = 0;

	public function new()
	{
		super();
	}

	override public function create()
	{
		camGame = new FlxCamera();
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camGame);

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		grpCheckboxes = new FlxTypedGroup<Checkbox>();
		add(grpCheckboxes);

		addOptions('Low Detail');
		addOptions('Ghost Tapping');
		addOptions('Antialiasing');
		addOptions('Hide Ratings');

		for (i in 0...menu.length)
		{
			var optiontext:Alphabet = new Alphabet(0, (70 * i) + 30, menu[i].menuName, true, false);
			optiontext.isMenuItem = true;
			optiontext.targetY = i;
			optiontext.ID = i;

			var checkbox:Checkbox = new Checkbox(optiontext.width +50, (70 * i) + 30, true);
			checkbox.antialiasing = Settings.Antialiasing;
			checkbox.setGraphicSize(Std.int(checkbox.width * 0.7));
			checkbox.updateHitbox();
			add(checkbox);

			checkbox.isMenuItem = true;
			checkbox.targetY = i;
			checkbox.ID = i;

			grpOptions.add(optiontext);
			grpCheckboxes.add(checkbox);
		}

		for (item in grpCheckboxes.members) {
			if (item.ID == 0) {
				if (Settings.LowDetail) {
					item.animation.play('selecting animation');
					item.offset.set(17, 70);
				}
				else {
					item.animation.play('unselected');
					item.offset.set();
				}
			}
	
			if (item.ID == 1) {
				if (Settings.GhostTapping) {
					item.animation.play('selecting animation');
					item.offset.set(17, 70);
				}
				else {
					item.animation.play('unselected');
					item.offset.set();
				}
			}
	
			if (item.ID == 2) {
				if (Settings.Antialiasing) {
					item.animation.play('selecting animation');
					item.offset.set(17, 70);
				}
				else {
					item.animation.play('unselected');
					item.offset.set();
				}
			}

			if (item.ID == 3) {
				if (Settings.HideRatings) {
					item.animation.play('selecting animation');
					item.offset.set(17, 70);
				}
				else {
					item.animation.play('unselected');
					item.offset.set();
				}
			}
		}

		changeSelection();
	}

	public function addOptions(MenuOption:String)
	{
		menu.push(new MenuOptions(MenuOption));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK) {
			FlxG.switchState(new OptionsState());
		}

		if (controls.UP_P) {
			changeSelection(-1);
		}

		if (controls.DOWN_P) {
			changeSelection(1);
		}

		if (FlxG.mouse.wheel != 0) {
			changeSelection(-Math.round(FlxG.mouse.wheel / 4));
		}

		WaitingToAccept();
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
		var bullShit2:Int = 0;
	
		for (item in grpOptions.members)
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

		for (item in grpCheckboxes.members)
		{
		    item.targetY = bullShit2 - curSelected;
			bullShit2++;
		
			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));
		
			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	var trueanimation:Bool = false;

	function WaitingToAccept() {
		if (controls.ACCEPT) {
			FlxG.sound.play(Paths.sound('confirmMenu'));

			var antiSPAM:Bool = false;
			var antiSPAM2:Bool = false;

			for (item in grpOptions.members) {
				if (curSelected == 0 && !antiSPAM) {
					if (Settings.LowDetail) {
						trace('changed to false!');
						Settings.LowDetail = false;
						Settings.SettingsSave();
						trueanimation = false;
					}
					else {
						trace('changed to true!');
						Settings.LowDetail = true;
						Settings.SettingsSave();
						trueanimation = true;
					}
				}
		
				if (curSelected == 1 && !antiSPAM) {
					if (Settings.GhostTapping) {
						trace('changed to false!');
						Settings.GhostTapping = false;
						Settings.SettingsSave();
						trueanimation = false;
					}
					else {
						trace('changed to true!');
						Settings.GhostTapping = true;
						Settings.SettingsSave();
						trueanimation = true;
					}
				}
		
				if (curSelected == 2 && !antiSPAM) {
					if (Settings.Antialiasing) {
						trace('changed to false!');
						Settings.Antialiasing = false;
						Settings.SettingsSave();
						trueanimation = false;
					}
					else {
						trace('changed to true!');
						Settings.Antialiasing = true;
						Settings.SettingsSave();
						trueanimation = true;
					}
				}
	
				if (curSelected == 3 && !antiSPAM) {
					if (Settings.HideRatings) {
						trace('changed to false!');
						Settings.HideRatings = false;
						Settings.SettingsSave();
						trueanimation = false;
					}
					else {
						trace('changed to true!');
						Settings.HideRatings = true;
						Settings.SettingsSave();
						trueanimation = true;
					}
				}

				antiSPAM = true;
			}

			var FuckMyLife:Int = curSelected;
			FlxG.switchState(new GameplaySettings());
			GameplaySettings.curSelected = FuckMyLife;
			/*
			for (item in grpCheckboxes.members)
			{
				if (!antiSPAM2) {
					if (item.ID == curSelected && trueanimation) {
						item.animation.play('selecting animation');
						item.offset.set(17, 70);
					} else if (item.ID == curSelected && !trueanimation) {
						item.animation.play('unselected');
						item.offset.set();
					}
				}

				antiSPAM2 = true;
			}
			*/
		}
	}

	/*
	function ChangeSettings(SettingtoChange:Dynamic, enable:Bool) {
		if (enable) {
			SettingtoChange = true;
		} else {
			SettingtoChange = false;
		}

		Settings.SettingsSave();
	} */ //lol!
}

class MenuOptions
{
	public var menuName:String = "";

	public function new(menu:String)
	{
		this.menuName = menu;
	}
}

package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import openfl.Assets;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var logo:FlxSprite;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = [
		'story_mode',
	    'freeplay',
	    'donate',
	    'options'
	    ];
	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);

		Application.current.window.title = 'Nike Engine - In the Menus';
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		OutdatedState.alreadySeen = true;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = Settings.Antialiasing;
		add(bg);


		// i made this code for psych engine mainly but i just added it here because i was bored
		var blackbar:FlxSprite = new FlxSprite(60).loadGraphic(Paths.image('blackbar'));
		blackbar.scrollFactor.x = 0;
		blackbar.scrollFactor.y = 0;
		blackbar.x = -220;
		blackbar.setGraphicSize(Std.int(blackbar.width * 1.3));
		blackbar.antialiasing = Settings.Antialiasing;
		add(blackbar);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = Settings.Antialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 0.7;

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.x = 20;
			//menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = 0.135;
			menuItem.scrollFactor.set(0);
			menuItem.antialiasing = Settings.Antialiasing;
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		var nikeversionShit:FlxText = new FlxText(5, FlxG.height - 36, 0, "Nike Engine v " + Startup.curVersion, 12);
		nikeversionShit.scrollFactor.set();
		nikeversionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(nikeversionShit);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		logo = new FlxSprite(420, 30).loadGraphic(Paths.image('logoBumpin'));//Thats the logo that appears in the menu
		logo.frames = Paths.getSparrowAtlas('logoBumpin');//here put the name of the xml
		logo.animation.addByPrefix('idleR', 'logo bumpin', 24, true);//on 'idle normal' change it to your xml one
		logo.animation.play('idleR');//you can rename the anim however you want to
		logo.scrollFactor.set();
		logo.scale.set(0.8, 0.8);
		logo.antialiasing = Settings.Antialiasing;
		add(logo);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					trace("" + FlxG.camera.angle);
					FlxTween.tween(FlxG.camera, {zoom: 75}, 0.9, {ease: FlxEase.quadInOut});
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										FlxG.switchState(new StoryMenuState());
									    trace("Story Menu Selected");
										
									case 'freeplay':
										FlxG.switchState(new FreeplaySelect());
										trace("Freeplay Menu Selected");

									case 'options':
										transIn = FlxTransitionableState.defaultTransIn;
										transOut = FlxTransitionableState.defaultTransOut;
	
										FlxG.switchState(new OptionsState());
										trace("Options Menu Selected");
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}

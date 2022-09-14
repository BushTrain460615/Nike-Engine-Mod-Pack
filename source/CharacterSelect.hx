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
#end

using StringTools;

class CharacterSelect extends MusicBeatState
{
	var money:Alphabet = new Alphabet(0, 0, 'Character Select', true, false);
	var chars:Array<String> = ['bf', 'bf-car', 'bf-christmas', 'bf-pixel', 'bf-holding-gf', 'pico-player'#if mods , '3d-bf', 'bf-encore', 'sonic-running' #end];
	var grpBF:FlxTypedGroup<Character>;
	var curSelected:Int = 0;
	var timer:Float = 0.35;
	var FunniX:Float = 400;

	var bf:Character;
	var bfcar:Character;
	var bfChristmas:Character;
	var bfpixel:Character;
	var bfHoldingGF:Character;
	var picoplayer:Character;
	var sonicrunning:Character;

	#if mods
	var bf3d:Character;
	var bfencore:Character;
	#end

	override public function create()
	{
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = Settings.Antialiasing;
		add(bg);

		money.screenCenter(X);
		money.y += 50;
		add(money);

		grpBF = new FlxTypedGroup<Character>();
		add(grpBF);

		bf = new Character(440, 142, chars[0]);
		add(bf);
		bf.ID = 0;
		grpBF.add(bf);

		bfcar = new Character(420, 140, chars[1]);
		add(bfcar);
		bfcar.ID = 1;
		grpBF.add(bfcar);

		bfChristmas = new Character(420, 140, chars[2]);
		add(bfChristmas);
		bfChristmas.ID = 2;
		grpBF.add(bfChristmas);

		bfpixel = new Character(613, 283, chars[3]);
		bfpixel.antialiasing = false;
		add(bfpixel);
		bfpixel.ID = 3;
		grpBF.add(bfpixel);

		bfHoldingGF = new Character(400, 130, chars[4]);
		add(bfHoldingGF);
		bfHoldingGF.ID = 4;
		grpBF.add(bfHoldingGF);

		picoplayer = new Character(412, 124, chars[5]);
		add(picoplayer);
		picoplayer.ID = 5;
		grpBF.add(picoplayer);

		#if mods
		bf3d = new Character(378, 118, chars[6]);
		add(bf3d);
		bf3d.ID = 6;
		grpBF.add(bf3d);

		bfencore = new Character(416, 126, chars[7]);
		add(bfencore);
		bfencore.ID = 7;
		grpBF.add(bfencore);

		sonicrunning = new Character(346, -224, chars[8]);
		sonicrunning.antialiasing = false;
		add(sonicrunning);
		sonicrunning.ID = 8;
		grpBF.add(sonicrunning);
		#end

		var text:FlxText = new FlxText(16, FlxG.height - 48, 0, "Press SPACE to select base character.", 12);
		text.scrollFactor.set();
		text.setFormat(Paths.font('comic.ttf'), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(text);

		#if desktop
		DiscordClient.changePresence("Selecting character... - Freeplay", null);
		Application.current.window.title = "Selecting character... - Freeplay";
		#end

		reload();

		// char selection...
		// to tired rn lol.
	}

	function reload() {
		for (item in grpBF.members)
		{			
			item.visible = false;
		
			if (item.ID == curSelected)
			{
				item.visible = true;
				spam = false;
			}
		}
	}

	var spam:Bool = false;

	override function update(elapsed:Float)
	{
		/*
		if (FlxG.keys.justPressed.A) {
			for (item in grpBF.members)
			{		
				if (item.ID == curSelected)
				{
					item.x -= 10;
				}
			}
		}

		if (FlxG.keys.justPressed.W) {
			for (item in grpBF.members)
			{		
				if (item.ID == curSelected)
				{
					item.y -= 10;
				}
			}
		}

		if (FlxG.keys.justPressed.S) {
			for (item in grpBF.members)
			{		
				if (item.ID == curSelected)
				{
					item.y += 10;
				}
			}
		}

		if (FlxG.keys.justPressed.D) {
			for (item in grpBF.members)
			{		
				if (item.ID == curSelected)
				{
					item.x += 10;
				}
			}
		}
		*/

		if (FlxG.keys.justPressed.LEFT && !spam) {
			curSelected -= 1;
			spam = true;

			if (curSelected < 0) {
				curSelected = chars.length - 1;
			}

			reload();
		}

		if (FlxG.keys.justPressed.RIGHT && !spam) {
			curSelected += 1;
			spam = true;

			if (curSelected == chars.length) {
				curSelected = 0;
			}

			reload();
		}

		for (item in grpBF.members)
		{			
			if (item.animation.curAnim.name == 'idle' && item.animation.curAnim.curFrame >= 12) {
				item.playAnim('idle', true);
			}
		}

		if (FlxG.keys.justPressed.ENTER && !spam) {
			spam = true;
			PlayState.SONG.player1 = chars[curSelected];
			for (item in grpBF.members)
			{			
				if (item.ID == curSelected)
				{
					trace("X: " + item.x);
					trace("Y: " + item.y);
					if (item.animation.getByName('hey') != null) {
						item.playAnim('hey', true);
					} else { 
						item.playAnim('singUP', true);    
					}
					item.debugMode = true;
				}
			}
			FlxG.sound.play(Paths.sound('confirmMenu'));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 0.9, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}

		if (FlxG.keys.justPressed.SPACE && !spam) {
			spam = true; //doesn't change char
			FlxG.sound.play(Paths.sound('confirmMenu'));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 0.9, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;
	var canIdle:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
}

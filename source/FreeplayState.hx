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

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var scoreBG:FlxSprite;
	var lerpScore:Float = 0;
	var intendedScore:Int = 0;

	var bg:FlxSprite;
	private var coolColors = [];

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var Inst:FlxSound = null;
	private var Voices:FlxSound = null;
	private var iconArray:Array<HealthIcon> = [];
	public static var modSongs:Bool = false;
	public static var miscSongs:Bool = false;

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		if (!modSongs && !miscSongs) {
			coolColors.push(0xFF9271FD); //needed lol
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		*/
		if (Settings.Cache) {
			#if !html5
			FlxG.sound.music.stop();
			#end
		} else {
			trace("Don't stop music lol!");
		}

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		if (!modSongs && !miscSongs) {
			for (i in 0...initSonglist.length)
			{
				songs.push(new SongMetadata(initSonglist[i], 1, 'gf'));
			}

		    //if (StoryMenuState.weekUnlocked[2] || isDebug)
		        addWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']);

			if (Settings.Week2Unlocked || isDebug)
				addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', 'monster'], 0xFF223344);

			if (Settings.Week3Unlocked || isDebug)
				addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico'], 0xFF941653);

			if (Settings.Week4Unlocked || isDebug)
				addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom'], 0xFFFC96D7);

			if (Settings.Week5Unlocked || isDebug)
				addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas'], 0xFFA0D1FF);

			if (Settings.Week6Unlocked || isDebug)
				addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai', 'spirit'], 0xFFFF78BF);

			if (Settings.Week7Unlocked || isDebug)
				addWeek(['Ugh', 'Guns', 'Stress'], 7, ['tankman'], 0xFFF6B604);

			if (Settings.Week8Unlocked || isDebug)
			addWeek(['Darnell', 'Lit-up', 'Hot'], 8, ['darnell']);
		} else if (modSongs && !miscSongs) {
			#if mods
			addSong('Algebra', 9, 'og-dave'); //add a song alone lol
			addSong('Ferocious', 10, 'garrett-animal', 0xFFF6B604); //add a song alone lol
			addSong('Too-Slow', 11, 'sonicexe', 0xFF223344); //add a song alone lol
			addSong('Prey', 12, 'Furnace'); //add a song alone lol
			addSong('parasite', 13, 'agoti'); //add a song alone lol
			#else
			addSong('Tutorial', 1, 'gf'); //add a song alone lol
			#end
		} else if (miscSongs && !modSongs) {
			addSong('Test', 1, 'bf-pixel', 0xFF223344);
		}

		/*
		if (sys.FileSystem.exists('assets/editable/weeks/week.txt')) {
			addWeek([Assets.getText(Paths.MODtxt('weeks/week1', [0], 'editable'))], 0, [Assets.getText(Paths.txt('weeks/week1', [1], 'editable'))]);
		}
		*/

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.antialiasing = false;
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, ?bgColor:Dynamic = 0xFF9271FD)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));

		coolColors.push(bgColor);

		if (Settings.Cache) {
			#if !html5
			if (FileSystem.exists('assets/songs/' +songName.toLowerCase() +'/Inst.ogg')) {
				FlxG.sound.cache(Paths.inst(songName.toLowerCase()));
			}

			/*
			if (FileSystem.exists('assets/songs/' +songName.toLowerCase() +'/Voices.ogg')) {
				FlxG.sound.cache(Paths.voices(songName.toLowerCase()));
			}
			*/
			trace('Just loaded: ' + songName.toLowerCase());
			//needed because lag sucks lol
			#end
		}

	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, ?bgColor:Dynamic = 0xFF9271FD)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num], bgColor);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Settings.Cache) {
			// nothing
		} else {
			if (FlxG.sound.music.volume < 0.7)
			{
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			}
		}
		//FlxG.sound.music.volume == 0;

		lerpScore = CoolUtil.coolLerp(lerpScore, intendedScore, 0.4);
		bg.color = FlxColor.interpolate(bg.color, coolColors[curSelected], CoolUtil.camLerpShit(0.045));

		scoreText.text = "PERSONAL BEST:" + Math.round(lerpScore);
		positionHighscore();

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

		if (controls.LEFT_P) {
			changeDiff(-1);
		}

		if (controls.RIGHT_P) {
			changeDiff(1);
		}


		if (controls.BACK)
		{
			#if !html5
			if (Inst != null) {
				Inst.destroy();
			}
	
			/*
			if (Voices != null) {
				Voices.destroy();
			}
			*/
			#end

			FlxG.switchState(new FreeplaySelect());
		}

		if (accepted)
		{			
			FlxG.sound.play(Paths.sound('confirmMenu'));
			var timer:Float = 0.35;
			var FunniX:Float = 200;
			FlxTween.tween(FlxG.camera, {zoom: 0}, timer, {ease: FlxEase.quadInOut,
				onComplete: function(flx:FlxTween)
				{
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					blackScreen.scale.set(10, 10);
					add(blackScreen);
				}
			});
			var bullShit:Int = 0;
			for (i in 0...iconArray.length)
			{
				iconArray[i].alpha = 0;
			}
	
			iconArray[curSelected].alpha = 1;
			var balls:Float = iconArray[curSelected].x +FunniX;
			FlxTween.tween(iconArray[curSelected], {x: balls}, timer, {ease: FlxEase.quadInOut});
			FlxFlicker.flicker(iconArray[curSelected], 1.1, 0.15, false);
	
			for (item in grpSongs.members)
			{
				item.targetY = bullShit - curSelected;
				bullShit++;
	
				item.alpha = 0;
				// item.setGraphicSize(Std.int(item.width * 0.8));
	
				if (item.targetY == 0)
				{
					item.alpha = 1;
					var balls:Float = item.x +FunniX;
					FlxTween.tween(item, {x: balls}, timer, {ease: FlxEase.quadInOut});
					FlxFlicker.flicker(item, 1.1, 0.15, false);
					// item.setGraphicSize(Std.int(item.width));
				}
			}
			
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);

			new FlxTimer().start(timer, function(tmr:FlxTimer) {
				#if html5
				LoadingState.loadAndSwitchState(new PlayState()); //character select is broken for html5 lol
				#else
				LoadingState.loadAndSwitchState(new CharacterSelect());
				#end
			});

			#if !html5
			if (Inst != null) {
				Inst.destroy();
			}
	
			/*
			if (Voices != null) {
				Voices.destroy();
			}
			*/
			#end
		}
	}

	function ChangeBGColor(color:Dynamic) {
		bg.color = color;
		//FlxTween.tween(bg, {color: color}, 0.2);
	}

	function updateText() {
		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 3;
		if (curDifficulty > 3)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Listening to music - " + songs[curSelected].songName, null);

		Application.current.window.title = 'Nike Engine - Listening to: ' + songs[curSelected].songName;
		#end

		//Inst.pause();

		if (Settings.Cache) {
			#if !html5
			if (Inst != null) {
				Inst.destroy();
			}
			Inst = new FlxSound().loadEmbedded(Paths.inst(songs[curSelected].songName));
			Inst.persist = true;
	
			/*
			if (Voices != null) {
				Voices.destroy();
			}
	
			if (curSelected != 0) {
				Voices = new FlxSound().loadEmbedded(Paths.voices(songs[curSelected].songName));
				Voices.persist = true;
			}
			*/
	
			Inst.play();
			if (curSelected != 0) {
				//Voices.play();
			}
			#end
		} else {
			trace("No gay mega sex balls");
		}

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

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

	function positionHighscore()
	{
	    scoreText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - scoreBG.scale.x / 2;
		diffText.x = scoreBG.x + scoreBG.width / 2;
		diffText.x -= diffText.width / 2;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}

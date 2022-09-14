package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import lime.app.Application;
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.display.BitmapData;
import openfl.utils.Assets as OpenFlAssets;
import flixel.graphics.FlxGraphic;
import flash.net.URLRequest;
import haxe.io.Path;
#if sys
import sys.FileSystem;
import sys.io.File;
#else
import openfl.utils.Assets as FileSystem;
#end

using StringTools;

class Startup extends MusicBeatState
{
	var bg:FlxSprite;
	public static var e:String = 'icons/icon-';
	var songs = ['tutorial', 'bopeebo', 'fresh', 'dadbattle', 'spookeez', 'south', 'monster', 'pico', 'philly', 'blammed', 'satin-panties',
    'high', 'milf', 'cocoa', 'eggnog', 'winter-horrorland', 'senpai', 'roses', 'thorns', 'ugh', 'guns', 'stress'];

	var bitmapData:Map<String, FlxGraphic>;
	public static var images:Array<Dynamic> = [];

	public static var imagesSHARED:Array<Dynamic> = [];

	public static var imagesCHARS:Array<Dynamic> = [];

	public static var curVersion:String = '';
	public static var onlineVer:String = '';

	override function create()
	{
		#if html5
		FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		FlxG.sound.music.fadeIn(4, 0, 0.7);
		#end
		
		bg = new FlxSprite().loadGraphic(Paths.image('funkay'));
		bg.scale.set(0.75, 0.75);
		bg.screenCenter();
		add(bg);

		PlayerSettings.init();
		FlxG.save.bind('funkin', 'ninjamuffin99');
		Highscore.load();
		Settings.LoadSettings();
		controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		trace("Loaded keybinds.");

		#if !html5
		#if !mods
		if (FileSystem.isDirectory('assets/shared/images/characters/mods')) {
			deleteDirRecursively('assets/shared/images/characters/mods');
			trace('Deleted: Mod Characters');
		}

		if (FileSystem.isDirectory('assets/shared/images/mods')) {
			deleteDirRecursively('assets/shared/images/mods');
			trace('Deleted: Mod Images');
		}

		if (FileSystem.isDirectory('assets/shared/sounds/mods')) {
			deleteDirRecursively('assets/shared/sounds/mods');
			trace('Deleted: Mod Sounds');
		}

		if (FileSystem.isDirectory('assets/data/algebra')) {
			deleteDirRecursively('assets/data/algebra');
			trace('Deleted: Algebra Data');
		}

		if (FileSystem.isDirectory('assets/data/ferocious')) {
			deleteDirRecursively('assets/data/ferocious');
			trace('Deleted: Ferocious Data');
		}

		if (FileSystem.isDirectory('assets/data/too-slow')) {
			deleteDirRecursively('assets/data/too-slow');
			trace('Deleted: Too-Slow Data');
		}

		if (FileSystem.isDirectory('assets/data/prey')) {
			deleteDirRecursively('assets/data/prey');
			trace('Deleted: Prey Data');
	    }

		if (FileSystem.isDirectory('assets/data/agoti')) {
			deleteDirRecursively('assets/data/agoti');
			trace('Deleted: Agoti Data');
	    }

		if (FileSystem.isDirectory('assets/songs/algebra')) {
			deleteDirRecursively('assets/songs/algebra');
			trace('Deleted: Algebra');
		}

		if (FileSystem.isDirectory('assets/songs/ferocious')) {
			deleteDirRecursively('assets/songs/ferocious');
			trace('Deleted: Ferocious');
		}

		if (FileSystem.isDirectory('assets/songs/too-slow')) {
			deleteDirRecursively('assets/songs/too-slow');
			trace('Deleted: Too-Slow');
		}

		if (FileSystem.isDirectory('assets/song/prey')) {
			deleteDirRecursively('assets/songs/prey');
			trace('Deleted: Prey');
		}

		if (FileSystem.isDirectory('assets/song/parasite')) {
			deleteDirRecursively('assets/songs/parasite');
			trace('Deleted: Parasite');
		}

		if (FileSystem.exists('assets/images/icons/icon-3d-bf.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-3d-bf.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-og-dave.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-og-dave.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-garrett.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-garrett.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-hall-monitor.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-hall-monitor.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-diamond-man.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-diamond-man.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-playrobot.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-playrobot.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-garrett-animal.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-garrett-animal.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-playtime.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-playtime.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-palooseMen.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-palooseMen.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-wizard.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-wizard.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-piano-guy.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-piano-guy.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-pedophile.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-pedophile.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-sonicexe.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-sonicexe.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-sonic-running.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-sonic-running.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-Furnace.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-Furnace.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-starved-pixel.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-starved-pixel.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.exists('assets/images/icons/icon-agoti.png')) {
			FileSystem.deleteFile('assets/images/icons/icon-agoti.png');
			trace('Deleted: Icon');
		}

		if (FileSystem.isDirectory('assets/videos/mods')) {
			deleteDirRecursively('assets/videos/mods');
			trace('Deleted: Videos');
		}
		#end
		#end

		#if !html5
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/")))
		{
			if (i.endsWith('.png')) {
				images.push(bullshits(i));
			}
		}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/icons")))
		{
			if (i.endsWith('.png')) {
				images.push('icons/' + bullshits(i));
			}
		}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/mods")))
		{
			if (i.endsWith('.png')) {
				imagesSHARED.push('mods/' + bullshits(i));
			}
		}

		if (FileSystem.isDirectory('assets/shared/images/mods/dave')) {
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/mods/dave")))
			{
				if (i.endsWith('.png')) {
					imagesSHARED.push('mods/dave/' + bullshits(i));
				}
			}

			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/mods/dave/bgJunkers")))
			{
				if (i.endsWith('.png')) {
					imagesSHARED.push('mods/dave/bgJunkers/' + bullshits(i));
				}
			}
		}

		if (FileSystem.isDirectory('assets/shared/images/mods/funnyAnimal')) {
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/mods/funnyAnimal")))
			{
				if (i.endsWith('.png')) {
					imagesSHARED.push('mods/funnyAnimal/' + bullshits(i));
				}
			}
		}

		if (FileSystem.isDirectory('assets/shared/images/mods/agoti')) {
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/mods/agoti")))
			{
				if (i.endsWith('.png')) {
					imagesSHARED.push('mods/agoti/' + bullshits(i));
				}
			}
		}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images")))
		{
			if (i.endsWith('.png')) {
				imagesCHARS.push(bullshits(i));
			}
		}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
		{
			if (i.endsWith('.png')) {
				imagesCHARS.push('characters/' + bullshits(i));
			}
		}

		if (FileSystem.isDirectory('assets/shared/images/characters/mods')) {
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters/mods")))
			{
				if (i.endsWith('.png')) {
					imagesCHARS.push('characters/mods/' + bullshits(i));
				}
			}	
		}
		#end

		//trace(images);
		//trace(imagesSHARED);
		//trace(imagesCHARS);

		curVersion = Assets.getText('Version/curVersion.txt');

		//online version!!!
		var shit = new haxe.Http("https://raw.githubusercontent.com/JuniorNovoa1/Nike-Engine/master/version/onlineVersion.txt");
		shit.onData = function(data:String){
			var lol = data.replace("", "");
			onlineVer = lol;
		}
			
		shit.onError = function(error) {
			if (error.contains('X509')) {
				onlineVer = 'Not allowed to connect to internet';
			} else {
				onlineVer = 'No Internet Connection';
			}
			trace('Error: ' + error);
		}
		shit.request();	

		trace("Online ver is: " + onlineVer);

		#if desktop
		DiscordClient.initialize();
		
		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		#end

		#if !html5
		if (Settings.Cache) {
			Cache();
		}
		else {
			Start();
		}
		#else 
		Start();
		#end
	}

	function bullshits(lol:String):String {
		var replaced = lol.replace(".png","");
		var xd:String = "" + replaced;
		trace(xd);

		return xd;
	}

	public static function getMods() {
		#if !html5
		#if mods
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("mods")))
		{
			polymod.Polymod.init({
				modRoot: "./mods/",
				dirs:[i]
			   });
			trace('Loaded mods:\n' + FileSystem.readDirectory(FileSystem.absolutePath("mods")));
		}
		#end
		#end
	}

	#if !mods
	function deleteDirRecursively(path:String):Void
	{
		#if !html5
	    if (FileSystem.isDirectory(path))
		{
			var entries = FileSystem.readDirectory(path);
			for (entry in entries) {
				if (FileSystem.isDirectory(path + '/' + entry)) {
					deleteDirRecursively(path + '/' + entry);
					FileSystem.deleteDirectory(path + '/' + entry);
				} else {
					FileSystem.deleteFile(path + '/' + entry);
				}
			}
		}
		#end
	}
	#end

	function Start() {
		trace('Finished!');
		FlxG.switchState(new TitleState());
	}

	function Cache() {
		for (i in 0...images.length) {
			//trace(images[i]);
		}

		for (i in 0...imagesSHARED.length) {
			//trace(imagesSHARED[i]);
		}

		for (i in 0...imagesCHARS.length) {
			//trace(imagesCHARS[i]);
		}

		for (i in 0...songs.length) {
			//trace(songs[i]);
			/*
			#if PRELOAD_ALL
			FlxG.sound.cache(Paths.inst(songs[i]));
			if (FileSystem.exists('assets/songs/' +songs[i] +'/Voices.ogg')) {
				FlxG.sound.cache(Paths.voices(songs[i]));
			}
			trace('Just loaded: ' + songs[i]);
			#end
			*/ //this works but just no point
		}

		//trace('Finished Caching!');
		Start();
	}
}
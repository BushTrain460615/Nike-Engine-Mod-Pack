package;

import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxG;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import flixel.tweens.FlxTween;
import openfl.display.StageScaleMode;
#if CRASH_HANDLER
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import Discord.DiscordClient;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = Startup; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	#if !html5
	public static var framerate:Int = 90; // How many frames per second the game should run at.
	#else
	public static var framerate:Int = 60; // How many frames per second the game should run at.
	#end
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		#if android
		SUtil.uncaughtErrorHandler();
		#end
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = Startup;
		#end

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
		#if android
		SUtil.check();
		#end

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash); //bush forgot to add this lol
		#end
	}
	#if CRASH_HANDLER
	//this is from izzy engine i didn't make this
	//also crdit to psych for the og crash handler

	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();
	
		dateNow = StringTools.replace(dateNow, " ", "_");
		dateNow = StringTools.replace(dateNow, ":", "'");
	
		path = "./crash/" + "NikeCrash_" + dateNow + ".txt";
	
		errMsg = "Version: " + Lib.application.meta["version"] + "\n";
	
		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}
	
		errMsg += 
		"\n
		Uncaught Error: " 
		+ 
		e.error 
		+ 
		"\n
		Please report this error to the Discord server: 
		https://discord.gg/J2HMjaUqfr
		\n
		\n
		> Crash Handler written by: sqirra-rng
		\n
		> Engine by: JuniorNovoa and Bushtrain
		\n
		> Og Crash Handler by: https://github.com/gedehari";
	
		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");
	
		File.saveContent(path, errMsg + "\n");
	
		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));
	
		var crashDialoguePath:String = "FlixelCrashHandler";
	
		#if windows
		crashDialoguePath += ".exe";
		#end
	
		if (FileSystem.exists("./" + crashDialoguePath))
		{
			Sys.println("Found crash dialog: " + crashDialoguePath);
	
			#if linux
			crashDialoguePath = "./" + crashDialoguePath;
			#end
			new Process(crashDialoguePath, [path]);
		}
		else
		{
			Sys.println("No crash dialog found! Making a simple alert instead...");
			Application.current.window.alert(errMsg, "Error!");
		}
	
		Sys.exit(1);
	}
	#end
}	

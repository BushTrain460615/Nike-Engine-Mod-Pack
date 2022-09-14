package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.display.FlxTiledSprite;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import lime.app.Application;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import lime.utils.AssetCache;
#if sys
import sys.FileSystem;
import sys.io.File;
#else
import openfl.utils.Assets as FileSystem;
#end

#if android
import android.flixel.FlxVirtualPad;
import flixel.input.actions.FlxActionInput;
import flixel.util.FlxDestroyUtil;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var practiceMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var Difficulty:Int = 1;
	public static var deathCounter:Int = 0;
	public var songStarted = false;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;
	var lostfocuspause:FlxSprite;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var opponentStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camOTHER:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = [':dad:blah blah blah', ':bf:coolswag'];

	var StageBG:FlxSprite;
	var stageFront:FlxSprite;
	var stageCurtains:FlxSprite;

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var colors:Array<Dynamic> = CoolUtil.coolTextFile(Paths.mechanicsTxt('configs/phillyColors'));
	var phillyColors:Array<FlxColor> = [];
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;
	var light:FlxSprite;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	//tankman shit
	var smokeL:FlxSprite;
	var smokeR:FlxSprite;
	var tankWatchtower:FlxSprite;
	var tankGround:FlxSprite;
	var tankmanRun:FlxTypedGroup<TankmenBG>;
	var tankdude1:FlxSprite;
	var tankdude2:FlxSprite;
	var tankdude3:FlxSprite;
	var tankdude4:FlxSprite;
	var tankdude5:FlxSprite;
	var tankdude6:FlxSprite;

	//helper shit
	public static var bg:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var timeTxt:FlxText;
	var songScore:Int = 0;
	var songTxt:FlxText;
	var missesTxt:FlxText;
	var scoreTxt:FlxText;
	var ratingTxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	var misses:Int = 0;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	//healthbar shit lol
	private var OpponentHealthbar:Dynamic = 0xFFFF0000;
	private var BFHealthbar:Dynamic = FlxColor.fromRGB(0, 185, 220);
	var oldIcon:Bool = false;

	//score
	private var PixelSONG:Bool = false;
	private var week7zoom:Bool = false;
	//private var tankmanHEAVEN:Bool = false;
	private var score:Int = 0;
	private var daRating:String = "";

	private var DialoguePath:String = "";

	//mod shit!!!!
	var modStageFILE = "";
	var stageMOD:Bool = false;
	var songName:String = '';

	#if desktop
	// Discord RPC variables
	public static var storyDifficultyText:String = "";
	public static var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	public static var detailsPausedText:String = "";
	#end

	//hit notes shit
	var NormalAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];
	var AltAnimations:Array<String> = ['singLEFT-alt', 'singDOWN-alt', 'singUP-alt', 'singRIGHT-alt'];
	var altAnim:String = "";
	private var babyArrow:FlxSprite;
	var dadNoteData:Int = 0;

	//endsong stuff
	var endingSong:Bool = false;

	//camera bullshit
	var camPos:FlxPoint;
	var ForceCameraInCenter:Bool = false;

	//milf mid song bs
	var MilfMechanic:Bool = false;
	var blackBars:FlxSprite;
	var blackBars2:FlxSprite;

	var offset:Float = 25;
	var CamMovement:FlxTween;

	var blackScreenBG:FlxSprite;
	#if mods
	//LOL XD
	var flipNotesPos:Bool = false;

	var schoolSTATIC:FlxSprite;
	var RUNBITCH:FlxSprite;
	var RUNBITCHSTATIC:FlxSprite;
	var BFLEGS2:FlxSprite;
	var Jail:FlxSprite;
	var blackScreen:FlxSprite;
	var IPADBG:FlxSprite;
	var IPAD:FlxSprite;
	var PEDOPHILESTATIC:FlxSprite;
	var POLICECAR:FlxSprite;

	var yoMAMA1:FlxTween;
	var yoMAMA2:FlxTween;
	var cameraOFFSET:Float = 0;

	//sonic.exe
	var TooSlowSKY:FlxSprite;
	var treesFarthest:FlxSprite;
	var treesFar:FlxSprite;
	var treesMid:FlxSprite;
	var treesOuterMid:FlxSprite;
	var treesLeft:FlxSprite;
	var treesRight:FlxSprite;
	var bushUp:FlxSprite;
	var bottomBush:FlxSprite;
	var grass:FlxSprite;
	var grassFG:FlxSprite;
	var EggmanDead:FlxSprite;
	var Tailz:FlxSprite;
	var TailzSIGN:FlxSprite;
	var Tailz2:FlxSprite;
	var KnucklesDead:FlxSprite;
	var daJumpscare:FlxSprite = new FlxSprite(0, 0);
	var daNoteStatic:FlxSprite = new FlxSprite(0, 0);

	//prey
	var funnitext:FlxText;
	var BGSpeed:Int = 0;
	var StarvedPixelBG:FlxTiledSprite;
	var StarvedPixelBGFloor:FlxTiledSprite;
	var FurnaceLol:FlxSprite;
	#end

	//Video cutscnene shit
	#if !html5
	var video:VideoHandler = new VideoHandler();
	#else
	var video:FlxVideo;
	#end

	// a
	var sicks:Int = 0;
	var goods:Int = 0;
	var bads:Int = 0;
	var shits:Int = 0;

	var SicksText:FlxText;
	var GoodsText:FlxText;
	var BadsText:FlxText;
	var ShitsText:FlxText;
	var MissesText:FlxText;

	//FNF Lyricals
	var hasLyrics:Bool = false;

	var lyricSteps:Array<String>;
	var curLyrStep:String = '';
	var lyrText:String = '';
	var lyrAdded:Bool = false;

	var lyrObj:FlxText;

	override public function create()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		camOTHER = new FlxCamera();
		camOTHER.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camOTHER);

		FlxCamera.defaultCameras = [camGame];

		switch (SONG.song.toLowerCase()) {
			case 'senpai' | 'roses' | 'thorns' #if mods | 'prey' #end:
				camGame.antialiasing = false;
				camHUD.antialiasing = false;
				camOTHER.antialiasing = false;
			default:
				camGame.antialiasing = Settings.Antialiasing;
				camHUD.antialiasing = Settings.Antialiasing;
				camOTHER.antialiasing = Settings.Antialiasing;
		}

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial-hard', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		/*
		for (i in 0...colors.length)
		{
			Std.parseInt(colors[i]);
			phillyColors.push(colors[i]);
		} */ //this just return black as a color for some reason...
		phillyColors.push(FlxColor.WHITE); //1
		phillyColors.push(FlxColor.LIME); //2
		phillyColors.push(FlxColor.PURPLE); //3
		phillyColors.push(FlxColor.RED); //4
		phillyColors.push(FlxColor.YELLOW); //5
		phillyColors.push(FlxColor.PINK); //6
		phillyColors.push(FlxColor.CYAN); //7
		phillyColors.push(FlxColor.BLUE); //8
		phillyColors.push(FlxColor.MAGENTA); //9
		phillyColors.push(FlxColor.BROWN); //10
		phillyColors.push(FlxColor.fromRGB(255, 140, 0)); //11
		phillyColors.push(FlxColor.fromRGB(0, 200, 50)); //12
		phillyColors.push(FlxColor.fromRGB(100, 125, 100)); //13
		phillyColors.push(FlxColor.fromRGB(100, 50, 25)); //14
		phillyColors.push(FlxColor.fromRGB(200, 210, 50)); //15
		phillyColors.push(FlxColor.fromRGB(50, 100, 25)); //16
		phillyColors.push(FlxColor.fromRGB(75, 85, 90)); //17
		phillyColors.push(FlxColor.fromRGB(45, 100, 50)); //18
		phillyColors.push(FlxColor.fromRGB(25, 170, 20)); //19
		phillyColors.push(FlxColor.fromRGB(70, 140, 50)); //20

		/*
		if (FileSystem.exists('assets/editable/stages/' +SONG.song.toLowerCase() +'.txt')) {
			modStageFILE = CoolUtil.coolTextFile('assets/editable/stages/' +SONG.song.toLowerCase() +'.txt');
			stageMOD = true;
		}

		songName = '' + SONG.song;
		songName.toLowerCase();
		*/

		if (isStoryMode) {
			switch (SONG.song.toLowerCase())
			{
				case 'lol':
					//yo mama!
				default:
					if (FileSystem.exists(Paths.txt(SONG.song.toLowerCase() + '/' + SONG.song.toLowerCase() + 'Dialogue' + '.txt'))) {
						DialoguePath = Paths.txt(SONG.song.toLowerCase() + '/' + SONG.song.toLowerCase() + 'Dialogue');
						dialogue = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/' + SONG.song.toLowerCase() + 'Dialogue'));
						//auto detects dialogue!
					}
			} //storymode dialogue
		} else {
			switch (SONG.song.toLowerCase())
			{
				case 'lol':
					//yo mama!
				default:
					if (FileSystem.exists(Paths.txt(SONG.song.toLowerCase() + '/' + SONG.song.toLowerCase() + 'FreeplayDialogue' + '.txt'))) {
						DialoguePath = Paths.txt(SONG.song.toLowerCase() + '/' + SONG.song.toLowerCase() + 'FreeplayDialogue');
						dialogue = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase() + '/' + SONG.song.toLowerCase() + 'FreeplayDialogue'));
						//auto detects dialogue!
					}
			} //freeplay dialogue
		}
		#if sys
 		// Lyrical stuff
 		hasLyrics = FileSystem.exists(Paths.lyric((StringTools.replace(PlayState.SONG.song," ","-").toLowerCase())  + "/lyrics"));
 		trace('Lyric File: ' + hasLyrics + " - " + Paths.lyric(PlayState.SONG.song.toLowerCase() + "/lyrics"));

 		lyricSteps = null;
 		if (hasLyrics)
 		{
 			lyricSteps = CoolUtil.coolTextFile(Paths.lyric((StringTools.replace(PlayState.SONG.song," ","-").toLowerCase()) + "/lyrics"));
 			var splitStep:Array<String> = lyricSteps[0].split(":");
 			curLyrStep = splitStep[1];
 			lyrText = lyricSteps[0].substr(splitStep[1].length + 2).trim();
 		}

 		lyrAdded = false;
 		#end

		Difficulty = storyDifficulty;
		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
			case 3:
				storyDifficultyText = "Erect";
		}

		Application.current.window.title = 'Nike Engine - Playing: ' + SONG.song + ' - ' + storyDifficultyText;

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek + "(" +storyDifficulty + ")";
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end

		switch (SONG.song.toLowerCase())
		{
            case 'spookeez' | 'monster' | 'south': {
                curStage = 'spooky';
	            halloweenLevel = true;

		        var hallowTex = Paths.getSparrowAtlas('halloween_bg');

	            halloweenBG = new FlxSprite(-200, -100);
		        halloweenBG.frames = hallowTex;
	            halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
	            halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
	            halloweenBG.animation.play('idle');
	            halloweenBG.antialiasing = Settings.Antialiasing;
	            add(halloweenBG);

		        isHalloween = true;
		    }
		    case 'pico' | 'blammed' | 'philly': {
		        curStage = 'philly';

		        var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
		        bg.scrollFactor.set(0.1, 0.1);
				bg.antialiasing = Settings.Antialiasing;
		        add(bg);

				if (!Settings.LowDetail) {
					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					city.antialiasing = Settings.Antialiasing;
					add(city);
	
					light = new FlxSprite(city.x).loadGraphic(Paths.image('philly/windows'));
					light.scrollFactor.set(0.3, 0.3);
					light.alpha = 1;
					light.color = phillyColors[(FlxG.random.int(0, phillyColors.length))];
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = Settings.Antialiasing;
					add(light);
	
					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
					streetBehind.antialiasing = Settings.Antialiasing;
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
					phillyTrain.antialiasing = Settings.Antialiasing;
					add(phillyTrain);
	
					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
					FlxG.sound.list.add(trainSound);
				}

		        // var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

		        var street:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/street'));
	            add(street);
		    }
		    case 'milf' | 'satin-panties' | 'high': {
		        curStage = 'limo';
		        defaultCamZoom = 0.90;

		        var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
		        skyBG.scrollFactor.set(0.1, 0.1);
				skyBG.antialiasing = Settings.Antialiasing;
		        add(skyBG);

				if (!Settings.LowDetail) {
					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					bgLimo.antialiasing = Settings.Antialiasing;
					add(bgLimo);
	
					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);
	
					for (i in 0...5) {
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}
	
					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
					overlayShit.alpha = 0.5;
					/*
					add(overlayShit);

					var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);
					FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);
					overlayShit.shader = shaderBullshit;
					*/

					/*
				    var funny:OverlayShader;
		            funny = new OverlayShader();
		            camGame.setFilters([new ShaderFilter(funny)]);
	            	camHUD.setFilters([new ShaderFilter(funny)]);
					*/
				}

		        var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

		        limo = new FlxSprite(-120, 550);
		        limo.frames = limoTex;
		        limo.animation.addByPrefix('drive', "Limo stage", 24);
		        limo.animation.play('drive');
		        limo.antialiasing = Settings.Antialiasing;

				if (!Settings.LowDetail) {
					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
					// add(limo);
				}
		    }
		    case 'cocoa' | 'eggnog': {
	            curStage = 'mall';

		        defaultCamZoom = 0.80;

		        var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
		        bg.antialiasing = Settings.Antialiasing;
		        bg.scrollFactor.set(0.2, 0.2);
		        bg.active = false;
		        bg.setGraphicSize(Std.int(bg.width * 0.8));
		        bg.updateHitbox();
		        add(bg);

				if (!Settings.LowDetail) {
					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = Settings.Antialiasing;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);
				}

		        var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
		        bgEscalator.antialiasing = Settings.Antialiasing;
		        bgEscalator.scrollFactor.set(0.3, 0.3);
		        bgEscalator.active = false;
		        bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
		        bgEscalator.updateHitbox();
		        add(bgEscalator);

				if (!Settings.LowDetail) {
					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
					tree.antialiasing = Settings.Antialiasing;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);
	
					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = Settings.Antialiasing;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					add(bottomBoppers);
				}

		        var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
		        fgSnow.active = false;
		        fgSnow.antialiasing = Settings.Antialiasing;
		        add(fgSnow);

				if (!Settings.LowDetail) {
					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = Settings.Antialiasing;
					add(santa);
				}
		    }
		    case 'winter-horrorland': {
		        curStage = 'mallEvil';
		        var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
		        bg.antialiasing = Settings.Antialiasing;
		        bg.scrollFactor.set(0.2, 0.2);
		        bg.active = false;
		        bg.setGraphicSize(Std.int(bg.width * 0.8));
		        bg.updateHitbox();
		        add(bg);

				if (!Settings.LowDetail) {
					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
					evilTree.antialiasing = Settings.Antialiasing;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);
				}

		        var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
	            evilSnow.antialiasing = Settings.Antialiasing;
		        add(evilSnow);
            }
		    case 'senpai' | 'roses': {
		        curStage = 'school';

		        // defaultCamZoom = 0.9;

		        var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
		        bgSky.scrollFactor.set(0.1, 0.1);
		        add(bgSky);

		        var repositionShit = -200;
				var widShit = Std.int(bgSky.width * 6);

				if (!Settings.LowDetail) {
					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					bgSchool.setGraphicSize(widShit);
					bgSchool.updateHitbox();
				}

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

				if (!Settings.LowDetail) {
					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);
	
					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);
	
					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();
				}

				bgSky.setGraphicSize(widShit);
		        bgStreet.setGraphicSize(widShit);
		        bgSky.updateHitbox();
				bgStreet.updateHitbox();

				if (!Settings.LowDetail) {
					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);
	
					if (SONG.song.toLowerCase() == 'roses') {
						bgGirls.getScared();
					}
	
					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
				}

				PixelSONG = true;
		    }
		    case 'thorns': {
		        curStage = 'schoolEvil';

		        var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
		        var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

		        var posX = 400;
	            var posY = 200;

		        var bg:FlxSprite = new FlxSprite(posX, posY);
		        bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
		        bg.animation.addByPrefix('idle', 'background 2', 24);
		        bg.animation.play('idle');
		        bg.scrollFactor.set(0.8, 0.9);
		        bg.scale.set(6, 6);
		        add(bg);

				PixelSONG = true;
		    }
			case 'guns' | 'stress' | 'ugh': {
				defaultCamZoom = 0.9;

				curStage = 'tank';

				var sky:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image('tankSky', 'week7'));
				sky.scale.set(4, 9);
				sky.antialiasing = Settings.Antialiasing;
				add(sky);
				
				if (!Settings.LowDetail) {
					var clouds:FlxSprite = new FlxSprite(FlxG.random.int(-700, -100), FlxG.random.int(-20, 20)).loadGraphic(Paths.image('tankClouds'));
					clouds.scrollFactor.set(0.1, 0.1);
					clouds.velocity.x = FlxG.random.float(5, 15);
					clouds.antialiasing = Settings.Antialiasing;
					add(clouds);
				}

				var mountains:FlxSprite = new FlxSprite(-300, -20).loadGraphic(Paths.image('tankMountains', 'week7'));
				mountains.setGraphicSize(Std.int(mountains.width * 1.2));
				mountains.updateHitbox();
				mountains.scrollFactor.set(0.2, 0.2);
				mountains.antialiasing = Settings.Antialiasing;
				add(mountains);

				if (!Settings.LowDetail) {
					var buildings:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tankBuildings', 'week7'));
					buildings.setGraphicSize(Std.int(buildings.width * 1.1));
					buildings.updateHitbox();
					buildings.scrollFactor.set(0.3, 0.3);
					buildings.antialiasing = Settings.Antialiasing;
					add(buildings);
	
					var ruins:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tankRuins', 'week7'));
					ruins.setGraphicSize(Std.int(buildings.width * 1.1));
					ruins.updateHitbox();
					ruins.scrollFactor.set(0.3, 0.3);
					ruins.antialiasing = Settings.Antialiasing;
					add(ruins);
	
					smokeL = new FlxSprite(-200, -100);
					smokeL.frames = Paths.getSparrowAtlas('smokeLeft', 'week7');
					smokeL.animation.addByPrefix('smoke', 'SmokeBlurLeft', 24, true);
					smokeL.animation.play('smoke');
					smokeL.scrollFactor.set(0.4, 0.4);
					smokeL.antialiasing = Settings.Antialiasing;
					add(smokeL);
	
					smokeR = new FlxSprite(1100, -100);
					smokeR.frames = Paths.getSparrowAtlas('smokeRight', 'week7');
					smokeR.animation.addByPrefix('smoke', 'SmokeRight', 24, true);
					smokeR.animation.play('smoke');
					smokeR.scrollFactor.set(0.4, 0.4);
					smokeR.antialiasing = Settings.Antialiasing;
					add(smokeR);
	
					tankWatchtower = new FlxSprite(100, 50);
					tankWatchtower.frames = Paths.getSparrowAtlas('tankWatchtower', 'week7');
					tankWatchtower.animation.addByPrefix('watching', 'watchtower gradient color', 24, true);
					tankWatchtower.animation.play('watching');
					tankWatchtower.scrollFactor.set(0.5, 0.5);
					tankWatchtower.antialiasing = Settings.Antialiasing;
					add(tankWatchtower);

				    tankGround = new FlxSprite(300, 350);
				    tankGround.frames = Paths.getSparrowAtlas('tankRolling', 'week7');
				    tankGround.animation.addByPrefix('tank', 'BG tank w lighting', 24, true);
				    tankGround.animation.play('tank');
					tankGround.scrollFactor.set(0.5, 0.5);
					tankGround.antialiasing = Settings.Antialiasing;
					add(tankGround);
				}

				tankmanRun = new FlxTypedGroup<TankmenBG>();
				add(tankmanRun);

				var ground:FlxSprite = new FlxSprite(-420, -150).loadGraphic(Paths.image('tankGround', 'week7'));
				ground.antialiasing = Settings.Antialiasing;
				ground.setGraphicSize(Std.int(1.15 * ground.width));
				ground.updateHitbox();
				add(ground);

				if (!Settings.LowDetail) {
					tankdude1 = new FlxSprite(-500, 650);
					tankdude1.frames = Paths.getSparrowAtlas('tank0', 'week7');
					tankdude1.animation.addByPrefix('tank', 'fg tankhead far right instance 1', 24, true);
					tankdude1.animation.play('tank');
					tankdude1.scrollFactor.set(1.7, 1.5);
					tankdude1.antialiasing = Settings.Antialiasing;
				
					tankdude2 = new FlxSprite(-300, 750);
					tankdude2.frames = Paths.getSparrowAtlas('tank1', 'week7');
					tankdude2.animation.addByPrefix('tank', 'fg tankhead 5 instance 1', 24, true);
					tankdude2.animation.play('tank');
					tankdude2.scrollFactor.set(2, 0.2);
					tankdude2.antialiasing = Settings.Antialiasing;
				
					tankdude3 = new FlxSprite(450, 940);
					tankdude3.frames = Paths.getSparrowAtlas('tank2', 'week7');
					tankdude3.animation.addByPrefix('tank', 'foreground man 3 instance 1', 24, true);
					tankdude3.animation.play('tank');
					tankdude3.scrollFactor.set(1.5, 1.5);
					tankdude3.antialiasing = Settings.Antialiasing;
				
					tankdude4 = new FlxSprite(1300, 900);
					tankdude4.frames = Paths.getSparrowAtlas('tank4', 'week7');
					tankdude4.animation.addByPrefix('tank', 'fg tankman bobbin 3 instance 1', 24, true);
					tankdude4.animation.play('tank');
					tankdude4.scrollFactor.set(1.5, 1.5);
					tankdude4.antialiasing = Settings.Antialiasing;
				
					tankdude5 = new FlxSprite(1620, 700);
					tankdude5.frames = Paths.getSparrowAtlas('tank5', 'week7');
					tankdude5.animation.addByPrefix('tank', 'fg tankhead far right instance 1', 24, true);
					tankdude5.animation.play('tank');
					tankdude5.scrollFactor.set(1.5, 1.5);
					tankdude5.antialiasing = Settings.Antialiasing;

					tankdude6 = new FlxSprite(1300, 1200);
					tankdude6.frames = Paths.getSparrowAtlas('tank3', 'week7');
					tankdude6.animation.addByPrefix('tank', 'fg tankhead 4 instance 1', 24, true);
					tankdude6.animation.play('tank');
					tankdude6.scrollFactor.set(3.5, 2.5);
					tankdude6.antialiasing = Settings.Antialiasing;

					//image, library, x, y, scrollfactor x, scrollfactor y, screencenter, animated, xml code, loops
					/*
					var bg:BackgroundHelper = new BackgroundHelper('tank3', 'week7', 1300, 1200, 3.5, 2.5, true);
					bg.AddAnimation('tank', 'fg tankhead 4 instance 1', 24, true);
					bg.PlayAnimation('tank');
					bg.Antialiasing(true);
				    add(bg);
					//this doesn't work lol so uh ye
					*/
					
				}
				moveTank();
			}
			case "darnell" | "hot" | "lit-up":
				defaultCamZoom = 0.95;
				curStage = "darnell";

				var Alley = new FlxSprite(-1500, -850).loadGraphic(Paths.image('alley', 'week8'));
				Alley.scrollFactor.set(1, 1);
				Alley.setGraphicSize(Std.int(Alley.width * 0.5));
				Alley.antialiasing = Settings.Antialiasing;
				add(Alley);
			#if mods
			case 'ferocious': {
				defaultCamZoom = 0.6;

				curStage = 'garrett-school';

				schoolSTATIC = new FlxSprite(-1670, -600).loadGraphic(Paths.image('mods/funnyAnimal/schoolBG', 'shared'));
				schoolSTATIC.antialiasing = Settings.Antialiasing;
				schoolSTATIC.scale.set(1.8, 1.8);
				schoolSTATIC.updateHitbox();
				add(schoolSTATIC);

				RUNBITCH = new FlxSprite(-200, 100);
				RUNBITCH.frames = Paths.getSparrowAtlas('mods/funnyAnimal/runningThroughTheHalls', 'shared');
				RUNBITCH.animation.addByPrefix('run', 'Symbol 2', 24, true);
				RUNBITCH.antialiasing = Settings.Antialiasing;
				RUNBITCH.animation.play('run');
				RUNBITCH.scale.set(1.8, 1.8);
				RUNBITCH.visible = false;
				add(RUNBITCH);

				RUNBITCHSTATIC = new FlxSprite(-200, 100);
				RUNBITCHSTATIC.frames = Paths.getSparrowAtlas('mods/funnyAnimal/runningThroughTheHalls', 'shared');
				RUNBITCHSTATIC.animation.addByPrefix('run', 'Symbol 2', 24, false);
				RUNBITCHSTATIC.antialiasing = Settings.Antialiasing;
				RUNBITCHSTATIC.animation.play('run');
				RUNBITCHSTATIC.scale.set(1.8, 1.8);
				RUNBITCHSTATIC.visible = false;
				add(RUNBITCHSTATIC);

				BFLEGS2 = new FlxSprite(-500, 700);
				BFLEGS2.frames = Paths.getSparrowAtlas('mods/funnyAnimal/legs_working', 'shared');
				BFLEGS2.antialiasing = Settings.Antialiasing;
				BFLEGS2.scale.set(0.7, 0.7);
				BFLEGS2.visible = false;
				BFLEGS2.flipX = true;
				BFLEGS2.animation.addByPrefix('LEGS', 'poop attack0', 24, true);
				BFLEGS2.animation.addByPrefix('e', 'legs0', 24, true);
				BFLEGS2.animation.play('e', true);
				add(BFLEGS2);

				blackScreenBG = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				blackScreenBG.scale.set(5, 5);
				blackScreenBG.visible = false;
				add(blackScreenBG);

				blackScreen = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				blackScreen.cameras = [camHUD];
				blackScreen.scale.set(5, 5);
				blackScreen.visible = false;
				add(blackScreen);

				Jail = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/funnyAnimal/jailCell', 'shared'));
				Jail.antialiasing = Settings.Antialiasing;
				Jail.scale.set(1.8, 1.8);
				Jail.visible = false;
				Jail.screenCenter();
				Jail.updateHitbox();
				add(Jail);

				IPADBG = new FlxSprite(FlxG.width -1800, FlxG.height -1150).loadGraphic(Paths.image('mods/funnyAnimal/futurePadBG', 'shared'));
				IPADBG.visible = false;
				IPADBG.scale.set(2, 2);
				IPADBG.updateHitbox();
				add(IPADBG);
			}
			case 'too-slow':
				defaultCamZoom = 0.65;
				curStage = 'too-slow';

				TooSlowSKY = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/BGSky', 'shared'));
				TooSlowSKY.antialiasing = Settings.Antialiasing;
				TooSlowSKY.scale.set(1.2, 1.2);
				TooSlowSKY.screenCenter();
				TooSlowSKY.updateHitbox();
				add(TooSlowSKY);

				treesFarthest = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/TreesMid', 'shared'));
				treesFarthest.antialiasing = Settings.Antialiasing;
				treesFarthest.scale.set(1.2, 1.2);
				treesFarthest.screenCenter();
				treesFarthest.updateHitbox();
				add(treesFarthest);

				treesFar = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/TreesMidBack', 'shared'));
				treesFar.antialiasing = Settings.Antialiasing;
				treesFar.scale.set(1.2, 1.2);
				treesFar.screenCenter();
				treesFar.updateHitbox();
				add(treesFar);

				treesMid = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/TreesOuterMid1', 'shared'));
				treesMid.antialiasing = Settings.Antialiasing;
				treesMid.scale.set(1.2, 1.2);
				treesMid.screenCenter();
				treesMid.updateHitbox();
				add(treesMid);

				treesOuterMid = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/TreesOuterMid2', 'shared'));
				treesOuterMid.antialiasing = Settings.Antialiasing;
				treesOuterMid.scale.set(1.2, 1.2);
				treesOuterMid.screenCenter();
				treesOuterMid.updateHitbox();
				add(treesOuterMid);

				treesLeft = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/TreesLeft', 'shared'));
				treesLeft.antialiasing = Settings.Antialiasing;
				treesLeft.scale.set(1.2, 1.2);
				treesLeft.screenCenter();
				treesLeft.updateHitbox();
				add(treesLeft);

				treesRight = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/TreesRight', 'shared'));
				treesRight.antialiasing = Settings.Antialiasing;
				treesRight.scale.set(1.2, 1.2);
				treesRight.screenCenter();
				treesRight.updateHitbox();
				add(treesRight);

				bushUp = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/OuterBushUp', 'shared'));
				bushUp.antialiasing = Settings.Antialiasing;
				bushUp.scale.set(1.2, 1.2);
				bushUp.screenCenter();
				bushUp.updateHitbox();
				add(bushUp);

				bottomBush = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/OuterBush', 'shared'));
				bottomBush.antialiasing = Settings.Antialiasing;
				bottomBush.scale.set(1.2, 1.2);
				bottomBush.screenCenter();
				bottomBush.updateHitbox();
				add(bottomBush);

				grass = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/Grass', 'shared'));
				grass.antialiasing = Settings.Antialiasing;
				grass.scale.set(1.2, 1.2);
				grass.screenCenter();
				grass.updateHitbox();
				add(grass);

				grassFG = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/TreesFG', 'shared'));
				grassFG.antialiasing = Settings.Antialiasing;
				grassFG.scale.set(1.2, 1.2);
				grassFG.screenCenter();
				grassFG.updateHitbox();

				Tailz = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/DeadTailz1', 'shared'));
				Tailz.antialiasing = Settings.Antialiasing;
				Tailz.scale.set(1.2, 1.2);
				Tailz.screenCenter();
				Tailz.updateHitbox();
				add(Tailz);

				EggmanDead = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/DeadEgg', 'shared'));
				EggmanDead.antialiasing = Settings.Antialiasing;
				EggmanDead.scale.set(1.2, 1.2);
				EggmanDead.screenCenter();
				EggmanDead.updateHitbox();
				add(EggmanDead);

				TailzSIGN = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/DeadTailz', 'shared'));
				TailzSIGN.antialiasing = Settings.Antialiasing;
				TailzSIGN.scale.set(1.2, 1.2);
				TailzSIGN.screenCenter();
				TailzSIGN.updateHitbox();

				Tailz2 = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/DeadTailz2', 'shared'));
				Tailz2.antialiasing = Settings.Antialiasing;
				Tailz2.scale.set(1.2, 1.2);
				Tailz2.screenCenter();
				Tailz2.updateHitbox();
				add(Tailz2);

				KnucklesDead = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/PolishedP1/DeadTailz2', 'shared'));
				KnucklesDead.antialiasing = Settings.Antialiasing;
				KnucklesDead.scale.set(1.2, 1.2);
				KnucklesDead.screenCenter();
				KnucklesDead.updateHitbox();
				add(KnucklesDead);
			case 'prey':
				defaultCamZoom = 0.6;
				curStage = 'starved-pixel';
				StarvedPixelBG = new FlxTiledSprite(Paths.image('mods/stardustBg', 'shared'), 4608, 2832, true, true);
				StarvedPixelBG.scrollFactor.set(0.4, 0.4);
				StarvedPixelBG.screenCenter();
				add(StarvedPixelBG);
				StarvedPixelBG.visible = false;

				StarvedPixelBGFloor = new FlxTiledSprite(Paths.image('mods/stardustFloor', 'shared'), 4608, 2832, true, true);
				StarvedPixelBGFloor.screenCenter();
				StarvedPixelBGFloor.visible = false;

				FurnaceLol = new FlxSprite(-8000, 1450);
				FurnaceLol.frames = Paths.getSparrowAtlas('mods/Furnace_sheet', 'shared');
				FurnaceLol.animation.addByPrefix('idle', 'Furnace idle', 24, true);
				FurnaceLol.animation.play('idle');
				FurnaceLol.scale.set(6, 6);
				FurnaceLol.antialiasing = false;
				add(FurnaceLol);
				FurnaceLol.screenCenter();
				FurnaceLol.visible = false;
			#end
		    default:  {
				if (stageMOD) {
				    trace('Loading mod stage...');
					//var StageFILE:String = Assets.getText(Paths.MODtxt('stages/' + songName));
					trace('Loaded mod stage!');
				}
				else {
					trace('False alarm, There is no mod stage. \nLoading default stage...');
					defaultCamZoom = 0.9;
					curStage = 'stage';
	
					StageBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					StageBG.antialiasing = Settings.Antialiasing;
					StageBG.scrollFactor.set(0.9, 0.9);
					StageBG.visible = true;
					add(StageBG);
	
					stageFront = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = Settings.Antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.visible = true;
					add(stageFront);
	
					if (!Settings.LowDetail) {
						stageCurtains = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = Settings.Antialiasing;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.visible = true;
						add(stageCurtains);
					}
				}
		    }
        }

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'tank':
				gfVersion = 'gf-tankmen';
			case 'darnell':
				gfVersion = 'nene';
			default:
				trace('Default gf lol');
			
		}

		if (curStage == 'limo')
			gfVersion = 'gf-car';

		if (SONG.song.toLowerCase() == 'stress')
			gfVersion = 'pico-speaker';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);
		switch (gfVersion) {
			case 'gf':
				#if mods
				if (SONG.song.toLowerCase() == 'too-slow') {
					gf.x += 100;
					gf.y -= 45;
				}
				#end
			case 'pico-speaker':
				gf.x -= 50;
				gf.y -= 200;
				var tankmen:TankmenBG = new TankmenBG(20, 500, true);
				tankmen.strumTime = 10;
				tankmen.resetShit(20, 600, true);
				tankmanRun.add(tankmen);
				for (i in 0...TankmenBG.animationNotes.length)
				{
					if (FlxG.random.bool(16))
					{
						var man:TankmenBG = tankmanRun.recycle(TankmenBG);
						man.strumTime = TankmenBG.animationNotes[i][0];
						man.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
						tankmanRun.add(man);
					}
				}
			default:
				trace('No GF offsets');
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);
		dad = new Character(100, 100, SONG.player2);

		camPos = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player1) {
			case 'bf':
				#if mods
				if (SONG.song.toLowerCase() == 'too-slow') {
					boyfriend.y -= 50;
					boyfriend.x += 150;
				}
				#end
			case 'pico-player':
				BFHealthbar = FlxColor.fromRGB(130, 170, 0);
			case 'bf-holding-gf':
				boyfriend.y -= 15;
			#if mods
			case '3d-bf':
				boyfriend.x += 80;
				boyfriend.y -= 350;
				boyfriend.y += 320; //somehow this works lol
			case "bf-encore":
				boyfriend.x -= 770;
				boyfriend.x += 950;
				boyfriend.y -= 245;
				boyfriend.y += 100;
				BFHealthbar = FlxColor.fromRGB(49, 176, 209);
			#end
			default:
				trace('No X/Y adjustment for the player.');
		}

		switch (SONG.player2)
		{
			case 'dad':
				camPos.x += 400;
				OpponentHealthbar = FlxColor.fromRGB(200, 90, 250);
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn(1.3, (Conductor.stepCrochet * 4 / 1000));
				}
				OpponentHealthbar = FlxColor.fromRGB(244, 8, 255);
			case "spooky":
				dad.y += 200;
				OpponentHealthbar = FlxColor.fromRGB(255, 140, 0);
			case "monster":
				dad.y += 100;
				OpponentHealthbar = FlxColor.fromRGB(255, 255, 0);
			case 'monster-christmas':
				dad.y += 130;
				OpponentHealthbar = FlxColor.fromRGB(255, 255, 0);
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
				OpponentHealthbar = FlxColor.fromRGB(130, 170, 0);
			case 'mom-car':
				OpponentHealthbar = FlxColor.fromRGB(148, 0, 211);
			case 'parents-christmas':
				dad.x -= 500;
				OpponentHealthbar = FlxColor.fromRGB(200, 90, 250);
			case 'senpai' | 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				OpponentHealthbar = FlxColor.fromRGB(255, 192, 203);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				OpponentHealthbar = FlxColor.fromRGB(199, 21, 133);
			case "tankman":
				dad.y += 130;
				OpponentHealthbar = FlxColor.fromRGB(250, 150, 25);
			#if mods
			case 'garrett-animal':
				dad.x -= 430;
				dad.y -= 20;
			case "sonicexe":
				dad.x += 100;
				dad.y -= 60;
				OpponentHealthbar = FlxColor.fromRGB(0, 85, 142);
			case "Furnace":
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			#end
			default:
				trace('No X/Y adjustment for the opponent.');
		}

		blackScreenBG = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
		blackScreenBG.scale.set(5, 5);
		blackScreenBG.alpha = 0;
		add(blackScreenBG);
			
		blackBars = new FlxSprite(0, -200).makeGraphic(1280, 180, FlxColor.BLACK);
		blackBars.cameras = [camOTHER];
		blackBars.screenCenter(X);
		blackBars.alpha = 0;
		add(blackBars);

		blackBars2 = new FlxSprite(0, 750).makeGraphic(1280, 180, FlxColor.BLACK);
		blackBars2.cameras = [camOTHER];
		blackBars2.screenCenter(X);
		blackBars2.alpha = 0;
		add(blackBars2);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'tank':
				gf.y += 10;
				gf.x -= 30;
				boyfriend.x += 40;
				boyfriend.y += 0;
				dad.y += 60;
				dad.x -= 80;
				if (gfVersion != 'pico-speaker')
				{
					gf.x -= 170;
					gf.y -= 75;
				}
			case 'darnell':
				dad.y += 550;
				dad.x += 50;
				gf.x += 25;
		}

		add(gf);

		// Shitty layering but whatev it works LOL
		switch (curStage) {
			case 'limo':
				add(limo);

				add(dad);
				add(boyfriend);
			case 'tank':
				if (!Settings.LowDetail) {
					add(dad);
					add(boyfriend);
		
					add(tankdude1);
					add(tankdude2);
					add(tankdude3);
					add(tankdude4);
					add(tankdude5);
					add(tankdude6);
				}
			#if mods
			case 'garrett-school':
			    gf.visible = false;
		    	add(dad);
		    	add(boyfriend);
			case 'too-slow':
				add(dad);
		    	add(boyfriend);
				add(TailzSIGN);
				add(grassFG);
			case 'starved-pixel':
				gf.visible = false;
				add(dad);
		    	add(boyfriend);
				add(StarvedPixelBGFloor);
				boyfriend.alpha = 0;
				camHUD.alpha = 0;
				boyfriend.x += 250;
				boyfriend.y += 100;
				dad.x -= 1050;
				dad.y += 400;
			#end
			default:
				trace('No special stage bs');
				add(dad);
				add(boyfriend);
		}

		AntialiasingStuff();

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = DialogueEnd;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		if (Settings.Downscroll) {
			strumLine.y = FlxG.height -150;
		}

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		opponentStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		// You can change the font of lyricals to whatever you want, just put it to assets/fonts path.
		lyrObj = new FlxText(0, 0, 0, "", 36);
		lyrObj.setFormat(Paths.font("comic.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		lyrObj.scrollFactor.set();
		lyrObj.alignment = CENTER;
		lyrObj.screenCenter();
		lyrObj.x -= 450;
		lyrObj.y += 175;
		add(lyrObj);
		lyrObj.text = '';
		lyrObj.alpha = 0;

		if (Settings.Downscroll) {
			healthBarBG.y = (FlxG.height * 0.1);
		}

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(OpponentHealthbar, BFHealthbar);
		// healthBar
		add(healthBar);

		timeTxt = new FlxText(0, -600, 400, "", 24);
		if (PixelSONG) {
			timeTxt.setFormat(Paths.font("pixel.otf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		else {
			timeTxt.setFormat(Paths.font("comic.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		timeTxt.borderSize = 3;
		timeTxt.scrollFactor.set();
		timeTxt.screenCenter(X);
		add(timeTxt);

		trace(SONG.song);
		songTxt = new FlxText(0, healthBarBG.y -60, 400, "", 24);
		if (PixelSONG) {
			songTxt.setFormat(Paths.font("pixel.otf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		else {
			songTxt.setFormat(Paths.font("comic.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		songTxt.borderSize = 3;
		songTxt.scrollFactor.set();
		add(songTxt);

		missesTxt = new FlxText(0, healthBarBG.y -30, 400, "", 24);
		if (PixelSONG) {
			missesTxt.setFormat(Paths.font("pixel.otf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		else {
			missesTxt.setFormat(Paths.font("comic.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		missesTxt.borderSize = 3;
		missesTxt.scrollFactor.set();
		add(missesTxt);

		scoreTxt = new FlxText(0, healthBarBG.y, 400, "", 24);
		if (PixelSONG) {
			scoreTxt.setFormat(Paths.font("pixel.otf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		else {
			scoreTxt.setFormat(Paths.font("comic.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		scoreTxt.borderSize = 3;
		scoreTxt.scrollFactor.set();
		add(scoreTxt);

		ratingTxt = new FlxText(0, healthBarBG.y +30, 400, "", 24);
		if (PixelSONG) {
			ratingTxt.setFormat(Paths.font("pixel.otf"), 18, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		else {
			ratingTxt.setFormat(Paths.font("comic.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		ratingTxt.borderSize = 3;
		ratingTxt.scrollFactor.set();
		add(ratingTxt);

		SicksText = new FlxText(0, 300, "", 24);
		SicksText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		SicksText.scrollFactor.set();
		SicksText.cameras = [camHUD];
		add(SicksText);
			   
		GoodsText = new FlxText(0, 335, "", 24);
		GoodsText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		GoodsText.scrollFactor.set();
		GoodsText.cameras = [camHUD];
		add(GoodsText);
				
		BadsText = new FlxText(0, 370, "", 24);
		BadsText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		BadsText.cameras = [camHUD];
		add(BadsText);
				
		ShitsText = new FlxText(0, 405, "", 24);
		ShitsText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		ShitsText.scrollFactor.set();
		ShitsText.cameras = [camHUD];
		add(ShitsText);
			   
		MissesText = new FlxText(0, 440, "", 24);
		MissesText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		MissesText.scrollFactor.set();
		MissesText.cameras = [camHUD];
		add(MissesText);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		iconP1.antialiasing = Settings.Antialiasing;
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		iconP2.antialiasing = Settings.Antialiasing;
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		songTxt.cameras = [camHUD];
		missesTxt.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		ratingTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		lyrObj.cameras = [camHUD];

		#if android
		addAndroidControls();
        androidControls.visible = true;
        #end

		ReloadHealthBarColors();

		/*
		if (halloweenLevel) {
			var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
			add(blackScreen);
			blackScreen.alpha = 0.6;
			blackScreen.cameras = [camHUD];
			blackScreen.scrollFactor.set();
		}
		*/

		// cameras = [FlxG.cameras.list[1]];

		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case 'tutorial':
					startDialogue(doof);
				case 'bopeebo':
					startDialogue(doof);
				case 'fresh':
					startDialogue(doof);
				case 'dadbattle':
					startDialogue(doof);
				case 'spookeez':
					startDialogue(doof);
				case 'south':
					startDialogue(doof);
				case 'monster':
					startDialogue(doof);
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'ugh':
					playCutscene('ughCutscene.mp4', false);
				case 'guns':
					playCutscene('gunsCutscene.mp4', false);
				case 'stress':
					playCutscene('stressCutscene.mp4', false);
				case 'darnell':
					playCutscene('DarnellCutsceneLEAKED.mp4', false);
				default:
					if (FileSystem.exists(DialoguePath)) {
						schoolIntro(doof); //if detects dialogue it plays it!!!!
					} else {
						trace('No story cutscene.');
						startCountdown();
					}
			}
		}
		else 
		{
			switch (SONG.song.toLowerCase()) 
		    {
				case 'ferocious':
					/*
					var greenScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.GREEN);
					greenScreen.scale.set(5, 5);
					greenScreen.cameras = [camHUD];
					add(greenScreen);

					var Garrett:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/funnyAnimal/fat_guy', 'shared'));
					Garrett.cameras = [camHUD];
					Garrett.screenCenter();
					Garrett.updateHitbox();
					add(Garrett);

					var CanYou:FlxSprite = new FlxSprite(250, 450).loadGraphic(Paths.image('mods/funnyAnimal/canYouBeat', 'shared'));
					CanYou.cameras = [camHUD];
					CanYou.updateHitbox();
					add(CanYou);

					new FlxTimer().start(6, function(tmr:FlxTimer) 
					{
						remove(Garrett);
						var Garrett:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/funnyAnimal/obese_guy', 'shared'));
						Garrett.cameras = [camHUD];
						Garrett.screenCenter();
						Garrett.updateHitbox();
						add(Garrett);

						remove(CanYou);
						var CanYou:FlxSprite = new FlxSprite(250, 450).loadGraphic(Paths.image('mods/funnyAnimal/hooray', 'shared'));
						CanYou.cameras = [camHUD];
						CanYou.updateHitbox();
						add(CanYou);

						new FlxTimer().start(3, function(tmr:FlxTimer)
						{
							remove(greenScreen);
							remove(Garrett);
							remove(CanYou);
							startCountdown();
						});
					}); */ startCountdown();
				case 'too-slow':
					playCutscene('mods/tooslowcutscene1.mp4', false);
				default:
					if (FileSystem.exists(DialoguePath)) {
						schoolIntro(doof); //if detects dialogue it plays it!!!!
					} else {
						trace('No freeplay cutscene.');
						startCountdown();
					}
			}
		}

		super.create();
	}

	function AntialiasingStuff() {
		switch (SONG.song.toLowerCase()) {
			case 'senpai' | 'roses' | 'thorns'#if mods | 'prey' #end:
				gf.antialiasing = false;
				boyfriend.antialiasing = false;
				dad.antialiasing = false;
			default:
				gf.antialiasing = Settings.Antialiasing;
				boyfriend.antialiasing = Settings.Antialiasing;
				dad.antialiasing = Settings.Antialiasing;
		}
	}

	function playCutscene(name:String, atEndOfSong:Bool = false, ?isMidSongCutscene:Bool = false)
	{
		canPause = false;
		var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
		blackScreen.cameras = [camHUD];
		add(blackScreen);
		blackScreen.scrollFactor.set();
			
		inCutscene = true;
		FlxG.sound.music.stop();
			
		#if html5
		video = new FlxVideo('videos/' + name);
		#end
		video.finishCallback = function()
		{
			FlxTween.tween(blackScreen, {alpha: 0}, 1);

			// patch for mid-song videos
			if (isMidSongCutscene && songStarted)
			{
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;
			}

			if (atEndOfSong)
			{
				if (storyPlaylist.length <= 0)
			    	FlxG.switchState(new StoryMenuState());
				else
				{
					SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase());
					FlxG.switchState(new PlayState());
				}
			}
			else {
				canPause = true;
				startCountdown();
			}
		}
		#if !html5
		video.playVideo(Paths.video(name));
		#end
	}

	function startDialogue(?dialogueBox:DialogueBox) {
		if (dialogueBox != null) {
			trace('Started dialogue!');
			inCutscene = true;
			add(dialogueBox);
		}
		else {
			trace('Ending dialogue!');
			DialogueEnd();
		}
	}

	function DialogueEnd() {
		inCutscene = false;
		startCountdown();
		trace('Ended dialogue!');
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					DialogueEnd();

				remove(black);
			}
		});
	}

	#if mods
	function staticHitMiss()
	{
		trace('lol you missed the static note!');
		daNoteStatic = new FlxSprite(0, 0);
		daNoteStatic.frames = Paths.getSparrowAtlas('mods/hitStatic', 'shared');
		daNoteStatic.setGraphicSize(FlxG.width, FlxG.height);
		daNoteStatic.screenCenter();
		daNoteStatic.cameras = [camOTHER];
		daNoteStatic.animation.addByPrefix('static', 'staticANIMATION', 24, false);
		daNoteStatic.animation.play('static', true);
	
		FlxG.sound.play(Paths.sound("mods/hitStatic1", 'shared'));
	
		add(daNoteStatic);
	
		new FlxTimer().start(.38, function(trol:FlxTimer) // fixed lmao
		{
			daNoteStatic.alpha = 0;
			trace('ended HITSTATICLAWL');
			remove(daNoteStatic);
		});
	}
	#end

	function ReloadHealthBarColors() {
		healthBar.createFilledBar(OpponentHealthbar, BFHealthbar);
	}

	function ReloadIcons(?Icon1:String = "", ?Icon2:String = "") {
		if (Icon1 == "") {
			Icon1 = boyfriend.curCharacter;
		}
		remove(iconP1);
		iconP1 = new HealthIcon(Icon1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		iconP1.antialiasing = Settings.Antialiasing;
		add(iconP1);
		iconP1.cameras = [camHUD];

		if (Icon2 == "") {
			Icon2 = dad.curCharacter;
		}
		remove(iconP2);
		iconP2 = new HealthIcon(Icon2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		iconP2.antialiasing = Settings.Antialiasing;
		add(iconP2);
		iconP2.cameras = [camHUD];
	}

	function PlayANIMATION(Player:Int, AnimName:Dynamic) {
		if (Player == 3){
			gf.playAnim(AnimName, true);
		}
		else if (Player == 2) {
			dad.playAnim(AnimName, true);
		}
		else if (Player == 1) {
			boyfriend.playAnim(AnimName, true);
		}
	}

	function ChangeCHAR(Player:Int, X:Dynamic, Y:Dynamic, NewCHAR:Dynamic, ?HideFlash:Bool = false) {
		if (Player == 3){
			gf.alpha = 0.0000001;
			remove(gf);
			gf = new Character(X, Y, NewCHAR);
			add(gf);
		}
		else if (Player == 2) {
			dad.alpha = 0.0000001;
			remove(dad);
			dad = new Character(X, Y, NewCHAR);
			add(dad);
		}
		else if (Player == 1) {
			boyfriend.alpha = 0.0000001;
			remove(boyfriend);
			boyfriend = new Boyfriend(X, Y, NewCHAR);
			add(boyfriend);
		}
		AntialiasingStuff();
		ReloadIcons();
		if (!HideFlash) {
			FlxG.camera.flash(FlxColor.WHITE, 0.35, null, true);
		}
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown(?dialogueBox:DialogueBox):Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	public function startSong():Void
	{
		startingSong = false;
		songStarted = true;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var daNoteStyle:String = songNotes[3];
				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daNoteStyle);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daNoteStyle);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 1.8; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 1.8; // general offset
				}
				else {}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);

			babyArrow = new FlxSprite(0, strumLine.y);

			switch (curStage)
			{
				case 'school' | 'schoolEvil' | 'starved-pixel':
					if (curStage == 'starved-pixel') {
						babyArrow.loadGraphic(Paths.image('mods/NOTE_assets', 'shared'), true, 17, 17);
					} else {
						babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					}
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				default:
					if (curStage != 'garrett-school') {
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
					}
					else if (curStage == 'garrett-school') {
						babyArrow.frames = Paths.getSparrowAtlas('mods/NOTE_assets_3D');
					}
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = Settings.Antialiasing;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
			{
				opponentStrums.add(babyArrow);
			}

			if (player == 0) {
				playerStrums.add(babyArrow);
			}
			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 1.8) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCam(zoom:Float, time:Float):Void
	{
		FlxTween.tween(FlxG.camera, {zoom: zoom}, time, {type: FlxTween.PERSIST});
	}

	function tweenCamIn(zoom:Float, time:Float):Void
	{
		FlxTween.tween(FlxG.camera, {zoom: zoom}, time, {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	var tankX:Float = 400;
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankAngle:Float = FlxG.random.int(-90, 45);

	function moveTank(?elapsed:Float = 0):Void
	{
		if(!inCutscene && !Settings.LowDetail)
		{
			tankAngle += elapsed * tankSpeed;
			tankGround.angle = tankAngle - 90 + 15;
			tankGround.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
			tankGround.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
		}
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var LoadingSPAM:Bool = false;

	var BackgroundSPEED:Float = 15;
	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		#if html5
		    if (inCutscene && FlxG.keys.justPressed.ENTER) {
				video.finishVideo();
			}
		#end

		/*
		if (flipNotesPos && SONG.song.toLowerCase() == 'ferocious') {
			notes.forEachAlive(function(daNote:Note) {
				if (daNote.mustPress) {
					daNote.x -= 640;
				} else {
					daNote.x += 640;
				}
			});
		} else if (!flipNotesPos && SONG.song.toLowerCase() == 'ferocious') {
			notes.forEachAlive(function(daNote:Note) {
				if (daNote.mustPress) {
					//daNote.x = 700;
					if (daNote.noteData == 0) {
						trace('BF Left note x: ' + daNote.x);
						daNote.x = 86;
					} else if (daNote.noteData == 1) {
						trace('BF Down note x: ' + daNote.x);
						daNote.x = 192;
					} else if (daNote.noteData == 2) {
						trace('BF Up note x: ' + daNote.x);
						daNote.x = 274;
					} else if (daNote.noteData == 3) {
						trace('BF Right note x: ' + daNote.x);
						daNote.x = 386;
					}
				} else {
					//daNote.x = 700;
					if (daNote.noteData == 0) {
						trace('OPPONENT Left note x: ' + daNote.x);
						daNote.x = 751;
					} else if (daNote.noteData == 1) {
						trace('OPPONENT Down note x: ' + daNote.x);
						daNote.x = 853;
					} else if (daNote.noteData == 2) {
						trace('OPPONENT Up note x: ' + daNote.x);
						daNote.x = 985;
					} else if (daNote.noteData == 3) {
						trace('OPPONENT Right note x: ' + daNote.x);
						daNote.x = 1097;
					}
				}
			});
		}
		*/

		if (!LoadingScreen.caching && startedCountdown && canPause && !LoadingSPAM) {
			LoadingSPAM = true;

			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			FlxG.sound.cache(Paths.voices(SONG.song.toLowerCase()));
			FlxG.sound.cache(Paths.inst(SONG.song.toLowerCase()));
			openSubState(new LoadingScreen());
			LoadingScreen.caching = true;
		} else {
			LoadingScreen.caching = false;
		}

		//Sicks on screen!
		SicksText.text = 'Sicks: ' + sicks;
		//Goods on screen!
		GoodsText.text = 'Goods: ' + goods;
		//Bads on screen!
		BadsText.text = 'Bads: ' + bads;
		//Shits on screen!
		ShitsText.text = 'Shits: ' + shits;
		//Misses on screen!
		MissesText.text = 'Misses: ' + misses;
		
		#if mods
		var FloorSPEED:Float = 15;
		switch (BGSpeed)
		{
			case 0:
				FloorSPEED = 25;
			case 1:
				FloorSPEED = 50;
		}
		BackgroundSPEED = FlxMath.lerp(BackgroundSPEED, FloorSPEED, 0.3*(elapsed/(1/60)));
		if (FloorSPEED - BackgroundSPEED < 0.2)
		{
			BackgroundSPEED = FloorSPEED;
		}

		if (curStage == 'starved-pixel')
		{
			StarvedPixelBG.scrollX -= (BackgroundSPEED * StarvedPixelBG.scrollFactor.x) * (elapsed/(1/120));
			StarvedPixelBGFloor.scrollX -= BackgroundSPEED * (elapsed/(1/120));
		}
		#end

		OpponentLetNoteGO();

		/*
		//CamMovement.cancel();

		if (dad.animation.curAnim.name.startsWith('idle') && !boyfriend.animation.curAnim.name.startsWith('sing')) {
			CamMovement = FlxTween.tween(camFollow, {x: camFollow.x, y: camFollow.y}, Conductor.crochet / 1000, {ease: FlxEase.quadInOut});
		} else if (boyfriend.animation.curAnim.name.startsWith('idle') && !dad.animation.curAnim.name.startsWith('sing')) {
			CamMovement = FlxTween.tween(camFollow, {x: camFollow.x, y: camFollow.y}, Conductor.crochet / 1000, {ease: FlxEase.quadInOut});
		}

		CamMovement.start();
		*/

		if (FlxG.keys.justPressed.NINE)
		{
			if (oldIcon) {
				oldIcon = false;
				ReloadIcons();
			} else {
				oldIcon = true;
				ReloadIcons('bf-old');
			}
		}

		switch (curStage)
		{
			case 'tank':
				moveTank(elapsed);
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		/*
		var spam:Bool = false;
		if (tankmanHEAVEN && SONG.song == 'guns' && !spam) {
			spam = true;
			FlxTween.tween(camFollow, {y: -2500}, 13, {
				onComplete:function(twn:FlxTween)
				{
					//return down!!!!
					FlxTween.tween(camFollow, {y: 0}, 8);
				}
			});
		}
		*/

		super.update(elapsed);

		timeTxt.text = "";
		songTxt.text = "" + SONG.song;
		missesTxt.text = "Combo Breaks:" + misses;
		scoreTxt.text = "Score:" + songScore;
		if (misses == 0) {
			ratingTxt.text = "FC";
		}
		else {
			ratingTxt.text = "Clear";
		}

		//DiscordClient.changePresence(detailsText, SONG.song + " ("  +scoreTxt + " - " +ratingTxt +")", iconRPC);

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);

			Application.current.window.title = 'Nike Engine - ' + detailsPausedText;
			#end
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());

			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 0)
			health = 0;

		if (healthBar.percent < 20) {
			iconP1.animation.play(iconP1.animationsBase[1]);
			if (iconP2.hasWinningIcon) {
				iconP2.animation.play(iconP2.animationsBase[2]);
			}
		}
		else {
			iconP1.animation.play(iconP1.animationsBase[0]);
		}

		if (healthBar.percent > 80) {
			iconP2.animation.play(iconP2.animationsBase[1]);
			if (iconP1.hasWinningIcon) {
				iconP1.animation.play(iconP1.animationsBase[2]);
			}
		}
		else {
			iconP2.animation.play(iconP2.animationsBase[0]);
		}

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(boyfriend.curCharacter));
		if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new AnimationDebug(dad.curCharacter));
	    #end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case "darnell":
						camFollow.x = dad.getMidpoint().x + 125;
						camFollow.y = dad.getMidpoint().y - 375;
					#if mods
					case 'playtime':
						camFollow.x = dad.getMidpoint().x -300;
						camFollow.y = dad.getMidpoint().y -300;
				    case 'garrett-ipad':
						camFollow.x = dad.getMidpoint().x +700;
						camFollow.y = dad.getMidpoint().y -150;
					case 'pedophile':
						camFollow.x = dad.getMidpoint().x +50;
						camFollow.y = dad.getMidpoint().y -100;
					case 'sonicexe':
						camFollow.x = dad.getMidpoint().x +200;
						camFollow.y = dad.getMidpoint().y +50; 
					case 'Furnace':
						camFollow.x = dad.getMidpoint().x +300;
						camFollow.y = dad.getMidpoint().y +250;
					case 'starved-pixel':
						camFollow.x = dad.getMidpoint().x +200;
						camFollow.y = dad.getMidpoint().y +500; 
					#end
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn(1.3, (Conductor.stepCrochet * 4 / 1000));
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (boyfriend.curCharacter) {
					case 'bf':
						#if mods
						if (SONG.song.toLowerCase() == 'too-slow') {
							camFollow.x = boyfriend.getMidpoint().x -150;
						}
						#end
					#if mods
					case 'bf-ipad':
						camFollow.x = dad.getMidpoint().x +700;
						camFollow.y = dad.getMidpoint().y -150;
					case 'bf-encore':
						camFollow.x = boyfriend.getMidpoint().x -250;
					case 'sonic-running':
						camFollow.x = boyfriend.getMidpoint().x +300;
						camFollow.y = boyfriend.getMidpoint().x +50; //ik i did x lol
					case 'sonic-running-fast':
						camFollow.x = boyfriend.getMidpoint().x +200;
						camFollow.y = boyfriend.getMidpoint().y +500;
					#end
				}

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case "darnell":
						camFollow.x = boyfriend.getMidpoint().x - 175;
						camFollow.y = boyfriend.getMidpoint().y - 100;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET)
		{
			health = 2;
			trace("RESET = True");
		}

		if (health <= 2 && !practiceMode)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			deathCounter += 1;


			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else { openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y)); }

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			
			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				var center = strumLine.y + Note.swagWidth / 2;
				if (Settings.Downscroll) {
					daNote.y = (strumLine.y + 0.45 * (Conductor.songPosition - daNote.strumTime) * (FlxMath.roundDecimal(SONG.speed, 2)));
					if (daNote.isSustainNote) {
						if (daNote.animation.curAnim.name.endsWith("end") && daNote.prevNote != null) {
							daNote.y = daNote.y + daNote.prevNote.height;
						} else {
							daNote.y = daNote.y + (daNote.prevNote.height / 2);	
						}

						if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center && (!daNote.mustPress || (daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit))) {
							var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
							swagRect.height = (center - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;
							daNote.clipRect = swagRect;
						}
					}

					//I hate converting JS code.
					//(Week 8 code.)
					/*
					daNote.set_y(_gthis.strumLine.y + 0.45 * (Conductor.songPosition - daNote.strumTime) * flixel_math_FlxMath.roundDecimal(PlayState.SONG.speed,2));
					if(daNote.isSustainNote) {
						if(StringTools.endsWith(daNote.animation._curAnim.name,"end") && daNote.prevNote != null) {
							var _g = daNote;
							_g.set_y(_g.y + daNote.prevNote.get_height());
						} else {
							var _g = daNote;
							_g.set_y(_g.y + daNote.get_height() / 2);
						}
						if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.get_height() >= center && (!daNote.mustPress || (daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit))) {
							var swagRect = new flixel_math_FlxRect(0,0,daNote.frameWidth,daNote.frameHeight);
							swagRect.height = (center - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;
							daNote.set_clipRect(swagRect);
						}
					}
					*/
				} else {
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

					// i am so fucking sorry for this if condition -ninjamuffin99. you fucking should be -junior.
					if (daNote.isSustainNote
						&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
						&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					{
						var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
						swagRect.y /= daNote.scale.y;
						swagRect.height -= swagRect.y;
						daNote.clipRect = swagRect;
					}
				}

				//you are working on playing as opponent but u have to shit!!!
				//playerStrums.forEach //this!!!!
				//opponentStrums.forEach
				//to player strums!!!

				if (daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim || daNote.noteStyle == 'alt-anim')
							altAnim = '-alt';
					}

					//CamMovement.cancel();

					switch (Math.abs(daNote.noteData))
					{
						case 0:
							boyfriend.playAnim('singLEFT' + altAnim, true);
							/*
							if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !daNote.isSustainNote) {
								CamMovement = FlxTween.tween(camFollow, {x: dad.x -offset, y: dad.y}, Conductor.crochet / 10000, {ease: FlxEase.quadInOut});
							} */
						case 1:
							boyfriend.playAnim('singDOWN' + altAnim, true);
							/*
							if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !daNote.isSustainNote) {
								CamMovement = FlxTween.tween(camFollow, {x: dad.x, y: dad.y +offset}, Conductor.crochet / 10000, {ease: FlxEase.quadInOut});
							} */
						case 2:
							boyfriend.playAnim('singUP' + altAnim, true);
							/*
							if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !daNote.isSustainNote) {
								CamMovement = FlxTween.tween(camFollow, {x: dad.x, y: dad.y -offset}, Conductor.crochet / 10000, {ease: FlxEase.quadInOut});
							} */
						case 3:
							boyfriend.playAnim('singRIGHT' + altAnim, true);
							/*
							if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !daNote.isSustainNote) {
								CamMovement = FlxTween.tween(camFollow, {x: dad.x +offset, y: dad.y}, Conductor.crochet / 10000, {ease: FlxEase.quadInOut});
							} */
					}

					if (dad.animation.curAnim.name.contains('-alt') && altAnim == '-alt') {
						altAnim = '';
					}

					//CamMovement.start();

					if (healthBar.percent < 80) {
						if (daNote.noteData >= 0)
							health += 0.015;
						else
							health += 0.0023;
					}

					OpponentHITnote(daNote);

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					var doKill = daNote.y > FlxG.height;

					if (doKill && Settings.Downscroll) {
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					} else {
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();				
					}
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if (daNote.y < -daNote.height)
				{
					if (daNote.tooLate || !daNote.wasGoodHit)
					{
						#if mods
						if (daNote.noteStyle == 'police') {
							//trace('No miss for the police note lol');
						} else if (daNote.noteStyle == 'magic') {
							//trace('No miss for the magic note lol');
						} else if (daNote.noteStyle == 'Static Note') {
							staticHitMiss();
							NormalMiss(); //do both!
						} else {
							NormalMiss();
						}
						#else
						NormalMiss();
						#end
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		if (!inCutscene && songStarted && !endingSong)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function OpponentHITnote(daNote:Note) {
		opponentStrums.forEach(function(spr:FlxSprite)
		{
			if (Math.abs(daNote.noteData) == spr.ID)
			{
				spr.animation.play('confirm', true);
				if (spr.animation.curAnim.name != 'confirm' || curStage.startsWith('school') || curStage == 'starved-pixel')
					spr.centerOffsets();
				else
				{
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
				
				                                            //75/100% chance to hit sick for the opponent
				if (!daNote.isSustainNote && FlxG.random.bool(75)) { //its as if the opponent doesn't always hit sick :smirk:
					SpawnNoteSplash(daNote);
				}
			}
		});
		OpponentLetNoteGO();
		dadNoteData = daNote.noteData;
	}

	function OpponentLetNoteGO():Void {
		var shits:String = dad.animation.curAnim.name + altAnim;
		opponentStrums.forEach(function(spr:FlxSprite)
		{
			if (Math.abs(dadNoteData) == spr.ID)
			{
				if (shits != NormalAnimations[dadNoteData] && shits != AltAnimations[dadNoteData]) {
					spr.animation.play('static', true);
					spr.centerOffsets();
				}
			}
		});	
	}

	function NormalMiss() {
		combo = 0; //you lose your combo and miss when you don't hit a note lol
		misses += 1;
		health -= 0.0475;
		vocals.volume = 0;
	}

	function UnlockWeek() {
		if (storyWeek == 1) {
			Settings.Week2Unlocked = true;
		} else if (storyWeek == 2) {
			Settings.Week3Unlocked = true;
		} else if (storyWeek == 3) {
			Settings.Week4Unlocked = true;
		} else if (storyWeek == 4) {
			Settings.Week5Unlocked = true;
		} else if (storyWeek == 5) {
			Settings.Week6Unlocked = true;
		} else if (storyWeek == 6) {
			Settings.Week7Unlocked = true;
		} else if (storyWeek == 7) {
			Settings.Week8Unlocked = true;
		}
		Settings.SettingsSave();
	}

	function endSong():Void
	{ 
		endingSong = true;
		if (SONG.song.toLowerCase() == 'eggnog')
		{
			var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
				-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			blackShit.scrollFactor.set();
			add(blackShit);
			camHUD.visible = false;

			FlxG.sound.play(Paths.sound('Lights_Shut_off'));
		} //so this shit can be heard!!

		deathCounter = 0;
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			switch (SONG.song.toLowerCase()) {
				case 'stress':
					playCutscene('kickstarterTrailer.mp4', true);
				default:
					trace('No cutscene at the end of song');
			}

			if (storyPlaylist.length <= 0)
			{
				if (storyWeek == 0 || Settings.Week2Unlocked || Settings.Week3Unlocked || Settings.Week4Unlocked || Settings.Week5Unlocked ||
					Settings.Week6Unlocked || Settings.Week7Unlocked || Settings.Week8Unlocked) {
					trace('already unlocked lol');
				} else {
					UnlockWeek();
				}

				if (!inCutscene) {
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
	
					if (SONG.song.toLowerCase() != 'eggnog') {
						FlxG.switchState(new StoryMenuState());
					} else {
						new FlxTimer().start(2, function(tmr:FlxTimer) {
							FlxG.switchState(new StoryMenuState());
						});
					}

					Difficulty = 1;
	
					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
	
					if (SONG.validScore)
					{
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}
	
					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				if (storyDifficulty == 3) 
					difficulty = '-erect';

				if (!inCutscene) {
					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);
	
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();
	
					if (SONG.song.toLowerCase() != 'eggnog') {
						LoadingState.loadAndSwitchState(new PlayState());
					} else {
						new FlxTimer().start(2, function(tmr:FlxTimer) {
							LoadingState.loadAndSwitchState(new PlayState());
						});
					}
				}
			}
		}
		else
		{
			Difficulty = 1;
			
			trace('WENT BACK TO FREEPLAY??');

			#if desktop
			Application.current.window.title = 'Nike Engine';
			#end

			if (SONG.song.toLowerCase() != 'eggnog') {
				FlxG.switchState(new FreeplayState());
			} else {
				new FlxTimer().start(2, function(tmr:FlxTimer) {
					FlxG.switchState(new FreeplayState());
				});
			}
		}
	}
	
	/*
	override public function onFocus()
	{
		super.onFocus();
		FlxG.sound.music.resume();
		trace("[SYSTEM] User Focused the window");
	}
		
	override public function onFocusLost()
	{
		super.onFocusLost();
		FlxG.sound.music.pause();
		trace("[SYSTEM] User Lost Focus the window");
	}
	*/
	
	//this fucks up paused music

	private function popUpScore(strumtime:Float, note:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();

		if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			shits += 1;
			daRating = "shit";
			score = 75;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			bads += 1;
			daRating = "bad";
			score = 160;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			goods += 1;
			daRating = "good";
			score = 350;
		}
		else {
			sicks += 1;
			health -= 0.00425; //little reward for hitting sicks
			daRating = "sick";
			SpawnNoteSplash(note);
			score = 450;
		}

		songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		if (SONG.song == 'Ferocious') {
			pixelShitPart1 = "mods/3dUi/";
			pixelShitPart2 = '-3d';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x -360;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.cameras = [camHUD];

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x -320;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		comboSpr.cameras = [camHUD];
		if (combo >= 10 && !week7zoom) {
			if (!Settings.HideRatings || MilfMechanic) {
				add(comboSpr);
			}
		}
		
		if (!week7zoom) {
			if (!Settings.HideRatings || MilfMechanic) {
				add(rating);	
			}		
		}

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) -360;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
			numScore.cameras = [camHUD];

			if (combo >= 10 || combo == 0) {
				if (!week7zoom) {
					if (!Settings.HideRatings || MilfMechanic) {
						add(numScore);
					}
				}
			}

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		daRating = '';
		score = 0;

		curSection += 1;
	}

	function SpawnNoteSplash(note:Note):Void
    {
		var notesplash:NoteSplash = new NoteSplash(note.x -75, strumLine.y -90, note);
		notesplash.cameras = [camHUD];
		add(notesplash);
		//fixed!!!!
	}

	private function keyShit():Void
	{
		var holdingArray:Array<Bool> = [];
		var controlArray:Array<Bool> = [];
		var releaseArray:Array<Bool> = [];

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			holdingArray = [gamepad.pressed.X, gamepad.pressed.A, gamepad.pressed.Y, gamepad.pressed.B];
			controlArray = [gamepad.justPressed.X, gamepad.justPressed.A, gamepad.justPressed.Y, gamepad.justPressed.B];
			releaseArray = [gamepad.justReleased.X, gamepad.justReleased.A, gamepad.justReleased.Y, gamepad.justReleased.B];
		} else {
			holdingArray = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
			controlArray = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
			releaseArray = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];
		}

		if (Settings.RobloxFnFAnimation) {
			if (controlArray[0]) {
				dad.playAnim('singLEFT', true);
			}

			if (controlArray[1]) {
				dad.playAnim('singDOWN', true);
			}

			if (controlArray[2]) {
				dad.playAnim('singUP', true);
			}

			if (controlArray[3]) {
				dad.playAnim('singRIGHT', true);
			}
		}

		if (!controlArray.contains(true) && !holdingArray.contains(true) && releaseArray.contains(true)) {
			dad.holdTimer = 0.005;
		} else if (controlArray.contains(true) || holdingArray.contains(true)) {
			dad.holdTimer -= 1; // to make sure idle doesn't play in anims lol!
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (holdingArray.contains(true) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && !daNote.canBeHit && !daNote.mustPress && holdingArray[daNote.noteData]) {
					goodNoteHit(daNote);
				}
			});
		}

		if (controlArray.contains(true) && generatedMusic)
		{
			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			var removeList:Array<Note> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (!daNote.canBeHit && !daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (ignoreList.contains(daNote.noteData))
					{
						for (possibleNote in possibleNotes)
						{
							if (possibleNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - possibleNote.strumTime) < 10)
							{
								removeList.push(daNote);
							}
							else if (possibleNote.noteData == daNote.noteData && daNote.strumTime < possibleNote.strumTime)
							{
								possibleNotes.remove(possibleNote);
								possibleNotes.push(daNote);
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						ignoreList.push(daNote.noteData);
					}
				}
			});

			for (badNote in removeList)
			{
				badNote.kill();
				notes.remove(badNote, true);
				badNote.destroy();
			}

			possibleNotes.sort(function(note1:Note, note2:Note)
			{
				return Std.int(note1.strumTime - note2.strumTime);
			});

			if (perfectMode)
			{
				goodNoteHit(possibleNotes[0]);
			}
			else if (possibleNotes.length > 0)
			{
				for (i in 0...controlArray.length)
				{
					if (controlArray[i] && !ignoreList.contains(i))
					{
						badNoteHit();
					}
				}
				for (possibleNote in possibleNotes)
				{
					if (controlArray[possibleNote.noteData])
					{
						goodNoteHit(possibleNote);
					}
				}
			}
			else
				badNoteHit();
		}

		if (dad.holdTimer > 0.004 * Conductor.stepCrochet && !holdingArray.contains(true) && dad.animation.curAnim.name.startsWith('sing') #if mods
			&& !dad.animation.curAnim.name.contains("first") && !dad.animation.curAnim.name.contains("taunt") #end)
		{
			dad.playAnim('idle');
		}
		
		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
				spr.animation.play('pressed');
			if (!holdingArray[spr.ID])
				spr.animation.play('static');
	
			if (spr.animation.curAnim.name != 'confirm' || curStage.startsWith('school') || curStage == 'starved-pixel')
				spr.centerOffsets();
			else
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
		});
	}

	function noteMiss(direction:Int = 1, note:Note = null):Void
	{
		if (!boyfriend.stunned)
		{
			health += 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses += 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			boyfriend.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}
		}
	}

	function badNoteHit()
	{
		if (!Settings.GhostTapping) {
		    // just double pasting this shit cuz fuk u
		    // REDO THIS SYSTEM!
	    	var upP = controls.UP_P;
	    	var rightP = controls.RIGHT_P;
    		var downP = controls.DOWN_P;
	    	var leftP = controls.LEFT_P;

	    	if (leftP)
		    	noteMiss(0);
		    if (downP)
	    		noteMiss(1);
		    if (upP)
			    noteMiss(2);
		    if (rightP)
			    noteMiss(3);
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime, note);
				combo += 1;
			} else {
				//combo += 1;
				songScore += 9;
				//you get shits for sustain notes!!!!!
			}

			if (note.noteData >= 0)
				health -= 0.023;
			else
				health -= 0.004;


			#if mods
			//note mechanics lol
			if (note.noteStyle == 'police') {
				ArrowShits(0, 10, false);
			}

			if (note.noteStyle == 'magic') {
				var Shit1:Float = FlxG.random.int(-140, 140);
				var Shit2:Float = FlxG.random.int(-140, 140);

				if (Shit1 < 0) {
					camGame.angle -= Shit1;
				}
				else {
					camGame.angle += Shit1;
				}

				if (Shit2 < 0) {
					camHUD.angle -= Shit2;
				}
				else {
					camHUD.angle += Shit2;
				}
				FlxTween.tween(camGame, {angle: 0}, 4);
				FlxTween.tween(camHUD, {angle: 0}, 4);
			}
			#end

			var altAnim:String = "";

			if (SONG.notes[Math.floor(curStep / 16)] != null)
			{
				if (SONG.notes[Math.floor(curStep / 16)].altAnim || note.noteStyle == 'alt-anim')
					altAnim = '-alt';
			}

			//CamMovement.cancel();

			switch (note.noteData)
			{
				case 0:
					dad.playAnim('singLEFT' + altAnim, true);
					/*
					if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !note.isSustainNote) {
						CamMovement = FlxTween.tween(camFollow, {x: boyfriend.x -offset, y: boyfriend.y}, Conductor.crochet / 10000, {ease: FlxEase.circIn});
					} */
				case 1:
					dad.playAnim('singDOWN' + altAnim, true);
					/*
					if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !note.isSustainNote) {
						CamMovement = FlxTween.tween(camFollow, {x: boyfriend.x, y: boyfriend.y +offset}, Conductor.crochet / 10000, {ease: FlxEase.circIn});
					} */
				case 2:
					dad.playAnim('singUP' + altAnim, true);
					/*
					if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !note.isSustainNote) {
						CamMovement = FlxTween.tween(camFollow, {x: boyfriend.x, y: boyfriend.y -offset}, Conductor.crochet / 10000, {ease: FlxEase.circIn});
					} */
				case 3:
					dad.playAnim('singRIGHT' + altAnim, true);
					/*
					if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !note.isSustainNote) {
						CamMovement = FlxTween.tween(camFollow, {x: boyfriend.x +offset, y: boyfriend.y}, Conductor.crochet / 10000, {ease: FlxEase.circIn});
						
					} */
			}

			if (dad.animation.curAnim.name.contains('-alt') && altAnim == '-alt') {
				altAnim = '';
			}

			//CamMovement.start();

			opponentStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	#if !html5
	function getModStage():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.MODtxt('stages/' + songName));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];
	
		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}
	
		return swagGoodArray;
	}
	#end

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	#if mods
	function ArrowShits(X:Dynamic, Y:Dynamic, Subtracting:Bool) {
		if (Subtracting) {
			strumLine.x -= X;
			strumLine.y -= Y;
			//cameraOFFSET -= Y;


			playerStrums.forEach(function(spr:FlxSprite) {
				switch (spr.ID)
				{
					case 0:
						spr.x -= strumLine.x;
						spr.y = strumLine.y;
					case 1:
						spr.x -= strumLine.x;
						spr.y = strumLine.y;
					case 2:
						spr.x -= strumLine.x;
						spr.y = strumLine.y;
					case 3:
						spr.x -= strumLine.x;
						spr.y = strumLine.y;
				}
			});

			opponentStrums.forEach(function(spr:FlxSprite) {
				switch (spr.ID)
				{
					case 0:
						spr.x -= strumLine.x;
						spr.y = strumLine.y;
					case 1:
						spr.x -= strumLine.x;
						spr.y = strumLine.y;
					case 2:
						spr.x -= strumLine.x;
						spr.y = strumLine.y;
					case 3:
						spr.x -= strumLine.x;
						spr.y = strumLine.y;
				}
			});
		} else {
			strumLine.x += X;
			strumLine.y += Y;
			cameraOFFSET += Y;

			playerStrums.forEach(function(spr:FlxSprite) {
				switch (spr.ID)
				{
					case 0:
						spr.x += strumLine.x;
						spr.y = strumLine.y;
					case 1:
						spr.x += strumLine.x;
						spr.y = strumLine.y;
					case 2:
						spr.x += strumLine.x;
						spr.y = strumLine.y;
					case 3:
						spr.x += strumLine.x;
						spr.y = strumLine.y;
				}
			});

			opponentStrums.forEach(function(spr:FlxSprite) {
				switch (spr.ID)
				{
					case 0:
						spr.x += strumLine.x;
						spr.y = strumLine.y;
					case 1:
						spr.x += strumLine.x;
						spr.y = strumLine.y;
					case 2:
						spr.x += strumLine.x;
						spr.y = strumLine.y;
					case 3:
						spr.x += strumLine.x;
						spr.y = strumLine.y;
				}
			});
		}
	}
	#end

	var CAMGOINGUP:FlxTween;
	//Cam zoom, alpha for camHUD, if tankman floats in guns
	function TankmanSHITS(CAMZOOM:Bool, ?ALPHA:Float = 1, ?gunsFLOAT:Bool = false) {
		if (CAMZOOM) {
			week7zoom = true;

			camFollow.x = 225;
			FlxTween.tween(FlxG.camera, {zoom: 1.25}, 0.35);
			FlxG.camera.focusOn(camFollow.getPosition());
		}
		else {
			week7zoom = false;
			
			camFollow.x = 0;
			camFollow.y = 0;
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.35);
		}
		FlxTween.tween(camHUD, {alpha: ALPHA}, 0.35);

		if (gunsFLOAT) {
			FlxTween.tween(camHUD, {y: 1000}, 0.35);
			CAMGOINGUP = FlxTween.tween(camFollow, {y: -2500}, 13);
			
			FlxTween.tween(dad, {y: -2500}, 12, {
				onComplete:function(twn:FlxTween)
				{
					//230 is tankmans position but its not the same previously
					FlxTween.tween(dad, {y: 285}, 8);
				}
			});
			trace('TANKMAN IS FLOATING!!!!!!');
		}
		else {
			//tankmanHEAVEN = false;
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.35);
		}
	}

	override function stepHit()
	{
		super.stepHit();

		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}

		#if sys
		// make the lyrics change while the song passes by
		var balls:String = "" + curStep;
		if (balls == curLyrStep && hasLyrics)
		{
			if (!lyrAdded)
			{
				lyrAdded = true;
			}
			lyrObj.text = lyrText;
			if (lyrText != "") {
				FlxTween.tween(lyrObj, {alpha: 1}, 0.25, {ease: FlxEase.quadInOut});
			}

			trace(lyrText);
			lyricSteps.remove(lyricSteps[0]);
			var splitStep:Array<String> = lyricSteps[0].split(":");
			curLyrStep = splitStep[1];
			lyrText = lyricSteps[0].substr(splitStep[1].length + 2).trim();
		}
		#end

		if (SONG.song.toLowerCase() == 'dadbattle' && Difficulty == 3) {
			if (curStep == 245) {
				defaultCamZoom = 0.98;
			}

			if (curStep == 365) {
				defaultCamZoom = 1.025;
			}

			if (curStep == 488) {
				defaultCamZoom = 0.9;
			}

			if (curStep == 531) {
				defaultCamZoom = 1.2;
			}

			if (curStep == 540) {
				defaultCamZoom = 0.9;
			}

			if (curStep == 972) {
				defaultCamZoom = 1.25;

				strumLine.y += 50;
				FlxTween.tween(blackBars, {y: -100}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(blackBars, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(blackBars2, {y: 635}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(blackBars2, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
				boyfriend.color = FlxColor.BLACK;
				//dad.color = FlxColor.BLACK;
				dad.visible = false;
				gf.visible = false;
				FlxTween.tween(blackScreenBG, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
					
				playerStrums.forEach(function(spr:FlxSprite) {
					switch (spr.ID)
					{
						case 0:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 1:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 2:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 3:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
					}
				});
	
				opponentStrums.forEach(function(spr:FlxSprite) {
					switch (spr.ID)
					{
						case 0:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 1:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 2:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 3:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
					}
				});
			}

			if (curStep == 1455) {
				defaultCamZoom = 0.98;

				strumLine.y -= 50;
				FlxTween.tween(blackBars, {y: -200}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(blackBars, {alpha: 0}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(blackBars2, {y: 750}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(blackBars2, {alpha: 0}, 0.6, {ease: FlxEase.quadInOut});
				boyfriend.color = FlxColor.fromRGB(141, 127, 191);
				dad.color = FlxColor.fromRGB(141, 127, 191);
				gf.color = FlxColor.fromRGB(141, 127, 191);
				dad.visible = true;
				StageBG.color = FlxColor.fromRGB(141, 127, 191);
				stageCurtains.color = FlxColor.fromRGB(141, 127, 191);
				stageFront.color = FlxColor.fromRGB(141, 127, 191);
				//255, 0, 255
				gf.visible = true;
				FlxTween.tween(blackScreenBG, {alpha: 0}, 0.6, {ease: FlxEase.quadInOut});
	
				playerStrums.forEach(function(spr:FlxSprite) {
					switch (spr.ID)
					{
						case 0:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 1:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 2:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 3:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
					}
				});
	
				opponentStrums.forEach(function(spr:FlxSprite) {
					switch (spr.ID)
					{
						case 0:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 1:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 2:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 3:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
					}
				});
			}
		}

		if (SONG.song.toLowerCase() == 'milf') {
			if (curStep == 670) {
				MilfMechanic = true;
				strumLine.y += 100;

				FlxTween.tween(blackBars, {y: -50}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(blackBars, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(blackBars2, {y: 585}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(blackBars2, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
				defaultCamZoom = 1.2;
	
				playerStrums.forEach(function(spr:FlxSprite) {
					switch (spr.ID)
					{
						case 0:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 1:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 2:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 3:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
					}
				});
	
				opponentStrums.forEach(function(spr:FlxSprite) {
					switch (spr.ID)
					{
						case 0:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 1:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 2:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 3:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
					}
				});
			}

			if (curStep == 800) {
				MilfMechanic = false;
				strumLine.y -= 100;

				FlxTween.tween(blackBars, {y: -200}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(blackBars, {alpha: 0}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(blackBars2, {y: 750}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(blackBars2, {alpha: 0}, 0.6, {ease: FlxEase.quadInOut});
				defaultCamZoom = 0.90;
	
				playerStrums.forEach(function(spr:FlxSprite) {
					switch (spr.ID)
					{
						case 0:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 1:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 2:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 3:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
					}
				});
	
				opponentStrums.forEach(function(spr:FlxSprite) {
					switch (spr.ID)
					{
						case 0:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 1:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 2:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
						case 3:
							FlxTween.tween(spr, {y: strumLine.y}, 0.6, {ease: FlxEase.quadInOut});
					}
				});
			}
		}

		if (SONG.song.toLowerCase() == 'guns') {
			if (curStep == 896) {
				TankmanSHITS(true, 0, true);

				trace('zoom lol');
			}

			if (curStep == 1022) {
				TankmanSHITS(false, 1, false);
				FlxTween.tween(camHUD, {y: 0}, 0.8);

				CAMGOINGUP.cancel();
				//FlxTween.tween(camFollow, {y: 650}, 2.3);
				FlxTween.tween(camFollow, {y: boyfriend.getMidpoint().y - 100}, 2.3);

				trace('No more zoom :(');
			}
		}

		if (SONG.song.toLowerCase() == 'stress') {
			if (curStep == 736) {
				TankmanSHITS(true, 0.4);

				trace('Changing alpha to make more cool');
			}

			if (curStep == 768) {
				TankmanSHITS(false, 1);

				trace('Changing alpha back to normal for strums...');
			}
		}

		#if mods
		if (SONG.song.toLowerCase() == 'ferocious') {
			if (curStep == 12) {
				trace('THIS IS FOR TESTING LOL');

				/*
				var offsetP2:Float = 710;//really to the left
				var offsetP1:Float = 710;
				//flipNotesPos = true;

				playerStrums.forEach(function(spr:FlxSprite) {
					switch (spr.ID)
					{
						case 0:
							var OffsetLOL:Dynamic = spr.x -offsetP1;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
						case 1:
							var OffsetLOL:Dynamic = spr.x -offsetP1;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
						case 2:
							var OffsetLOL:Dynamic = spr.x -offsetP1;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
						case 3:
							var OffsetLOL:Dynamic = spr.x -offsetP1;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
					}
				});

				opponentStrums.forEach(function(spr:FlxSprite) {
					switch (spr.ID)
					{
						case 0:
							var OffsetLOL:Dynamic = spr.x +offsetP2;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
						case 1:
							var OffsetLOL:Dynamic = spr.x +offsetP2;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
						case 2:
							var OffsetLOL:Dynamic = spr.x +offsetP2;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
						case 3:
							var OffsetLOL:Dynamic = spr.x +offsetP2;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
					}
				});
			}
			*/

			if (curStep == 1152) {
				ChangeCHAR(2, -110, 220, 'playtime');
				PlayANIMATION(2, 'garrett pulls out ass');
				trace('garret summoned playtime out of ass');
			}

			if (curStep == 2159) {
				RUNBITCH.visible = true;
				BFLEGS2.visible = true;
				defaultCamZoom = 0.75;
				ChangeCHAR(2, 840, 840, 'palooseMen');
				camPos = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
				ChangeCHAR(1, -230, 625, '3d-bf-flipped');

				/*
				flipNotesPos = false;

				playerStrums.forEach(function(spr:FlxSprite) {
					switch (spr.ID)
					{
						case 0:
							var OffsetLOL:Dynamic = spr.x -640;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
						case 1:
							var OffsetLOL:Dynamic = spr.x -640;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
						case 2:
							var OffsetLOL:Dynamic = spr.x -640;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
						case 3:
							var OffsetLOL:Dynamic = spr.x -640;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
					}
				});

				opponentStrums.forEach(function(spr:FlxSprite) {
					switch (spr.ID)
					{
						case 0:
							var OffsetLOL:Dynamic = spr.x +640;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
						case 1:
							var OffsetLOL:Dynamic = spr.x +640;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
						case 2:
							var OffsetLOL:Dynamic = spr.x +640;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
						case 3:
							var OffsetLOL:Dynamic = spr.x +640;
							FlxTween.tween(spr, {x: OffsetLOL}, 2, {ease: FlxEase.quadInOut});
					}
				}); */

				trace('POLICE IS ON YOUR ASS RUN BITCH');
			}

			if (curStep == 3215) {
				defaultCamZoom = 0.7;
				RUNBITCH.visible = false;
				BFLEGS2.visible = false;
				Jail.visible = true;
				//flipNotesPos = false;

				var whereTonowlol:Float = dad.x +3800;

				ChangeCHAR(2, 680, 620, 'palooseMen');
				ChangeCHAR(1, 1340, 1020, '3d-bf');

				FlxTween.tween(dad, {x: whereTonowlol}, 6.5, {
					startDelay: 1.45, 
					onComplete: function(twn:FlxTween) 
					{
						//dad.visible = false;
						//this broke it lol
					}
				});
			}

			if (curStep == 3311) {
				defaultCamZoom = 0.5;
				blackScreenBG.alpha = 1;
				Jail.visible = false;
				//FerociousGarrettPissed(true);

				//strumLine.y -= cameraOFFSET; //returns notes to normal lol
				//ArrowShits(0, cameraOFFSET, true);

				strumLine.y -= cameraOFFSET;
				playerStrums.forEach(function(spr:FlxSprite) {
					spr.y -= cameraOFFSET;
				});

				opponentStrums.forEach(function(spr:FlxSprite) {
					spr.y -= cameraOFFSET;
				});

				IPADBG.visible = true;

				ChangeCHAR(2, -180, 300, 'garrett-ipad');
				ChangeCHAR(1, 200, -150, 'bf-ipad');

				IPAD = new FlxSprite(FlxG.width -1800, FlxG.height -1150).loadGraphic(Paths.image('mods/funnyAnimal/futurePad', 'shared'));
				IPAD.antialiasing = Settings.Antialiasing;
				IPAD.scale.set(2, 2);
				IPAD.updateHitbox();
				add(IPAD);
				trace('GARRETT IS PISSED LOL');
			}

			if (curStep == 4719) {
				defaultCamZoom = 0.8;
				//FerociousGarrettPissed(false);
				blackScreenBG.alpha = 0;
				IPADBG.visible = false;
				IPAD.visible = false;
				RUNBITCHSTATIC.visible = true;
				ChangeCHAR(2, -370, 240, 'wizard');
				ChangeCHAR(1, 770, 875, '3d-bf');
				trace('wizard!!!');
			}

			if (curStep == 5903) {
				RUNBITCHSTATIC.visible = false;
				RUNBITCH.visible = true;
				var offsets:Float = boyfriend.x -580;
				ChangeCHAR(2, offsets, 500, 'piano-guy');
				ChangeCHAR(1, 770, 900, '3d-bf-flipped');
				trace('piano guy?');
			}

			if (curStep == 7719) {
				RUNBITCHSTATIC.visible = true;
				RUNBITCH.visible = false;

				var whereTonowlol:Float = dad.x -3800;
				var offsets:Float = boyfriend.x +700;
				FlxTween.tween(dad, {x: whereTonowlol}, 1.3, {
					onComplete: function(twn:FlxTween) 
					{
						ChangeCHAR(2, offsets, 320, 'pedophile', true);
						trace('OH NO ITS A PEDOPHILE RUN BITCH');
					}
				});
			}

			if (curStep == 8703) {
				PEDOPHILESTATIC = new FlxSprite(dad.x -300, dad.y);
				PEDOPHILESTATIC.frames = Paths.getSparrowAtlas('mods/funnyAnimal/zunkity', 'shared');
				PEDOPHILESTATIC.animation.addByPrefix('hey its the toddler', 'FAKE LOADING SCREEN0000', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('hhmm', 'FAKE LOADING SCREEN0001', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('smile', 'FAKE LOADING SCREEN0002', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('im smile at you', 'FAKE LOADING SCREEN0003', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('you ugly', 'FAKE LOADING SCREEN0004', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('did you get uglier', 'FAKE LOADING SCREEN0005', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('garrett is ugly', 'FAKE LOADING SCREEN0006', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('bf is ugly', 'FAKE LOADING SCREEN0007', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('like my cut', 'FAKE LOADING SCREEN0008', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('i wear a mask with a smile', 'FAKE LOADING SCREEN0009', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('wtf', 'FAKE LOADING SCREEN0010', 24, false);
				PEDOPHILESTATIC.animation.addByPrefix('THERE IS A CAR COMING RUN BITCH', 'FAKE LOADING SCREEN0011', 24, false);
				PEDOPHILESTATIC.visible = false;
				PEDOPHILESTATIC.antialiasing = Settings.Antialiasing;
				add(PEDOPHILESTATIC);

				ChangeCHAR(2, -370, 420, 'garrett-angry');
				ChangeCHAR(1, 770, 875, '3d-bf');

				PEDOPHILESTATIC.animation.play('hey its the toddler');
				PEDOPHILESTATIC.visible = true;
			}

		    if (curStep == 8927) {
				PEDOPHILESTATIC.animation.play('hhmm');
			}

			if (curStep == 9119) {
				PEDOPHILESTATIC.animation.play('smile');
			}

			if (curStep == 9279) {
				PEDOPHILESTATIC.animation.play('im smile at you');
			}

			if (curStep == 9347) {
				PEDOPHILESTATIC.animation.play('you ugly');
			}

			if (curStep == 9420) {
				PEDOPHILESTATIC.animation.play('did you get uglier');
			}

			if (curStep == 9503) {
				PEDOPHILESTATIC.animation.play('garrett is ugly');
			}

			if (curStep == 9759) {
				PEDOPHILESTATIC.animation.play('bf is ugly');
			}

			if (curStep == 10015) {
				PEDOPHILESTATIC.animation.play('like my cut');
			}

			if (curStep == 10271) {
				PEDOPHILESTATIC.animation.play('i wear a mask with a smile');
			}

			if (curStep == 10527) {
				PEDOPHILESTATIC.animation.play('wtf');
			}

			if (curStep == 10863) {
				PEDOPHILESTATIC.animation.play('THERE IS A CAR COMING RUN BITCH');
			}
				
			if (curStep == 11035) {
				PEDOPHILESTATIC.visible = false;
				blackScreen.visible = true;
				RUNBITCHSTATIC.visible = false;
				RUNBITCH.visible = true;
				RUNBITCH.flipX = true;
				BFLEGS2.visible = true;
				BFLEGS2.flipX = false;
				BFLEGS2.x += 1420;
				ChangeCHAR(1, 1130, 625, '3d-bf');
				ChangeCHAR(2, -230, 425, 'garrett-car');

				POLICECAR = new FlxSprite(dad.x, dad.y);
				POLICECAR.frames = Paths.getSparrowAtlas('mods/funnyAnimal/palooseCar', 'shared');
				POLICECAR.animation.addByPrefix('run', 'idle0', 24, true);
				POLICECAR.animation.play('run');
				POLICECAR.antialiasing = Settings.Antialiasing;
				add(POLICECAR);

				new FlxTimer().start(0.2, function(tmr:FlxTimer) {
					blackScreen.visible = false;
				});
			}

			if (curStep == 11295) {
				defaultCamZoom = 1.2;
			}

			if (curStep == 11423) {
				defaultCamZoom = 0.8;
			}
	    }

		if (SONG.song.toLowerCase() == 'too-slow' && Difficulty != 3) {
			switch (curStep)
			{
				case 27:
					doStaticSign(0);
				case 130:
					doStaticSign(0);
				case 265:
					doStaticSign(0);
				case 450:
					doStaticSign(0);
				case 645:
					doStaticSign(0);
				case 765:
					FlxG.camera.shake(0.005, 0.10);
					FlxG.camera.flash(FlxColor.RED, 4);
				case 792:
					defaultCamZoom = 0.65;
				case 800:
					doStaticSign(0);
				case 855:
					doStaticSign(0);	
				case 889:
					doStaticSign(0);
				case 921:
					doSimpleJump();
				case 938:
					doStaticSign(0);
				case 981:
					doStaticSign(0);
				case 1030:
					doStaticSign(0);
				case 1065:
					doStaticSign(0);
				case 1105:
					doStaticSign(0);
				case 1123:
					doStaticSign(0);
				case 1178:
					doSimpleJump();
				case 1245:
					doStaticSign(0);
				case 1305:
					FlxTween.tween(camHUD, {alpha: 0}, 0.3);
					//dad.playAnim('iamgod', true);
				case 1337:
					doSimpleJump();
				case 1345:
					doStaticSign(0);
				case 1362:
					FlxG.camera.shake(0.002, 0.6);
					camHUD.camera.shake(0.002, 0.6);
				case 1432:
					defaultCamZoom = 0.65;
					FlxTween.tween(camHUD, {alpha: 1}, 0.3);
					doStaticSign(0);
				case 1454:
					doStaticSign(0);
				case 1495:
					doStaticSign(0);
				case 1521:
					doStaticSign(0);
				case 1558:
					doStaticSign(0);
				case 1578:
					doStaticSign(0);
				case 1599:
					doStaticSign(0);
				case 1618:
					doStaticSign(0);
				case 1647:
					doStaticSign(0);
				case 1657:
					doStaticSign(0);
				case 1692:
					doStaticSign(0);
				case 1713:
					doStaticSign(0);
				case 1723:
					doJumpscare();
				case 1738:
					doStaticSign(0);
				case 1747:
					doStaticSign(0);
				case 1761:
					doStaticSign(0);
				case 1785:
					doStaticSign(0);
				case 1806:
					doStaticSign(0);
				case 1816:
					doStaticSign(0);
				case 1832:
					doStaticSign(0);
				case 1849:
					doStaticSign(0);
				case 1868:
					doStaticSign(0);
				case 1887:
					doStaticSign(0);
				case 1909:
					doStaticSign(0);
			}

			if (curStep >= 760 && curStep < 786) {
				defaultCamZoom = 1.2;
			}


			if (curStep >= 1392 && curStep < 1428) {
				defaultCamZoom = 1.2;
			}
		}

		if (SONG.song.toLowerCase() == 'too-slow' && Difficulty == 3) {
			if (curStep == 384) {
				blackScreenBG = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				blackScreenBG.scale.set(5, 5);
				blackScreenBG.visible = true;
				add(blackScreenBG);
			}

			if (curStep == 400) {
				blackScreenBG.visible = false;
			}
		}

		if (SONG.song.toLowerCase() == 'prey') {
			switch (curStep)
			{
				case 1:
					FlxTween.tween(boyfriend, {alpha: 1}, 6);
				case 128:
					FlxG.camera.flash(FlxColor.WHITE, 2);	
					FlxTween.tween(FlxG.camera, {zoom: 1.95}, 0.4, {
						ease: FlxEase.cubeInOut,
					    onComplete:function(twn:FlxTween) 
						{
							FlxTween.tween(FlxG.camera, {zoom: 0.6}, 0.2);
						}
					});
					StarvedPixelBG.visible = true;
					StarvedPixelBGFloor.visible = true;
				case 246:
					FlxTween.tween(dad, {x: 580}, 1, {ease: FlxEase.cubeInOut});
					FlxTween.tween(camHUD, {alpha: 1}, 1.2,{ease: FlxEase.cubeInOut});
				case 1530:
					FlxTween.tween(camHUD, {alpha: 0}, 0.75,{ease: FlxEase.cubeInOut});
				case 1505:
					FlxTween.tween(dad, {x: -1500}, 5, {ease: FlxEase.cubeInOut});
					FlxTween.angle(dad, 0, -180, 5, {ease: FlxEase.cubeInOut});
				case 1542:
					dad.visible = false;
					ChangeCHAR(2, -400, 210, 'starved-pixel', true);
				case 1545:
					dad.x -= 500;
					dad.y += 100;
				case 1548:
					dad.visible = true;
				case 1543:
					DialogueBars(false);
					funnitext = new FlxText(0, 0, FlxG.width, "");
					funnitext.setFormat(Paths.font("pixel.otf"), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
					funnitext.screenCenter();
					funnitext.text = "Seems that bucket of bolts had to lay off the nitro this time around!";
					funnitext.y += 300;
					funnitext.cameras = [camOTHER];
					add(funnitext);

					health = 1;
					boyfriend.playAnim('first');
					dad.playAnim('You dont even');
				case 1570:
					FlxTween.tween(dad, {x: 1300}, 2.5,{ease: FlxEase.cubeInOut});
				case 1587:
					funnitext.color = FlxColor.WHITE;
					funnitext.text = "Hey Red Head!";
				case 1600:
					funnitext.text = "Might wanna repair your toys!";
				case 1624:
					funnitext.color = 0xFF0000;
					funnitext.text = "You don't even know your fate, hedgehog...";
				case 1675:
					funnitext.text = "*Maniacal kackling*";
				case 1780:
					FlxTween.tween(camHUD, {alpha: 1}, 1.0);
				case 1787:
					DialogueBars(true);
					ChangeCHAR(1, 1000, 500, 'sonic-running-fast', true);
					BGSpeed = 1;
					funnitext.color = FlxColor.WHITE;
					funnitext.text = "";
				case 2432:
					FurnaceLol.visible = true;
					FurnaceLol.y = boyfriend.y +1050;
					FlxTween.tween(FurnaceLol, {x: 3000}, 10);
				case 3328:
					DialogueBars(false);
					FlxTween.tween(camHUD, {alpha: 0}, 1,{ease: FlxEase.cubeInOut});
					FlxTween.tween(dad, {x: -300}, 4,{ease: FlxEase.cubeInOut});
				case 3335:
					funnitext.color = FlxColor.WHITE;
					funnitext.text = "Man, you really like scrambling your own plans don't'cha-";
					boyfriend.playAnim('taunt');
				case 3364:
					var HahaBURR = new FlxSprite(0, 0).loadGraphic(Paths.image('mods/furnace_gotcha', 'shared'));
					HahaBURR.setGraphicSize(Std.int(HahaBURR.width * 5));
					HahaBURR.antialiasing = false;
					HahaBURR.flipX = true;
					add(HahaBURR);
					HahaBURR.x = boyfriend.x + 1500;
					HahaBURR.y = boyfriend.y + 505;
					FlxTween.tween(HahaBURR, {x: boyfriend.x + 500}, 0.2, {onComplete: function(yes:FlxTween)
					{
						remove(HahaBURR);
						DialogueBars(true);
					}});
				case 3367:
					funnitext.text = "";
					remove(funnitext);
					FlxG.camera.flash(FlxColor.RED, 2);
					boyfriend.visible = false;
					dad.visible = false;
					FurnaceLol.visible = false;
					StarvedPixelBG.visible = false;
					StarvedPixelBGFloor.visible = false;
			}
		}
		#end
	}

	function DialogueBars(Hide:Bool) {
		if (Hide) {
			FlxTween.tween(blackBars, {y: -200}, 0.6, {ease: FlxEase.quadInOut});
			FlxTween.tween(blackBars, {alpha: 0}, 0.6, {ease: FlxEase.quadInOut});
			FlxTween.tween(blackBars2, {y: 750}, 0.6, {ease: FlxEase.quadInOut});
			FlxTween.tween(blackBars2, {alpha: 0}, 0.6, {ease: FlxEase.quadInOut});
		} else {
			FlxTween.tween(blackBars, {y: -50}, 0.6, {ease: FlxEase.quadInOut});
			FlxTween.tween(blackBars, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
			FlxTween.tween(blackBars2, {y: 585}, 0.6, {ease: FlxEase.quadInOut});
			FlxTween.tween(blackBars2, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
		}
	}

	#if mods
	function doSimpleJump()
	{
		trace('SIMPLE JUMPSCARE');
		var simplejump:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mods/simplejump', 'shared'));
		simplejump.setGraphicSize(FlxG.width, FlxG.height);
		simplejump.screenCenter();
		simplejump.cameras = [camOTHER];
		FlxG.camera.shake(0.0025, 0.50);
		add(simplejump);
	
		FlxG.sound.play(Paths.sound('mods/sppok', 'shared'), 1);
	
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			trace('ended simple jump');
			remove(simplejump);
		});
	
		// now for static
	
		var daStatic:FlxSprite = new FlxSprite(0, 0);
		daStatic.frames = Paths.getSparrowAtlas('mods/daSTAT', 'shared');
		daStatic.setGraphicSize(FlxG.width, FlxG.height);
		daStatic.screenCenter();
		daStatic.cameras = [camOTHER];
		daStatic.animation.addByPrefix('static', 'staticFLASH', 24, false);
		add(daStatic);
	
		FlxG.sound.play(Paths.sound('mods/staticBUZZ', 'shared'));
	
		if (daStatic.alpha != 0)
			daStatic.alpha = FlxG.random.float(0.1, 0.5);
	
		daStatic.animation.play('static');
		daStatic.animation.finishCallback = function(pog:String)
		{
			trace('ended static');
			remove(daStatic);
		}
	}

	function doJumpscare()
	{
		trace('JUMPSCARE aaaa');
	
		daJumpscare.frames = Paths.getSparrowAtlas('mods/sonicJUMPSCARE', 'shared');
		daJumpscare.animation.addByPrefix('jump', 'sonicSPOOK', 24, false);
		daJumpscare.screenCenter();
		daJumpscare.scale.x = 1.1;
		daJumpscare.scale.y = 1.1;
		daJumpscare.y += 370;
		daJumpscare.cameras = [camOTHER];
		FlxG.sound.play(Paths.sound('mods/jumpscare', 'shared'));
		FlxG.sound.play(Paths.sound('mods/datOneSound', 'shared'));
		add(daJumpscare);
		daJumpscare.animation.play('jump');
		daJumpscare.animation.finishCallback = function(pog:String)
		{
			trace('ended jump');
			remove(daJumpscare);
		}
	}

	function doStaticSign(lestatic:Int = 0, leopa:Bool = true)
	{
		trace('static MOMENT HAHAHAH ' + lestatic);
		var daStatic:FlxSprite = new FlxSprite(0, 0);
		daStatic.frames = Paths.getSparrowAtlas('mods/daSTAT', 'shared');
		daStatic.setGraphicSize(FlxG.width, FlxG.height);
		daStatic.screenCenter();
		daStatic.cameras = [camOTHER];
	
		switch (lestatic)
		{
			case 0:
				daStatic.animation.addByPrefix('static', 'staticFLASH', 24, false);
		}
		add(daStatic);
		FlxG.sound.play(Paths.sound('mods/staticBUZZ', 'shared'));
	
		if (leopa)
		{
			if (daStatic.alpha != 0)
				daStatic.alpha = FlxG.random.float(0.1, 0.5);
		}
		else
			daStatic.alpha = 1;
	
		daStatic.animation.play('static');
		daStatic.animation.finishCallback = function(pog:String)
		{
			trace('ended static');
			remove(daStatic);
		}
	}
	#end

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			if (Settings.Downscroll) {
				notes.sort(FlxSort.byY, FlxSort.ASCENDING);
			} else {
				notes.sort(FlxSort.byY, FlxSort.DESCENDING);
			}
		}

		//FlxG.camera.zoom = ((SONG.bpm / (defaultCamZoom * 160)) / 3.35);

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.03;
			camHUD.zoom += 0.015;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing") && !boyfriend.animation.curAnim.name.contains("first") && !boyfriend.animation.curAnim.name.contains("taunt"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
			gf.playAnim('cheer', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		if (SONG.song == 'Ferocious') {
			//health icon bounce but epic
			if (curBeat % gfSpeed == 0) {
				curBeat % (gfSpeed * 2) == 0 ? {
					iconP1.scale.set(1.1, 0.8);
					iconP2.scale.set(1.1, 1.3);

					FlxTween.angle(iconP1, -15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
					FlxTween.angle(iconP2, 15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
				} : {
					iconP1.scale.set(1.1, 1.3);
					iconP2.scale.set(1.1, 0.8);

					FlxTween.angle(iconP2, -15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
					FlxTween.angle(iconP1, 15, 0, Conductor.crochet / 1300 * gfSpeed, {ease: FlxEase.quadOut});
			    }

				FlxTween.tween(iconP1, {'scale.x': 1, 'scale.y': 1}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quadOut});
				FlxTween.tween(iconP2, {'scale.x': 1, 'scale.y': 1}, Conductor.crochet / 1250 * gfSpeed, {ease: FlxEase.quadOut});

				iconP1.updateHitbox();
				iconP2.updateHitbox();
			}
		}

		switch (curStage)
		{
			case 'school':
				if (!Settings.LowDetail) {
					bgGirls.dance();
				}

			case 'mall':
				if (!Settings.LowDetail) {
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if (!Settings.LowDetail) {
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});
		
					if (FlxG.random.bool(10) && fastCarCanDrive)
						fastCarDrive();
				}
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					var curColor = FlxG.random.int(0, phillyColors.length);
					if (!Settings.LowDetail) {
						FlxTween.tween(light, {alpha: 0}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut, 
						    onComplete:function(twn:FlxTween)
						    {
								//FlxG.camera.shake(0.003, Conductor.crochet / 1000);
								light.color = phillyColors[(curColor)];
								FlxTween.tween(light, {alpha: 1}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut});
								trace('CurLight color is: ' + curColor);
							}
					    });
					    // phillyCityLights.members[curLight].alpha = 1;
				    }
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					if (!Settings.LowDetail) {
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	var curLight:Int = 0;

	public function CacheIMAGE(graphic:String, ?library:String = '')
	{
		trace('(' + graphic + ') in ' + library);
		//Paths.loadImage(graphic);
		var newthing:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image(graphic, library));
		newthing.visible = false;
		newthing.screenCenter();
		add(newthing);
		remove(newthing);
		/*
		if (library == 'shared') {
			cacheItemsShared.remove(graphic);
		} else {
			itemstocache.remove(graphic);
		}
		*/
	}
}
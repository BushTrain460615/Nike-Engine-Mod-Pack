//COOL EPIC LOADING SCREEN

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxCamera;

class LoadingScreen extends MusicBeatSubstate
{
	//caching
	private var loadingSprite:FlxSprite;
	private var loadingText:FlxText;
	private var blackbar_top:FlxSprite;
	private var blackbar_bottom:FlxSprite;
	private var black:FlxSprite;

	private var beginTweens:Bool = false;

	private var itemstocache:Array<String> = [];
	private var cacheItemsShared:Array<String> = [];
	private var spam:Bool = false;
	private var done:Bool = false;

	private var fatty:Float = 999;
	public static var caching:Bool = false;

	private var camHUD:FlxCamera;
	//this is for PlayState!!!!!

	override function create()
	{
		super.create();
		trace('opened'); //bugs
		caching = true;

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD);

		black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		black.scrollFactor.set();
		black.scale.set(8, 8);
		black.cameras = [camHUD];
		add(black);
		FlxTween.tween(black, {alpha: 0}, 0.75, {ease: FlxEase.quadInOut});

		loadingSprite = new FlxSprite().loadGraphic(Paths.image('funkay'));
		loadingSprite.setGraphicSize(Std.int(loadingSprite.width * 0.5));
		loadingSprite.screenCenter();
		loadingSprite.antialiasing = Settings.Antialiasing;
		loadingSprite.alpha = 0;
		loadingSprite.scale.x = 0;
		loadingSprite.scale.y = 0;
		loadingSprite.cameras = [camHUD];
		add(loadingSprite);

		loadingText = new FlxText(0, loadingSprite.y + 135, FlxG.width, "", 21);
		loadingText.setFormat(Paths.font('vcr.ttf'), 24, FlxColor.WHITE, CENTER);
		loadingText.screenCenter(Y);
		loadingText.cameras = [camHUD];
		add(loadingText);

		blackbar_top = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height - (15 * 3), FlxColor.BLACK);
		blackbar_top.scrollFactor.set();
		blackbar_top.cameras = [camHUD];
		add(blackbar_top);

		blackbar_bottom = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height + (10 * 3), FlxColor.BLACK);
		blackbar_bottom.scrollFactor.set();
		blackbar_bottom.cameras = [camHUD];
		add(blackbar_bottom);

		FlxTween.tween(blackbar_top, {alpha: 1}, 0.75, {ease: FlxEase.quadInOut});
		FlxTween.tween(blackbar_bottom, {alpha: 1}, 0.75, {ease: FlxEase.quadInOut});
		FlxTween.tween(loadingText, {alpha: 1}, 0.75, {ease: FlxEase.quadInOut});
		FlxTween.tween(loadingSprite, {alpha: 1}, 0.75, {ease: FlxEase.quadInOut,
		    onComplete:function(twn:FlxTween) {
				beginTweens = true;
			}
		});
		FlxTween.tween(loadingSprite.scale, {x: 0.75, y: 0.75}, 0.75, {ease: FlxEase.quadInOut});

		switch (PlayState.SONG.song.toLowerCase()) {
			/*
			case 'ferocious':
				cacheItemsShared.push("mods/funnyAnimal/futurePadBG");
				cacheItemsShared.push("mods/funnyAnimal/futurePad");
				cacheItemsShared.push("mods/funnyAnimal/zunkity");
				cacheItemsShared.push("mods/funnyAnimal/palooseCar");

				//now chars!!!
				cacheItemsShared.push("characters/mods/3D_BF");
				cacheItemsShared.push("characters/mods/playtime");
				cacheItemsShared.push("characters/mods/palooseMen");
				cacheItemsShared.push("characters/mods/garrett_bf");
				cacheItemsShared.push("characters/mods/future");
				cacheItemsShared.push("characters/mods/wizard");
				cacheItemsShared.push("characters/mods/mrMusic");
				cacheItemsShared.push("characters/mods/do_you_accept");
				cacheItemsShared.push("characters/mods/garrett_piss");
				cacheItemsShared.push("characters/mods/carThing");

				cacheItemsShared.push("noteSplashes");
				//thats it!
			*/ //a little example lol
			default:
				if (Settings.Cache) {
					var lolXD = Startup.images;
					var lolXD2 = Startup.imagesSHARED;
					var lolXD3 = Startup.imagesCHARS;
		
					for (i in 0...lolXD.length) {
						itemstocache.push(lolXD[i]);
					}

					for (i in 0...lolXD2.length) {
						cacheItemsShared.push(lolXD2[i]); //2 bc its in shared
					}
		
					for (i in 0...lolXD3.length) {
						cacheItemsShared.push(lolXD3[i]); //2 bc its in shared,
					}
		
					//load assets xd
				} else {
					//gonna cache note splashes either way lol due to lag
					cacheItemsShared.push('noteSplashes');
					trace("Cached: noteSplashes.png");
				}
		}

		fatty = 2;//itemstocache.length + cacheItemsShared.length;
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (beginTweens && !spam) {
			spam = true;
			for (i in 0...itemstocache.length) {
				CacheIMAGE(itemstocache[i]);
			}
		
			for (i in 0...cacheItemsShared.length) {
				CacheIMAGE(cacheItemsShared[i], true);
			}

			loadingText.text = "Done!"; //lags to the point where it is done lol
			FlxTween.tween(blackbar_top, {alpha: 0}, fatty, {ease: FlxEase.quadInOut});
			FlxTween.tween(loadingSprite, {alpha: 0}, fatty, {ease: FlxEase.quadInOut});
			FlxTween.tween(blackbar_bottom, {alpha: 0}, fatty, {ease: FlxEase.quadInOut});
			FlxTween.tween(loadingText, {alpha: 0}, fatty, {ease: FlxEase.quadInOut});
			FlxTween.tween(loadingSprite.scale, {x: 0, y: 0}, fatty, {ease: FlxEase.quadInOut,
				onComplete:function(twn:FlxTween) {
					//should have left!!!
					black.visible = false;
					close();
				}
			});
		}
	}

	public function CacheIMAGE(graphic:String, ?library:Bool = false)
	{
		if (library) {
			FlxG.bitmap.add(Paths.image(graphic, 'shared'));
			trace('(' + graphic + ') in shared');
		} else {
			FlxG.bitmap.add(Paths.image(graphic));
			trace('(' + graphic + ')');
		}
	}
}

package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.events.Event;
import flixel.addons.ui.FlxUINumericStepper;
import openfl.net.FileReference;
import flixel.ui.FlxBar;
import flixel.FlxCamera;
import openfl.events.IOErrorEvent;

/**
	*DEBUG MODE
*/

using StringTools;

class AnimationDebug extends FlxState
{
	var bfBG:Boyfriend;
	var bf:Boyfriend;
	var dadBG:Character;
	var dad:Character;
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;

	var _file:FileReference;
	var RGB:FlxUINumericStepper;
	var RGB2:FlxUINumericStepper;
	var RGB3:FlxUINumericStepper;
	var HealthColor:Dynamic;
	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var cameraLOL:FlxCamera;
	private var camHUD:FlxCamera;
	var daLoop2LOL:Int = 0;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.sound.music.stop();
		FlxG.mouse.visible = true;
		
		if (isDad) {
			HealthColor = FlxColor.fromRGB(69, 69, 69);
		} else {
			HealthColor = FlxColor.fromRGB(69, 69, 69);
		}

		cameraLOL = new FlxCamera();
		cameraLOL.bgColor.alpha = 0;
		FlxG.cameras.add(cameraLOL);

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD);

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		RGB = new FlxUINumericStepper(10, 280, 1, 0, 0, 255, 0);
		RGB.value = 69;
		RGB.name = 'RBG';
		RGB.cameras = [camHUD];
		add(RGB);

		RGB2 = new FlxUINumericStepper(10, 300, 1, 0, 0, 255, 0);
		RGB2.value = 69;
		RGB2.name = '';
		RGB2.cameras = [camHUD];
		add(RGB2);

		RGB3 = new FlxUINumericStepper(10, 320, 1, 0, 0, 255, 0);
		RGB3.value = 69;
		RGB3.name = '';
		RGB3.cameras = [camHUD];
		add(RGB3);

		var IconColor:FlxButton = new FlxButton(10, 340, "Get Icon Color", function()
		{
			geticoncolors();
		});

		if (daAnim.startsWith('bf'))
			isDad = false;

		if (isDad)
		{
			dadBG = new Character(0, 0, daAnim);
			dadBG.screenCenter();
			dadBG.debugMode = true;
			add(dadBG);
			dadBG.alpha = 0.6;

			dad = new Character(0, 0, daAnim);
			dad.screenCenter();
			dad.debugMode = true;
			add(dad);

			char = dad;
			if (daAnim.contains('flipped')) {
				dadBG.flipX = true;
				dad.flipX = true;
			} else {
				dadBG.flipX = false;
				dad.flipX = false;
			}
		}
		else
		{
			bfBG = new Boyfriend(0, 0);
			bfBG.screenCenter();
			bfBG.debugMode = true;
			add(bfBG);
			bfBG.alpha = 0.6;

			bf = new Boyfriend(0, 0);
			bf.screenCenter();
			bf.debugMode = true;
			add(bf);

			char = bf;
			if (daAnim.contains('flipped')) {
				bfBG.flipX = true;
				bf.flipX = true;
			} else {
				bfBG.flipX = false;
				bf.flipX = false;
			}
		}

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		cameraLOL.follow(camFollow);

		for (anim => offsets in char.animOffsets)
		{
			daLoop2LOL += 20;
		}
		RGB.y = daLoop2LOL;
		RGB2.y = RGB.y +20;
		RGB3.y = RGB2.y +20;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);
		healthBarBG.cameras = [camHUD];

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
		'health', 0, 2);
	    healthBar.scrollFactor.set();
        healthBar.createFilledBar(0xFFFF0000, HealthColor);
	    add(healthBar);
		healthBar.cameras = [camHUD];

		var icon:HealthIcon;
		icon = new HealthIcon(daAnim, true);
		icon.x = 250;
		icon.y = healthBar.y - (icon.height / 2);
		add(icon);
		icon.cameras = [camHUD];

		if (isDad) {
			icon.flipX = true;
		}

		super.create();
	}

	function geticoncolors() {
		//to do later cuz im in florida lol
	}

	function ReloadColors(val1:Int, val2:Int, val3:Int) {
        healthBar.createFilledBar(FlxColor.fromRGB(val1, val2, val3), FlxColor.fromRGB(val1, val2, val3));
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLUE;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	private function saveLevel()
	{	
		var yomama:Dynamic = 'Offsets lol';
		for (anim => offsets in char.animOffsets)
		{
			yomama = yomama +'\n' +anim + ": " + offsets;
		}
		/*
		for (i in 0...animList.length) {
			yomama = yomama +'\n' +offsets;//animList[i];
		}
		*/
		yomama = yomama +'\n\nHealthbar shit!!! \n' +'R: ' +RGB.value +", G: "+RGB2.value +', B: ' +RGB3.value;
		_file = new FileReference();
		_file.addEventListener(Event.COMPLETE, onSaveComplete);
		_file.addEventListener(Event.CANCEL, onSaveCancel);
		_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file.save(yomama, daAnim + "Offsets.txt");
	}
	
	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved LEVEL DATA.");
	}
	
	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving Level data");
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		var val1:Dynamic = RGB.value;
		var val2:Dynamic = RGB2.value;
		var val3:Dynamic = RGB3.value;
		ReloadColors(val1, val2, val3);
		textAnim.text = char.animation.curAnim.name;

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;
	
		if (FlxG.keys.justPressed.ENTER)
		{
			saveLevel();
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.mouse.visible = false;
			FlxG.switchState(new PlayState());
		}

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim]);

			updateTexts();
			genBoyOffsets(false);
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			updateTexts();
			if (upP)
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			if (downP)
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			if (leftP)
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			if (rightP)
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		super.update(elapsed);
	}
}

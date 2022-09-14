package;

import flixel.FlxSprite;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class BackgroundHelper extends FlxSprite
{
	var Animations:Array<String> = [];
	public function new(image:String, library:String = '', x:Float = 0, y:Float = 0, scrollfactorX:Float = 0.9, scrollfactorY:Float = 0.9, animated:Bool = false)
	{
		super();

		if (animated = false) {
			loadGraphic(Paths.image(image, library));
			scrollFactor.set(scrollfactorX, scrollfactorY);
		}
		else {
			frames = Paths.getSparrowAtlas(image, library);
			scrollFactor.set(scrollfactorX, scrollfactorY);
		}

		super();
	}

	public function Antialiasing(?Works:Bool) {
		antialiasing = Works;
	}

	public function AddAnimation(Name:String, xmlcode:String = null, FPS:Int = 24,loop:Bool = null) {
		animation.addByPrefix(Name, xmlcode, FPS, loop);
		Animations.push(Name);
	}

	public function PlayAnimation(Name:String) {
		animation.play(Name);
	}

	public function SetScreencenter(?X:Dynamic, ?Y:Dynamic) {
		if (X) {
			screenCenter(X);
		}

		if (Y) {
			screenCenter(Y);
		}
	}
}

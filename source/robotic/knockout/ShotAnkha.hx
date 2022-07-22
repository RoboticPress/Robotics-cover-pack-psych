package robotic.knockout;

import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;

class ShotAnkha extends FlxSprite
{
	var floatyFloat:Float = 0;
	public function new(x:Float, y:Float, letter:Int) {
		super(x, y);

		var letters:Array<String> = ['8', '6'];

		loadGraphic(Paths.image('knockout/shootstuff/ankha projectiles/' + letters[Std.int(Math.abs(letter%2))]));
		setGraphicSize(Std.int(width * 4), Std.int(height*4));
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		floatyFloat += 0.1 * (120/ClientPrefs.framerate);
		x += 10 * (120/ClientPrefs.framerate);
		angle = Math.sin(floatyFloat) * 20;
		if (x > PlayState.instance.bfHitBox.x)
		{
			PlayState.instance.remove(this);
			destroy();
		}
	}
}
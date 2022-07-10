package robotic.knockout;

import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;

class ShotGreenSunk extends FlxSprite
{
	var floatyFloat:Float = 0;
	public function new(x:Float, y:Float) {
		super(x, y);

		loadGraphic(Paths.image('knockout/shootstuff/sunk/loop ' + FlxG.random.int(1, 6)));
		setGraphicSize(Std.int(width * 0.5), Std.int(height * 0.5));
		updateHitbox();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		floatyFloat += 0.1 * (120/ClientPrefs.framerate);
		angle += 1 * (120/ClientPrefs.framerate);
		x += 10 * (120/ClientPrefs.framerate);
		y += Math.sin(floatyFloat) * 2;
		if (x > PlayState.instance.bfHitBox.x)
		{
			PlayState.instance.remove(this);
			destroy();
		}
	}
}
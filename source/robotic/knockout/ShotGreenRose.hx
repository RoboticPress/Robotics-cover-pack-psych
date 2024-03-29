package robotic.knockout;

import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;

class ShotGreenRose extends FlxSprite
{
	var floatyFloat:Float = 0;
	public function new(x:Float, y:Float) {
		super(x, y);

		loadGraphic(Paths.image('knockout/shootstuff/one projectile/rose'));
		setGraphicSize(Std.int(width * 2), Std.int(height * 2));
		updateHitbox();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		floatyFloat += 0.1 * (120/ClientPrefs.framerate);
		angle += 3 * (120/ClientPrefs.framerate);
		x += 10 * (120/ClientPrefs.framerate);
		y += Math.sin(floatyFloat) * 6;
		if (x > PlayState.instance.bfHitBox.x)
		{
			PlayState.instance.remove(this);
			destroy();
		}
	}
}
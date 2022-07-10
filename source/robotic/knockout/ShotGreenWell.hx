package robotic.knockout;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;

class ShotGreenWell extends FlxSprite
{
	var floatyFloat:Float = 0;
	public function new(x:Float, y:Float) {
		super(x, y);
		alpha = 0.6;

		loadGraphic(Paths.image('knockout/shootstuff/one projectile/wELL'));
		this.color = color;
		updateHitbox();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		floatyFloat += 0.1 * (120/ClientPrefs.framerate);
		angle = Math.sin(floatyFloat) * 20;
		x += 8 * (120/ClientPrefs.framerate);
		y += Math.sin(floatyFloat) * 3;
		if (x + width / 2 > PlayState.instance.bfHitBox.x)
		{
			PlayState.instance.remove(this);
			destroy();
		}
	}
}
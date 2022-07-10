package robotic.knockout;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;

class ShotGreenYuri extends FlxSprite
{
	var floatyFloat:Float = 0;
	public function new(x:Float, y:Float) {
		super(x, y);

		loadGraphic(Paths.image('knockout/shootstuff/yuri projectiles/word ' + FlxG.random.int(0, 6)));
		this.color = color;
		updateHitbox();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		floatyFloat += 0.1 * (120/ClientPrefs.framerate);
		angle = Math.sin(floatyFloat) * 20;
		x += 12 * (120/ClientPrefs.framerate);
		y += Math.sin(floatyFloat) * 3;
		if (x + width / 2 > PlayState.instance.bfHitBox.x)
		{
			PlayState.instance.remove(this);
			destroy();
		}
	}
}
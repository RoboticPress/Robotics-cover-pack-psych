package robotic.knockout;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;

class ShotSusan extends FlxSprite
{
	var floatyFloat:Float = 0;
	var distanceJ = [];
	public function new(x:Float, y:Float, color:FlxColor) {
		super(x, y);
		alpha = 0.6;
		distanceJ = [PlayState.instance.bfHitBox.x - x, PlayState.instance.bfHitBox.y - y];

		loadGraphic(Paths.image('knockout/shootstuff/one projectile/SusanShootFunni'));
		this.color = color;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		floatyFloat += 0.1 * (120/ClientPrefs.framerate);
		angle = Math.sin(floatyFloat) * 20 + 30;
		x += distanceJ[0]/120;
		y += distanceJ[1]/120;
		if (x > PlayState.instance.bfHitBox.x)
		{
			PlayState.instance.remove(this);
			destroy();
		}
	}
}
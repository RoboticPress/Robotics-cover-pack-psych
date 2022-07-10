package robotic.knockout;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;

class ShotGreenSusan extends FlxSprite
{
	var floatyFloat:Float = 0;
	public function new(x:Float, y:Float, color:FlxColor) {
		super(x, y);
		alpha = 0.6;

		loadGraphic(Paths.image('knockout/shootstuff/one projectile/SusanShootFunni'));
		this.color = color;
		setGraphicSize(Std.int(width/2), Std.int(height/2));
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		floatyFloat += 0.1 * (120/ClientPrefs.framerate);
		angle = Math.sin(floatyFloat) * 20 + 30;
		x += 5 * (120/ClientPrefs.framerate);
		if ( Math.sin(floatyFloat) > 0 )
			y += Math.sin(floatyFloat) * 8;
		else
			y += Math.sin(floatyFloat) * 2;
		if (x > PlayState.instance.bfHitBox.x)
		{
			PlayState.instance.remove(this);
			destroy();
		}
	}
}
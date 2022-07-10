package robotic.knockout;

import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;

class ShotSunk extends FlxSprite
{
	public function new(x:Float, y:Float) {
		super(x, y);

		loadGraphic(Paths.image('knockout/shootstuff/sunk/spoon'));
		setGraphicSize(Std.int(width * 0.25), Std.int(height * 0.25));
		angle = 90;
		updateHitbox();
		color = 0x88edff;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		x += 20 * (120/ClientPrefs.framerate);
		if (x > PlayState.instance.bfHitBox.x)
		{
			PlayState.instance.remove(this);
			destroy();
		}
	}
}
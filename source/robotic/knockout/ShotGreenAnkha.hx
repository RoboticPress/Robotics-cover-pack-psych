package robotic.knockout;

import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;

class ShotGreenAnkha extends FlxSprite
{
	var floatyFloat:Float = 0;
	public function new(x:Float, y:Float, letter:Int) {
		super(x, y);

		var letters:Array<String> = ['B', 'A', 'L', 'L', 'S'];

		loadGraphic(Paths.image('knockout/shootstuff/ankha projectiles/' + letters[Std.int(Math.abs(letter%5))]));
		setGraphicSize(Std.int(width * 2), Std.int(height*2));
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		floatyFloat += 0.1 * (120/ClientPrefs.framerate);
		angle = Math.sin(floatyFloat) * 20;
		x += 10 * (120/ClientPrefs.framerate);
		y += Math.sin(floatyFloat) * 2;
		if (x > PlayState.instance.bfHitBox.x)
		{
			PlayState.instance.remove(this);
			destroy();
		}
	}
}
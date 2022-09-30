package robotic.knockout;

import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;

class ShotGreen extends FlxSprite
{
	public var doNot = false;
	public function new(x:Float, y:Float) {
		super(x, y);


		frames = Paths.getSparrowAtlas('knockout/shootstuff/GreenShit');

		animation.addByPrefix('shot', 'GreenShit0' + FlxG.random.int(1,3) + ' instance 1', 24, false);
		animation.play('shot');
		FlxG.sound.play(Paths.sound('knockout/shootfunni/chaser' + FlxG.random.int(0,4)), 0.8);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (animation.curAnim.curFrame == 6 && animation.curAnim.name == 'shot' && PlayState.instance.health > 0.07 && !doNot)
			PlayState.instance.health -= 0.005;
		if (animation.curAnim.finished && animation.curAnim.name == 'shot')
		{
			PlayState.instance.remove(this);
			destroy();
		}
	}
}
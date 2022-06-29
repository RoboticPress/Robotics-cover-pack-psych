package robotic.knockout;

import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;

class Shot extends FlxSprite
{
	public function new(x:Float, y:Float) {
		super(x, y);


		frames = Paths.getSparrowAtlas('knockout/shootstuff/Cupheadshoot');

		switch (FlxG.random.int(0,2))
		{
			case 0:
				animation.addByPrefix('shot', 'BulletFX_H-Tween_02 instance 1', 24, false);
			case 1:
				animation.addByPrefix('shot', 'BulletFX_H-Tween_02 instance 2', 24, false);
			case 2:
				animation.addByPrefix('shot', 'BulletFX_H-Tween_03 instance 1', 24, false);
		}
		animation.play('shot');
		FlxG.sound.play(Paths.sound('knockout/shootfunni/pea' + FlxG.random.int(0,5)));
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (animation.curAnim.curFrame == 6 && animation.curAnim.name == 'shot')
			PlayState.instance.health -= 0.03;
		if (animation.curAnim.finished && animation.curAnim.name == 'shot')
		{
			PlayState.instance.remove(this);
			destroy();
		}
	}
}
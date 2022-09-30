package robotic.knockout;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;

class ShotRecolored extends FlxSprite
{
	public function new(x:Float, y:Float, ?color:FlxColor = FlxColor.BLUE) {
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
		setGraphicSize(Std.int(width * 1.6), Std.int(height));
		this.color = color;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (animation.curAnim.finished && animation.curAnim.name == 'shot')
		{
			PlayState.instance.remove(this);
			destroy();
		}
	}
}
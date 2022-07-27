package robotic.knockout;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
using StringTools;

class LoseCard extends FlxSpriteGroup
{
	public var curSelected:Int = 0;
	public var retry:FlxSprite;
	public var exit:FlxSprite;
	public var quit:FlxSprite;
	public function new(quote:String, image:String) {
		super();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('knockout/deaths/cuphead_death' + image, 'shared'));
		add(bg);
		bg.alpha = 0;
		bg.angle = -40;
		var runboi = new FlxSprite(50, 370);
		runboi.frames = Paths.getSparrowAtlas('knockout/NewCupheadrunAnim', 'shared');
		runboi.animation.addByPrefix('run', 'Run_cycle_gif copy instance 1', 24, true);
		runboi.animation.play('run');
		runboi.scrollFactor.set();
		runboi.angle = -10;
		runboi.alpha = 0;
		add(runboi);
		runboi.scale.set(0.5,0.5);
		var sentence:FlxText = new FlxText(0, 320, bg.width, '\"${quote}\"', 32);
		sentence.setFormat(Paths.font("CupheadICFont.ttf"), 22, 0xFF6E665F, CENTER);
		sentence.scrollFactor.set();
		sentence.angle = -10;
		sentence.alpha = 0;
		add(sentence);

		var buttonsframes = Paths.getSparrowAtlas('knockout/buttons', 'shared');
		retry = new FlxSprite(295, 450);
		retry.frames = buttonsframes;
		retry.animation.addByPrefix('retry', 'retry basic', 24, false);
		retry.animation.addByPrefix('retry clicked', 'retry white', 24, false);
		retry.animation.play('retry');
		retry.angle = -10;
		retry.alpha = 0;
		add(retry);

		exit = new FlxSprite(242, 510);
		exit.frames = buttonsframes;
		exit.animation.addByPrefix('menu', 'menu basic', 24, false);
		exit.animation.addByPrefix('menu clicked', 'menu white', 24, false);
		exit.animation.play('menu');
		exit.angle = -10;
		exit.alpha = 0;
		add(exit);

		quit = new FlxSprite(272, 553);
		quit.frames = buttonsframes;
		quit.animation.addByPrefix('quit', 'quit basic', 24, false);
		quit.animation.addByPrefix('quit clicked', 'quit white', 24, false);
		quit.animation.play('quit');
		quit.angle = -10;
		quit.alpha = 0;
		add(quit);
		FlxTween.tween(bg, {alpha: 1, angle: -10}, 0.7, {
			ease: FlxEase.quadOut,
			onComplete: function (twn:FlxTween) {
				FlxTween.tween(sentence, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(retry, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(exit, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(quit, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
				var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
				if(curTime < 0) curTime = 0;
				var songPercent = (curTime / FlxG.sound.music.length);

				FlxTween.tween(runboi, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(runboi, {x: FlxMath.lerp(runboi.x, 780, songPercent), y: FlxMath.lerp(runboi.y, 295, songPercent)}, 2, {ease: FlxEase.quadInOut});
			}
		});
	}
	override function update(elapsed:Float)
	{
		screenCenter();
		super.update(elapsed);
		switch (curSelected)
		{
			case 0:
				retry.animation.play('retry clicked');
				exit.animation.play('menu');
				quit.animation.play('quit');
			case 1:
				retry.animation.play('retry');
				exit.animation.play('menu clicked');
				quit.animation.play('quit');
			case 2:
				retry.animation.play('retry');
				exit.animation.play('menu');
				quit.animation.play('quit clicked');
		}
		if (curSelected <= -1)
		{
			curSelected = 2;
		}
		if (curSelected >= 3)
		{
			curSelected = 0;
		}
	}
}
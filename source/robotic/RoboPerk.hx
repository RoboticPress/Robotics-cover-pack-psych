package robotic;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
using StringTools;

class RoboPerk extends FlxSpriteGroup
{
	public var bg:FlxSprite;
	public var bg1:FlxSprite;
	public var baseX:Float = 0;
	public var baseY:Float = 0;
	public var floaty:Float = 0;
	public var type:String = '';
	public function new(perk:String, theX:Float, theY:Float) {
		super();
		baseX = theX;
		baseY = theY;
		type = perk;
		switch (perk)
		{
			case 'extra life':
				bg = new FlxSprite().loadGraphic(Paths.image('badge', 'shared'));
				add(bg);
				bg1 = new FlxSprite().loadGraphic(Paths.image('heart', 'shared'));
				add(bg1);
			case 'extra health':
				bg = new FlxSprite().loadGraphic(Paths.image('badge', 'shared'));
				add(bg);
				bg1 = new FlxSprite().loadGraphic(Paths.image('morehealth', 'shared'));
				add(bg1);
			case 'botplay':
				bg = new FlxSprite().loadGraphic(Paths.image('botpley', 'shared'));
				add(bg);
			case 'atrocity':
				bg = new FlxSprite().loadGraphic(Paths.image('cover', 'shared'));
				add(bg);
				bg1 = new FlxSprite().loadGraphic(Paths.image('atrocity', 'shared'));
				add(bg1);
			case 'disabled':
				bg = new FlxSprite().loadGraphic(Paths.image('badge', 'shared'));
				add(bg);
				bg.color = 0xff5a5a5a;
		}
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		x = baseX;
		y = baseY;
		floaty += (120/ClientPrefs.framerate);
		switch (type)
		{
			case 'extra life' | 'extra health' | 'atrocity':
				bg.y = baseY - 30 * scale.y;
				if (!flying)
					bg1.y = baseY + Math.sin(floaty/30) * 20 * scale.y - 100 * scale.y;
			case 'botplay' | 'disabled':
				bg.y = baseY - 30 * scale.y;
		}
	}
	var flying = false;
	public function fly()
	{
		flying = true;
		FlxTween.tween(bg1, {y: bg1.y - 200, alpha: 0}, 0.5, {ease:FlxEase.elasticInOut});
	}
}
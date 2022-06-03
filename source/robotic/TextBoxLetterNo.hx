package robotic;

import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

using StringTools;
class TextBoxLetterNo extends FlxText
{
	var isUpperCase:Bool = false;
	var directorything:String = 'lowercase';
	public function new(x:Float = 0, y:Float = 0, letter:String = 'W', size:Int = 48, font:String = 'Berlin sans fb demi') {
		super(x, y, 1000, letter, size, true);
	
		setFormat(font, 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		alignment = "left";

	}
	
	override function update(elapsed:Float)
	{
	}
}
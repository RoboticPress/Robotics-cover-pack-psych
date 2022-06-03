package robotic;

import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import robotic.TextBox;
import robotic.RoboticFunctions;

using StringTools;

class TextBoxLetter extends FlxSprite
{
	var isUpperCase:Bool = false;
	var directorything:String = 'symbols';
	var letterIndex:Int = 0;
	var myTextBox:TextBox;

	var isWavy:Bool = false;
	public var baseX:Float = 0;
	public var baseY:Float = 0;
	var isShaking:Bool = false;
	var waveIntensity:Float = 20;
	var waveDistance:Float = 5;
	var shakeIntensity:Float = 5;

	public function new(thebox:TextBox, x:Float = 0, y:Float = 0, letter:String = 'W', font:String = 'quicksand', size:Float = 1, theColor:FlxColor = FlxColor.WHITE, letterInd:Int, theWavy = false, theWaveIntensity:Float = 20, theWaveDistance:Float = 5, theShaking = false, theShakeIntensity:Float = 5) {
		super(x, y);

		antialiasing = false;
		myTextBox = thebox;
		baseX = x;
		baseY = y;
		letterIndex = letterInd;
		isWavy = theWavy;
		isShaking = theShaking;
		color = theColor;
		waveIntensity = theWaveIntensity;
		shakeIntensity = theShakeIntensity;
		waveDistance = theWaveDistance;

		var directoryArray = RoboticFunctions.getDirectoryAndLetter(letter);
		letter = directoryArray[0];
		directorything = directoryArray[1];
			
		trace('Robo/fonts/$font/$directorything/$letter');
		loadGraphic(Paths.image('Robo/fonts/$font/$directorything/$letter'));
		scale.set(size, size);
		updateHitbox();

	}
	
	override function update(elapsed:Float)
	{
		var waveValue:Float = 0;
		var shakeY:Float = 0;
		var shakeX:Float = 0;
		if (isWavy)
		{
			waveValue = Math.sin(myTextBox.waveNumber + waveDistance * (letterIndex + 1)) * waveIntensity;
		}
		if (isShaking)
		{
			shakeX = FlxG.random.float(-shakeIntensity, shakeIntensity);
			shakeY = FlxG.random.float(-shakeIntensity, shakeIntensity);
		}

		x = baseX + shakeX;
		y = baseY + waveValue + shakeY;
		super.update(elapsed);
	}
}
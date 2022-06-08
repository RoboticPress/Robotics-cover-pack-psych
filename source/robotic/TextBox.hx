package robotic;

import flixel.system.FlxSound;
import lime.utils.Assets;
import haxe.Json;
import flixel.text.FlxText;
import flixel.FlxBasic;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import robotic.TextBoxLetter;
#if sys
import sys.FileSystem;
#end
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
import flash.media.Sound;
#end

using StringTools;

typedef Jcharacter =
{
	public var characterName:String;
	public var iconName:String;
	public var color:String;
}

typedef TextBoxEvent =
{
	public var index:Int; // = 0;
	//public var indexInLetters:String; // = '0';
	public var event:String; // = 'wave';
	/*public function new(theIndex:Int = 0, theEvent:String = 'wave') {
		index = theIndex;
		event = theEvent;
		indexInLetters = '${theIndex}';
	}*/
	public var value1:String;
	public var value2:String;
	public var value3:String;
}

typedef DialogueLine =
{
	public var characterName:String;
	public var line:String;
	public var events:Array<TextBoxEvent>;
}
class TextBox extends FlxSpriteGroup
{
	var daName:FlxText;
	var skipText:FlxText;
	var bg:FlxSprite;
	var iconSongName:FlxSprite;
	var dad:Character;
	var thisThingsHeight:Int = 125;

	var letters:Array<robotic.TextBoxLetter> = [];
	var firstInTheLine:Array<Int> = [];
	var letterLine:Int = 0;
	var letterIndex:Int = 0;
	public var typeThis:String = '"When the amongi are gone the world will be an absoloutely\nbetter place", said no one ever';
	var arrived:Bool = false;
	var startingLine:Bool = true;
	public var waveNumber:Float = 0;
	var waveIntensity:Float = 5;
	var waveDistance:Float = 5;
	var shakeIntensity = 2.5;
	var letterOffset:Float = 20;
	var letterSpeed:Float = 30;
	var boxColor:FlxColor;
	var thefunniSound:FlxSound;

	var waveTheLetters:Bool = false;
	var shakeTheLetters:Bool = false;
	var sizeTheLetters:Float = 0.5;
	public var events:Array<robotic.TextBoxEvent> = [];
	public var allDialogues:Array<DialogueLine> = [];
	var currentDialogue:Int = 0;
	var noMoreDialogues:Bool = false;
	var dontStartNewText:Bool = false;
	public var onComplete:Void->Void;
	var animationToPlayDad:String = "singRIGHT";
	var animationToPlayBf:String = "singLEFT";
	var animationToPlayGf:String = "singRIGHT";
	var soundToPlay:String = "characters/sarv";
	var animationPlayDad:Bool = false;
	var animationPlayDadAgain:Bool = false;
	var animationPlayBf:Bool = false;
	var animationPlayGf:Bool = false;
	var letterColor:FlxColor = FlxColor.WHITE;
	var theJ:Bool = PlayState.dialogueEditing;
	var autoPlay:Bool = false;
	var timeToSkip:Float = 4;

	public function new(rectx:Float = 0, recty:Float = 0, theHeight:Int = 125, color:FlxColor = FlxColor.WHITE, letterSpeed:Float = 1, textmoment:String = '', startingIcon:String = 'robo-gf', theAutoPlay:Bool = false, theTimeToSkip:Float = 4) {
		super();

		if (textmoment != '')
			typeThis = textmoment;
		dad = PlayState.instance.dad;
		this.letterSpeed = letterSpeed;
		autoPlay = theAutoPlay;
		timeToSkip = theTimeToSkip;

		thisThingsHeight = theHeight;
		bg = new FlxSprite(rectx, recty);
		bg.makeGraphic(FlxG.width, thisThingsHeight, color);
		bg.alpha = 0;
		add(bg);
		boxColor = color;

		iconSongName = new FlxSprite(0,0);
		changeIcon(startingIcon);
		
		iconSongName.x = 200 - iconSongName.width/2;

		iconSongName.y = bg.y;
		iconSongName.alpha = 0;
		add(iconSongName);
		daName = new FlxText(bg.x + 80, bg.y - 10, 0, 'Robo', 24);
		add(daName);
		daName.alpha = 0;
		skipText = new FlxText(bg.x + 80, bg.y + bg.height, 0, 'Press S to skip dialogue', 24);
		if (!autoPlay)
			add(skipText);
		skipText.alpha = 0;
		thefunniSound = new FlxSound().loadEmbedded(Paths.sound(soundToPlay));
		if (autoPlay)
			new FlxTimer().start(timeToSkip, function(tmr:FlxTimer)
			{
				goToNextDialogue();
			}, allDialogues.length);
	}
	var fard:Float = 0;
	var limitThing:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ANY && !theJ && !FlxG.keys.justPressed.S && !autoPlay)
			goToNextDialogue();
		if (FlxG.keys.justPressed.S && !autoPlay && !PlayState.dialogueEditing)
			skipDialogue();
		//if (events.length == 1)
			//trace(events[0].index);
		bg.makeGraphic(FlxG.width, thisThingsHeight, boxColor);
		var ratio = iconSongName.height/iconSongName.width;
		iconSongName.setGraphicSize(Std.int(bg.height/ratio), Std.int(bg.height));
		iconSongName.x = 200 - iconSongName.width/2;
		iconSongName.updateHitbox();
		daName.x = bg.x + 80;
		daName.y = bg.y - 10;
		skipText.x = bg.x + 80;
		skipText.y = bg.y + bg.height;
		waveNumber += 0.1 * (120/ClientPrefs.framerate);
		iconSongName.y = bg.y;
		if (arrived && !dontStartNewText)
			fard += letterSpeed * (120/ClientPrefs.framerate);
		if (letterIndex < typeThis.length && arrived && fard >= limitThing)
		{
			thefunniSound.play(true);
			limitThing += 1;
			for (event in events)
			{
				if (letterIndex == event.index - letterLine)
				{
					switch (event.event)
					{
						case 'Wave On':
							waveTheLetters = true;
							waveIntensity = Std.parseFloat(event.value1);
							waveDistance = Std.parseFloat(event.value2);
						case 'Wave Off':
							waveTheLetters = false;
						case 'Shake On':
							shakeTheLetters = true;
							shakeIntensity = Std.parseFloat(event.value1);
						case 'Shake Off':
							shakeTheLetters = false;
						case 'Camera Follow':
							if (event.value1.toLowerCase() == 'dad')
								PlayState.instance.camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
							else if (event.value1.toLowerCase() == 'bf')
								PlayState.instance.camFollow.set(PlayState.instance.boyfriend.getMidpoint().x - 100, PlayState.instance.boyfriend.getMidpoint().y - 100);
							else if (event.value1.toLowerCase() == 'gf')
								PlayState.instance.camFollow.set(PlayState.instance.gf.getMidpoint().x, PlayState.instance.gf.getMidpoint().y);
						case 'Box Color':
							changeBoxColor(event.value1);
						case 'Text Color':
							var bgColor:String = event.value1;
							if(!bgColor.startsWith('0x')) {
								bgColor = '0xFF' + bgColor;
							}
							letterColor = Std.parseInt(bgColor);
						case 'Camera Skake':
							FlxG.camera.shake(Std.parseFloat(event.value1), Std.parseFloat(event.value2));
						case 'Change Box Size':
							changeHeight(Std.parseInt(event.value1), 69420);
						case 'Change Letter Size':
							sizeTheLetters = Std.parseFloat(event.value1);
						case 'Change Character Animation':
							if (event.value1.toLowerCase() == 'dad')
								animationToPlayDad = event.value2;
							else if (event.value1.toLowerCase() == 'bf')
								animationToPlayBf = event.value2;
							else if (event.value1.toLowerCase() == 'gf')
								animationToPlayGf = event.value2;
						case 'Set if Character singing':
							if (event.value1.toLowerCase() == 'dad')
							{
								if (event.value2 == 'true')
									animationPlayDad = true;
								else
									animationPlayDad = false;
							}
							if (event.value1.toLowerCase() == 'dadagain')
							{
								if (event.value2 == 'true')
									animationPlayDadAgain = true;
								else
									animationPlayDadAgain = false;
							}
							else if (event.value1.toLowerCase() == 'bf')
							{
								if (event.value2 == 'true')
									animationPlayBf = true;
								else
									animationPlayBf = false;
							}
							else if (event.value1.toLowerCase() == 'gf')
							{
								if (event.value2 == 'true')
									animationPlayGf = true;
								else
									animationPlayGf = false;
							}
						case 'Change Icon':
							changeIcon(event.value1);
						case 'Change Sound':
							soundToPlay = event.value1;
							thefunniSound = new FlxSound().loadEmbedded(Paths.sound(soundToPlay));
							FlxG.sound.list.add(thefunniSound);
					}
				}
			}
			if (animationPlayDad)
				PlayState.instance.dad.playAnim(animationToPlayDad);
			if (animationPlayDadAgain)
				PlayState.instance.dad.playAnim('singRIGHT');
			if (animationPlayBf)
				PlayState.instance.boyfriend.playAnim(animationToPlayBf);
			if (animationPlayGf)
				PlayState.instance.gf.playAnim(animationToPlayGf);
			var letterToType = typeThis.charAt(letterIndex);
			if (letterToType != '\n')
			{
				var letter:TextBoxLetter;
				if (letterIndex == 0)
				{
					if (startingLine)
					{
						startingLine = false;
						firstInTheLine.push(letterIndex);
					}
					letter = new TextBoxLetter(this, 300, bg.y, letterToType, 'Bsans', sizeTheLetters, letterColor, letterIndex, waveTheLetters, waveIntensity, waveDistance, shakeTheLetters, shakeIntensity);
				}
				else
				{
					if (startingLine)
					{
						startingLine = false;
						firstInTheLine.push(letterIndex-letterLine);
						letter = new TextBoxLetter(this, letters[firstInTheLine[letterLine-1]].x, letters[firstInTheLine[letterLine-1]].y + letters[firstInTheLine[letterLine-1]].height - letterOffset, letterToType, 'Bsans', sizeTheLetters, letterColor, letterIndex, waveTheLetters, waveIntensity, waveDistance, shakeTheLetters, shakeIntensity);
						letter.y = letters[firstInTheLine[letterLine-1]].y + letters[firstInTheLine[letterLine-1]].height/2 - letter.height/2;
					}
					else
					{
						letter = new TextBoxLetter(this, letters[letters.length-1].x + letters[letters.length-1].width, letters[firstInTheLine[letterLine]].y, letterToType, 'Bsans', sizeTheLetters, letterColor, letterIndex, waveTheLetters, waveIntensity, waveDistance, shakeTheLetters, shakeIntensity);
						letter.y = letters[letters.length-1].y + letters[letters.length-1].height/2 - letter.height/2;
					}
				}
				add(letter);
				/*var letter:TextBoxLetter;
				if (letterIndex == 0)
					letter = new TextBoxLetter(300, bg.y, typeThis.charAt(letterIndex), 48, 'Bsans');
				else
					letter = new TextBoxLetter(letters[letters.length-1].x + letters[letters.length-1].size, bg.y, typeThis.charAt(letterIndex), 48, 'Bsans');
				add(letter);*/
				letters.push(letter);
				letterIndex++;
			}
			else
			{
				letterLine += 1;
				startingLine = true;
				letterIndex++;
			}
		}
		super.update(elapsed);
	}

	public function appear()
	{
		var finalY = bg.y;
		bg.y += 100;
		FlxTween.tween(bg, {y: finalY, alpha: 0.8}, 0.5, {
			ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween)
			{
				arrived = true;
			}
		});
		FlxTween.tween(iconSongName, {alpha: 1}, 0.5, {
			ease: FlxEase.quadInOut
		});
		FlxTween.tween(daName, {alpha: 1}, 0.5, {
			ease: FlxEase.quadInOut
		});
		FlxTween.tween(skipText, {alpha: 1}, 0.5, {
			ease: FlxEase.quadInOut
		});
	}

	public function changeHeight(value:Int, time:Float)
	{
		FlxTween.tween(this, {thisThingsHeight: value}, 0.5, {
			ease: FlxEase.quadInOut
		});
	}

	public function clearText()
	{
		typeThis = '';
		for (letter in letters)
		{
			FlxTween.tween(letter, {baseX: letter.baseX + 200, alpha: 0}, 0.5, {
				ease: FlxEase.quadInOut,
				onComplete: function(twn: FlxTween) {
					letter.destroy();
				}
			});
		}
		letters = [];
	}


	public function startText(nerdText:String)
	{
		dontStartNewText = true;
		clearText();
		new FlxTimer().start(0.6, function(tmr:FlxTimer)
		{
			waveIntensity = 5;
			waveDistance = 5;
			shakeIntensity = 2.5;
			dontStartNewText = false;
			waveTheLetters = false;
			shakeTheLetters = false;
			sizeTheLetters = 0.5;
			typeThis = nerdText.replace('\\n', '\n');
			firstInTheLine = [];
			letterLine = 0;
			letterIndex = 0;
			//var arrived:Bool = false;
			startingLine = true;
			//var letterOffset:Float = 20;
			//var letterSpeed:Float = 30;
			//var boxColor:FlxColor;
		});
	}

	public function goToNextDialogue()
	{
		limitThing = 0;
		fard = 0;
		
		if (dontStartNewText)
			return;
		if (currentDialogue >= allDialogues.length)
			noMoreDialogues = true;
		if (noMoreDialogues)
		{
			skipDialogue();
			return;
		}
		startText(allDialogues[currentDialogue].line);
		events = allDialogues[currentDialogue].events;
		
		{
			var songName:String = Paths.formatToSongPath('robo');
			var file:String = Paths.json(songName + '/characters/' + allDialogues[currentDialogue].characterName);
			#if sys
			if (#if MODS_ALLOWED FileSystem.exists(Paths.modsJson(songName + '/characters/' + allDialogues[currentDialogue].characterName)) || #end FileSystem.exists(file))
			#else
			if (OpenFlAssets.exists(file))
			#end
			{
				var charProperties = parseCharacter(file);
				
				if (daName.text != charProperties.characterName)
				{
					letterColor = FlxColor.WHITE;
					soundToPlay = "characters/" + allDialogues[currentDialogue].characterName;
					thefunniSound = new FlxSound().loadEmbedded(Paths.sound(soundToPlay));
					trace('the');
					trace(charProperties.characterName);
					trace(daName.text);
					daName.text = charProperties.characterName;
					trace(charProperties.characterName);
					trace(daName.text);
					changeIcon(charProperties.iconName);
					changeBoxColor(charProperties.color);
				}
			}
		}
		currentDialogue++;
	}

	public function disappear()
	{
		clearText();
		
		FlxTween.tween(bg, {y: bg.y - 100, alpha: 0}, 0.5, {
			ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween)
			{
				this.destroy();
			}
		});
		FlxTween.tween(iconSongName, {alpha: 0}, 0.5, {
			ease: FlxEase.quadInOut
		});
		FlxTween.tween(daName, {alpha: 0}, 0.5, {
			ease: FlxEase.quadInOut
		});
		FlxTween.tween(skipText, {alpha: 0}, 0.5, {
			ease: FlxEase.quadInOut
		});
	}

	public function changeBoxColor(theColor:String)
	{
		
		var bgColor:String = theColor;
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		boxColor = Std.parseInt(bgColor);
		/*FlxTween.tween(bg, {color: theColor}, 0.5, {
			ease: FlxEase.quadInOut
		});*/
	}

	public function changeIcon(theFunniName:String)
	{
		FlxTween.tween(iconSongName, {alpha: 0}, 0.2, {
			ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween)
			{

				FlxTween.tween(iconSongName, {alpha: 1}, 0.5, {
					ease: FlxEase.quadInOut
				});
				//songBackSprite.color = FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]);
				//displaySongName.color = FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]);
				var name:String = 'icons/' + theFunniName;
				if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + dad.healthIcon; //Older versions of psych engine's support
				if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
				var file:Dynamic = Paths.image(name);
		
				iconSongName.loadGraphic(file); //Load stupidly first for getting the file size
				iconSongName.loadGraphic(file, true, Math.floor(iconSongName.width / 2), Math.floor(iconSongName.height)); //Then load it fr
				iconSongName.offset.x = (iconSongName.width - 150) / 2;
				iconSongName.offset.y = (iconSongName.width - 150) / 2;
				iconSongName.setGraphicSize(Std.int(iconSongName.width * 0.8));
				iconSongName.updateHitbox();
		
				iconSongName.animation.add(dad.healthIcon, [0, 1], 0, false, false);
				iconSongName.animation.play(dad.healthIcon);
		
				iconSongName.antialiasing = ClientPrefs.globalAntialiasing;
			}

		});
	}
	public static function parseCharacter(path:String):Jcharacter {
		#if MODS_ALLOWED
		if(FileSystem.exists(path))
		{
			return cast Json.parse(File.getContent(path));
		}
		#end
		return cast Json.parse(Assets.getText(path));
	}

	public function skipDialogue()
	{
		arrived = false;
		onComplete();
		disappear();
		return;
	}
}
package robotic;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import robotic.RoboticFunctions;

/**
	*DEBUG MODE
 */
class RoboCoin extends MusicBeatState
{

	var coin:FlxSprite;
	var floaties:Float = 0;
	public function new()
	{
		super();
	}

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite(-(FlxG.width/2), -(FlxG.height/2)).makeGraphic(FlxG.width*2, FlxG.height*2, FlxColor.BLACK);
		bg.alpha = 0.6;
		add(bg);
		coin = new FlxSprite(0,0, Paths.image('robo_coin'));
		add(coin);
		var sentence:FlxText = new FlxText(0, 50, 500, 'You got a Robo Coin :D\n\nGood Job! Use this in the shop to buy cool stuffs\n\n\n\n\n\n\n\n\nPress any key to continue', 32);
		sentence.scrollFactor.set();
		sentence.screenCenter(X);
		add(sentence);
		sentence.alignment = CENTER;
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		floaties += 1 * (120/ClientPrefs.framerate);
		coin.screenCenter();
		coin.y += Math.sin(floaties/30) * 20;

		if (FlxG.keys.justPressed.ANY)
		{
			RoboticFunctions.BeatSong(PlayState.SONG.song);
			MusicBeatState.switchState(new FreeplayState());
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			PlayState.changedDifficulty = false;
		}
	}
}

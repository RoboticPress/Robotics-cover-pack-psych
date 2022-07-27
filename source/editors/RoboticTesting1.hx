package editors;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxSubState;

/**
	*DEBUG MODE
 */
class RoboticTesting1 extends MusicBeatSubstate
{

	var coin:FlxSprite;
	var floaties:Float = 0;
	public function new()
	{
		super();
	}

	override function create()
	{
		add(coin = new FlxSprite(0,0, Paths.image('robo_coin')));
		var sentence:FlxText = new FlxText(0, 50, 500, 'You got a Robo Coin :D\n\nGood Job! Use this in the shop to buy cool stuffs', 32);
		sentence.scrollFactor.set();
		sentence.screenCenter(X);
		add(sentence);
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		floaties += 1 * (120/ClientPrefs.framerate);
		coin.screenCenter();
		coin.y += Math.sin(floaties/30) * 20;

		if (controls.ACCEPT)
		{
			MusicBeatState.switchState(new FreeplayState());
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			PlayState.changedDifficulty = false;
		}
	}
}

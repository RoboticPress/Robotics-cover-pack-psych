package robotic.knockout;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
using StringTools;

class GameOverSubstateCuphead extends MusicBeatSubstate
{
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var card:LoseCard;
	var candoshit:Bool = false;
	var isEnding:Bool = false;
	var knock:FlxSprite;
	var slowedMusic:AudioThing;

	override function create()
	{
		slowedMusic = new AudioThing('assets/songs/' + PlayState.SONG.song.toLowerCase().replace(' ', '-') + '/Inst.' + Paths.SOUND_EXT);
		trace(slowedMusic);
		slowedMusic.play();
		slowedMusic.speed = 0.5;
		var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
		if(curTime < 0) curTime = 0;
		slowedMusic.volume = 0;
		slowedMusic.time = curTime;
		var bg:FlxSprite = new FlxSprite(-(FlxG.width/2), -(FlxG.height/2)).makeGraphic(FlxG.width*2, FlxG.height*2, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		FlxTween.tween(bg, {alpha: 0.6}, 1, {ease: FlxEase.quartInOut});
		FlxG.sound.play(Paths.sound('knockout/death','shared'), 1);
		add(bg);
		var death:FlxSprite = new FlxSprite();
		death.loadGraphic(Paths.image('knockout/death', 'shared'));
		death.scrollFactor.set();
		death.updateHitbox();
		death.screenCenter();
		death.antialiasing = ClientPrefs.globalAntialiasing;
		add(death);
		candoshit = false;
		new FlxTimer().start(1.5, function(tmr:FlxTimer) {
			FlxTween.tween(death, {alpha: 0}, 0.5, {ease: FlxEase.quadIn, onComplete: function (twn:FlxTween) {remove(death);}});
			FlxTween.tween(slowedMusic, {volume: 0.5}, 2, {ease: FlxEase.quadInOut});
		});
		new FlxTimer().start(2, function(tmr:FlxTimer) {
			
			card = new LoseCard(quote, image);
			card.scrollFactor.set();
			insert(this.members.indexOf(bg) + 1, card);
			candoshit = true;
		});
		super.create();
	}

	var quote:String = "";
	var image:String = "";
	public function new(x:Float, y:Float, camX:Float, camY:Float, quote:String, image:String)
	{
		super();
		this.quote = quote;
		this.image = image;

		camFollow = new FlxPoint(x, y);
		knock = new FlxSprite(x + 30, y + 150);
		knock.frames = Paths.getSparrowAtlas('knockout/BF_Ghost');
		knock.animation.addByPrefix('start','thrtr instance 1', 24, true);
		knock.animation.play('start');
		knock.scrollFactor.set();
		knock.updateHitbox();

		knock.antialiasing = ClientPrefs.globalAntialiasing;
		add(knock);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
		add(camFollowPos);
		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		huh = true;
	}
var huh = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		knock.y -= 2;
		if (candoshit)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('knockout/select','shared'), 1);
				card.curSelected--;
			}
			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('knockout/select','shared'), 1);
				card.curSelected++;
			}
			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('knockout/select','shared'), 1);
				endBullshit();
			}
		}

	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			candoshit = false;
			isEnding = true;
			FlxTween.tween(slowedMusic, {volume: 0}, 0.3, {ease: FlxEase.quadInOut});
			FlxG.camera.fade(FlxColor.BLACK, 0.3, false, function()
			{
				switch (card.curSelected)
				{
					case 0:
						MusicBeatState.resetState();
						PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
					case 1:
						FlxG.sound.music.stop();
						PlayState.deathCounter = 0;
						PlayState.seenCutscene = false;
			
						if (PlayState.isStoryMode)
							MusicBeatState.switchState(new StoryMenuState());
						else
							MusicBeatState.switchState(new FreeplayState());
			
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
						PlayState.instance.callOnLuas('onGameOverConfirm', [false]);
					case 2:
						Sys.exit(0);
				}
			});
		}
	}
}

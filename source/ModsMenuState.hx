package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxSprite;
import robotic.RoboPerk;
using StringTools;
#if desktop
import Discord.DiscordClient;
#end

class ModsMenuState extends MusicBeatState
{
	var bg:FlxSprite;
	var perks:FlxTypedSpriteGroup<RoboPerk>;
	var perksNames:Array<String> = ['extra life', 'extra health', 'botplay', 'atrocity'];
	var curSelected:Int = 1;
	var description:FlxText;
	var coins:FlxText;
	var tooltip:FlxText;

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("Shop Menu", null);
		#end
		if (FlxG.save.data.bought == null)
			FlxG.save.data.bought = [];
		if (FlxG.save.data.equipped == null)
			FlxG.save.data.equipped = [];
		if (FlxG.save.data.coins == null)
			FlxG.save.data.coins = 0;
		perks = new FlxTypedSpriteGroup();
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();
		bg.color = FlxColor.CYAN;
		for (i in 0...perksNames.length)
		{
			perks.add (new RoboPerk(perksNames[i], -50 + i * 400,  100));
		}
		add(perks);

		description = new FlxText(0, 400, 1000, 'Extra Life\nWhen you reach zero health, you won\'t die, but you\'ll have only half max health for the rest of the song', 32);
		description.scrollFactor.set();
		description.screenCenter(X);
		description.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		add(description);

		tooltip = new FlxText(0, 600, 1000, 'Press Space to buy this item for 1 Robo Coin\nNO REFUNDS!', 32);
		tooltip.scrollFactor.set();
		tooltip.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		tooltip.screenCenter(X);
		add(tooltip);

		coins = new FlxText(0, 0, 1000, 'You have ' + FlxG.save.data.coins + ' Robo Coins', 32);
		coins.scrollFactor.set();
		coins.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		coins.screenCenter(X);
		add(coins);

		changeSelected();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.C)
			FlxG.save.data.coins = 4;
		if (FlxG.keys.justPressed.R)
			FlxG.save.data.bought = [];
		if (controls.NOTE_RIGHT_P)
		{
			changeSelected(1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.NOTE_LEFT_P)
		{
			changeSelected(-1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			if (FlxG.save.data.bought != null && !FlxG.save.data.bought.contains(perks.members[curSelected].type))
			{
				switch (perks.members[curSelected].type)
				{
					case 'extra life':
						if (FlxG.save.data.coins > 1)
						{
							FlxG.save.data.bought.push(perks.members[curSelected].type);
							FlxG.save.data.coins -= 2;
							FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
						}
					default:
						if (FlxG.save.data.coins > 0)
						{
							FlxG.save.data.bought.push(perks.members[curSelected].type);
							FlxG.save.data.coins--;
							FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
						}
				}
			}
			else if (FlxG.save.data.equipped != null && perks.members[curSelected].type != 'atrocity')
			{
				if (!FlxG.save.data.equipped.contains(perks.members[curSelected].type))
				{
					FlxG.save.data.equipped.push(perks.members[curSelected].type);
					if (FlxG.save.data.equipped.length > 3)
						FlxG.save.data.equipped = FlxG.save.data.equipped.splice(0, 1);
				}
				else
				{
					FlxG.save.data.equipped.remove(perks.members[curSelected].type);
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			changeSelected();
			coins.text = 'You have ' + FlxG.save.data.coins + ' Robo Coins';
		}
	}

	function changeSelected(shift:Int = 0) {
		curSelected += shift;
		if (curSelected <= -1)
			curSelected = perks.length - 1;
		if (curSelected >= perks.length)
			curSelected = 0;

		for (i in 0...perks.length)
		{
			perks.members[i].baseX = -500;
			perks.members[i].alpha = 0.4;
			if (FlxG.save.data.bought != null && !FlxG.save.data.bought.contains(perks.members[curSelected].type))
				perks.members[curSelected].color = 0xff5a5a5a;
			else
				perks.members[curSelected].color = 0xffffffff;
		}
		var nBefore = curSelected - 1;
		var nAfter = curSelected + 1;
		if (nBefore <= -1)
			nBefore = perks.length - 1;
		if (nAfter >= perks.length)
			nAfter = 0;

		perks.members[curSelected].baseX = -50 + 400;
		perks.members[nBefore].baseX = -50;
		perks.members[nAfter].baseX = -50 + 800;
		perks.members[curSelected].alpha = 1;
		tooltip.text = 'Press Space to buy this item for 1 Robo Coin\nNO REFUNDS!';
		if (perks.members[curSelected].type == 'extra life')
			tooltip.text = 'Press Space to buy this item for 2 Robo Coins\nNO REFUNDS!';
		var equipped = 'locked';
		var bought = 'not bought';
		description.color = FlxColor.RED;
		tooltip.visible = true;
		if (FlxG.save.data.bought.contains(perks.members[curSelected].type))
		{
			equipped = 'not equipped';
			if (perks.members[curSelected].type == 'atrocity')
			{
				description.color = FlxColor.WHITE;
				tooltip.visible = false;
			}
			bought = 'bought';
			tooltip.text = 'Press Space to equip this item';
			if (FlxG.save.data.equipped.contains(perks.members[curSelected].type))
			{
				equipped = 'equipped';
				tooltip.text = 'Press Space to unequip this item';
				description.color = FlxColor.WHITE;
			}
		}
		switch (perks.members[curSelected].type)
		{
			case 'extra life':
				description.text = 'Extra Life\nWhen you reach zero health, you won\'t die, but you\'ll have only half max health for the rest of the song\n\nThis perk is ' + equipped;
			case 'extra health':
				description.text = 'Extra Health\nGain 50% more max health\n\nThis perk is ' + equipped;
			case 'botplay':
				description.text = 'Robo Robo\nTurn botplay on for 8.6 seconds by pressing 3\n\nThis perk is ' + equipped;
			case 'atrocity':
				description.text = 'Atrocity\nProvides the ability to play Snow The Fox\'s Atrocity cover\n\nThis cover is ' + bought;
		}
	}
}

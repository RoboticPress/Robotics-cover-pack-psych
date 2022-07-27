package editors;

import robotic.knockout.LoseCard;
import flixel.FlxState;

/**
	*DEBUG MODE
 */
class RoboticTesting extends FlxState
{

	public function new()
	{
		super();
	}

	override function create()
	{
		add(new LoseCard("Best server in existance,\nno matter what you say,\nliking this has no resistance", "_server"));
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

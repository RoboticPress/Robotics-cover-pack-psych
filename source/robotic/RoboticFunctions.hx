package robotic;

import flixel.FlxG;
using StringTools;

class RoboticFunctions
{
	static public function getDirectoryAndLetter(letter:String)
	{
		var returnLetter = '';
		var returnDirectory = 'symbols';
		switch (letter)
		{
			case ' ':
				returnLetter = 'space';

			case '.':
				returnLetter = 'period';

			case ':':
				returnLetter = 'double dot';

			case ',':
				returnLetter = 'comma';

			case ';':
				returnLetter = 'dotted comma';

			case '\'':
				returnLetter = 'apostrophe';

			case '"':
				returnLetter = 'double quotation';

			case '(':
				returnLetter = 'left bracket';

			case '!':
				returnLetter = 'exclamation';

			case '?':
				returnLetter = 'question';

			case ')':
				returnLetter = 'right bracket';

			case '+':
				returnLetter = 'plus';

			case '-':
				returnLetter = 'minus';

			case '*':
				returnLetter = 'star';

			case '/':
				returnLetter = 'right slash';

			case '=':
				returnLetter = 'equal';

			case '|':
				returnLetter = 'the thing';

			case '[':
				returnLetter = 'left square bracket';

			case ']':
				returnLetter = 'right square bracket';

			case '<':
				returnLetter = 'left arrow';

			case '>':
				returnLetter = 'right arrow';

			case '_':
				returnLetter = 'underscore';

			case '`':
				returnLetter = 'weird quotation thing';

			case '@':
				returnLetter = 'at';

			case '#':
				returnLetter = 'hash';

			case '$':
				returnLetter = 'dollar';

			case '%':
				returnLetter = 'percent';

			case '^':
				returnLetter = 'power';

			case '&':
				returnLetter = 'and';

			case '\\':
				returnLetter = 'left slash';

			default:
				if (letter.toUpperCase() == letter)
				{
					returnDirectory = 'uppercase';
				}
				else
				{
					returnDirectory = 'lowercase';
				}
				returnLetter = letter;
		}

		return [returnLetter, returnDirectory];
	}

	static public function ifBeatenSong(song:String):Bool
	{
		if (FlxG.save.data.beatsong == null)
			FlxG.save.data.beatsong = ['tutorial'];
		return FlxG.save.data.beatsong.contains(song.toLowerCase());
	}

	static public function BeatSong(song:String)
	{
		if (FlxG.save.data.beatsong == null)
			FlxG.save.data.beatsong = ['tutorial'];
		FlxG.save.data.beatsong.push(song.toLowerCase());
		FlxG.save.data.coins++;
	}
}

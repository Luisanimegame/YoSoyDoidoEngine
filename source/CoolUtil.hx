package;

import flixel.FlxG;
import flixel.util.FlxSort;
import gameObjects.hud.note.Note;

using StringTools;

class CoolUtil
{
	inline public static function formatChar(char:String):String
	{
		return char.substring(0, char.lastIndexOf('-'));
	}

	public static function charList():Array<String>
	{
		return [
			"bf",
			"gf",
			"dad",
		];
	}

	public static function coolTextFile(key:String):Array<String>
	{
		var daList:Array<String> = Paths.text(key).split('\n');

		for(i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}

	public static function getDirection(i:Int)
		return ["left", "down", "up", "right"][i];

	public static function noteWidth()
	{
		return (160 * 0.7); // 112
	}
	
	public static function sortByShit(Obj1:Note, Obj2:Note):Int
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.songTime, Obj2.songTime);

	// easier music management stuff
	public static var curMusic:String = "none";
	public static function playMusic(?key:String, ?vol:Float = 1)
	{
		if (Paths.dumpExclusions.contains('music/' + curMusic + '.ogg'))
			Paths.dumpExclusions.remove  ('music/' + curMusic + '.ogg');

		if(key == null)
		{
			curMusic = "none";
			FlxG.sound.music.stop();
		}
		else
		{
			Paths.dumpExclusions.push('music/' + key + '.ogg');

			if(curMusic != key)
			{
				curMusic = key;
				FlxG.sound.playMusic(Paths.music(key), vol);
				//FlxG.sound.music.loadEmbedded(Paths.music(key), true, false);
				FlxG.sound.music.play(true);
			}
		}
	}
}
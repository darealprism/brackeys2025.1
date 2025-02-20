package sprites;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import states.PlayState.LevelInfo;

class InfoUI extends FlxTypedGroup<FlxSprite> {
	var background:FlxSprite;

	var levelNameText:FlxText;
	var levelDescText:FlxText;
	var levelTimerText:FlxText;

	var timer:Float = 0;

	public function new(levelID:Int, levelInfo:LevelInfo) {
		super();

		background = new FlxSprite();
		background.makeGraphic(FlxG.width, 100, 0xFF171820);
		add(background);

		levelNameText = new FlxText(10, 0, FlxG.width);
		levelNameText.size = 60;
		levelNameText.antialiasing = false;
		add(levelNameText);

		levelDescText = new FlxText(10, 65, FlxG.width);
		levelDescText.size = 30;
		levelNameText.antialiasing = false;
		add(levelDescText);
		levelTimerText = new FlxText(FlxG.width - 10, 10, FlxG.width);
		levelTimerText.size = 80;
		levelTimerText.antialiasing = false;
		levelTimerText.autoSize = false;
		levelTimerText.alignment = CENTER;
		add(levelTimerText);

		updateInfo(levelID, levelInfo);
	}

	public function formatTimer(seconds:Float):String {
		var hours = Math.floor(seconds / 3600);
		var minutes = Math.floor((seconds % 3600) / 60);
		var secs = seconds % 60;

		function padNumber(num:Float):String {
			num = Math.floor(num);
			return num < 10 ? '0' + num : Std.string(num);
		}

		var formattedHours = hours > 0 ? padNumber(hours) + ':' : '';
		var formattedMinutes = padNumber(minutes);
		var formattedSeconds = padNumber(secs);

		return '${formattedHours}${formattedMinutes}:${formattedSeconds}';
	}

	public function updateInfo(levelID:Int, levelInfo:LevelInfo) {
		levelNameText.text = "Level " + levelID;
		levelDescText.text = levelInfo.levelDesc;

		timer = 0;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		timer += elapsed;
		levelTimerText.text = formatTimer(timer);
		trace(levelTimerText.text);
	}
}
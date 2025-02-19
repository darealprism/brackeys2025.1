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

	public function new(levelID:Int, levelInfo:LevelInfo) {
		super();

		background = new FlxSprite();
		background.makeGraphic(FlxG.width, 100, 0xFF171820);
		add(background);

		levelNameText = new FlxText(0, 0, FlxG.width);
		levelNameText.size = 60;
		levelNameText.text = "Level " + levelID;
		levelNameText.antialiasing = false;
		add(levelNameText);

		levelDescText = new FlxText(0, 65, FlxG.width);
		levelDescText.size = 30;
		levelDescText.text = levelInfo.levelDesc;
		levelNameText.antialiasing = false;
		add(levelDescText);
	}
}
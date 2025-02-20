package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import sprites.Background;
import sprites.Bullet;
import sprites.GoalArea;
import sprites.InfoUI;
import sprites.Shooter;
import states.substates.PauseSubState;

class PlayState extends FlxState {
	public static var globalLevelData:Array<Null<LevelInfo>> = [
		null,
		{
			levelDesc: "SHOOT YOURSELF",
			bulletNum: 3
		},
		{
			levelDesc: "Pillars",
			bulletNum: 8
		}
	];

	var lvlID:Int = 1;

	var shooter: Shooter;

	var boundariesGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var bullets:FlxTypedGroup<Bullet> = new FlxTypedGroup<Bullet>();

	var ui:InfoUI;

	var lvlInfo:LevelInfo;

	var goal:GoalArea;

	function new(levelID:Int) {
		super();
		lvlID = levelID;
	}

	override public function create() {
		super.create();

		add(new Background());

		loadLevel();

		camera.bgColor = 0xFF16263b;
		add(boundariesGroup);
		add(bullets);

		ui = new InfoUI(lvlID, lvlInfo);
		add(ui);
	}

	var disableGoalTemp:Bool = false;

	override public function update(elapsed:Float) {
		super.update(elapsed);

		FlxG.collide(bullets, boundariesGroup);
		if (shooter != null) {
			FlxG.collide(bullets, shooter, (a:FlxSprite, b:FlxSprite) -> a.destroy());
			FlxG.collide(shooter, boundariesGroup);
			FlxG.overlap(shooter, goal, (a, b) -> {
				if (disableGoalTemp) return;

				trace("you win!!!");
				switchlevel(lvlID + 1);
				disableGoalTemp = true;
			});
		}

		bullets.forEach((e) -> if (e.disabled) e.destroy());
		if (FlxG.keys.anyJustPressed([ESCAPE])) openSubState(new PauseSubState(0x80000000));
	}

	public function spawnBullet() {
		bullets.add(new Bullet(shooter, 15));
	}

	private function switchlevel(newLevel:Int) {
		boundariesGroup.forEach((s) -> s.destroy());
		boundariesGroup.clear();

		lvlID = newLevel;
		loadLevel();
		ui.updateInfo(lvlID, lvlInfo);
	}

	private function loadLevel() {
		var templvlInfo = globalLevelData[lvlID];
		trace(lvlID);
		trace(templvlInfo);
		if (templvlInfo == null) FlxG.switchState(MenuState.new);

		lvlInfo = templvlInfo;

		var left = new FlxSprite(0, 100).makeGraphic(10, FlxG.height - 100, 0xFFFFFFFF);
		left.immovable = true;
		boundariesGroup.add(left);

		var right = new FlxSprite(FlxG.width - 10, 100).makeGraphic(10, FlxG.height - 100, 0xFFFFFFFF);
		right.immovable = true;
		boundariesGroup.add(right);

		var up = new FlxSprite(0, 100).makeGraphic(FlxG.width, 10, 0xFFFFFFFF);
		up.immovable = true;
		boundariesGroup.add(up);

		var down = new FlxSprite(0, FlxG.height - 10).makeGraphic(FlxG.width, 10, 0xFFFFFFFF);
		down.immovable = true;
		boundariesGroup.add(down);

		if (shooter != null) shooter.destroy();
		shooter = new Shooter(templvlInfo.bulletNum);
		shooter.movementEnabled = true;
		add(shooter);

		if (goal != null) goal.destroy();
		goal = new GoalArea();
		add(goal);

		var CENTER_Y = (FlxG.height - 100) / 2 + 100;

		switch (lvlID) {
			case 1:
				createWall(0, 100, FlxG.width, 200);
				createWall(0, FlxG.height - 200, FlxG.width, 200);

				shooter.x = 300;
				shooter.y = CENTER_Y - shooter.height / 2;

				goal.x = FlxG.width - 300;
				goal.y = CENTER_Y - goal.height / 2;
			case 2:
				createWall(10, 110, 285, 280);
				createWall(475, 285, 220, 385);
				createWall(845, 465, 345, 200);
				createWall(845, 110, 345, 200);

				shooter.x = 111;
				shooter.y = 498;

				goal.x = FlxG.width - 300;
				goal.y = CENTER_Y - goal.height / 2;
		}

		disableGoalTemp = false;
	}

	public static function getConstuctor(levelID:Int):() -> PlayState {
		return () -> new PlayState(levelID);
	}

	private function createWall(x: Float, y: Float, w: Int, h: Int) {
		var wall = new FlxSprite(x, y).makeGraphic(w, h, 0xFFFFFFFF);
		wall.immovable = true;
		boundariesGroup.add(wall);
	}
}

typedef LevelInfo = {
	levelDesc:String,
	bulletNum:Int
}

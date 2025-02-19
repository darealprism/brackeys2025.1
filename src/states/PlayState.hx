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

class PlayState extends FlxState {
	public static var globalLevelData:Array<Null<LevelInfo>> = [
		null,
		{
			levelDesc: "Damn bro what the fuck am i doing",
			shotData: new ShotData(3)
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

		shooter = new Shooter();
		shooter.movementEnabled = true;
		add(shooter);

		loadLevel();

		camera.bgColor = 0xFF16263b;
		add(new Background());

		ui = new InfoUI(lvlID, lvlInfo);
		add(ui);

		add(boundariesGroup);
		add(bullets);
	}

	var disableGoalTemp:Bool = false;

	override public function update(elapsed:Float) {
		super.update(elapsed);

		FlxG.collide(shooter, boundariesGroup);
		FlxG.collide(bullets, boundariesGroup);
		FlxG.collide(bullets, shooter, (a:FlxSprite, b:FlxSprite) -> a.destroy());
		FlxG.overlap(shooter, goal, (a, b) -> {
			if (disableGoalTemp) return;

			trace("you win!!!");
			switchlevel(lvlID + 1);
			disableGoalTemp = true;
		});

		bullets.forEach((e) -> if (e.disabled) e.destroy());
	}

	public function spawnBullet() {
		bullets.add(new Bullet(shooter, 15));
	}

	private function switchlevel(newLevel:Int) {
		boundariesGroup.forEach((s) -> s.destroy());
		boundariesGroup.clear();

		lvlID = newLevel;
		loadLevel();
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

		goal = new GoalArea();
		add(goal);

		switch (lvlID) {
			case 1:

				shooter.x = 300;
				shooter.y = FlxG.height / 2 - shooter.height / 2;

				goal.x = FlxG.width - 300;
				goal.y = FlxG.height / 2 - goal.height / 2;
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
	shotData:ShotData
}

package sprites;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Shooter extends FlxSprite {
    public var movementEnabled: Bool = false;
	public var shotData:ShotData;

    var barrel: FlxSprite;

	public function new(bulletNum:Int) {
        super(200, 200);
        loadGraphic("assets/images/shooter.png", false);

		shotData = new ShotData(bulletNum);

		elasticity = 1;
		mass = .25;
        solid = true;
		scale.set(0.1, 0.1);
        updateHitbox();

        barrel = new FlxSprite();
        barrel.loadGraphic("assets/images/barrel.png", false);
		barrel.scale.set(0.1, 0.1);
        barrel.updateHitbox();
        FlxG.state.add(barrel);
    }

    override public function update(elapsed:Float) {
        if (movementEnabled) movement(elapsed);

        velocity.set(velocity.x * 0.95, velocity.y * 0.95);

        barrel.x = x + Math.cos((angle + 180) * (Math.PI / 180)) * width * 0.5;
        barrel.y = y + Math.sin((angle + 180) * (Math.PI / 180)) * width * 0.5;
        barrel.angle = angle + 90;
        
        super.update(elapsed);
    }

    public function movement(elapsed:Float) {
        angle = new FlxPoint(x + width / 2, y + height / 2).degreesTo(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y)) + 180;
        updateHitbox();

        shotData.update(elapsed);

		if ((FlxG.mouse.pressed || FlxG.keys.anyPressed([SPACE])) && shotData.canUse()) {
            shotData.bulletCount -= 1;
			cast(FlxG.state, states.PlayState).spawnBullet();
            shotData.reset();

            velocity.add(
			Math.cos(angle * (Math.PI / 180)) * shotData.shotStrength * 0.5, Math.sin(angle * (Math.PI / 180)) * shotData.shotStrength * 0.5
            );
        }
    }

    override function revive() {
        barrel.revive();
        super.revive();
    }

    override function kill() {
        barrel.kill();
        super.kill();
    }

    override function destroy() {
        barrel.destroy();
        super.destroy();
    }
}

class ShotData {
    public var bulletCount: Int;
	public var cooldown:Float = 1;
    public var timer: Float = 0;

    public var shotStrength: Float;

	public function new(startingBulletCount:Int = 3, shotStrength:Float = 750) {
        this.shotStrength = shotStrength;
        this.bulletCount = startingBulletCount;
    }

    public function update(deltaTime: Float): Void {
        timer -= deltaTime;
        timer = Math.max(0, timer);
    }

	public function canUse():Bool {
		return timer <= 0 && this.bulletCount > 0;
    }

    public function reset(): Void {
        timer = cooldown;
    }
}
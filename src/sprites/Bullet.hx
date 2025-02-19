package sprites;

import flixel.FlxSprite;

class Bullet extends FlxSprite {
	var lifetime:Float = 0;

	public var disabled:Bool = false;

	public function new(shooter:Shooter, size:Int) {
		super(shooter.x + shooter.width / 2 - size * 0.5, shooter.y + shooter.height / 2 - size * 0.5);
		makeGraphic(size, size, 0xFFFFFFFF);
		solid = true;
		elasticity = 1;

		velocity.set(Math.cos((shooter.angle + 180) * (Math.PI / 180)) * shooter.shotData.shotStrength,
			Math.sin((shooter.angle + 180) * (Math.PI / 180)) * shooter.shotData.shotStrength);
	}

	override public function update(elapsed:Float) {
		lifetime += elapsed;

		if (lifetime >= 5) disabled = true;
		alpha = Math.min(1, 5 - lifetime);
        
		super.update(elapsed);
	}
}
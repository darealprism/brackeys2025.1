package sprites;

import flixel.addons.display.FlxBackdrop;

class Background extends FlxBackdrop {
    public function new() {
        super("assets/images/parralax.png", XY);
        color = 0xFFFFFF;
        alpha = 0.25;
        scale.set(0.15, 0.15);
        velocity.set(25, 25);
        scrollFactor.set(0.1, 0.1);
    }
}
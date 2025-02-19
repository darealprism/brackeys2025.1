package sprites;

import flixel.FlxSprite;

class GoalArea extends FlxSprite {
    public function new() {
        super();
        makeGraphic(80, 80, 0xFF00FF00);
        immovable = true;
    }
}
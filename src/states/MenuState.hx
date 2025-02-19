package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import sprites.Background;

class MenuState extends FlxState {
    public var menuItemData: Array<MenuItem> = [
        {
            name: "Play",
            state: PlayState.getConstuctor(1)
        }
    ];

    var logo: FlxSprite;

    var menuSelectables: FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
    var curSelection: Int = 0;

    override function create() {
        super.create();

        camera.bgColor = 0xFF6D2A6D;
        add(new Background());

        logo = new FlxSprite(0, 0);
        logo.loadGraphic("assets/images/logo.png");
        logo.scale.set(0.625, 0.625);
        logo.updateHitbox();

        logo.screenCenter(X);
        logo.y = 50;
        add(logo);

        for (i in 0...menuItemData.length) {
            var item: MenuItem = menuItemData[i];

            var newItem = new FlxText(0, i * 100, FlxG.width / 2, item.name);
            newItem.screenCenter(XY);
            newItem.size = 50;
            newItem.alignment = CENTER;
            newItem.borderSize = 4;
            newItem.borderColor = 0xFF000000;
            newItem.ID = i;
            menuSelectables.add(newItem);
        }

        add(menuSelectables);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        logo.y = 50 + Math.sin(Date.now().getTime() / 500) * 10;

        menuSelectables.forEach((s) -> {
            s.color = s.ID == curSelection ? 0xFFFFFF00 : 0xFFFFFFFF;
        });

        if (FlxG.keys.anyJustPressed([SPACE])) FlxG.switchState(menuItemData[curSelection].state);
    }
}

typedef MenuItem = {
    name: String,
    state: () -> FlxState
}
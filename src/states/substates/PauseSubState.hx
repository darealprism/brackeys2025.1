package states.substates;

import flixel.FlxG;
import flixel.FlxSubState;
import openfl.filters.ShaderFilter;
import shaders.WiggleShader;

class PauseSubState extends FlxSubState {
    override function create() {
        super.create();

        openCallback = _open;
        closeCallback = _close;
    }

    public function _open() {
        
    }

    public function _close() {

    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.anyJustPressed([ENTER, SPACE, ESCAPE])) close();
    }
}
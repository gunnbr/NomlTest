package ;

import InstructionsScene;
import openfl.display.Sprite;
import org.si.b3.CMLMovieClip;

#if ouya
import openfl.utils.JNI;
import tv.ouya.console.api.OuyaController;
#end

class Main extends Sprite{
    public static var mc:CMLMovieClip;
    public static var resManager:ResourceManager;
    public static var scoreManager:ScoreManager;
    public static var actManager:ActorManager;

    function new() {
        super();
        resManager = new ResourceManager(onResourceLoaded, null);
        scoreManager = new ScoreManager();
        actManager = new ActorManager();
    }

    public function onResourceLoaded():Void {
        mc = new CMLMovieClip(this, 8, 8, 450, 450, 0xffffff, true, setup);
        mc.control.map(CMLMovieClip.KEY_ESCAPE, ["Q"]);
        mc.scene.register("title", new TitleScene());
        mc.scene.register("instructions", new InstructionsScene());
        mc.scene.register("main", new MainScene());
        mc.scene.register("gameover", new GameoverScene());
        mc.scene.id = "title";
    }

    public function setup():Void {
        addChild(resManager.sionDriver);
        resManager.sionDriver.bpm = 152;
        resManager.sionDriver.play();
    }
}


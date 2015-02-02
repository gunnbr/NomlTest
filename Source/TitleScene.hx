package ;

import org.si.b3.modules.CMLScene;
import org.si.b3.modules.CMLMovieClipSceneManager;
import openfl._v2.events.Event;
import org.si.b3.CMLMovieClip;

class TitleScene extends CMLScene {
    private var menuIndex:Int;
    private var startLevel:Int;
    private var menu:Array<String> = ["Press [Z] Key To Start", "Show Net Ranking", "Clear Cookie", "Debug Mode"];
    private var anim:Array<Int> = [0, 4, 7, 9, 10, 9, 7, 4];

    public override function enter():Void {
        Main.mc.fps.reset();
        menuIndex = 0;
        startLevel = 0;
        Main.scoreManager.reset(true);
        Main.actManager.reset();
        Main.scoreManager.debugMode = false;
    }

    public override function update():Void {
        if (!Main.mc.pause) {
            if (Main.mc.control.isHitted(CMLMovieClip.KEY_BUTTON0)) {
                if (menuIndex == 2) {
                    Main.scoreManager.clearCookie();
                    Main.scoreManager.reset(true);
                }
                else if (menuIndex == 1) {
                    Main.mc.pause = true;
                    Main.resManager.showRanking(function():Void { Main.mc.pause = false; });
                }
                else Main.mc.scene.id = "main";
            }
            else if (Main.mc.control.isHitted(CMLMovieClip.KEY_RIGHT)) {
                if (--menuIndex == -1) menuIndex = menu.length - 1;
#if SION_ENABLED
                Noml.resManager.sionDriver.noteOn(67, Noml.resManager.beep, 1);
#end
            }
            else if (Main.mc.control.isHitted(CMLMovieClip.KEY_LEFT)) {
                if (++menuIndex == menu.length) menuIndex = 0;
#if SION_ENABLED
                Noml.resManager.sionDriver.noteOn(67, Noml.resManager.beep, 1);
#end
            }
            else {
                startLevel -= cast(Main.mc.control.y * 5, Int);
                if (startLevel < 0) startLevel = 0;
                else if (startLevel > 250) startLevel = 250;
            }
        }
    }

    public override function draw():Void {
        var menuString:String = menu[menuIndex], width:Int = menuString.length * 8,
        frameCount:Int = Main.mc.fps.totalFrame;
        Main.mc.copyPixels(Main.resManager.background, 0, 0, 450, 450, -225, -225);
        Main.scoreManager.draw();
        Main.resManager.print(-166, -56, "NOMLTEST HX", Main.resManager.lfonttex, 32);
        Main.resManager.print(-width, 160, menuString, Main.resManager.fonttex, 16);
        Main.resManager.print(-196 - anim[frameCount & 7], 160, "{", Main.resManager.fonttex, 16);
        Main.resManager.print(180 + anim[frameCount & 7], 160, "}", Main.resManager.fonttex, 16);
        Main.resManager.print(-128, 90, "START LEVEL : " + startLevel, Main.resManager.fonttex, 16);

        if (frameCount > 5 * 30) {
            Main.mc.scene.id = "instructions";
        }
    }

    public override function exit():Void {
        Main.scoreManager.startLevel = startLevel;
        Main.scoreManager.debugMode = (menuIndex == 3);
    }
}


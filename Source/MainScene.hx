package ;

import org.si.b3.CMLMovieClip;
import org.si.b3.modules.CMLScene;
import Main;

class MainScene extends CMLScene {
    public override function enter():Void {
        Main.mc.fps.reset();
        Main.scoreManager.reset(false);
        Main.actManager.reset();
        Main.actManager.start();
        Main.resManager.sionDriver.play(Main.resManager.bgm);
#if SION_ENABLED
        Main.resManager.sionDriver.playSound(6, 1, 0, 0, 2);
#end
    }

    public override function update():Void {
        Main.scoreManager.update();
        Main.actManager.update();
        if (Main.mc.control.getPressedFrame(CMLMovieClip.KEY_ESCAPE) > 15) {
            Main.resManager.sionDriver.play();
            Main.mc.scene.id = "title";
        }
    }

    public override function draw():Void {
        var f:Int;
        var t:Float;
        Main.mc.copyPixels(Main.resManager.background, 0, 0, 450, 450, -225, -225);
        Main.scoreManager.draw();
        Main.actManager.draw();
        if (Main.mc.fps.totalFrame < 90) {
            f = Main.mc.fps.totalFrame;
            if (f < 70) {
                t = (f < 50) ? ((40 - f) * (40 - f) - 100) * 0.2 : 0;
                Main.resManager.print(-102 - t, -32, "ARE YOU", Main.resManager.lfonttex, 32);
                Main.resManager.print(-102 + t, 0, "READY ?", Main.resManager.lfonttex, 32);
            }
            else {
                Main.resManager.print(-70, -16, "GO !!", Main.resManager.lfonttex, 32);
            }
        }
    }
}

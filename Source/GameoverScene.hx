package ;


import org.si.b3.modules.CMLScene;
import org.si.b3.CMLMovieClip;
import openfl._v2.events.Event;

class GameoverScene extends CMLScene {
    private var referenceRecord:Bool;

    public override function enter():Void {
        referenceRecord = (Main.scoreManager.delayedFrames > Main.mc.fps.totalFrame * 0.1);
        Main.mc.fps.reset();
#if SION_ENABLED
        Noml.resManager.sionDriver.play(Noml.resManager.gameover);
        Noml.resManager.sionDriver.playSound(2, 1, 0, 0, 2);
#end
    }

    public override function update():Void {
        if (!Main.mc.pause) {
            Main.scoreManager.update();
            Main.actManager.update();
            if (Main.mc.fps.totalFrame > 60 && Main.mc.control.isHitted(CMLMovieClip.KEY_BUTTON0)) {
                if (!referenceRecord && Main.scoreManager.checkResult()) {
                    Main.mc.pause = true;
                    Main.resManager.registerRanking(function():Void {
                        Main.mc.pause = false;
                        Main.mc.scene.id = "title";
                    });
                }
                else Main.mc.scene.id = "title";
            }
        }
    }

    public override function draw():Void {
        Main.mc.copyPixels(Main.resManager.background, 0, 0, 450, 450, -225, -225);
        Main.scoreManager.draw();
        Main.actManager.draw();
        Main.resManager.print(-136, -32, "GAME OVER", Main.resManager.lfonttex, 32);
        if (referenceRecord) Main.resManager.print(-96, 16, "REFERENCE=RECORD", Main.resManager.numtex, 12, 48);
    }
}


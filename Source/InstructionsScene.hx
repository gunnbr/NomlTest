package ;

import openfl.Vector;
import openfl._v2.display.Graphics;
import openfl._v2.display.Shape;
import org.si.b3.modules.CMLScene;
import org.si.b3.modules.CMLMovieClipSceneManager;
import org.si.b3.CMLMovieClip;

class InstructionsScene extends CMLScene {

    public var eatRangeShape:Shape;
    public var eatRangeAngle:Float;
    public var eatRangeDraw:Float = 40;

    public override function enter():Void {
        Main.mc.fps.reset();
        eatRangeAngle = 0;
        eatRangeShape = new Shape();
    }

    public override function update():Void {
        if (!Main.mc.pause) {
            if (Main.mc.control.isHitted(CMLMovieClip.KEY_BUTTON0)) {
                Main.mc.scene.id = "title";
            }

            eatRangeAngle += eatRangeDraw * 0.002;
        }
    }

    public override function draw():Void {
        var frameCount:Int = Main.mc.fps.totalFrame;
        var animFrame = frameCount >> 2; // To slow down the animations
        var joyFrame = ((frameCount >> 4) %4) + 2;

        // Draw the background
        Main.mc.copyPixels(Main.resManager.background, 0, 0, 450, 450, -225, -225);

        // Draw the instructions
        Main.resManager.print(-192, -200, "INSTRUCTIONS", Main.resManager.lfonttex, 32);

        Main.resManager.print( -96, -140, "MOVE WITH ", Main.resManager.fonttex, 16);
        Main.mc.copyTexture(Main.resManager.ouyaTexture, 70, -133, joyFrame);

        Main.resManager.print( -96, -92, "SHOOT ALIENS", Main.resManager.fonttex, 16);
        Main.mc.copyTexture(Main.resManager.enemyTextures[0], -120, -55, (animFrame % Main.resManager.enemyTextures[0].animationCount));
        Main.mc.copyTexture(Main.resManager.enemyTextures[4],  -40, -55, (animFrame % Main.resManager.enemyTextures[4].animationCount));
        Main.mc.copyTexture(Main.resManager.enemyTextures[8],   40, -55, (animFrame % Main.resManager.enemyTextures[8].animationCount));
        Main.mc.copyTexture(Main.resManager.enemyTextures[9],  120, -55, (animFrame % Main.resManager.enemyTextures[9].animationCount));

        Main.resManager.print(-152,  -10, "THREE SHOT PATTERNS", Main.resManager.fonttex, 16);
        Main.mc.copyTexture(Main.resManager.ouyaTexture, -90, 23, 0);
        Main.mc.copyTexture(Main.resManager.ouyaTexture, -26, 23, 1);
        Main.mc.copyTexture(Main.resManager.ouyaTexture,  38, 23, 0);
        Main.resManager.print(55, 16, "+", Main.resManager.lfonttex, 16);
        Main.mc.copyTexture(Main.resManager.ouyaTexture, 86, 23, 1);

        Main.resManager.print(-136,   60, "AVOID ALIEN SHOTS", Main.resManager.fonttex, 16);
        Main.mc.copyTexture(Main.resManager.bulletTextures[0], -130, 90, (animFrame % Main.resManager.bulletTextures[0].animationCount));
        Main.mc.copyTexture(Main.resManager.bulletTextures[1],  -81, 90, (animFrame % Main.resManager.bulletTextures[1].animationCount));
        Main.mc.copyTexture(Main.resManager.bulletTextures[2],  -33, 90, (animFrame % Main.resManager.bulletTextures[2].animationCount));
        Main.mc.copyTexture(Main.resManager.bulletTextures[3],   17, 90, (animFrame % Main.resManager.bulletTextures[3].animationCount));
        Main.mc.copyTexture(Main.resManager.bulletTextures[4],   65, 90, (animFrame % Main.resManager.bulletTextures[4].animationCount));
        Main.mc.copyTexture(Main.resManager.bulletTextures[5],  114, 90, (animFrame % Main.resManager.bulletTextures[5].animationCount));

        Main.resManager.print(-168,   120, "CATCH SHOTS FOR BONUS", Main.resManager.fonttex, 16);
        updateEatRange();
        Main.mc.draw(eatRangeShape, 0, 180);

        if (frameCount > 30 * 30) {
            Main.mc.scene.id = "title";
        }
    }

    public override function exit():Void {
    }

    private var cmd:Array<Int> = [1, 2, 2, 2, 2];
    private var path:Array<Float> = new Array<Float>();
    private function updateEatRange() : Void {
        var g:Graphics = eatRangeShape.graphics,
            sin:Float = Math.sin(eatRangeAngle) * eatRangeDraw,
            cos:Float = Math.cos(eatRangeAngle) * eatRangeDraw,
            asin:Float = (sin<0) ? - sin : sin,
            acos:Float = (cos<0) ? - cos : cos;
        path[0] = cos; path[1] = sin;
        path[2] = - sin; path[3] = cos;
        path[4] = -cos; path[5] = - sin;
        path[6] = sin; path[7] = - cos;
        path[8] = cos; path[9] = sin;
        g.clear();
        g.lineStyle(2, 0x4040c0, 0.5);
        g.drawPath(cmd, path);
        g.drawRect( -acos, - asin, acos * 2, asin* 2);
    }
}


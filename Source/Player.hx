package ;

import openfl._v2.display.Graphics;
import openfl._v2.Vector;
import org.si.cml.CMLObject;
import openfl._v2.display.Shape;
import org.si.cml.extensions.Actor;

class Player extends Actor {
    static public inline var STATUS_TRANSPARENT:Int = 0;
    static public inline var STATUS_NORMAL:Int = 1;
    static public inline var STATUS_INVISIBLE:Int = 2;
    public var status:Int;
    public var statuFrameCount:Int;
    public var animationCount:Int;
    public var hitSize2:Float;
    public var shotFlag:Int;
    public var eatRangeShape:Shape;
    public var eatRangeAngle:Float;
    public var eatRangeDraw:Float;
    public var playerSpeed:Array<Int> = [10, 9, 9, 5];
    public var eatRange:Array<Int> = [60, 45, 30, 55];

    public function new() {
        super();
        scopeEnabled = false;
        eatRangeAngle = 0;
        size = 60;
        hitSize2 = 16;
        eatRangeDraw = 0;
        eatRangeShape = new Shape();
    }

    override public function onCreate():Void {
        animationCount = 0;
        shotFlag = 0;
        setAsDefaultTarget();
        expandScope(-16 - Main.mc.scopeMargin, -16 - Main.mc.scopeMargin);
        status = STATUS_INVISIBLE;
        statuFrameCount = 30;
    }

    override public function onUpdate():Void {
        var ix:Int = cast(Main.mc.control.x,Int);
        var iy:Int = cast(Main.mc.control.y,Int);
        var flg:Int = (Main.mc.control.flag >> 4) & 3;
        var dx:Float = ix * ((iy == 0) ? 1 : 0.707);
        var dy:Float = iy * ((ix == 0) ? 1 : 0.707),
        spd:Float = playerSpeed[flg];

        if (status != STATUS_INVISIBLE) {
            x += dx * spd;
            y += dy * spd;
            limitScope();
            if (shotFlag != flg) {
                halt();
                shotFlag = flg;
                if (shotFlag > 0) {
                    execute(Main.resManager.shotSeq[shotFlag - 1]);
                }
                size = eatRange[shotFlag];
            }
            eatRangeAngle += eatRangeDraw * 0.002;
            if (size > eatRangeDraw) {
                eatRangeDraw += 2;
            }
            else if (size < eatRangeDraw) {
                eatRangeDraw -= 2;
            }
        }

        if (--statuFrameCount == 0) {
            if (status == STATUS_TRANSPARENT)
                status = STATUS_NORMAL;
            else
                setTransparent();
        }
    }

    override public function onDraw():Void {
        if (status != STATUS_INVISIBLE) {
            animationCount++;
            if ((status == STATUS_NORMAL) || ((animationCount & 1) == 1)) {
                Main.mc.copyTexture(Main.resManager.playerTexture, Math.floor(x), Math.floor(y));
            }
            updateEatRange();
            Main.mc.draw(eatRangeShape, x, y);
        }
        else {
            var localY = y + (((statuFrameCount - 6) * (statuFrameCount - 6) - 36) * 0.4);
            Main.mc.copyTexture(Main.resManager.playerTexture, Math.floor(x), Math.floor(localY));
        }
    }

    override public function onFireObject(args:Array<Dynamic>):CMLObject {
        return Main.actManager.shots.newInstance();
    }

    override public function onHit(act:Actor):Void {
        if (status == STATUS_TRANSPARENT) return;
        var dx:Float = act.x - x, dy:Float = act.y - y, i:Int;
        if (dx * dx + dy * dy < hitSize2) {
            Particle.createParticle(x, y, 0, 0, 0, 0, 0, Main.resManager.explosionTextures[12]);
            for (i in 0...32) Particle.createParticle(x, y, Math.random() * 8 - 4, Math.random() * 6 - 8, 0, 0.4, 0xaaaac3);
            setDestruction(Main.scoreManager.miss());
        }
    }

    public function setTransparent():Void {
        status = STATUS_TRANSPARENT;
        statuFrameCount = 60;
    }

    public function setDestruction(gameover:Bool):Void {
        halt();
        status = STATUS_INVISIBLE;
        if (!gameover) {
            statuFrameCount = 30;
#if SION_ENABLED
            Noml.resManager.sionDriver.playSound(2, 1, 0, 0, 2);
#end
        }
        else {
            statuFrameCount = -1;
        }
    }

    private var cmd:Vector<Int> = Vector.ofArray([1, 2, 2, 2, 2]);
    private var path:Vector<Float> = new Vector<Float>(10);
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

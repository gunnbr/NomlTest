package;

import org.si.b3.CMLMovieClipTexture;
import org.si.cml.extensions.Actor;
import org.si.cml.CMLObject;

class Bullet extends Actor {
    public var texture:CMLMovieClipTexture;
    public var ac:Int = 0;
    public var acmax:Int = 0;
    public var acspd:Int = 0;
    public var shape:Int = 0;

    public function new() {
        super();
        size = 4;
    }

    public function init(args:Array<Dynamic>) : Bullet {
        try {
            shape = cast(args[0],Int);
        }
        catch (e:Dynamic) {
            //trace('*** Invalid parameter <${args[0]}> to Bullet.init(): $e');
            shape = 0;
        }

        texture = Main.resManager.bulletTextures[shape];
        acspd = 1;
        life = 1;
        acmax = texture.animationCount << acspd;
        return this;
    }

    override public function onCreate() : Void { ac = (shape<3) ? 0 : Math.round((angleOnStage * 0.08888888888888889 + 8.5)) & 15; }
    override public function onUpdate() : Void { if (shape<3 && ++ac==acmax) ac = 0; super.onUpdate(); }
    override public function onDraw() : Void { Main.mc.copyTexture(texture, Math.round(x), Math.round(y), ac>>acspd); }
    override public function onFireObject(args:Array<Dynamic>) : CMLObject { return Main.actManager.bullets.newInstance().init(args); }
    override public function onHit(act:Actor) : Void {
        var dx:Float = (vx < 0) ? - vx : vx, dy:Float = (vy < 0) ? - vy : vy,
        v:Float = (dx > dy) ? (dx + dy * 0.2928932188134524) : (dy + dx * 0.2928932188134524);

        life -= v * 0.0125;

        if (life <= 0) {
            destroy(1);
#if SION_ENABLED
            resManager.sionDriver.playSound(4, 1, 0, 0, 4);
#end
            dx = Main.actManager.player.x - x;
            dy = Main.actManager.player.y - y;
            v = 3 / Math.sqrt(dx * dx + dy * dy);
            Particle.createParticle(x, y, - dx *v, - dy * v, dx * v* 0.18, dy * v * 0.18, 0, Main.resManager.scoreTextures[Main.scoreManager.eat()]);
        }
    }
}


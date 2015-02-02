package ;

import org.si.cml.CMLObject;
import org.si.cml.CMLSequence;
import org.si.cml.extensions.Actor;
import org.si.b3.CMLMovieClipTexture;

class Enemy extends Actor {
    private var flagDamage:Int = 0;
    public var type:Int;
    public var group:Group;
    public var texture:CMLMovieClipTexture;
    public var bonus:Int;

    public function new() {
        super();
    }

    override public function onCreate() : Void {
        var seq:CMLSequence = Main.resManager.enemySeq[type];
        flagDamage = 0;
        life = seq.getParameter(0);
        bonus = Math.round(seq.getParameter(1));
        texture = Main.resManager.enemyTextures[type];
        size = texture.center.x;
        execute(seq);
    }
    override public function onDestroy() : Void {
        group.onChildDestroy(this);
        if (destructionStatus > 0) {
            Particle.createParticle(x, y, vx, vy, - vx * 0.04, - vy * 0.04, 0, Main.resManager.explosionTextures[type]);
            if (destructionStatus == 1) {
                Particle.createParticle(x, y, 0, - 6, 0, 0.5, 0, Main.resManager.scoreTextures[bonus]);
                var i:Int;
                var col:Int = Main.resManager.enemyColors[type];
                for (i in 0...6) Particle.createParticle(x, y, Math.random() *4 - 2 + vx * 0.3, Math.random() * 4 - 2 + vy *0.3, 0, 0.5, col);
            }
        }
    }
    override public function onDraw() : Void { --flagDamage; Main.mc.copyTexture(texture, Math.round(x), Math.round(y), isFlashing()); }
    override public function onFireObject(args:Array<Dynamic>) : CMLObject { return Main.actManager.bullets.newInstance().init(args); }
    override public function onHit(act:Actor) : Void {
        flagDamage = 6;
        if (life != 0) {
            life -= 1;
            if (life > 5) Particle.createParticle(x, y, Math.random() * 4 - 2, Math.random() * 4 - 2, 0, 0.5, Main.resManager.enemyColors[type]);
            if (life <= 0) {
                destroy(1);
#if SION_ENABLED
                resManager.sionDriver.playSound((size>24)?1:3, 1, 0, 0, 1);
#end
                Main.scoreManager.addScore(bonus * 10);
            }
        }
    }
    private function isFlashing() : Int {
        return (flagDamage>0) ? (flagDamage &1) : 0;
    }
}

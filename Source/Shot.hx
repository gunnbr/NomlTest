package;

import org.si.cml.extensions.Actor;

class Shot extends Actor {
    public function new() { super(); size = 10; }
    override public function onCreate() : Void { }//scopeYmax = 400; }
    override public function onDraw() : Void { Main.mc.copyTexture(Main.resManager.shotTexture, Math.round(x), Math.round(y)); }
    override public function onHit(act:Actor) : Void { destroy(1); }
}

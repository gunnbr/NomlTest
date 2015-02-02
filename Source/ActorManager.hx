package ;

import org.si.cml.extensions.Actor;
import org.si.cml.CMLObject;
import org.si.cml.extensions.ActorFactory;

//--------------------------------------------------------------------------------
class ActorManager {
    public var shots:ActorFactory;
    public var enemies:ActorFactory;
    public var bullets:ActorFactory;
    public var player:Player;
    public var master:Group;
    public var frameCounter:Int;
    public var groupID:Int;
    public var pauseRoot:Bool = false;

    public function new() {
        shots = new ActorFactory(Shot, 0, 0);
        enemies = new ActorFactory(Enemy, 0, 1);
        bullets = new ActorFactory(Bullet, 0, 2);
        player = new Player();
        player.evalIDNumber = 3;
        player.drawPriority = enemies.drawPriority;
        Particle.initialize(640);
    }

    public function reset():Void {
        CMLObject.destroyAll(0);
        Particle.reset();
    }

    public function start():Void {
        player.create(0, 180);
        master = new Group();
        master.create(0, 0);
        master.execute(Main.resManager.stageSequence);
    }

    public function draw():Void {
        Particle.draw();
        Actor.draw();
    }

    public function update():Void {
        // Actor.update() is called from CMLMovieClip
        Particle.update();
        if (player.status != Player.STATUS_INVISIBLE) {
            Actor.testf(bullets.evalIDNumber, player.evalIDNumber);
        }
        Actor.testf(shots.evalIDNumber, enemies.evalIDNumber);
    }

    public function destroyAllEnemies():Void {
        eval(enemies.evalIDNumber,
        function(act:Actor):Void {
            act.destroy(2);
        });
        eval(bullets.evalIDNumber,
        function(act:Actor):Void {
            Particle.createParticle(act.x, act.y, Math.random() * 8 - 4, Math.random() * 6 - 4, 0, 0.4, 0xaaaac3);
            act.destroy(0);
        });
    }

    static public function eval(evalID:Int, func:Actor->Void):Void {
        var act:Actor;
        var list:Actor = Actor._evalLayers[evalID];

        act = list._nextEval;
        while (act!=list) {
            func(act);
            act = act._nextEval;
        }
    }
}


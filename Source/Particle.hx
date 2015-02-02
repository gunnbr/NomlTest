package ;

import openfl._v2.display.BitmapData;
import openfl._v2.geom.Rectangle;
import org.si.b3.CMLMovieClipTexture;

class Particle {
    public var x:Float;
    public var y:Float;
    public var vx:Float;
    public var vy:Float;
    public var ax:Float;
    public var ay:Float;
    public var color:Int;
    public var anim:Int;
    public var tex:CMLMovieClipTexture;
    public var next:Particle;

    public function new(next_:Particle) { 
        next = next_; 
    }
    
    static private var _freeList:Particle = null;
    static private var _particles:Array<Particle> = [new Particle(null), new Particle(null)];
    static private var _width:Float;
    static private var _height:Float;
    static private var _rc:Rectangle = new Rectangle(0, 0, 4, 4);
    
    static public function initialize(particleMax:Int) : Void {
        var i:Int;
        for (i in 0...particleMax) _freeList = new Particle(_freeList);
        _width = 450;
        _height = 450;
    }

    static public function reset() : Void {
        var i:Int, p:Particle;
        for (i in 0...2) {
            p = _particles[i].next;
            if (p != null) {
                while (p.next != null) p = p.next;
                p.next = _freeList;
                _freeList = _particles[i].next;
                _particles[i].next = null;
            }
        }
    }

    static public function update() : Void {
        var p:Particle;
        var prev:Particle;
        var i:Int;

        for (i in 0...2) {
            prev = _particles[i];
            p = prev.next;
            while (p != null) {
                p.x += (p.vx += p.ax);
                p.y += (p.vy += p.ay);
                if (p.y>_height || ++p.anim == 16) {
                    prev.next = p.next;
                    p.next = _freeList;
                    _freeList = p;
                    p = prev;
                } else {
                    prev = p;
                }
                p = p.next;
            }
        }
    }

    static public function draw() : Void {
        var p:Particle;
        var screen:BitmapData = Main.mc.screen;

        p = _particles[0].next;
        while (p != null) {
            _rc.x = p.x;
            _rc.y = p.y;
            screen.fillRect(_rc, p.color);
            p = p.next;
        }

        p = _particles[1].next;
        while (p != null) {
            Main.mc.copyTexture(p.tex, Math.round(p.x), Math.round(p.y), (p.tex.animationCount>1)?p.anim:0);
            p = p.next;
        }
    }

    static public function createParticle(x:Float, y:Float, vx:Float, vy:Float, ax:Float, ay:Float, color:Int, tex:CMLMovieClipTexture = null) : Void {
        if (_freeList == null) return;
        var newParticle:Particle = _freeList;
        var list:Particle;

        _freeList = _freeList.next;
        if (tex != null) {
            newParticle.x = x;
            newParticle.y = y;
            newParticle.anim = 0;
            list = _particles[1];
        } else {
            newParticle.x = x + _width * 0.5;
            newParticle.y = y + _height * 0.5;
            newParticle.anim = - 256;
            list = _particles[0];
        }
        newParticle.vx = vx;
        newParticle.vy = vy;
        newParticle.ax = ax;
        newParticle.ay = ay;
        newParticle.tex = tex;
        newParticle.color = color;
        newParticle.next = list.next;
        list.next = newParticle;
    }
}


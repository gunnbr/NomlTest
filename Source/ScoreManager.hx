package ;

//--------------------------------------------------------------------------------
import openfl._v2.net.SharedObject;
import org.si.cml.CMLObject;

class BestScore {
    public var score:Int;
    public var level:Int;
    public var eaten:Int;
    public var lines:Int;

    public function new() {  }
}

class ScoreManager {
    private static inline var extendScore:Int = 200000;
    private static inline var defaultLife:Int = 3;

    public var score:Int;
    public var level:Int;
    public var eaten:Int;
    public var life:Int;
    public var eatBonus:Int;
    public var nextExtend:Int;
    public var gameoverLevel:Int;
    public var bestResult:BestScore = new BestScore();
    public var startLevel:Int;
    public var debugMode:Bool;
    public var delayedFrames:Int;
    private var _scoreDraw:Int;
    private var _levelDraw:Int;
    private var _eatenDraw:Int;
    private var _lifeDraw:Int;
    private var _scoreText:String;
    private var _levelText:String;
    private var _eatenText:String;
    private var _lifeText:String;

    public function new() {
        _loadCookie();
        reset(false);
    }

    public function reset(setHighScore:Bool):Void {
        CMLObject.globalRank = startLevel;
        _scoreDraw = score = (setHighScore) ? bestResult.score : 0;
        _levelDraw = level = (setHighScore) ? bestResult.level : startLevel;
        _eatenDraw = eaten = (setHighScore) ? bestResult.eaten : 0;
        _scoreText = "SCORE:" + '000000000$_scoreDraw'.substr(-10);
        _levelText = "LEVEL:" + '00$_levelDraw'.substr(-3);
        _eatenText = "EATEN:" + '00000$_eatenDraw'.substr(-6);
        _lifeText = "LIFE :";
        _lifeDraw = 0;
        life = (debugMode) ? 0 : defaultLife;
        eatBonus = 2;
        nextExtend = extendScore;
        delayedFrames = 0;
    }

    public function update():Void {
        var dif:Int = (score - _scoreDraw + 7) >> 3;
        level = Math.floor(CMLObject.globalRank);
        _scoreDraw += dif;
        if (dif > 0) {
            _scoreText = "SCORE:" + '000000000$_scoreDraw'.substr(-10);
        }
        if (_levelDraw != level) {
            _levelDraw = level;
            _levelText = "LEVEL:" + '00$_levelDraw'.substr(-3);
        }
        if (_eatenDraw != eaten) {
            _eatenDraw = eaten;
            _eatenText = "EATEN:" + '00000$_eatenDraw'.substr(-6);
        }
        if (_lifeDraw != life) {
            _lifeDraw = life;
            if (debugMode) {
                _lifeText = 'MISS :$_lifeDraw';
            }
            else {
                _lifeText = "LIFE :";
                var i:Int;
                for (i in 0..._lifeDraw) _lifeText += "|";
            }
        }
        if (Main.mc.fps.frameSkipLevel > 3) delayedFrames++;
    }

    public function draw():Void {
        Main.resManager.print(-220, -220, _scoreText, Main.resManager.fonttex, 16);
        Main.resManager.print(-220, -204, _levelText, Main.resManager.fonttex, 16);
        Main.resManager.print(-220, -188, _eatenText, Main.resManager.fonttex, 16);
        Main.resManager.print(-220, -172, _lifeText, Main.resManager.fonttex, 16);
        if (debugMode) {
            Main.resManager.print(-223, 190, "PRESS [Q] TO EXIT", Main.resManager.fonttex, 16);
            var fps = Math.round(Main.mc.fps.delayedFrames * 100) / 100;
            Main.resManager.print(-223, 209, "FRAME DELAY :" + fps, Main.resManager.fonttex, 16);
        }
    }

    public function checkResult():Bool {
        return _updateCookie();
    }

    public function destroyAll(groupBonus:Int):Void {
        eatBonus += 3;
        if (eatBonus > 50) eatBonus = 50;
        addScore(groupBonus);
    }

    public function destroyAllFailed():Void {
        eatBonus -= 2;
        if (eatBonus < 1) eatBonus = 1;
    }

    public function miss():Bool {
        Main.actManager.destroyAllEnemies();
        eatBonus >>= 1;
        if (eatBonus < 1) eatBonus = 1;
        if (debugMode) {
            life++;
        }
        else {
            if (--life < 0) {
                gameoverLevel = level;
                Main.mc.scene.id = "gameover";
                return true;
            }
        }
        return false;
    }

    public function eat():Int {
        eaten++;
        addScore(eatBonus * 10);
        return eatBonus;
    }

    public function addScore(gain:Int):Void {
        score += gain;
        if (score >= nextExtend) {
            nextExtend += extendScore;
            life++;
#if SION_ENABLED
            Noml.resManager.sionDriver.playSound(5, 1, 0, 0, 3);
#end
            Particle.createParticle(Main.actManager.player.x, Main.actManager.player.y, 0, -10, 0, 0.75, 0, Main.resManager.lifeUpTexture);
        }
    }

    public function clearCookie():Void {
        // TODO: Fix this to save somewhere else since we're not running in a browser.
        //var so:SharedObject = SharedObject.getLocal("savedData");
        //if (so) so.clear();
        //bestResult = {"score":0, "level":0, "lines":0};
    }

    private function _loadCookie():Void {
        // TODO: Fix this to save somewhere else since we're not running in a browser.
        //var so:SharedObject = SharedObject.getLocal("savedData");
        //bestResult = (so && "bestResult" in so.data) ? (so.data.bestResult) : {"score":0, "level":0, "eaten":0};
    }

    private function _updateCookie():Bool {
        // TODO: Fix this to save somewhere else since we're not running in a browser.
        //if (startLevel != 0 || debugMode) return false;
        //var updated:Bool = false, so:SharedObject, isHighScore:Bool = (score > bestResult.score);
        //if (score > bestResult.score) { updated = true; bestResult.score = score; }
        //if (gameoverLevel > bestResult.level) { updated = true; bestResult.level = gameoverLevel; }
        //if (eaten > bestResult.eaten) { updated = true; bestResult.eaten = eaten; }
        //if (updated && (so = SharedObject.getLocal("savedData"))) {
        //    so.data.bestResult = bestResult;
        //    so.flush();
        //}
        //return (isHighScore);
        return false;
    }
}


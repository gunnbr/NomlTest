package ;

import org.si.cml.CMLObject;

class Group extends CMLObject {
    static private var _freeList:Array<Group> = new Array<Group>();

    static public function run(groupType:Int, enemyType:Int) : Void {
        var group:Null<Group> = _freeList.pop();
        if (group == null) {
            group = new Group();
        }
        group.create(0, 0);
        group.execute(Main.resManager.groupSeq[groupType]);
        group.enemyType = enemyType;
        group.bonus = group.childCount = 0;
        group.destroyAll = true;
        group.finished = false;
    }

    public var enemyType:Int;
    public var childCount:Int;
    public var finished:Bool;
    public var destroyAll:Bool;
    public var bonus:Int;

    public function new() { super(); }

    public function onChildDestroy(enemy:Enemy) : Int {
        if (enemy.destructionStatus == 0) destroyAll = false;
        if (--childCount == 0 && finished) {
            if (bonus>0) {
                if (destroyAll) {
                    Main.scoreManager.destroyAll(bonus);
                    Particle.createParticle(enemy.x, enemy.y, 0, - 6, 0, 0.5, 0, Main.resManager.scoreTextures[bonus]);
                }
                else {
                    Main.scoreManager.destroyAllFailed();
                }
            }
            destroy(0);
        }
        return 0;
    }

    override public function onDestroy() : Void { _freeList.push(this); }

    override public function onNewObject(args:Array<Dynamic>) : CMLObject {
        var enemy:Enemy = Main.actManager.enemies.newInstance();
        enemy.type = enemyType;
        enemy.group = this;
        childCount++;
        return enemy;
    }
}


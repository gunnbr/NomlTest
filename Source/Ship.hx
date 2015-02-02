package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.media.Sound;
import flash.media.SoundChannel;

import openfl.Assets;

@:bitmap("Assets/Spaceship.png") class SpaceshipData extends BitmapData {}
@:bitmap("Assets/Shield.png") class ShieldData extends BitmapData {}

class Ship extends Sprite {
    static public var shipWidth:Int = 32;
    static public var shipHeight:Int = 32;

	public function new () {
		super ();
        mResurrectCountdown = 0;
        mShieldCountdown = 120;
        //mDieSound = Assets.getSound ("dead");
		//mShieldSound = Assets.getSound ("shield");
		addEventListener (Event.ADDED_TO_STAGE, onAddedToStage);
    }

	private function onAddedToStage (event:Event):Void {
        if (mBgData == null) {
            mBgData = new SpaceshipData(32,32);

            mBitmap = new Bitmap (new BitmapData(32, 32, true, 0));
            addChild (mBitmap);

            mBitmap.bitmapData.copyPixels(mBgData, new Rectangle(0,0,32,32), new Point(0,0));
            
            mShield = new Sprite();
            var shield = new Bitmap(new ShieldData(0,0));
            mShield.addChild(shield);
            mShield.x = -10;
            mShield.y = -7;
            mShield.alpha = 0.4;
            //mShield.graphics.beginFill(0x00FFFF, 0.25);
            //mShield.graphics.lineStyle(2.0, 0x0000FF);
            //mShield.graphics.drawCircle(16,16,16);
            //mShield.graphics.lineStyle();
            //mShield.graphics.endFill();
            addChild(mShield);
            //mChannel = mShieldSound.play();

            mMatrix = transform.matrix.clone();
            
            mMoveMatrix = new Matrix();
            mMoveMatrix.translate(-16, -16);
            mMoveBackMatrix = new Matrix();
            mMoveBackMatrix.translate(16, 16);
        }
    }
    public function die() {
        //mDieSound.play();
        mResurrectCountdown = 120;
        mBitmap.bitmapData.copyPixels(mBgData, new Rectangle(0,32,32,32), new Point(0,0));
    }

    public function update() {
        if (mResurrectCountdown > 0) {
            mResurrectCountdown--;
            if (mResurrectCountdown <= 0) {
                resurrect();
            }
        }

        if (mShieldCountdown > 0) {
            mShieldCountdown--;
            if (mShieldCountdown < 30) {
                mShield.visible = !mShield.visible;
                // if (mShield.visible) {
                //     mChannel = mShieldSound.play();
                // } else {
                //     mChannel.stop();
                // }
            }
            if (mShieldCountdown == 0) {
                mShield.visible = false;
                //mChannel.stop();
            }
        }
    }

    public function resurrect() {
        x = stage.stageWidth / 2;
        y = stage.stageHeight - 100;
        mResurrectCountdown = 0;
        mShieldCountdown = 120;
        mBitmap.bitmapData.copyPixels(mBgData, new Rectangle(0,0,32,32), new Point(0,0));
        mShield.visible = true;
        //mChannel = mShieldSound.play(0);
    }

    public function location() : Point {
        return new Point(x,y);
    }
    
    public function isKillable() : Bool {
        return (!isDead() && (mShieldCountdown == 0));
    }

    public function isDead() : Bool {
        return (mResurrectCountdown > 0);
    }
    
    private var mBgData : BitmapData;
    private var mBitmap : Bitmap;
	//private var mDieSound : Sound;
	//private var mShieldSound : Sound;
    private var mResurrectCountdown : Int;
    private var mShieldCountdown : Int;
    private var mShield : Sprite;
    private var mMatrix : Matrix;
    private var mMoveMatrix : Matrix;
    private var mMoveBackMatrix : Matrix;
    //private var mChannel : SoundChannel;
}



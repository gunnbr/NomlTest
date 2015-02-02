package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.text.TextField;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.ui.Keyboard;
import flash.Lib;
import flash.media.Sound;
import openfl.Assets;
import haxe.Timer;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.filters.GlowFilter;

@:bitmap("Assets/DNASpriteSheet.png") class MutantData extends BitmapData {}

class Mutant extends Sprite {

    static inline public var NUM_FRAMES:Int = 4;
    static inline public var NUM_ROWS:Int = 2;
    static private var mMutantData : BitmapData = new MutantData(0,0);

	public function new () {
		super ();
        mNumFrames = 4;
        mCurrentFrame = 0;
        mFrameCount = 0;
        mAnimFrame = Std.int(Math.random() * 7) + 1;
        mDead = false;
        
		addEventListener (Event.ADDED_TO_STAGE, onAddedToStage);
    }
    
	private function onAddedToStage (event:Event):Void {
        if (mBitmap == null) {
            var frameWidth : Int = Std.int(mMutantData.width / NUM_FRAMES);
            var frameHeight : Int = Std.int(mMutantData.height / NUM_ROWS);

            mBitmap = new Bitmap ();
            
            var copyRect:Rectangle = new Rectangle(0, 0, frameWidth, frameHeight);
            var point : Point = new Point(0,0);
            
            var i:Int;
            var newBitmapData : BitmapData;
            frames = new Array<BitmapData>();
            
            for (i in 0...NUM_FRAMES) {
                newBitmapData = new BitmapData(frameWidth, frameHeight);
                copyRect.x = i * frameWidth;
                newBitmapData.copyPixels(mMutantData, copyRect, point);
                frames.push(newBitmapData);
            }
            
            deathFrames = new Array<BitmapData>();
            copyRect.y+=frameHeight;
            for (i in 0...NUM_FRAMES) {
                newBitmapData = new BitmapData(frameWidth, frameHeight);
                copyRect.x = i * frameWidth;
                newBitmapData.copyPixels(mMutantData, copyRect, point);
                deathFrames.push(newBitmapData);
            }
            
            addChild (mBitmap);
        }
    }

    public function die() {
        mDead = true;
        mAnimFrame = 3;
        mFrameCount = 0;
        mCurrentFrame = 0;
        mBitmap.bitmapData = deathFrames[0];
    }
    
    public function update ():Bool
    {
        if (mDead)
        {
            alpha -= 0.1;
            if (alpha <= 0)
            {
                return false;
            }
        }
        
        mFrameCount++;

        if (mFrameCount >= mAnimFrame) {
            mCurrentFrame = (mCurrentFrame + 1 ) % mNumFrames;
            if (mDead) {
                mBitmap.bitmapData = deathFrames[mCurrentFrame];
            } else {
                mBitmap.bitmapData = frames[mCurrentFrame];
            }
            mFrameCount = 0;
        }
        
        return true;
    }

    public function dead():Bool {
        return mDead;
    }
    
    private var mBitmap : Bitmap;
    private var mCurrentFrame : Int;
    private var mNumFrames : Int;
    private var mFrameCount : Int;
    private var mAnimFrame : Int;
    private var mDead : Bool;
    private var frames : Array <BitmapData>;
    private var deathFrames : Array <BitmapData>;
}


package overworld.maps;

import states.screen.OverworldState;
import World.IWorld;

class Level{

    public var width (default, null) : Int;
    public var height (default, null) : Int;

    public var id (default, null) : String;
    public var name (default, null) : String;

    public var cx (default, null) : Int;
    public var cy (default, null) : Int;

    private var world : IWorld;
    private var overworld : OverworldState;
    private var manager : LevelManager;

    private var env : Array<Int> = [];

    private var walkables = [0, 1, 2, 3, 4, 5, 6, 55, 23];
    /**
     * Map<Env position index, callback)
     */
    private var bumpTriggers:Map<Int, (index:Int)->Void> = [];

    public function new(overworld:OverworldState, world:IWorld, manager:LevelManager, cx:Int, cy:Int){
        this.world = world;
        this.manager = manager;
        this.overworld = overworld;
        this.cx = cx;
        this.cy = cy;
        init();
    }

    private function init(){
        // override this;
    }

    public function onEnter(){
        if (overworld.hasTag('water_walking')){
            walkables.push(62);
        }
    }

    public function getNeighborMap(dx:Int, dy:Int){
        return manager.get(cx + dx, cy + dy);
    }

    public function triggerBump(cx:Int, cy:Int){
        var trigger = getBumpTrigger(cx, cy);
        if (trigger != null){
            trigger(convert(cx, cy));
        }
    }

    public function hasBumpTrigger(cx:Int, cy:Int){
        return getBumpTrigger(cx, cy) != null;
    }

    public function getBumpTrigger(cx:Int, cy:Int){
        return bumpTriggers.get(convert(cx, cy));
    }

    public function hasCollision(cx:Int, cy:Int){
        return walkables.indexOf(getEnvId(cx, cy)) != -1;
    }

    public function inBounds(cx:Int, cy:Int){
        return cx >= 0 && cy >= 0 && cx < width && cy < height;
    }

    public function getEnvId(cx:Int, cy:Int){
        return this.env[convert(cx, cy)];
    }

    inline function convert(cx:Int, cy:Int){
        return cy * width + cx;
    }
}
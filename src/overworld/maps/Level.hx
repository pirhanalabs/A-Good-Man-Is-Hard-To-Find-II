package overworld.maps;

import states.screen.DialogState;
import overworld.actors.CommonTags;
import overworld.actors.Npc;
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
    private var npc : Map<Int, Npc> = [];

    private var walkables = [0, 1, 2, 3, 4, 5, 6, 55, 21, 23, 25, 27, 29];
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

    public function checkWaterWalking(){
        if (overworld.hasTag(CommonTags.WATER_WALKING)){
            walkables.push(62);
        }
    }

    public function onEnter(){
        checkWaterWalking();
        for (index in 0 ... env.length){
            var tileid = env[index];
            switch(tileid){
                case 20:
                    bumpTriggers[index] = bumpTriggerSpice;
                case 22:
                    bumpTriggers[index] = bumpTriggerWheat;
                case 24:
                    bumpTriggers[index] = bumpTriggerBrownMushroom;
                case 28:
                    bumpTriggers[index] = bumpTriggerRedMushroom;
                case 26:
                    bumpTriggers[index] = bumpTriggerGoldenSpice;
                case 60:
                    bumpTriggers[index] = bumpTriggerHoneyTree;
                case 66:
                    bumpTriggers[index] = bumpTriggerWell;
                case 57:
                    bumpTriggers[index] = bumpTriggerFountain2;
                case 67:
                    bumpTriggers[index] = bumpTriggerFountain;
                default:
            }
        }
    }

    public function onLoad(){
        
    }

    private function bumpTriggerFountain2(index){
        world.setGameState(new DialogState(getY(index), [
            Line('This is a fountain.'),
            Para("It's dazzling and fully"),
            Cont("made out of gold"),
            Done(null)
        ]));
    }

    private function bumpTriggerFountain(index){
        var dialogs = [
            Line('This is a fountain.'),
            Para("It's dazzling and fully"),
            Cont("made out of gold"),
            
        ];

        if (!overworld.hasTag(Inventory.Items.GOLD_KEY)){
            overworld.setTag(Inventory.Items.GOLD_KEY);
            dialogs.push(Para("* You find a GOLDEN KEY *"));
        }

        dialogs.push(Done(null));
        world.setGameState(new DialogState(getY(index), dialogs));
    }

    private function bumpTriggerWell(index){
        if (!world.inventory.has(Inventory.Items.WATER) && overworld.hasTag("toad_water_request")){
            world.inventory.add(Inventory.Items.WATER);
            world.setGameState(new DialogState(getY(index), [
                Line('You take WATER from'),
                Cont('the water well.'),
                Para('* You got'),
                Cont('WATER *'),
                Done(null)
            ]));
        }else{
            world.setGameState(new DialogState(getY(index), [
                Line('This is a well.'),
                Para("It's filled with water."),
                Done(null)
            ]));
        }
    }

    private function bumpTriggerHoneyTree(index){
        world.inventory.add(Inventory.Items.HONEY);
        overworld.replaceEnv(index, 50);
        world.setGameState(new DialogState(getY(index), [
            Line('You harvest the'),
            Cont('Honey Tree.'),
            Para('* You got'),
            Cont('HONEY *'),
            Done(null)
        ]));
    }

    private function bumpTriggerRedMushroom(index){
        world.inventory.add(Inventory.Items.RED_MUSHROOM);
        overworld.replaceEnv(index, 29);
        world.setGameState(new DialogState(getY(index), [
            Line('You harvest the'),
            Cont('Red Mushroom.'),
            Para('* You got'),
            Cont('BROWN MUSHROOM *'),
            Done(null)
        ]));
    }

    private function bumpTriggerBrownMushroom(index){
        world.inventory.add(Inventory.Items.BROWN_MUSHROOM);
        overworld.replaceEnv(index, 25);
        world.setGameState(new DialogState(getY(index), [
            Line('You harvest the'),
            Cont('Brown Mushroom.'),
            Para('* You got'),
            Cont('BROWN MUSHROOM *'),
            Done(null)
        ]));
    }

    private function bumpTriggerGoldenSpice(index){
        if (overworld.hasTag(CommonTags.HOE)){
            world.inventory.add(Inventory.Items.GOLD_SPICE);
            overworld.replaceEnv(index, 27);
            world.setGameState(new DialogState(getY(index), [
                Line('You harvest the golden spice'),
                Cont('using the HOE.'),
                Para('* You got GOLDEN SPICE *'),
                Done(null)
            ]));
        }else{
            world.setGameState(new DialogState(getY(index), [
                Line('This is GOLDEN SPICE.'),
                Para('I would need a HOE'),
                Cont('to harvest this.'),
                Done(null)
            ]));
        }
    }

    private function bumpTriggerSpice(index){
        if (overworld.hasTag(CommonTags.HOE)){
            world.inventory.add(Inventory.Items.SPICE);
            overworld.replaceEnv(index, 21);
            world.setGameState(new DialogState(getY(index), [
                Line('You harvest the spice'),
                Cont('using the HOE.'),
                Para('* You got SPICE *'),
                Done(null)
            ]));
        }else{
            world.setGameState(new DialogState(getY(index), [
                Line('This is SPICE.'),
                Para('I would need a HOE'),
                Cont('to harvest this.'),
                Done(null)
            ]));
        }
    }

    private function bumpTriggerWheat(index){
        if (overworld.hasTag(CommonTags.HOE)){
            world.inventory.add(Inventory.Items.WHEAT);
            overworld.replaceEnv(index, 23);
            world.setGameState(new DialogState(getY(index), [
                Line('You harvest the wheat'),
                Cont('using the HOE.'),
                Para('* You got WHEAT *'),
                Done(null)
            ]));
        }else{
            world.setGameState(new DialogState(getY(index), [
                Line('This is WHEAT.'),
                Para('I would need a HOE'),
                Cont('to harvest this.'),
                Done(null)
            ]));
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
        return walkables.indexOf(getEnvId(cx, cy)) == -1;
    }

    public function hasNpc(cx:Int, cy:Int){
        return npc.exists(convert(cx, cy)) && !getNpc(cx, cy).hasTag(CommonTags.DEAD);
    }

    public function getNpc(cx:Int, cy:Int){
        return npc[convert(cx, cy)];
    }

    public function inBounds(cx:Int, cy:Int){
        return cx >= 0 && cy >= 0 && cx < width && cy < height;
    }

    public function setEnv(cx:Int, cy:Int, id:Int){
        env[convert(cx, cy)] = id;
        bumpTriggers.remove(convert(cx, cy));
    }

    public function getEnvId(cx:Int, cy:Int){
        return this.env[convert(cx, cy)];
    }

    public function npcfn(fn:(npc:Npc)->Void){
        for (loc=>actor in npc){
            fn(actor);
        }
    }

    inline function convert(cx:Int, cy:Int){
        return cy * width + cx;
    }

    public inline function getX(index:Int){
        return Math.floor(index % width);
    }

    public inline function getY(index:Int){
        return Math.floor(index / width);
    }
}
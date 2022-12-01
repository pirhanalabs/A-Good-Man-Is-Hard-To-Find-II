package overworld.actors;

import World.IWorld;
import states.screen.OverworldState;
import overworld.actors.dialogs.IActorDialog;

class Npc extends Actor{

    public static final FROG = 1;
    public static final SABE = 2;
    public static final SELE = 3;
    public static final BEAVER = 4;
    public static final BADGER = 5;
    public static final SQUID_RIGHT_TENTACLE = 6;
    public static final SQUID_HEAD = 7;
    public static final SQUID_LEFT_TENTACLE = 8;
    public static final FISHERMOLE = 9;
    public static final SAILOR_CRAB = 10;
    public static final SAILOR_TOAD = 11;
    public static final PENGUIN = 12;
    public static final PYTHON = 13;
    public static final SNAKE = 14;
    public static final GOAT = 15;
    public static final DUCK = 16;
    public static final CHICKEN = 17;
    public static final PORK = 18;

    private static var ALL : Map<Int, Npc> = [];

    public static function get(id:Int){
        return ALL[id];
    }

    public var id (default, null) : Int;

    private var dialogs : IActorDialog;

    public function new(id:Int, dialogs:IActorDialog, cx:Int, cy:Int){
        super(Assets.getEntTile(id), cx, cy);
        this.id = id;
        this.dialogs = dialogs;
        ALL[id] = this;
    }

    public function executeDialog(world:IWorld, overworld:OverworldState){
        dialogs.execute(this, world, overworld);
    }
}
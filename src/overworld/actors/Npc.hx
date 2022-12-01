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

    public static var ALL : Map<Int, Npc> = [];

    public static function get(id:Int){
        return ALL[id];
    }

    public var id (default, null) : Int;

    public var killReward : String;

    private var dialogs : IActorDialog;

    public function new(id:Int, dialogs:IActorDialog, cx:Int, cy:Int){
        super(Assets.getEntTile(id), cx, cy);
        this.id = id;
        this.dialogs = dialogs;
        ALL[id] = this;

        switch(id){
            case FROG : 
                name = "Roger Frog";
                killReward = Inventory.Items.FROG_LEGS;
            case FISHERMOLE: 
                name = "Finn Fishermole";
                killReward = Inventory.Items.MOLE_MEAT;
                var bitmap = new h2d.Bitmap(Assets.getEnvTile(49));
                bitmap.x -= 8;
                bitmap.y += 8;
                sprite.addChild(bitmap);
            case SABE: 
                name = "Sabe Rat";
                killReward = Inventory.Items.SPICY_RAT_MEAT;
            case SELE: 
                name = "Sele Rat";
                killReward = Inventory.Items.RAT_MEAT;
            case BEAVER: 
                name = "Bob Beaver";
                killReward = Inventory.Items.BLUEPRINT_PAPER;
            case _: "None";
        }
    }

    public function executeDialog(world:IWorld, overworld:OverworldState){
        dialogs.execute(this, world, overworld);
    }

    override function update(dt:Float) {
        if (id == Npc.FISHERMOLE){
            if (m_facing == -1){
                m_facing = 1;
            }
        }
        super.update(dt);
    }
}
package overworld.maps;

import overworld.actors.Npc;
import overworld.actors.dialogs.CrabSailorDialog;

class Map_3_2 extends Level{

    public static final ID = "sailor_crab_ocean";
    
    override function init() {
        super.init();

        this.id = Map_3_2.ID;
        this.name = "Sailor Crab Ocean";

        this.width = 8;
        this.height = 8;

        this.env = [
            50, 53, 53, 58, 59, 53, 53, 50,
            50, 0 , 0 , 0 , 0 , 0 , 0 , 50,
            0 , 0 , 0 , 0 , 0 , 0 , 0 , 50,
            50, 0 , 0 , 0 , 0 , 0 , 0 , 50,
            50, 0 , 0 , 0 , 0 , 0 , 0 , 50,
            61, 62, 62, 62, 62, 62, 62, 61,
            61, 62, 62, 62, 62, 62, 62, 61,
            61, 62, 62, 62, 62, 62, 62, 61,
        ];

        this.npc[convert(4, 3)] = new Npc(Npc.SAILOR_CRAB, new CrabSailorDialog(), 4, 3);
    }

    override function onEnter(){
        super.onEnter();

        this.bumpTriggers[3] = doorTrigger;
        this.bumpTriggers[4] = doorTrigger;

        world.sounds.playMusic(Assets.sounds.music_overworld, 1, 1);
        
    }

    private function doorTrigger(index:Int){
        if (overworld.hasTag(Inventory.Items.GOLD_KEY)){
            overworld.shake(function(){
                overworld.replaceEnv(3, 0);
                overworld.replaceEnv(4, 0);
            });
        }
    }
}


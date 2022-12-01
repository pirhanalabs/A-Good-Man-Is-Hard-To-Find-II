package overworld.maps;

import overworld.actors.Npc;
import overworld.actors.dialogs.ToadSailorDialog;

class Map_2_0 extends Level {
    
    public static final ID = "badger_hideout";
    
    override function init() {
        super.init();

        this.id = Map_3_2.ID;
        this.name = "Badger Hideout";

        this.width = 8;
        this.height = 8;

        this.env = [
            50, 50, 50, 50, 50, 50, 50, 50,
            50, 0 , 0 , 0 , 0 , 0 , 0 , 50,
            0 , 0 , 1 , 1 , 0 , 0 , 0 , 50,
            1 , 1 , 0 , 0 , 1 , 0 , 0 , 50,
            50, 0 , 0 , 0 , 0 , 0 , 0 , 50,
            50, 50, 50, 0 , 0 , 0 , 0 , 50,
            62, 62, 62, 50, 0 , 0 , 0 , 50,
            61, 62, 62, 62, 50, 50, 50, 50,
        ];

        this.npc[convert(5, 5)] = new Npc(Npc.SAILOR_TOAD, new ToadSailorDialog(), 5, 5);
    }

    override function onEnter(){
        super.onEnter();

        world.sounds.playMusic(Assets.sounds.music_overworld, 1, 1);
        
    }
}
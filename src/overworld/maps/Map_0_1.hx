package overworld.maps;

import overworld.actors.dialogs.SabeDialog;
import overworld.actors.Npc;

class Map_0_1 extends Level {
    
    public static final ID = "basilic_prairie";
    
    override function init() {
        super.init();

        this.id = Map_0_3.ID;
        this.name = "Basilic Prairie";

        this.width = 8;
        this.height = 8;

        this.env = [
            50, 50, 50, 50, 0 , 1 , 0 , 50,
            50, 0 , 0 , 0 , 50, 0 , 26, 50,
            50, 0 , 0 , 0 , 20, 50, 50, 50,
            50, 0 , 0 , 0 , 0 , 0 , 0 , 50,
            50, 20, 0 , 1 , 0 , 0 , 0 , 50,
            50, 0 , 0 , 1 , 0 , 20, 0 , 50,
            50, 0 , 0 , 0 , 1 , 0 , 0 , 50,
            50, 50, 50, 1 , 50, 50, 50, 50,
        ];

        this.npc[convert(3, 2)] = new Npc(Npc.SABE, new SabeDialog(), 3, 2);
    }

    override function onEnter(){
        super.onEnter();

        world.sounds.playMusic(Assets.sounds.music_overworld, 1, 1);
    }
}
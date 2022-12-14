package overworld.maps;

import overworld.actors.dialogs.SeleDialog;
import overworld.actors.dialogs.SabeDialog;
import overworld.actors.Npc;
import states.screen.DialogState;

class Map_1_3 extends Level {
    
    override function init() {
        super.init();

        this.id = "graveyard";
        this.name = "Graveyard";

        this.width = 8;
        this.height = 8;

        this.env = [
            47, 48, 48, 48, 1 , 1 , 48, 38,
            47, 51, 0 , 51, 0 , 1 , 0 , 38,
            47, 0 , 0 , 0 , 0 , 0 , 0 , 38,
            47, 51, 0 , 51, 0 , 51, 0 , 48,
            47, 0 , 0 , 0 , 0 , 0 , 0 , 0 ,
            47, 51, 0 , 51, 0 , 51, 0 , 45,
            47, 0 , 0 , 0 , 0 , 0 , 0 , 38,
            35, 37, 37, 37, 37, 37, 37, 36,
        ];

        this.npc[convert(4, 2)] = new Npc(Npc.SELE, new SeleDialog(), 4, 2);
    }

    override function onEnter(){
        super.onEnter();

        for (i in 0 ... env.length){
            if (env[i] == 51){ // if it is wheat
                bumpTriggers[i] = onBumpGrave;
            }
        }

        world.sounds.playMusic(Assets.sounds.music_graveyard, 1, 2);
        
    }

    private function onBumpGrave(index:Int){
        world.setGameState(new DialogState(getY(index), [
            Line('This is a TOMBSTONE.'),
            Para('Someone drew grey bars'),
            Cont('where markings should be.'),
            Done(null)
        ]));
    }
}
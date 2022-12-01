package overworld.maps;

import overworld.actors.dialogs.FrogDialog;
import overworld.actors.Npc;
import overworld.actors.CommonTags;
import states.screen.DialogState;

class Map_1_2 extends Level{

    override function init() {
        super.init();

        this.id = "kitchen_front";
        this.name = "Kitchen Front";

        this.width = 8;
        this.height = 8;

        this.env = [
            42, 42, 43, 55, 41, 42, 42, 42,
            50, 0 , 0 , 1 , 0 , 23, 22, 50,
            50, 0 , 0 , 1 , 0 , 22, 23, 50,
            50, 0 , 0 , 0 , 1 , 0 , 23, 50,
            0 , 0 , 1 , 1 , 0 , 0 , 0 , 50,
            1 , 1 , 0 , 1 , 0 , 0 , 1 , 1 ,
            50, 0 , 0 , 0 , 1 , 0 , 0 , 50,
            50, 50, 50, 50, 1 , 0 , 50, 50,
        ];

        this.npc[convert(5, 4)] = new overworld.actors.Npc(Npc.FROG, new FrogDialog(), 5, 4);
    }

    override function onEnter(){
        super.onEnter();

        this.bumpTriggers[4] = onBumpSign;

        world.sounds.playMusic(Assets.sounds.music_overworld, 1, 1);
    }

    private function onBumpSign(index){
        world.setGameState(new DialogState(getY(index), [
            Text('Town\'s Kitchen.'),
            Para('Currently empty. Nobody'),
            Cont('knows how to cook.'),
            Done(null)
        ]));
    }
    
}
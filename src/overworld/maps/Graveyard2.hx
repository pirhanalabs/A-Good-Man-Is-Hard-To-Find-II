package overworld.maps;

import states.screen.DialogState;

class Graveyard2 extends Level {
    
    override function init() {
        super.init();

        this.id = "graveyard2";
        this.name = "Graveyard";

        this.width = 8;
        this.height = 8;

        this.env = [
            47, 48, 48, 48, 48, 48, 48, 38,
            47, 0 , 51, 0 , 51, 0 , 0 , 38,
            47, 0 , 0 , 0 , 0 , 0 , 51, 38,
            48, 0 , 51, 0 , 51, 0 , 0 , 38,
            0 , 0 , 0 , 0 , 0 , 0 , 0 , 48,
            46, 0 , 51, 0 , 51, 0 , 0 , 0,
            47, 0 , 0 , 0 , 0 , 0 , 0 , 0,
            35, 37, 37, 37, 37, 37, 37, 37,
        ];
    }

    override function onEnter(){
        super.onEnter();

        this.bumpTriggers = [];

        for (i in 0 ... env.length){
            if (env[i] == 51){ // if it is wheat
                bumpTriggers[i] = onBumpGrave;
            }
        }

        world.sounds.playMusic(hxd.Res.music.dev.OMIHTF_dont_cook_with_the_bones, 1, 2);
        
    }

    private function onBumpGrave(index:Int){
        world.setGameState(new DialogState([
            Text('This is a TOMBSTONE.'),
            Para('Someone drew grey bars'),
            Cont('where markings should be.'),
            Done(null)
        ]));
    }
}
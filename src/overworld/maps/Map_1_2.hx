package overworld.maps;

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
    }

    override function onEnter(){
        super.onEnter();

        this.bumpTriggers = [
            4 => onBumpSign
        ];

        for (i in 0 ... env.length){
            if (env[i] == 22){ // if it is wheat
                bumpTriggers[i] = onBumpWheat;
            }
        }

        world.sounds.playMusic(Assets.sounds.music_overworld, 1, 1);
    }

    private function onBumpWheat(index){
        world.setGameState(new DialogState([
            Text('This is WHEAT.'),
            Para('I would need a HOE'),
            Cont('to harvest this.'),
            Done(null)
        ]));
    }

    private function onBumpSign(index){
        world.setGameState(new DialogState([
            Text('Town\'s Kitchen.'),
            Para('Currently empty. Nobody'),
            Cont('knows how to cook.'),
            Done(null)
        ]));
    }
    
}
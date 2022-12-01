package overworld.maps;

class Map_2_1 extends Level{
    
    public static final ID = "hidden_fountain";
    
    override function init() {
        super.init();

        this.id = Map_3_2.ID;
        this.name = "Hidden Fountain";

        this.width = 8;
        this.height = 8;

        this.env = [
            61, 62, 62, 62, 50, 50, 50, 50,
            61, 62, 62, 62, 0 , 22, 23, 50,
            61, 62, 62, 0 , 23, 0 , 22, 50,
            61, 63, 62, 0 , 24, 57, 24, 50,
            61, 62, 0 , 23, 20, 67, 20, 50,
            61, 62, 0 , 0 , 24, 20, 24, 50,
            61, 62, 0 , 0 , 0 , 0 , 23, 50,
            61, 62, 61, 50, 50, 50, 50, 50,
        ];
    }

    override function onEnter(){
        super.onEnter();

        this.bumpTriggers = [];

        world.sounds.playMusic(Assets.sounds.music_overworld, 1, 1);
        
    }
}
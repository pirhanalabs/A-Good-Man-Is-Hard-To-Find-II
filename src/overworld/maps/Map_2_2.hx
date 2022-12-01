package overworld.maps;

class Map_2_2 extends Level {

    public static final ID = "wheat_pathway";
    
    override function init() {
        super.init();

        this.id = Map_2_2.ID;
        this.name = "Wheat Pathway";

        this.width = 8;
        this.height = 8;

        this.env = [
            61, 62, 61, 61, 50, 50, 50, 50,
            61, 62, 62, 61, 23, 22, 0 , 50,
            61, 61, 62, 22, 0 , 0 , 0 , 0 ,
            61, 62, 0 , 0 , 0 , 0 , 0 , 50,
            50, 0 , 0 , 0 , 1 , 0 , 23, 50,
            1 , 0 , 1 , 0 , 0 , 23, 23, 50,
            50, 0 , 0 , 0 , 23, 23, 22, 50,
            50, 50, 50, 50, 50, 50, 50, 50,
        ];
    }

    override function onEnter(){
        super.onEnter();

        this.bumpTriggers = [];

        world.sounds.playMusic(Assets.sounds.music_overworld, 1, 1);
        
    }
}
package overworld.maps;

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
    }

    override function onEnter(){
        super.onEnter();

        this.bumpTriggers = [];

        world.sounds.playMusic(Assets.sounds.music_overworld, 1, 1);
        
    }
}


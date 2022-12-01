package overworld.maps;

class Map_0_3 extends Level{

    public static final ID = "penguin_island";
    
    override function init() {
        super.init();

        this.id = Map_0_3.ID;
        this.name = "Penguin Island";

        this.width = 8;
        this.height = 8;

        this.env = [
            61, 62, 62, 62, 62, 62, 62, 61,
            61, 62, 62, 62, 62, 62, 62, 61,
            61, 62, 62, 62, 62, 62, 63, 61,
            61, 62, 62, 62, 63, 62, 62, 61,
            50, 0 , 0 , 0 , 0 , 62, 62, 61,
            50, 0 , 0 , 0 , 0 , 0 , 0 , 50,
            50, 0 , 0 , 0 , 0 , 0 , 0 , 50,
            50, 50, 50, 50, 60, 50, 50, 50,
        ];
    }

    override function onEnter(){
        super.onEnter();

        this.bumpTriggers = [];

        world.sounds.playMusic(Assets.sounds.music_overworld, 1, 1);
    }
}
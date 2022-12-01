package overworld.maps;

class Map_1_0 extends Level {

    public static final ID = "river_crossroad";
    
    override function init() {
        super.init();

        this.id = Map_3_2.ID;
        this.name = "River Crossroad";

        this.width = 8;
        this.height = 8;

        this.env = [
            50, 50, 50, 61, 61, 50, 50, 50,
            50, 0 , 0 , 62, 62, 0 , 0 , 50,
            50, 0 , 0 , 62, 62, 0 , 1 , 1 ,
            1 , 0 , 1 , 62, 62, 0 , 0 , 1 ,
            0 , 1 , 0 , 62, 62, 0 , 0 , 50, 
            50, 0 , 0 , 62, 62, 62, 0 , 50,
            50, 0 , 0 , 62, 62, 62, 62, 62,
            50, 50, 50, 50, 61, 61, 61, 61,
        ];
    }

    override function onEnter(){
        super.onEnter();

        world.sounds.playMusic(Assets.sounds.music_overworld, 1, 1);
        
    }
    
}
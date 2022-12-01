package overworld.maps;

class Map_0_2 extends Level {
    
    override function init() {
        super.init();

        this.id = "fishermole_lake";
        this.name = "Fishermole Lake";

        this.width = 8;
        this.height = 8;

        this.env = [
            50, 56, 50, 1 , 50, 50, 50, 50,
            50, 66, 0 , 0 , 0 , 0 , 0 , 50,
            50, 0 , 0 , 1 , 0 , 0 , 0 , 50,
            50, 0 , 0 , 0 , 1 , 1 , 0 , 50,
            50, 0 , 0 , 0 , 0 , 0 , 0 , 0 ,
            61, 62, 62, 62, 0 , 0 , 0 , 1 ,
            61, 62, 63, 62, 62, 0 , 0 , 50,
            61, 62, 62, 61, 62, 63, 62, 61,
        ];
    }

    override function onEnter(){
        super.onEnter();

        this.bumpTriggers = [];

        world.sounds.playMusic(Assets.sounds.music_overworld, 1, 1);
    }
}
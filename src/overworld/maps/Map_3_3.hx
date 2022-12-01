package overworld.maps;

class Map_3_3 extends Level{
    
    override function init() {
        super.init();

        this.id = "kraken_lake";
        this.name = "Kraken Lake";

        this.width = 8;
        this.height = 8;

        this.env = [
            61, 62, 62, 62, 62, 62, 62, 61,
            61, 63, 62, 62, 62, 62, 62, 61,
            61, 62, 62, 62, 62, 62, 63, 61,
            61, 61, 62, 62, 62, 62, 61, 61,
            50, 61, 61, 61, 62, 62, 61, 50,
            0 , 0 , 0 , 50, 0 , 28, 0 , 50,
            0 , 0 , 0 , 0 , 50, 0 , 28, 50,
            50, 50, 50, 50, 50, 50, 50, 50,
        ];
    }

    override function onEnter(){
        super.onEnter();

        world.sounds.playMusic(Assets.sounds.music_overworld, 1, 1);
    }
}
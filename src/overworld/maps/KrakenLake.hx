package overworld.maps;

class KrakenLake extends Level{
    
    override function init() {
        super.init();

        this.id = "kraken_lake";
        this.name = "Kraken Lake";

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

        this.bumpTriggers = [];

        world.sounds.playMusic(hxd.Res.music.dev.OMIHTF_ebauche4_vst__1_, 1, 1);
    }
}
package overworld.maps;

class KrakenLake extends Level{
    
    override function init() {
        super.init();

        this.id = "kraken_lake";
        this.name = "Kraken Lake";

        this.width = 8;
        this.height = 8;

        this.env = [
            61, 62, 62, 62, 62, 62, 62, 61,
            61, 62, 62, 62, 62, 62, 62, 61,
            61, 62, 62, 62, 62, 62, 62, 61,
            61, 61, 62, 62, 62, 62, 62, 61,
            50, 61, 61, 61, 62, 62, 62, 50,
            0 , 0 , 0 , 50, 0 , 0 , 0 , 50,
            0 , 0 , 0 , 0 , 50, 0 , 0 , 50,
            50, 50, 50, 50, 50, 50, 50, 50,
        ];
    }

    override function onEnter(){
        super.onEnter();

        this.bumpTriggers = [];

        world.sounds.playMusic(hxd.Res.music.dev.OMIHTF_ebauche4_vst__1_, 1, 1);
    }
}
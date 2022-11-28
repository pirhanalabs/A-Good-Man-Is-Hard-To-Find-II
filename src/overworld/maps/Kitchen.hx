package overworld.maps;

class Kitchen extends Level{

    override function init() {
        super.init();

        this.id = "kitchen";
        this.name = "Kitchen";

        this.width = 8;
        this.height = 8;

        this.env = [
            30, 42, 42, 42, 42, 42, 42, 40,
            34, 0 , 0 , 0 , 0 , 0 , 0 , 44,
            34, 0 , 0 , 0 , 0 , 0 , 0 , 44,
            34, 0 , 0 , 0 , 0 , 0 , 0 , 44,
            34, 0 , 0 , 0 , 0 , 0 , 0 , 44,
            34, 0 , 0 , 0 , 0 , 0 , 0 , 44,
            34, 0 , 0 , 0 , 0 , 0 , 0 , 44,
            7 , 32, 33, 55, 31, 32, 32, 7,
        ];
    }

    override function onEnter(){
        super.onEnter();

        this.bumpTriggers = [];

        world.sounds.playMusic(hxd.Res.music.dev.OMIHTF_wandering);
        
    }
    
}
class SoundManager{

    var m_curr : hxd.snd.Channel; // music
    var m_loop : hxd.snd.Channel; // ambiant

    var m_volAmbiant = 1.0;
    var m_volMusic = 1.0;
    var m_volSound = 1.0;

    public function new(){

    }

    public function setMasterVolume(volume:Float){
        hxd.snd.Manager.get().masterVolume = volume;
    }

    public function setAmbiantVolume(volume:Float){
        m_volAmbiant = volume;
    }

    public function setMusicVolume(volume:Float){
        m_volMusic = volume;
    }

    public function setSoundVolume(volume:Float){
        m_volSound = volume;
    }

    public function playOverlayLoop(music:hxd.res.Sound, volume = 1.0){
        stopOverlayLoop();
        m_loop = music.play(true, volume * m_volAmbiant);
    }

    public function stopOverlayLoop(){
        if (m_loop != null){
            m_loop.stop();
            m_loop = null;
        }
    }

    public function playMusic(music:hxd.res.Sound, volume = 1.0, delay = 1000){
        if (m_curr == null){
            m_curr = music.play(true, volume * m_volMusic);
        
        // if same as current, dont change.
        }else if(m_curr.sound == music){
            return;
        // otherwise play new one with fading.
        // if delay is set to 0, there will be no delay
        // and switch instantly.
        }else{
            m_curr.fadeTo(0, 0.2, ()->{
                m_curr.stop();
                haxe.Timer.delay(()->{
                    m_curr = music.play(true, 0);
                    m_curr.fadeTo(volume * m_volMusic, 0.2, null);
                }, delay);
            });
        }
    }

    public function playSound(sound:hxd.res.Sound, volume = 1.0){
        sound.play(false, volume * m_volSound);
    }
}
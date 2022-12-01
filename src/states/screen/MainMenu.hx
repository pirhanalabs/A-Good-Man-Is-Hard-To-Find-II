package states.screen;

class MainMenu extends AbstractScreenState{

    var bg : h2d.Bitmap;
    var girl : h2d.Bitmap;
    var title : h2d.Bitmap;

    public function new(){
        super();

        bg = new h2d.Bitmap(hxd.Res.hud.mainmenu.bg.toTile(), m_scene);
        girl = new h2d.Bitmap(hxd.Res.hud.mainmenu.bg_girl.toTile(), m_scene);
        title = new h2d.Bitmap(hxd.Res.hud.mainmenu.bg_title.toTile(), m_scene);
    }

    override function onEnter(?params:Dynamic) {
        super.onEnter(params);
        m_world.inventory.clear();
        m_world.sounds.playMusic(hxd.Res.music.Musique_Main_menu,1, 200);
    }

    override function onExit() {
        super.onExit();
    }

    override function update(dt:Float) {
        super.update(dt);

        var inputs = m_world.getInputs();
        if (inputs.isPressed(Interact) || inputs.isPressed(Cancel)){
            m_world.popGameState();
            m_world.setGameState(new OverworldState());
        }
    }

    public function triggerTransition(midcb:Void->Void, endcb:Void->Void){
        m_world.setGameState(new Transition(0, 1, 0.5, Tween.easeOut, function(){
            haxe.Timer.delay(function(){
                m_world.popGameState();
                if (midcb != null){
                    midcb();
                }
                m_world.setGameState(new Transition(1, 0, 2,  Tween.easeIn, function(){
                    m_world.popGameState();
                    if (endcb != null){
                        endcb();
                    }
                }), null, true);
            }, 200);
        }), null, false);
    }

	public function postUpdate() {
        girl.y = Tween.lerp(0, 5, Tween.spike((ftime%120)/120));
        title.y = Tween.lerp(0, 10, Tween.spike((ftime%180)/180));
    }
}
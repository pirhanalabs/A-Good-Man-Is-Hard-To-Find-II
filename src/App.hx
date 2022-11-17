import hxd.snd.Manager;

class App extends hxd.App{

    public static function main(){
        new App();
    }

    var m_world : World;

    override function init() {
        super.init();

        #if hl
            hl.UI.closeConsole();
        #end
        haxe.MainLoop.add(()->{});
        hxd.snd.Manager.get();
        hxd.Timer.skip();

        Assets.initialize();
        m_world = new World(this);
    }


    override function update(dt:Float) {
        super.update(dt);
        m_world.update(dt);
        m_world.postUpdate();
    }
}
package states.screen;


class Transition extends AbstractScreenState{
    
    var callback : Void->Void;
    var ftime : Float;
    var ftimeMax :Float;

    var from : Float;
    var to : Float;

    var ttype : (t:Float)->Float = Tween.linear;

    var bg : h2d.Bitmap;

    public function new(from:Float, to:Float, stime:Float, ?ttype:(t:Float)->Float, ?callback:Void->Void){
        super();

        ftimeMax = stime * 60;
        ftime = 0;
        this.callback = callback;
        this.from = from;
        this.to = to;

        if (ttype != null){
            this.ttype = ttype;
        }

        bg = new h2d.Bitmap(Assets.getMisc('bg_fade'));
        bg.alpha = from;
        m_scene.add(bg, 1);
    }

	public function update(dt:Float) {

        if (ftime >= ftimeMax){
            ftime = ftimeMax;
        }

        if (ftime == ftimeMax){
            if (callback != null){
                callback();
            }
            return;
        }
        ftime += dt;
    }

	public function postUpdate() {
        var a = Tween.lerp(from, to, ttype(ftime/ftimeMax));
        bg.alpha = a;
    }
}
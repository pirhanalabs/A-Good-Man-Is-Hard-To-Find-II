package states.screen;

class Screenshake extends AbstractScreenState{

    var m_target : h2d.Object;
    var m_strength : Float;
    var m_time : Float = 0;
    var m_timer : Float;
    var m_timerMax : Float;
    var m_speed : Float;
    var m_basex : Float;
    var m_basey : Float;
    var m_callback : Void->Void;
    
    public function new(target, strength, timer, speed, cb){
        super();
        m_target = target;
        m_strength = strength;
        m_timer = timer;
        m_timerMax = timer;
        m_speed = speed;
        m_basex = m_target.x;
        m_basey = m_target.y;
        m_callback = cb;
    }

    override function onEnter(?params:Dynamic){}

    override function onExit(){}

    private function getRatio(){
        return m_timer / m_timerMax;
    }

	public function update(dt:Float) {
        m_time += dt;
        m_timer = Math.max(m_timer - dt, 0);
    }

	public function postUpdate() {
        m_target.x = m_basex;
        m_target.y = m_basey;

        if (m_timer == 0){
            m_world.popGameState();
            if (m_callback != null){
                m_callback();
            }
            return;
        }
        m_target.x += Math.cos(m_time * 1.1) * 2.5 * m_strength * getRatio();
        m_target.y += Math.sin(0.3 + m_time * 1.7) * 2.5 * m_strength * getRatio();

        m_target.x = Math.round(m_target.x);
        m_target.y = Math.round(m_target.y);
    }
}
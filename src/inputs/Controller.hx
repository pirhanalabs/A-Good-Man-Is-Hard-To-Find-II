package inputs;

class Controller<T:EnumValue> implements IInputController<T>{

    var ANALOG_THRESHOLD = 0.03;

    var m_pad : hxd.Pad;
    var m_padQueue:List<hxd.Pad>;
    var m_mode : InputMode = Keyboard;

    var m_bindKeys : Map<T, Int> = [];
    var m_bindPads : Map<T, Int> = [];

    var m_bindKeyXAxisNeg : Int = -1;
    var m_bindKeyXAxisPos : Int = -1;
    var m_bindKeyYAxisNeg : Int = -1;
    var m_bindKeyYAxisPos : Int = -1;
    var m_bindDPadToAxis : Bool = false;


    public function new(){
        m_padQueue = new List<hxd.Pad>();
        hxd.Pad.wait(onPadConnected);
    }

    private function onPadConnected(pad:hxd.Pad){
        m_padQueue.add(pad);
        pad.onDisconnect = ()->{onPadDisconnected(pad);};
        tryConnectPad();
    }

    private function tryConnectPad(){
        if (m_pad == null){
            m_pad = m_padQueue.pop();
        }
        if (m_pad != null){
            m_mode = Controller;
        }else{
            m_mode = Keyboard;
        }
    }

    private function onPadDisconnected(pad:hxd.Pad){
        m_padQueue.remove(pad);
        if (m_pad == pad){
            m_pad = m_padQueue.pop();
        }
        tryConnectPad();
    }

    public function bindPad(val:T, button:Int){
        m_bindPads[val] = button;
    }

    public function bindKey(val:T, key:Int){
        m_bindKeys[val] = key;
    }

    public function bindKeysToXAxis(neg:Int, pos:Int){
        m_bindKeyXAxisNeg = neg;
        m_bindKeyXAxisPos = pos;
    }

    public function bindKeysToYAxis(neg:Int, pos:Int){
        m_bindKeyYAxisNeg = neg;
        m_bindKeyYAxisPos = pos;
    }

    public function bindDPadToAxis(val:Bool = true){
        m_bindDPadToAxis = val;
    }

    public function isPressed(val:T){
        if (getMode() == Keyboard)
            return isKeyPressed(val);
        return isPadPressed(val);
    }

    private function isKeyPressed(val:T){
        var key = m_bindKeys.get(val);
        if (key == null)
            return false;
        return hxd.Key.isPressed(key);
    }

    private function isPadPressed(val:T){
        var key = m_bindPads.get(val);
        if (key == null)
            return false;
        return m_pad.isPressed(key);
    }

    public function isDown(val:T){
        if (getMode() == Keyboard)
            return isKeyDown(val);
        return isPadDown(val);
    }

    private function isKeyDown(val:T){
        var key = m_bindKeys.get(val);
        if (key == null)
            return false;
        return hxd.Key.isDown(key);
    }

    private function isPadDown(val:T){
        var key = m_bindPads.get(val);
        if (key == null)
            return false;
        return m_pad.isDown(key);
    }

    public function isReleased(val:T){
        if (getMode() == Keyboard)
            return isKeyReleased(val);
        return isPadReleased(val);
    }

    private function isKeyReleased(val:T){
        var key = m_bindKeys.get(val);
        if (key == null)
            return false;
        return hxd.Key.isReleased(key);
    }

    private function isPadReleased(val:T){
        var key = m_bindPads.get(val);
        if (key == null)
            return false;
        return m_pad.isReleased(key);
    }

    public function getAxisDirection(){
        var dx = getXAxis();
        var dy = getYAxis();
        if(Math.abs(dx) < Math.abs(dy)){
            dx = 0;
            if (dy > 0 && dy >= ANALOG_THRESHOLD){
                dy = 1;
            }else if (dy < 0 && dy <= -ANALOG_THRESHOLD){
                dy = -1;
            }else{
                dy = 0;
            }
        }else if (Math.abs(dx) > Math.abs(dy)){
            dy = 0;
            if (dx > 0 && dx >= ANALOG_THRESHOLD){
                dx = 1;
            }else if (dx < 0 && dx <= -ANALOG_THRESHOLD){
                dx = -1;
            }else{
                dx = 0;
            }
        }else{
            dx = 0;
            dy = 0;
        }
        return Direction.fromDeltas(Std.int(dx), Std.int(dy));
    }

    public function getAnalogDirection(){
        var dx = getAnalogXAxis();
        var dy = getAnalogYAxis();
        if(Math.abs(dx) < Math.abs(dy)){
            dx = 0;
            if (dy > 0 && dy >= ANALOG_THRESHOLD){
                dy = 1;
            }else if (dy < 0 && dy <= -ANALOG_THRESHOLD){
                dy = -1;
            }else{
                dy = 0;
            }
        }else if (Math.abs(dx) > Math.abs(dy)){
            dy = 0;
            if (dx > 0 && dx >= ANALOG_THRESHOLD){
                dx = 1;
            }else if (dx < 0 && dx <= -ANALOG_THRESHOLD){
                dx = -1;
            }else{
                dx = 0;
            }
        }else{
            dx = 0;
            dy = 0;
        }
        return Direction.fromDeltas(Std.int(dx), Std.int(dy));
    }

    public function getRightAnalogDirection(){
        var dx = getRightAnalogXAxis();
        var dy = getRightAnalogYAxis();
        if(Math.abs(dx) < Math.abs(dy)){
            dx = 0;
            if (dy > 0 && dy >= ANALOG_THRESHOLD){
                dy = 1;
            }else if (dy < 0 && dy <= -ANALOG_THRESHOLD){
                dy = -1;
            }else{
                dy = 0;
            }
        }else if (Math.abs(dx) > Math.abs(dy)){
            dy = 0;
            if (dx > 0 && dx >= ANALOG_THRESHOLD){
                dx = 1;
            }else if (dx < 0 && dx <= -ANALOG_THRESHOLD){
                dx = -1;
            }else{
                dx = 0;
            }
        }else{
            dx = 0;
            dy = 0;
        }
        return Direction.fromDeltas(Std.int(dx), Std.int(dy));
    }

    public function getXAxis(){
        var val = getAnalogXAxis();
        if (Math.abs(val) < ANALOG_THRESHOLD)
            val = getRightAnalogXAxis();
        if (Math.abs(val) < ANALOG_THRESHOLD)
            val = getDPadXAxis();
        return val;
    }

    public function getYAxis(){
        var val = getAnalogYAxis();
        if (Math.abs(val) < ANALOG_THRESHOLD)
            val = getRightAnalogYAxis();
        if (Math.abs(val) < ANALOG_THRESHOLD)
            val = getDPadYAxis();
        return val;
    }

    public function getRightAnalogXAxis(){
        if (getMode() == Controller)
            return m_pad.values[hxd.Pad.DEFAULT_CONFIG.ranalogX];
        return getKeyboardXAxis();
    }

    public function getRightAnalogYAxis(){
        if (getMode() == Controller)
            return m_pad.values[hxd.Pad.DEFAULT_CONFIG.ranalogY];
        return getKeyboardYAxis();
    }

    public function getAnalogXAxis(){
        if (getMode() == Controller)
            return m_pad.values[hxd.Pad.DEFAULT_CONFIG.analogX];
        return getKeyboardXAxis();
    }

    public function getAnalogYAxis(){
        if (getMode() == Controller)
            return m_pad.yAxis;
        return getKeyboardYAxis();
    }

    private function getKeyboardXAxis(){
        if (hxd.Key.isDown(m_bindKeyXAxisNeg))
            return -1;
        if (hxd.Key.isDown(m_bindKeyXAxisPos))
            return 1;
        return 0;
    }

    private function getKeyboardYAxis(){
        if (hxd.Key.isDown(m_bindKeyYAxisNeg))
            return -1;
        if (hxd.Key.isDown(m_bindKeyYAxisPos))
            return 1;
        return 0;
    }

    private function getDPadXAxis(){
        if (m_pad.isDown(hxd.Pad.DEFAULT_CONFIG.dpadUp))
            return -1;
        if (m_pad.isDown(hxd.Pad.DEFAULT_CONFIG.dpadDown))
            return 1;
        return 0;
    }

    private function getDPadYAxis(){
        if (m_pad.isDown(hxd.Pad.DEFAULT_CONFIG.dpadLeft))
            return -1;
        if (m_pad.isDown(hxd.Pad.DEFAULT_CONFIG.dpadRight))
            return 1;
        return 0;
    }

    public function rumble(mode:RumbleMode){
        if (getMode() == Controller){
            m_pad.rumble(mode.getStrength(), mode.getTimeS());
        }
    }

    public function padAvailable(){
        return m_pad != null;
    }

    public function getMode(){
        if (m_mode == Controller && m_pad == null)
            return InputMode.Keyboard;
        return m_mode;
    }

    
}
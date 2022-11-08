package inputs;


class Controller implements IInputController{

    var m_pad : hxd.Pad;
    var m_padQueue:List<hxd.Pad>;
    var m_mode : InputMode = Keyboard;

    public function new(){
        m_padQueue = new List<hxd.Pad>();
        hxd.Pad.wait(onPadConnected);
        trace('waiting for controllers...');
    }

    /**
     * activates when a new pad is connected.
     * only one pad can be linked at a time.
     * extra pads are added to padQueue.
     */
    private function onPadConnected(pad:hxd.Pad){
        m_padQueue.add(pad);
        trace('pad ${pad.name} connected');
        pad.onDisconnect = ()->{onPadDisconnected(pad);};
        tryConnectPad();
    }

    private function tryConnectPad(){
        if (m_pad == null){
            m_pad = m_padQueue.pop();
        }
    }

    /**
     * activates when a pad is disconnected.
     * if m_pad, remove it and set next pad as active.
     * remove pad from m_padQueue.
     */
    private function onPadDisconnected(pad:hxd.Pad){
        trace('pad ${pad.name} disconnected');
        m_padQueue.remove(pad);
        if (m_pad == pad){
            m_pad = m_padQueue.pop();
        }
        tryConnectPad();
    }

    /**
     * triggers the active hxd.Pad rumble.
     */
    public function rumble(){
        if (padAvailable()){
            m_pad.rumble(0.9, 1);
        }
    }

    public function getPad(){
        return m_pad;
    }

    /**
     * returns if there is a pad connected to the controller.
     */
    public function padAvailable(){
        return m_pad != null;
    }

    /**
     * returns the input mode.
     */
    public function getMode(){
        // if set to controller but no controller available,
        // we default to keyboard.
        if (m_mode == Controller && m_pad == null){
            return InputMode.Keyboard;
        }
        return m_mode;
    }

    
}
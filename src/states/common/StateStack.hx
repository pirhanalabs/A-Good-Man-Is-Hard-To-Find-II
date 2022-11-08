package states.common;

/**
 * wrapper for a list of state stacked on
 * top of each other. only the last state added
 * will be updated, and can be removed. when removed,
 * the previous state is set active.
 */
class StateStack{

    var m_stack : List<IState>;
    var m_active : IState;
    
    public function new(){
        m_stack = new List<IState>();
    }

    /**
     * method to push a new state on the stack.
     * @param state 
     */
    public function push(state:IState, ?params:Dynamic){
        m_stack.push(state);
        m_active = state;
        m_active.onEnter(params);
    }

    /**
     * removes the top state from the stack.
     */
    public function pop(){
        m_active.onExit();
        m_active = m_stack.first();
    }

    /**
     * updates the top state.
     * @param dt delta time
     */
    public function update(dt:Float){
        if (m_active != null){
            m_active.update(dt);
        }
    }

    /**
     * renders the top state.
     */
    public function postUpdate(){
        if (m_active != null){
            m_active.postUpdate();
        }
    }
}
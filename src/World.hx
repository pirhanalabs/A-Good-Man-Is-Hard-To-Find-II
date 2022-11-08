/**
 * wrapper center hub for generic data that needs
 * to be accessed by states. the world also doubles
 * as the root scene for states to be added to.
 **/

import states.screen.AbstractScreenState;
import states.common.StateStack;

interface IWorld{
    function setGameState(state:AbstractScreenState, ?params:Dynamic):Void;
    function popGameState():Void;
}

class World implements IWorld{

    var m_gamestate : StateStack;

    public function new(){
        m_gamestate = new StateStack();
    }

    /**
     * set the game state, and adds it to the world.
     * @param state new top state.
     * @param params optional parameters when entering the state.
     */
    public function setGameState(state:AbstractScreenState, ?params:Dynamic){
        state.setWorld(this);
        m_gamestate.push(state, params);
    }

    /**
     * removes the active game state and
     * sets the previous one as active.
     */
    public function popGameState(){
        m_gamestate.pop();
    }

    /**
     * triggers every game tick (60 per seconds)
     * @param dt delta time
     */
    public function update(dt:Float){
        m_gamestate.update(dt);
    }

    /**
     * triggers every game tick (60 per seconds)
     */
    public function postUpdate(){
        m_gamestate.postUpdate();
    }
}


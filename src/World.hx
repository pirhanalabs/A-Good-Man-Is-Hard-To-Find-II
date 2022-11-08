/**
 * wrapper center hub for generic data that needs
 * to be accessed by states. the world also doubles
 * as the root scene for states to be added to.
 **/

import inputs.IInputController;
import inputs.Controller;
import states.screen.AbstractScreenState;
import states.common.StateStack;

interface IWorld{
    function setGameState(state:AbstractScreenState, ?params:Dynamic):Void;
    function popGameState():Void;
    function getInputs():IInputController;
}

class World implements IWorld{

    var m_gamestate : StateStack;
    var m_inputs : Controller;
    var m_app : App;

    public function new(app:App){
        m_app = app;
        m_gamestate = new StateStack();
        m_inputs = new Controller();
    }

    /**
     * set the game state, and adds it to the world.
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
     * returns the input controller.
     */
    public function getInputs(){
        return m_inputs;
    }

    /**
     * triggers every game tick (60 per seconds)
     */
    public function update(dt:Float){
        m_gamestate.update(dt);

        if (hxd.Key.isPressed(hxd.Key.SPACE)){
            m_inputs.getPad().rumble(0.2, 2);
        }
    }

    /**
     * triggers every game tick (60 per seconds)
     */
    public function postUpdate(){
        m_gamestate.postUpdate();
    }
}


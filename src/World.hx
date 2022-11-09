/**
 * wrapper center hub for generic data that needs
 * to be accessed by states. the world also doubles
 * as the root scene for states to be added to.
 **/

import inputs.ActionType;
import inputs.IInputController;
import inputs.Controller;
import states.screen.AbstractScreenState;
import states.common.StateStack;

interface IWorld{
    function setGameState(state:AbstractScreenState, ?params:Dynamic):Void;
    function popGameState():Void;
    function getInputs():IInputController<ActionType>;
}

class World implements IWorld{

    var m_gamestate : StateStack;
    var m_inputs : Controller<ActionType>;
    var m_app : App;

    public function new(app:App){
        m_app = app;
        m_gamestate = new StateStack();

        m_inputs = new Controller();

        m_inputs.bindPad(Up, hxd.Pad.DEFAULT_CONFIG.dpadUp);
        m_inputs.bindPad(Down, hxd.Pad.DEFAULT_CONFIG.dpadDown);
        m_inputs.bindPad(Left, hxd.Pad.DEFAULT_CONFIG.dpadLeft);
        m_inputs.bindPad(Right, hxd.Pad.DEFAULT_CONFIG.dpadRight);

        m_inputs.bindKey(Up, hxd.Key.W);
        m_inputs.bindKey(Down, hxd.Key.S);
        m_inputs.bindKey(Left, hxd.Key.A);
        m_inputs.bindKey(Right, hxd.Key.D);

        m_inputs.bindPad(Interact, hxd.Pad.DEFAULT_CONFIG.A);
        m_inputs.bindKey(Interact, hxd.Key.SPACE);

        m_inputs.bindPad(Cancel, hxd.Pad.DEFAULT_CONFIG.B);
        m_inputs.bindKey(Cancel, hxd.Key.ESCAPE);

        m_inputs.bindPad(Inventory, hxd.Pad.DEFAULT_CONFIG.X);
        m_inputs.bindKey(Inventory, hxd.Key.E);

        m_inputs.bindPad(Home, hxd.Pad.DEFAULT_CONFIG.start);
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
    public function getInputs():IInputController<ActionType>{
        return m_inputs;
    }

    /**
     * triggers every game tick (60 per seconds)
     */
    public function update(dt:Float){
        m_gamestate.update(dt);

        
        var dir = getInputs().getAxisDirection();
        if (dir != null){
            return;
            trace('axis ${dir.dx},${dir.dy}');
        }
    }

    /**
     * triggers every game tick (60 per seconds)
     */
    public function postUpdate(){
        m_gamestate.postUpdate();
    }
}


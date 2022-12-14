/**
 * wrapper center hub for generic data that needs
 * to be accessed by states. the world also doubles
 * as the root scene for states to be added to.
 **/
import data.ItemStack;
import data.ItemRegistry;
import data.ItemInventory;
import states.screen.OverworldState;
import inputs.ActionType;
import inputs.IInputController;
import inputs.Controller;
import states.screen.AbstractScreenState;
import states.common.StateStack;

interface IWorld{
    var sounds (default, null) : SoundManager;
    var inventory (default, null) : Inventory;
    function setGameState(state:AbstractScreenState, ?params:Dynamic, immediate:Bool = false):Void;
    function popGameState():Void;
    function getInputs():IInputController<ActionType>;
    function setScene(scene:h2d.Layers):Void;
}

class World implements IWorld{

    public var items (get, never) : ItemRegistry;

    var m_gamestate : StateStack;
    var m_inputs : Controller<ActionType>;
    var m_app : App;

    public var sounds (default, null): SoundManager;
    public var inventory (default, null) : Inventory;

    var m_stateBuffer : AbstractScreenState;
    var m_stateBufferParams:Dynamic;

    public function new(app:App){
        m_app = app;
        m_app.engine.backgroundColor = 0x000000;
        m_app.s2d.scaleMode = LetterBox(Presets.VIEWPORT_WID, Presets.VIEWPORT_WID, true, Center, Center);
        m_gamestate = new StateStack();

        sounds = new SoundManager();

        ItemRegistry.get().load();
        hxd.Timer.skip();

        inventory = new Inventory();

        hxd.Timer.wantedFPS = 60;

        m_inputs = new Controller();

        m_inputs.bindPad(Up, hxd.Pad.DEFAULT_CONFIG.dpadUp);
        m_inputs.bindPad(Down, hxd.Pad.DEFAULT_CONFIG.dpadDown);
        m_inputs.bindPad(Left, hxd.Pad.DEFAULT_CONFIG.dpadLeft);
        m_inputs.bindPad(Right, hxd.Pad.DEFAULT_CONFIG.dpadRight);

        m_inputs.setAxisAsDirection(Up, Down, Left, Right);

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
        m_inputs.bindKey(Home, hxd.Key.ESCAPE);

        haxe.Timer.delay(start, 1);
    }

    function start(){
        setGameState(new states.screen.MainMenu());
    }

    public function setScene(scene:h2d.Layers){
        m_app.s2d.add(scene, 1);
    }

    /**
     * set the game state, and adds it to the world.
     */
    public function setGameState(state:AbstractScreenState, ?params:Dynamic, immediate:Bool = false){
        m_stateBuffer = state;
        m_stateBufferParams = params;
        if (immediate){
            setstate();
        }
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

    private function get_items(){
        return ItemRegistry.get();
    }

    private function setstate(){
        m_stateBuffer.setWorld(this);
        m_gamestate.push(m_stateBuffer, m_stateBufferParams);
        m_stateBuffer = null;
    }

    /**
     * triggers every game tick (60 per seconds)
     */
    public function update(dt:Float){
        if (m_stateBuffer != null){
            setstate();
        }
        m_inputs.update(dt);
        m_gamestate.update(dt);
    }
    

    /**
     * triggers every game tick (60 per seconds)
     */
    public function postUpdate(){
        m_gamestate.postUpdate();
    }
}


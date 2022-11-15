package states.screen;

class OverworldState extends AbstractScreenState{
    
    public function new(){
        super();
    }

	override public function onEnter(?params:Dynamic) {
        super.onEnter(params);
    }

	override public function onExit() {
        super.onExit();
    }

	public function update(dt:Float) {
        handleInputs();
    }

    private function handleInputs(){
        var inputs = m_world.getInputs();
        
        // open inventory tab
        if (inputs.isPressed(Inventory)){
            m_world.setGameState(new InventoryState());
        }
        if (inputs.isPressed(Home)){
            hxd.System.exit();
        }
    }

	public function postUpdate() {}
}
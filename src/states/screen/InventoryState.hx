package states.screen;

import ui.window.ItemList;
import data.ItemStack;
import h2d.ScaleGrid;
import data.Item;
import h2d.Text;



class InventoryState extends AbstractScreenState{

    var inv_menu : ui.window.ItemList<ItemStack>;

    public function new(){
        super();
    }
    
    override public function onEnter(?params:Dynamic){
        super.onEnter(params);
        trace('opened inventory');

        // var bg = new h2d.ScaleGrid(Assets.getMisc('bg_menubox'), 8, 8, 8, 8);
        // bg.width = 256;
        // bg.height = 256;
        // m_scene.add(bg, 1);

        inv_menu = ui.window.ItemList.create()
            .setLines(12)
            .setWidth(230)
            .setData(m_world.getInventory().getItems())
            .setTitle('Inventory')
            .setCol('Items:', 3, getInvItemName)
            .setCol('QT:', 170, getInvItemQuantity)
            .setHoverCallback(onInventoryHover)
            .setSelectCallback(onInventorySelect)
            .ready();

        m_scene.add(inv_menu, 1);
        inv_menu.x = 100;
        inv_menu.y = 100;
    }

    var items : Array<ItemStack>;

    private function onInventoryHover(item:ItemStack){
        // callback on hover
    }

    private function onInventorySelect(item:ItemStack){
        m_world.getInventory().sub(item);
        // callback on select
    }

    private function getInvItemName(item:ItemStack){
        return item.item.name;
    }

    private function getInvItemQuantity(item:ItemStack){
        var str = 'x';
        str += item.quantity < 100 ? '0' : '';
        str += item.quantity < 10 ? '0' : '';
        str += item.quantity;
        return str;
    }

    override public function onExit(){
        super.onExit();
    }

	public function update(dt:Float) {
        handleInputs();
        inv_menu.update(dt);
    }

    private function handleInputs(){
        var inputs = m_world.getInputs();
        if (inputs.isPressed(Up)){
            inv_menu.prev();
        }
        if (inputs.isPressed(Down)){
            inv_menu.next();
        }
        if (inputs.isPressed(Inventory) || inputs.isPressed(Cancel)){
            m_world.popGameState();
            trace('inventory left');
        }
        if (inputs.isPressed(Interact)){
            inv_menu.select();
        }
    }

	public function postUpdate() {
        
    }
}
package states.screen;

import data.ItemRegistry;
import ui.window.ItemList;
import data.ItemStack;


/**
 * This is a temporary setup. Only purpose was to test the beautiful itemlist possibilities
 */
class InventoryState extends AbstractScreenState{

    var active_menu : ui.window.ItemList<ItemStack>;
    var inv_menu : ui.window.ItemList<ItemStack>;
    var cut_menu : ui.window.ItemList<ItemStack>;
    var cook_menu : ui.window.ItemList<ItemStack>;

    var cut_items : Array<ItemStack> = [];
    var cook_items : Array<ItemStack> = [];

    public function new(){
        super();
    }
    
    override public function onEnter(?params:Dynamic){
        super.onEnter(params);
        trace('opened inventory');

        inv_menu = ui.window.ItemList.create()
            .setLines(12)
            .setWidth(230)
            .setData(m_world.getInventory().getItems())
            .setTitle('Inventory')
            .setCol('Items:', 3, (item:ItemStack)->item.item.name)
            .setCol('QT:', 170, getItemQuantity)
            .setHoverCallback(onInventoryHover)
            .setSelectCallback(onInventorySelect)
            .ready();

        m_scene.add(inv_menu, 1);
        inv_menu.x = 35;
        inv_menu.y = 175;

        cut_menu = ui.window.ItemList.create()
            .setLines(12)
            .setWidth(230)
            .setData(cut_items)
            .setTitle('Cutting Board')
            .setCol('Items:', 3, (item:ItemStack)->item.item.name)
            .setCol('QT:', 170, getItemQuantity)
            .setHoverCallback(onCuttingBoardHover)
            .setSort(function sort(a:ItemStack, b:ItemStack){
                return a.item.name > b.item.name ? 1 : -1;
            })
            .setSelectCallback(onCuttingBoardSelect)
            .ready();

        m_scene.add(cut_menu, 1);
        cut_menu.x = 285;
        cut_menu.y = inv_menu.y;
        cut_menu.unfocus();

        cook_menu = ui.window.ItemList.create()
            .setLines(12)
            .setWidth(230)
            .setData(cook_items)
            .setTitle('Cookbook')
            .setCol('Items:', 3, (item:ItemStack)->item.item.name)
            .setCol('QT:', 170, getItemQuantity)
            .setHoverCallback(onCookbookHover)
            .setSort(function sort(a:ItemStack, b:ItemStack){
                return a.item.name > b.item.name ? 1 : -1;
            })
            .setSelectCallback(onCookbookSelect)
            .ready();

        m_scene.add(cook_menu, 1);
        cook_menu.x = 535;
        cook_menu.y = inv_menu.y;
        cook_menu.unfocus();

        active_menu = inv_menu;
    }

    private function onCookbookHover(item:ItemStack){
        // show description
    }

    private function onCookbookSelect(item:ItemStack){
        if (m_world.getInventory().add(item)){
            for (ingredient in item.item.getIngredients()){
                for (i in cut_items){
                    if (i.item.uid == ingredient.item.uid){
                        i.remove(ingredient.quantity, true);
                        if (i.quantity <= 0){
                            cut_items.remove(i);
                        }
                    }
                }
            }
            updateCookbookList();
            inv_menu.forceUpdate();
            cut_menu.forceUpdate();
        }
    }

    private function onCuttingBoardHover(item:ItemStack){
        // show description
    }

    private function onCuttingBoardSelect(item:ItemStack){
        cut_items.remove(item);
        m_world.getInventory().add(item);
        updateCookbookList();
    }

    private function onInventoryHover(item:ItemStack){
        // show description
    }

    private function onInventorySelect(item:ItemStack){
        cut_items.push(item);
        m_world.getInventory().remove(item);
        updateCookbookList();
    }

    private function getItemQuantity(item:ItemStack){
        var str = 'x';
        str += item.quantity < 100 ? '0' : '';
        str += item.quantity < 10 ? '0' : '';
        str += item.quantity;
        return str;
    }

    // could be optimized
    private function updateCookbookList(){
        while(cook_items.length != 0){
            cook_items.pop();
        }
        var recipes = ItemRegistry.get().getDishesByIngredients(cut_items);
        
        for (recipe in recipes){
            cook_items.push(new ItemStack(recipe, recipe.shopQuantity));
        }
    }

    override public function onExit(){
        super.onExit();
    }

	override public function update(dt:Float) {
        super.update(dt);
        handleInputs();
        inv_menu.update(dt);
        cut_menu.update(dt);
        cook_menu.update(dt);
    }

    private function handleInputs(){
        var inputs = m_world.getInputs();

        if (inputs.isPressed(Up)){
            active_menu.prev();
        }
        else if (inputs.isPressed(Down)){
            active_menu.next();
        }
        else if (inputs.isPressed(Left)){
            if (active_menu == cut_menu){
                active_menu.unfocus();
                active_menu = inv_menu;
                active_menu.focus();
            }
            else if (active_menu == cook_menu){
                active_menu.unfocus();
                active_menu = cut_menu;
                active_menu.focus();
            }
        }
        else if (inputs.isPressed(Right)){
            if (active_menu == inv_menu){
                active_menu.unfocus();
                active_menu = cut_menu;
                active_menu.focus();
            }
            else if (active_menu == cut_menu){
                active_menu.unfocus();
                active_menu = cook_menu;
                active_menu.focus();
            }
        }
        if (inputs.isPressed(Inventory) || inputs.isPressed(Cancel)){
            for (item in cut_items){
                m_world.getInventory().add(item);
            }
            m_world.popGameState();
            trace('inventory left');
        }
        if (inputs.isPressed(Interact)){
            active_menu.select();
        }
    }

	public function postUpdate() {
        
    }
}
package data;

class ItemInventory{

        var m_items:Array<ItemStack> = [];

        public function new(){

        }

        public function sortAlphabetically(){
                m_items.sort(function(a:ItemStack, b:ItemStack){
                        if (a.item.name > b.item.name) return 1;
                        return -1;
                });
        }

        public function sub(item:ItemStack, notIfNegative:Bool = false){
                for (itemm in m_items){
                        if (itemm.item.uid == item.item.uid){
                                if (itemm.remove(item.quantity, notIfNegative)){
                                        if (itemm.quantity <= 0){
                                                m_items.remove(itemm);
                                                sortAlphabetically();
                                        }
                                        return true;
                                }
                                return false;
                        }
                }
                return true;
        }

        public function add(item:ItemStack){
                for (itemm in m_items){
                        if (itemm.item.uid == item.item.uid){
                                return itemm.add(item.quantity);
                        }
                }
                m_items.push(item);
                sortAlphabetically();
                return true;
        }

        public function getItems(){
                return m_items;
        }
}
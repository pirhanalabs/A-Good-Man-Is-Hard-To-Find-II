package data;

class ItemStack{

    public static final STACK_SIZE_LIMIT = 999;
    
    public var quantity (default, null) : Int;
    public var item (default, null) : Item;

    public function new(item:Item, quantity = 1){
        this.item = item;
        this.quantity = quantity;
    }

    public function add(val:Int){
        if (this.quantity + val > STACK_SIZE_LIMIT){
            return false;
        }
        this.quantity += val;
        return true;
    }

    public function remove(val:Int, notIfResultNegative:Bool = false){
        if (notIfResultNegative && this.quantity - val < 0){
            return false;
        }
        this.quantity -= val;
        return true;
    }
}
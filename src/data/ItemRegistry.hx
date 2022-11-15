package data;

private class ItemBuilder extends Item{

    public function new(uid, name, type, category, cost, ingredients, shopQuantity){
        super(uid, name, type, category, cost, ingredients, shopQuantity);
    }
}

private typedef ItemJson = {
    uid : String,
    name : String,
    type : String,
    category : String,
    cost:Int,
    shopQuantity:Int,
    ingredients:Array<{uid:String, quantity:Int}>
}

private typedef IngredientsEntryJson = {
    data : Array<ItemJson>
}

class ItemRegistry{

    private static var instance : ItemRegistry;

    public static function get(){
        if (instance == null)
            instance = new ItemRegistry();
        return instance;
    }

    private var m_loaded:Bool = false;

    private var m_items : Map<String, Item> = [];

    private function new(){

    }

    public function load(){
        if (m_loaded) return;
        m_loaded = true;

        // load regulars
        var entry= hxd.Res.load('res/data/ingredients.json').entry;
        // right now, all ingredients are in the same file.
        // in the future, they will be in their individual files.
        // we will need to handle directory instead of unique file.
        var json:IngredientsEntryJson = haxe.Json.parse(entry.getText());
        for (j in json.data){
            var item = parse(j);
            m_items.set(item.uid, item);
        }
        // load mods
        // no mod support right now
    }

    public function parse(json:ItemJson):Item{
        return new ItemBuilder(
            json.uid,
            json.name,
            data.Item.ItemType.createByName(json.type),
            data.Item.ItemCategory.createByName(json.category),
            json.cost,
            json.ingredients,
            json.shopQuantity
        );
    }

    public function getByUID(uid:String){
        return m_items[uid];
    }
}
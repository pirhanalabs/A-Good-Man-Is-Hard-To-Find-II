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
    private var m_craft : Map<String, Item> = [];
    private var m_filter_ingredientToCraft : Map<String, Array<String>> = [];

    private function new(){

    }

    public function load(){
        if (m_loaded) return;
        m_loaded = true;

        // load regulars
        var entry= hxd.Res.load('data/ingredients.json').entry;

        // right now, all ingredients are in the same file.
        // in the future, they will be in their individual files.
        // we will need to handle directory instead of unique file.

        // the loading also needs to be reviewed.
        // i am not a big fan of only having strings for the ingredients.
        // loading all items and then setting their ingredients
        // might be better idea? worth considering a refactoring.

        var json:IngredientsEntryJson = haxe.Json.parse(entry.getText());
        for (j in json.data){
            var item = parse(j);
            if (item.type == Dish || item.type == PreparedIngredient){
                m_craft.set(item.uid, item);
                for (uid=>quantity in item.getIngredientData()){
                    var list = m_filter_ingredientToCraft.get(uid);
                    if (list == null){
                        list = [];
                        m_filter_ingredientToCraft[uid] = list;
                    }
                    list.push(item.uid);
                }
            }
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

    public function getDishesByIngredients(ingredients:Array<ItemStack>){
        var res = [];
        var newres = [];

        for (i in 0 ... ingredients.length){
            var ingredient = ingredients[i];
            newres = [];
            if (i == 0){
                var list = m_filter_ingredientToCraft[ingredient.item.uid];
                for (recipe in list){
                    var item = m_craft.get(recipe);
                    if (item.getIngredientQuantity(ingredient.item.uid) <= ingredient.quantity){
                        newres.push(item);
                    }
                }
            }else{
                var recipeqt:Int = 0;
                for (item in res){
                    recipeqt = item.getIngredientQuantity(ingredient.item.uid);
                    if (recipeqt != 0 && recipeqt <= ingredient.quantity){
                        newres.push(item);
                    }
                }   
            }
            res = newres;
        }

        newres = [];
        for (item in res){
            if (item.getIngredientCount() == ingredients.length){
                newres.push(item);
            }
        }
        return newres;
    }
}
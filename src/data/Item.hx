package data;

enum ItemType{
    Ingredient;
    Drink;
    Dish;
}

enum ItemCategory{

    Egg;
    Dairy;

    Fat;
    Oil;

    Fruit;
    Vegetable;

    Grain;
    Nut;
    BakingProduct;

    Herb;
    Spice;

    Meat;
    Sausage;
    Fish;

    Other;

    Pasta;
    Rice;
    Pulse;
}

class Item{

    public var uid (default, null) : String;
    public var name (default, null) : String;

    public var cost (default, null) : Float;
    public var shopQuantity (default, null) : Int;
    public var complexity (get, never) : Int;

    public var type (default, null) : ItemType;
    public var category (default, null) : ItemCategory;

    private var ingredients (default, null) : Array<{uid:String, quantity:Int}>;

    private var parsedIngredients : Array<ItemStack>;

    private function new(uid, name, type, category, cost, ingredients:Array<{uid:String, quantity:Int}>, shopQuantity){
        this.uid = uid;
        this.name = name;
        this.type = type;
        this.category = category;
        this.cost = cost;
        this.ingredients = ingredients == null ? [] : ingredients;
    }

    private function get_complexity(){
        var score = 1;
        for (ingredient in getIngredients()){
            score += ingredient.item.complexity * ingredient.quantity;
        }
        return score;
    }

    public function getIngredients(){
        // lazy loader.
        // might impact performance **
        // we do it this way because not all ingredients
        // can be found when loading the items.
        if (parsedIngredients == null){
            parsedIngredients = [];
            for (ingredient in ingredients){
                new ItemStack(ItemRegistry.get().getByUID(ingredient.uid), ingredient.quantity);
            }
        }
        return parsedIngredients;
    }
}
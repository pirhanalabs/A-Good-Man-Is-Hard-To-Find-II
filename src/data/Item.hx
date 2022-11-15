package data;

enum ItemType{
    /**
     * an ingredient is a single item
     * made of no ingredients. meaning it cannot
     * be crafted inside of the cookbook.
     */
    Ingredient;
    /**
     * a prepared ingredient is an ingredient
     * made of one or many other ingredients.
     * as an example, bread is an ingredient or
     * prepared food made of other ingredients.
     * similar to dishes, but cannot be served to a client
     * directly.
     */
    PreparedIngredient;
    /**
     * a drink is the equivalent of a dish made
     * with mostly liquids rather than solids.
     * it can be served alongside a dish in a client order.
     * drinks can be part of a menu.
     */
    Drink;
    /**
     * one or more food product that can be placed on the menu.
     * a dish is a package of various elements.
     * a dish can be a part of another dish.
     * ex: bread slices are not a dish because they only contain 1 ingredient.
     *     but garlic bread slice are a dish, since they contain multiple ingredients
     *     and can be served to a client. however, bread slices can be served as an
     *     ingredient part of a dish (ex spaghetti served with bread slices)
     */
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
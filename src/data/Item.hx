package data;

enum ItemType{
    Ingr;
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

    public static function getCowMilk(){
        var item = new Item('cow_milk', 'Cow Milk', Drink, Dairy, 10);
        return item;
    }

    public static function getPorkMeat(){
        var item = new Item('pork_meat', 'Pork Meat', Ingr, Meat, 20);
        return item;
    }

    public static function getChickenMeat(){
        var item = new Item('chicken_meat', 'Chicken Meat', Ingr, Meat, 20);
        return item;
    }

    public var uid (default, null) : String;
    public var name (default, null) : String;

    public var cost (default, null) : Float;

    public var type (default, null) : ItemType;
    public var category (default, null) : ItemCategory;

    private function new(uid, name, type, category, cost){
        this.uid = uid;
        this.name = name;
        this.type = type;
        this.category = category;
        this.cost = cost;
    }
}
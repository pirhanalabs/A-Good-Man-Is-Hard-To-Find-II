class Items{

    public static final WHEAT = "Wheat";
    public static final BROWN_MUSHROOM = "Brown Mushroom";
    public static final RED_MUSHROOM = "Red Mushroom";
    public static final SPICE = "Spice";
    public static final GOLD_SPICE = "Gold Spice";
    public static final GOLD_KEY = "Gold Key";
    public static final HONEY = "Honey";
    public static final FRESH_HONEY = "Fresh Honey";
    public static final WATER = "Fresh Water";
    public static final CRACKERS = "Plain Crackers";

    public static final TROUT = "Trout";
    public static final SALMON = "Salmon";
    public static final NORDIC_WOLFFISH = "Nordic Wolffish";
    public static final LIONFISH = "Lionfish";
    public static final PUFFERFISH = "Pufferfish";
    public static final HALIBUT = "Halibut";
    public static final SQUID_MEAT = "Squid Meat";
    public static final RED_LOBSTER = "Red Lobster";
    public static final TUNA = "Tuna";
    public static final SWORDFISH = "Swordfish";
    public static final SNAPPER = "Snapper";

    public static final MOLE_MEAT = "Mole Meat";
    public static final FROG_LEGS = "Frog Legs";
    public static final RAT_MEAT = "Rat Meat";
    public static final SPICY_RAT_MEAT = "Spicy Rat Meat";
    public static final BLUEPRINT_PAPER = "Blueprint Paper";
    public static final CRAB_MEAT = "Crab Meat";
    public static final TOAD_MEAT = "Toad Legs";
    public static final BADGER_MEAT = "Badger Meat";
    public static final SNAKE_VENOM = "Snake Venom";
    public static final PENGUIN_MEAT = "Penguin Meat";
    public static final GOAT_GUTS = "Goat Guts";
}

class Inventory{

    private var items : Array<String> = [];

    public function new(){

    }

    public function add(item:String){
        items.push(item);
    }

    public function remove(item:String){
        items.remove(item);
    }

    public function has(item:String){
        return items.indexOf(item) != -1;
    }
}
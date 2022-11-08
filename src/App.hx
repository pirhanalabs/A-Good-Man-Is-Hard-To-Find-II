class App extends hxd.App{

    public static function main(){
        new App();
    }

    override function init() {
        super.init();
    }

    override function update(dt:Float) {
        super.update(dt);
    }

    function irand(max:Float, min:Float){
        return Math.random()*(max-min)+min;
    }
}

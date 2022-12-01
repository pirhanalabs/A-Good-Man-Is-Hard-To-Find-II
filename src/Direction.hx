class Direction{

    public static function fromDeltas(dx:Int, dy:Int){
        for (dir in Direction.ALL){
            if (dir.dx == dx && dir.dy == dy)
                return dir;
        }
        return null;
    }

    public static final Up = new Direction(1, 'up', 0, -1);
    public static final Down = new Direction(2, 'dw', 0, 1);
    public static final Left = new Direction(3, 'lt', -1, 0);
    public static final Right = new Direction(4, 'rt', 1, 0);
    private static final ALL = [Up, Down, Left, Right];

    public var name (default, null) : String;
    public var id (default, null) : Int;
    public var dx (default, null) : Int;
    public var dy (default, null) : Int;


    private function new(id:Int, name:String, dx:Int, dy:Int){
        this.name = name;
        this.id = id;
        this.dx = dx;
        this.dy = dy;
    }

    public function getOpposite(){
        if (this == Up)
            return Down;
        if (this == Down)
            return Up;
        if (this == Left)
            return Right;
        return Left;
    }
}
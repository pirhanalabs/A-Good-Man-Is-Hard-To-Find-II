class Direction{

    public static function fromDeltas(dx:Int, dy:Int){
        for (dir in Direction.ALL){
            if (dir.dx == dx && dir.dy == dy)
                return dir;
        }
        return null;
    }

    public static final Up = new Direction(1, 0, -1);
    public static final Down = new Direction(2, 0, 1);
    public static final Left = new Direction(3, -1, 0);
    public static final Right = new Direction(4, 1, 0);
    private static final ALL = [Up, Down, Left, Right];

    public var id (default, null) : Int;
    public var dx (default, null) : Int;
    public var dy (default, null) : Int;


    private function new(id:Int, dx:Int, dy:Int){
        this.id = id;
        this.dx = dx;
        this.dy = dy;
    }
}
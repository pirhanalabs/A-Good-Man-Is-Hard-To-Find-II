package overworld.maps;

import World.IWorld;

typedef MapData = {
    wid : Int,
    hei : Int,
    id : String,
    name : String,
    env : Array<Int>,
    ent : Array<{id : Int, cx : Int, cy: Int}>
}

class LevelManager{

    private var m_world : IWorld;
    private var maps : Map<String, Level> = [];
    private var ids : Map<String, Level> = [];

    public function new(world:IWorld){
        this.m_world = world;
    }

    public function add(level:Level){
        maps[getId(level.cx, level.cy)] = level;
        ids[level.id] = level;
    }

    public function getById(id:String){
        return ids[id];
    }

    public function get(mx:Int, my:Int){
        return maps[getId(mx, my)];
    }

    inline function getId(mx:Int, my:Int){
        return '${mx}, ${my}';
    }
}
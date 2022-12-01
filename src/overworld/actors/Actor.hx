package overworld.actors;

class Actor {

    public var sprite (default, null) : h2d.Bitmap;

    public var cx (default, null) : Int;
    public var cy (default, null) : Int;

    public var name (default, null) : String;

    private var tags : Array<String> = [];

    private var ftime : Float = 0;

    private var m_facing = 1;
    private var m_scale = 1;

    public function new(tile:h2d.Tile, cx:Int, cy:Int){
        this.cx = cx;
        this.cy = cy;
        this.sprite = new h2d.Bitmap(tile);
    }

    public function setFacing(direction:Direction){
        if (direction.dx != 0){
            m_facing = direction.dx;
        }
    }

    public function setTag(tag:String){
        if (!hasTag(tag)){
            tags.push(tag);
        }
    }

    public function hasTag(tag:String){
        return tags.indexOf(tag) != -1;
    }

    public function removeTag(tag:String){
        tags.remove(tag);
    }

    public function update(dt:Float){
        ftime += dt;
    }

    public function postUpdate(){
        sprite.x = this.cx * Presets.TILE_SIZE - sprite.tile.dx;
        sprite.y = this.cy * Presets.TILE_SIZE - sprite.tile.dy;
        sprite.scaleX = m_scale * m_facing;
        sprite.scaleY = m_scale;
        sprite.visible = !hasTag(CommonTags.DEAD);
    }
}
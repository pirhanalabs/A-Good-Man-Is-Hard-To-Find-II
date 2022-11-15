
/**
 * class containing all the game assets, parsed and ready to use.
 */
 class Assets{

    private static var initialized : Bool = false;

    public static var font_reg : h2d.Font;

    private static var tilesets:Map<String, h2d.Tile> = [];
    private static var anims:Map<String, Array<h2d.Tile>> = [];
    private static var misctiles:Map<String, h2d.Tile> = []; // misc tiles, mainly hud/ui stuff
    private static var enttiles:Array<h2d.Tile> = []; // entity tiles
    private static var envtiles:Array<h2d.Tile> = []; // environment tiles

    public static function initialize(){
        if (Assets.initialized)
            return;
        Assets.initialized = true;

        hxd.Res.initEmbed();

        font_reg = hxd.Res.fonts.pixelfont.pixelfont.toFont();
        // font_reg = hxd.Res.fonts.pirhana4x4.pirhana4x4.toFont();

        tilesets['env'] = hxd.Res.atlas.environment.toTile();
        tilesets['ent'] = hxd.Res.atlas.entities.toTile();

        enttiles = subTilesheet(tilesets['ent'], 16, 16);
        envtiles = subTilesheet(tilesets['env'], 16, 16);

        // player client
        // idle
        makeAnim('rose_idle_0', enttiles, [3]); // up
        makeAnim('rose_idle_1', enttiles, [0]); // down
        makeAnim('rose_idle_2', enttiles, [6]); // right
        makeAnim('rose_idle_3', enttiles, [8]); // left
        // walk
        makeAnim('rose_walk_0', enttiles, [1, 0, 2, 0]); // up
        makeAnim('rose_walk_1', enttiles, [4, 3, 5, 3]); // down
        makeAnim('rose_walk_2', enttiles, [7, 6, 7, 6]); // right
        makeAnim('rose_walk_3', enttiles, [9, 8, 9, 8]); // left

        misctiles['bg_dialog'] = hxd.Res.hud.dialoguebox.toTile();
        misctiles['bg_menubox'] = hxd.Res.hud.menubox.toTile();
    }

    /**
     * returns a list of tiles from a tilesheet.
     * @param sheet tilesheet to sub from.
     * @param tw tile width.
     * @param th tile height.
     * @param dx tile origin offset.
     * @param dy tile origin offset.
     */
    private static function subTilesheet(sheet:h2d.Tile, tw:Int, th:Int, dx:Int=0, dy:Int=0){
        var ysteps = Std.int(sheet.height / tw);
        var xsteps = Std.int(sheet.width / tw);
        var tiles = [];
        for (y in 0 ... ysteps)
            for (x in 0 ... xsteps)
                tiles.push(sheet.sub(x*tw, y*th, tw, th, dx, dy));
        return tiles;
    }

    /**
     * creates an anim from a list of tiles.
     * @param id name of this animation.
     * @param tilesheet tilesheet the frames are from.
     * @param frames list of tile ids (int) in tilesheet.
     */
    private static function makeAnim(id:String, tilesheet:Array<h2d.Tile>, frames:Array<Int>){
        var anim = [];
        for (frame in frames){
            anim.push(tilesheet[frame]);
        }
        anims.set(id, anim);
    }

    public static function getMisc(id:String){
        return misctiles[id];
    }

    /**
     * returns a stored animation.
     * @param id animation identifier.
     */
    public static function getAnim(id:String){
        return anims[id];
    }

    /**
     * returns a stored environment tile
     * @param id tile identifier
     */
    public static function getEnvTile(id:Int){
        return envtiles[id];
    }

    /**
     * returns a tileset
     * @param id tileset id.
     */
    public static function getTileset(id:String){
        return tilesets[id];
    }
}
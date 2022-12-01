
class SoundAssets{

    public var music_kitchen (default, null) : hxd.res.Sound;
    public var music_overworld (default, null) : hxd.res.Sound;
    public var music_graveyard (default, null) : hxd.res.Sound;
    public var music_sacrifice (default, null) : hxd.res.Sound;

    public var ambiant_dialog_regular (default, null) : hxd.res.Sound;
    public var ambiant_dialog_god (default, null) : hxd.res.Sound;
    public var ambiant_dialog_shake (default, null) : hxd.res.Sound;

    public var sfx_move (default, null) : hxd.res.Sound;
    public var sfx_door (default, null) : hxd.res.Sound;
    public var sfx_dialog_closed (default, null) : hxd.res.Sound;

    public function new(){

        this.music_kitchen = hxd.Res.music.Musique_Home_Sweet_Home;
        this.music_overworld = hxd.Res.music.Musique_Overworld;
        this.music_graveyard = hxd.Res.music.Musique_Don_t_cook_with_the_bones;
        this.music_sacrifice = hxd.Res.music.Musique_Sacrifice;

        this.ambiant_dialog_regular = hxd.Res.sfx.UI_Dialog_long_5;
        this.ambiant_dialog_god = hxd.Res.sfx.UI_Dialog_God_medium_1;
        this.ambiant_dialog_shake = hxd.Res.sfx.Events_Earthquake;

        this.sfx_move = hxd.Res.sfx.move;
        this.sfx_door = hxd.Res.sfx.door_open;
        this.sfx_dialog_closed = hxd.Res.sfx.UI_Dialog_continue_button;
    }
}


/**
 * class containing all the game assets, parsed and ready to use.
 */
 class Assets{

    private static var initialized : Bool = false;

    public static var font_reg : h2d.Font;

    public static var sounds (default, null): SoundAssets;

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

        sounds = new SoundAssets();

        font_reg = hxd.Res.fonts.pixelfont.pixelfont.toFont();
        // font_reg = hxd.Res.fonts.pirhana4x4.pirhana4x4.toFont();

        tilesets['env'] = hxd.Res.atlas.environment.toTile();
        tilesets['ent'] = hxd.Res.atlas.entities.toTile();

        enttiles = subTilesheet(tilesets['ent'], 16, 16, -8, -8);
        envtiles = subTilesheet(tilesets['env'], 16, 16);

        misctiles['bg_dialog'] = hxd.Res.hud.dialoguebox.toTile();
        misctiles['dialog_marker'] = hxd.Res.hud.dialogmarker.toTile();
        misctiles['dialog_marker'].dx = - misctiles['dialog_marker'].width * 0.5;
        misctiles['dialog_marker'].dy = - misctiles['dialog_marker'].height;
        misctiles['bg_menubox'] = hxd.Res.hud.menubox.toTile();

        misctiles['bg_fade'] = h2d.Tile.fromColor(0x000000, Presets.VIEWPORT_WID, Presets.VIEWPORT_HEI);
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
     * returns a stored entity tile
     * @param id  tile identifier
     */
    public static function getEntTile(id:Int){
        return enttiles[id];
    }

    /**
     * returns a tileset
     * @param id tileset id.
     */
    public static function getTileset(id:String){
        return tilesets[id];
    }
}
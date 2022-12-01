package states.screen;

import overworld.actors.Npc;
import overworld.actors.Actor;
import overworld.maps.*;
import overworld.maps.LevelManager;
import overworld.maps.Level;
import inputs.ActionType;

class OverworldState extends AbstractScreenState{

    final SCALE_MAP = 2;

    final LAYER_MAP = 1;
    final LAYER_ACTORS = 2;
    final LAYER_PLAYER = 3;

    var m_scroller : h2d.Layers;

    var m_map : h2d.TileGroup;

    public var kills = 0;

    // directions
    var m_dirx = [-1, 1, 0, 0];
    var m_diry = [0, 0, -1, 1];
    var m_act : Array<ActionType>;

    // player
    var m_player : h2d.Bitmap;
    // player
    var m_playerMove : (dt:Float)->Void;
    var m_playerMoveCallback : ()->Void;
    // player facing direction (1 or -1)
    var m_playerDir : Int = 1; 
    // player animation timer
    var m_playerTimer : Float = 0;
    // player tile position (in map coordinates)
    var m_playercx : Int = 0;
    var m_playercy : Int = 0;
    // player tile offset start position (in world coordinates)
    var m_playersox : Float = 0;
    var m_playersoy : Float = 0;
    // player tile offset position (in world coordinates)
    var m_playerox : Float = 0;
    var m_playeroy : Float = 0;
    // player direction. this is needed for changing maps
    var m_playerdx : Int = 0;
    var m_playerdy : Int = 0;
    var m_shouldChangeMap = false;

    var m_buttonBuffer : ActionType = None;

    var m_updatefn : (dt:Float)->Void;

    // customizable flags for interactions
    var m_tags : Map<String, Bool> = [];

    // map manager
    var m_levels : LevelManager;
    var m_level : Level;
    
    public function new(){
        super();
        m_act = ActionType.createAll();
    }

	override public function onEnter(?params:Dynamic) {
        super.onEnter(params);

        m_scroller = new h2d.Layers();
        m_scene.add(m_scroller, 1);

        m_map = new h2d.TileGroup(Assets.getTileset('env'));
        m_scroller.add(m_map, LAYER_MAP);
        m_scroller.scale(SCALE_MAP);

        

        m_player = new h2d.Bitmap(Assets.getEntTile(0));
        m_scroller.add(m_player, LAYER_PLAYER);
        m_playercx = 3;
        m_playercy = 5;

        m_updatefn = updateGame;

        setTag('intro');
        // stuff to debug
        // setTag('water_walking');

        m_levels = new LevelManager(m_world);
        m_levels.add(new Map_0_0(this, m_world, m_levels, 0, 0));
        m_levels.add(new Map_0_1(this, m_world, m_levels, 0, 1));
        m_levels.add(new Map_0_2(this, m_world, m_levels, 0, 2));
        m_levels.add(new Map_0_3(this, m_world, m_levels, 0, 3));
        m_levels.add(new Map_1_0(this, m_world, m_levels, 1, 0));
        m_levels.add(new Map_1_1(this, m_world, m_levels, 1, 1));
        m_levels.add(new Map_1_2(this, m_world, m_levels, 1, 2));
        m_levels.add(new Map_1_3(this, m_world, m_levels, 1, 3));
        m_levels.add(new Map_2_0(this, m_world, m_levels, 2, 0));
        m_levels.add(new Map_2_1(this, m_world, m_levels, 2, 1));
        m_levels.add(new Map_2_2(this, m_world, m_levels, 2, 2));
        m_levels.add(new Map_2_3(this, m_world, m_levels, 2, 3));
        m_levels.add(new Map_3_1(this, m_world, m_levels, 3, 1));
        m_levels.add(new Map_3_2(this, m_world, m_levels, 3, 2));
        m_levels.add(new Map_3_3(this, m_world, m_levels, 3, 3));

        loadLevel(m_levels.get(3, 1), 3, 5, true);
        // loadLevel(m_levels.get(1, 1), 3, 5, true);
    }

    public function loadLevel(level:Level, playercx:Int, playercy:Int, teleport = false){
        // add a way to do a zelda scroll change of screen thing. thatd be kinda cool i think.
        // or maybe we should add the fade-in/fade-out transition to every screen.
        // there is a lot to think about around maps in general.
        // for example, should we do like pokemon and have large maps, then fade when changing maps
        // to hide loading time? That would perhaps be worth it as well.
        reset();

        m_level = level;
        m_level.onEnter();

        m_playercx = playercx;
        m_playercy = playercy;

        for (y in 0 ... 8){
            for (x in 0 ... 8){
                m_map.add(x * 16, y * 16, Assets.getEnvTile(level.getEnvId(x, y)));
            }
        }

        // since npc sprites are stored in Npc.sprite, we don't need to initialize anything.
        // all we need to do is loop through the npcs, then add then to the stage.
        m_level.npcfn((npc)->{
            m_scroller.add(npc.sprite, LAYER_ACTORS);
        });
    }

    public function replaceEnv(index:Int, id:Int){
        m_map.invalidate();
        var x = m_level.getX(index);
        var y = m_level.getY(index);
        m_level.setEnv(x, y, id);
        m_map.add(x * 16, y * 16, Assets.getEnvTile(id));
    }

    private function reset(){
        m_map.clear();
        m_map.invalidate();
        for (actor in m_scroller.getLayer(LAYER_ACTORS)){
            actor.remove();
        }
    }

    override function onResume(){
        m_buttonBuffer = None;
    }

	override public function onExit() {
        super.onExit();
    }

    // ===================================================
    //                    gameplay
    // ===================================================

    public function checkWaterWalking(){
        m_level.checkWaterWalking();
    }

    private function movePlayer(dx:Int, dy:Int){
        var destx = m_playercx + dx;
        var desty = m_playercy + dy;
        if (!m_level.inBounds(destx, desty)){
            walkPlayer(dx, dy);
            m_shouldChangeMap = true;
        }else if (m_level.hasCollision(destx, desty)){
            collidePlayer(dx, dy);
        }else if (m_level.hasNpc(destx, desty)){
            collidePlayer(dx, dy);
            m_playerMoveCallback = ()->checkNpcBumpTrigger(m_level.getNpc(destx, desty), destx, desty);
        }else{
            walkPlayer(dx, dy);
        }
        if (dx != 0){
            m_playerDir = dx;
        }
        m_updatefn = updatePlayerMove;
    }


    private function walkPlayer(dx:Int, dy:Int){
        m_playercx += dx;
        m_playercy += dy;
        m_playerox = dx * -Presets.TILE_SIZE;
        m_playeroy = dy * -Presets.TILE_SIZE;
        m_playersox = m_playerox;
        m_playersoy = m_playeroy;
        m_playerdx = dx;
        m_playerdy = dy;
        m_playerMove = walkPlayerAnim;
        Assets.sounds.sfx_move.play();
    }

    private function walkPlayerAnim(dt:Float){
        m_playerox = m_playersox * (1 - m_playerTimer);
        m_playeroy = m_playersoy * (1 - m_playerTimer);
    }

    private function collidePlayer(dx:Int, dy:Int){
        // last number is the position where we want it to
        // reach multiplied by 2 (1.2 would be 0.6 tiles ahead)
        m_playersox = dx * Presets.TILE_SIZE * 1.2;
        m_playersoy = dy * Presets.TILE_SIZE * 1.2;
        m_playerMove = collidePlayerAnim;
        m_playerMoveCallback = ()->checkBumpTrigger(m_playercx+dx, m_playercy+dy);
        Assets.sounds.sfx_door.play();
    }

    private function collidePlayerAnim(dt:Float){
        var time = m_playerTimer;

        if (time > 0.5){
            time = 1 - m_playerTimer;
        }
        
        m_playerox = m_playersox * time;
        m_playeroy = m_playersoy * time;
    }

    private function checkBumpTrigger(destx:Int, desty:Int){
        var tile = envget(destx, desty);
        if (m_level.hasBumpTrigger(destx, desty)){
            m_level.triggerBump(destx, desty);
        }
    }

    private function checkNpcBumpTrigger(npc:Npc, destx:Int, desty:Int){
        var distx = m_playercx - npc.cx;
        var disty = m_playercy - npc.cy;
        if (distx != 0 && disty == 0){
            npc.setFacing(Direction.fromDeltas(distx, disty));
        }
        npc.executeDialog(m_world, this);
    }

    public function shake(cb:Void->Void){
        m_world.setGameState(new Screenshake(m_scroller, 3, 90, 0, cb));
    }

    public function triggerTransition(midcb:Void->Void, endcb:Void->Void){
        m_world.setGameState(new Transition(0, 1, 0.5, Tween.easeOut, function(){
            haxe.Timer.delay(function(){
                m_world.popGameState();
                if (midcb != null){
                    midcb();
                }

                postUpdate(); // we update any visuals just in case

                m_world.setGameState(new Transition(1, 0, 2,  Tween.easeIn, function(){
                    m_world.popGameState();
                    if (endcb != null){
                        endcb();
                    }
                }), null, true);
            }, 200);
        }), null, false);
    }

    // ===================================================
    //                  end gameplay
    // ===================================================

    public function setTag(tag:String){
        if (!m_tags.exists(tag)){
            m_tags[tag] = true;
        }
    }

    public function removeTag(tag:String){
        m_tags.remove(tag);
    }

    public function hasTag(tag:String){
        return m_tags.exists(tag);
    }

    private inline function isFromFlagList(env:Int, flags:Array<Int>){
        return flags.indexOf(env) != -1;
    }

    private inline function envget(x:Int, y:Int){
        return m_level.getEnvId(x, y);
    }

    private function updateGame(dt:Float){
        handleInputs();
    }

    private function updatePlayerMove(dt:Float){
        var speed = 0.125;
        m_playerTimer = Math.min(m_playerTimer+speed*dt,1);
        m_playerMove(dt);

        if (m_buttonBuffer == None){
            m_buttonBuffer = getButton();
        }

        if (m_playerTimer == 1){
            m_updatefn = updateGame;
            m_playerTimer = 0;
            triggerMoveCallback();
            triggerChangeMap();
        }
    }

    private function triggerChangeMap(){
        if (m_shouldChangeMap){

            var px = 0;
            var py = 0;
            var level = m_level.getNeighborMap(m_playerdx, m_playerdy);

            if (m_playerdx == -1){
                px = level.width-1;
                py = m_playercy;
            }else if (m_playerdx == 1){
                py = m_playercy;
            }else if (m_playerdy == -1){
                py = level.height-1;
                px = m_playercx;
            }else if (m_playerdy == 1){
                px = m_playercx;
            }
            loadLevel(m_level.getNeighborMap(m_playerdx, m_playerdy), px, py);
            m_shouldChangeMap = false;
        }
    }

    private function triggerMoveCallback(){
        if (m_playerMoveCallback != null){
            m_playerMoveCallback();
        }
        m_playerMoveCallback = null;
    }

    private function handleInputs(){
        if (m_buttonBuffer == None){
            m_buttonBuffer = getButton();
        }
        doButton(m_buttonBuffer);
        m_buttonBuffer = None;
    }

    private function doButton(button:ActionType){
        if (button == None) return;
        var index = button.getIndex();
        if (index < 4){
            movePlayer(m_dirx[index], m_diry[index]);
        }
    }

    private function getButton(){
        var inputs = m_world.getInputs();
        for (action in m_act){
            if (inputs.isPressed(action)){
                return action;
            }
        }
        return ActionType.None;
    }

	override public function update(dt:Float) {
        super.update(dt);
        
        if (m_updatefn != null){
            m_updatefn(dt);
        }

        m_level.npcfn(function(npc){
            npc.update(dt);
        });
    }

	public function postUpdate() {
        var ts = Presets.TILE_SIZE;

        m_player.x = (m_playercx) * ts + m_playerox + ts * 0.5;
        m_player.y = (m_playercy) * ts + m_playeroy + ts * 0.5;
        m_player.scaleX = m_playerDir;

        m_level.npcfn(function(npc){
            npc.postUpdate();
        });

        m_scene.x = Presets.VIEWPORT_WID * 0.5 - 4 * ts * SCALE_MAP;
        m_scene.y = Presets.VIEWPORT_WID * 0.5 - 4 * ts * SCALE_MAP;

        m_scroller.ysort(LAYER_ACTORS);
    }
}
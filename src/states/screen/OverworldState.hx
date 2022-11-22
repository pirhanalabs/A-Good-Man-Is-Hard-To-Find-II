package states.screen;

import inputs.ActionType;

class OverworldState extends AbstractScreenState{

    final SCALE_MAP = 2;

    var m_scroller : h2d.Layers;

    var m_map : h2d.TileGroup;

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

    var m_buttonBuffer : ActionType = None;

    // collision detection
    // since there are more non-walkable tiles
    // than walkables, we check for walkables instead.
    var m_tilesWalkable = [0, 1, 2, 3, 4, 5, 6];
    // tiles that trigger on bumping only.
    // we check for them when bumping into an obstacle.
    // the trigger effects are applied in the callback function.
    // should think of a sexier way to do this.
    // initialized in constructor.
    var m_tilesBumpTrigger : Map<Int,Void->Void>;

    var m_envdata : Array<Int>;

    var m_updatefn : (dt:Float)->Void;
    
    public function new(){
        super();
        m_tilesBumpTrigger = [
            58 => onBumpLockedGoldDoor,
            59 => onBumpLockedGoldDoor,
            64 => onBumpSacrificialAltar, 
            65 => onBumpSacrificialAltar,
        ];

        m_envdata = [
            70, 71, 72, 73, 74, 75, 76, 77,
            80, 81, 82, 83, 84, 85, 86, 87,
            90, 91, 92, 93, 94, 95, 96, 97,
            54, 6 , 5 , 64, 65, 4 , 6 , 54,
            54, 6 , 5 , 2 , 2 , 4 , 6 , 54,
            54, 6 , 5 , 2 , 2 , 4 , 6 , 54,
            54, 6 , 5 , 2 , 2 , 4 , 6 , 54,
            54, 54, 54, 2 , 2 , 54, 54, 54,
        ];

        m_envdata[7 * 8 + 3] = 58;
        m_envdata[7 * 8 + 4] = 59;

        m_act = ActionType.createAll();

    }

	override public function onEnter(?params:Dynamic) {
        super.onEnter(params);

        m_scroller = new h2d.Layers();
        m_scene.add(m_scroller, 1);

        m_map = new h2d.TileGroup(Assets.getTileset('env'));
        m_scroller.add(m_map, 1);
        m_scroller.scale(SCALE_MAP);

        for (y in 0 ... 8){
            for (x in 0 ... 8){
                m_map.add(x * 16, y * 16, Assets.getEnvTile(m_envdata[y * 8 + x]));
            }
        }

        m_player = new h2d.Bitmap(Assets.getEntTile(0));
        m_scroller.add(m_player, 1);
        m_playercx = 3;
        m_playercy = 5;

        m_updatefn = updateGame;

        m_world.sounds.playMusic(hxd.Res.music.dev.OMIHTF_ebauche6_vst, 1);
    }

	override public function onExit() {
        super.onExit();
    }

    // ===================================================
    //                    gameplay
    // ===================================================

    private function movePlayer(dx:Int, dy:Int){
        var destx = m_playercx + dx;
        var desty = m_playercy + dy;
        var env = envget(destx, desty);
        if (isWalkable(env)){
            walkPlayer(dx, dy);
        }else{
            collidePlayer(dx, dy);
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
        if (isBumpTrigger(tile)){
            triggerBump(tile, destx, desty);
        }
    }

    private function triggerBump(tile:Int, destx:Int, desty:Int){
        var trigger = m_tilesBumpTrigger.get(tile);
        trigger();
    }

    // ===================================================
    //                  end gameplay
    // ===================================================

    private inline function isBumpTrigger(env:Int){
        return m_tilesBumpTrigger.exists(env);
    }

    private inline function isWalkable(env:Int){
        return isFromFlagList(env, m_tilesWalkable);
    }

    private inline function isFromFlagList(env:Int, flags:Array<Int>){
        return flags.indexOf(env) != -1;
    }

    private inline function envget(x:Int, y:Int){
        return m_envdata[convert(x, y)];
    }

    private inline function convert(cx:Int, cy:Int){
        return cy * 8 + cx;
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

	public function update(dt:Float) {
        if (m_updatefn != null){
            m_updatefn(dt);
        }
    }

	public function postUpdate() {
        var ts = Presets.TILE_SIZE;
        m_player.x = (m_playercx) * ts + m_playerox + ts * 0.5;
        m_player.y = (m_playercy) * ts + m_playeroy + ts * 0.5;
        m_player.scaleX = m_playerDir;

        m_scene.x = Presets.VIEWPORT_WID * 0.5 - 4 * ts * SCALE_MAP;
        m_scene.y = Presets.VIEWPORT_WID * 0.5 - 4 * ts * SCALE_MAP;
    }

    // ===================================================
    //                 event triggers
    // ===================================================

    private function shake(cb:Void->Void){
        m_world.setGameState(new Screenshake(m_scroller, 3, 90, 0, cb));
    }

    private function onBumpLockedGoldDoor(){
        shake(dialogIntroTryExitRoom);
    }

    private function onBumpSacrificialAltar(){
        shake(dialogIntroGoatGod);
    }

    // ===================================================
    //                  dialogs
    // ===================================================
    // this should be elsewhere in its own class
    // but i am lacking time to make the game and
    // throwing things where i can easily reach them

    private function dialogIntroTryExitRoom(){
        m_world.setGameState(new DialogState([
            Text('Fool!'),
            Para('The gateway is forbidden.'),
            Para('Do not escape fate.'),
            Done(null)
        ]));
    }

    private function dialogIntroGoatGod(){
        m_world.setGameState(new DialogState([
            Text('MAHHH! MAH! MAH! MAH!'),
            Para('The cycle repeats itself...'),
            Para('You have been invoked'),
            Cont('to serve as my vassal.'),
            Para('I require 13 sacrifices'),
            Cont('in the next 5 days.'),
            Para('Do.'),
            Para('Not.'),
            Para('Disappoint Me!'),
            Done(dialogIntroGoatGodDone)
        ]));
    }

    private function dialogIntroGoatGodDone(){
        shake(()->triggerTransition(function(){
            m_world.sounds.playMusic(hxd.Res.music.dev.OMIHTF_ebauche4_vst__1_);
        }, null));
    }

    private function triggerTransition(midcb:Void->Void, endcb:Void->Void){
        m_world.setGameState(new Transition(0, 1, 0.5, Tween.easeOut, function(){
            haxe.Timer.delay(function(){
                m_world.popGameState();
                if (midcb != null){
                    midcb();
                }
                m_world.setGameState(new Transition(1, 0, 2,  Tween.easeIn, function(){
                    m_world.popGameState();
                    if (endcb != null){
                        endcb();
                    }
                }), null, true);
            }, 200);
        }), null, false);
    }
}
package states.screen;

import inputs.ActionType;

class OverworldState extends AbstractScreenState{

    final SCALE_MAP = 2;

    var m_map : h2d.TileGroup;

    // directions
    var m_dirx = [-1, 1, 0, 0];
    var m_diry = [0, 0, -1, 1];
    var m_act : Array<ActionType> = [Left, Right, Up, Down];

    // player
    var m_player : h2d.Bitmap;
    // player tile position (in map coordinates)
    var m_playercx : Int = 0;
    var m_playercy : Int = 0;
    // player tile offset position (in world coordinates)
    var m_playerox : Float = 0;
    var m_playeroy : Float = 0;

    var m_updatefn : (dt:Float)->Void;
    
    public function new(){
        super();
    }

	override public function onEnter(?params:Dynamic) {
        super.onEnter(params);

        m_map = new h2d.TileGroup(Assets.getTileset('env'));
        m_scene.add(m_map, 1);
        m_scene.scale(SCALE_MAP);
        
        var envdata = [
            70, 71, 72, 73, 74, 75, 76, 77,
            80, 81, 82, 83, 84, 85, 86, 87,
            90, 91, 92, 93, 94, 95, 96, 97,
            54, 6 , 5 , 64, 65, 4 , 6 , 54,
            54, 6 , 5 , 2 , 2 , 4 , 6 , 54,
            54, 6 , 5 , 2 , 2 , 4 , 6 , 54,
            54, 6 , 5 , 2 , 2 , 4 , 6 , 54,
            54, 54, 54, 2 , 2 , 54, 54, 54,
        ];

        envdata[7 * 8 + 3] = 58;
        envdata[7 * 8 + 4] = 59;

        for (y in 0 ... 8){
            for (x in 0 ... 8){
                m_map.add(x * 16, y * 16, Assets.getEnvTile(envdata[y * 8 + x]));
            }
        }

        m_player = new h2d.Bitmap(Assets.getEntTile(0));
        m_scene.add(m_player, 1);
        m_playercx = 3;
        m_playercy = 5;

        m_updatefn = updateGame;
    }

	override public function onExit() {
        super.onExit();
    }

    

    private function updateGame(dt:Float){
        trace('hello');
        handleInputs();
    }

    private function updatePlayerMove(dt:Float){
        var speed = 2;
        if (m_playerox > 0){
            m_playerox -=  speed;
        }else if (m_playerox < 0){
            m_playerox += speed;
        }
        if (m_playeroy > 0){
            m_playeroy -= speed;
        }else if (m_playeroy < 0){
            m_playeroy += speed;
        }

        if (m_playerox == 0 && m_playeroy == 0){
            m_updatefn = updateGame;
        }
    }

    private function handleInputs(){
        var inputs = m_world.getInputs();
        // check for movement inputs
        for (i in 0 ... 4){
            if (inputs.isPressed(m_act[i])){
                var dx = m_dirx[i];
                var dy = m_diry[i];
                m_playercx += dx;
                m_playercy += dy;
                m_playerox = dx * -Presets.TILE_SIZE;
                m_playeroy = dy * -Presets.TILE_SIZE;
                m_updatefn = updatePlayerMove;
                return;
            }
        }
    }

	public function update(dt:Float) {
        if (m_updatefn != null){
            m_updatefn(dt);
        }
    }

	public function postUpdate() {
        m_player.x = (m_playercx) * Presets.TILE_SIZE + m_playerox;
        m_player.y = (m_playercy) * Presets.TILE_SIZE + m_playeroy;

        m_scene.x = Presets.VIEWPORT_WID * 0.5 - 4 * Presets.TILE_SIZE * SCALE_MAP;
        m_scene.y = Presets.VIEWPORT_WID * 0.5 - 4 * Presets.TILE_SIZE * SCALE_MAP;
    }
}
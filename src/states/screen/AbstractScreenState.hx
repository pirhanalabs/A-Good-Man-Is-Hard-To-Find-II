package states.screen;

import World.IWorld;
import states.common.IState;

abstract class AbstractScreenState implements IState{

    var m_world : IWorld;
    var m_scene : h2d.Layers;

    var ftime : Float = 0;

    public function new(){
        m_scene = new h2d.Layers();
    }

    public function setWorld(world:IWorld){
        m_world = world;
    }

    public function onEnter(?params:Dynamic){
        m_world.setScene(m_scene);
    }

    public function onResume(){
        
    }

    public function onExit(){
        m_scene.remove();
    }

    public function update(dt:Float){
        ftime += dt;
    }
}
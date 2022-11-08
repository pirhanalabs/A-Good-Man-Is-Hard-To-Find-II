package states.screen;

import World.IWorld;
import states.common.IState;

abstract class AbstractScreenState implements IState{

    var m_world : IWorld;

    public function setWorld(world:IWorld){
        m_world = world;
    }
}
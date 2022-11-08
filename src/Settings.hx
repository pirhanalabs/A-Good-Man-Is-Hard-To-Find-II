
/**
 * class responsible of storing and
 * handling general settings for the entire
 * program and not individual game saves.
 */

import World.IWorld;

class Settings{

    var m_world : IWorld;

    public function new(world:IWorld){
        m_world = world;
    }
}
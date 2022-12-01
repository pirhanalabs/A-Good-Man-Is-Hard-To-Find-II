package overworld.actors.dialogs;

import states.screen.OverworldState;
import World.IWorld;

interface IActorDialog {
    function execute(actor:Actor, world:IWorld, overworld:OverworldState):Void;
}
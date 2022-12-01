package overworld.actors.dialogs;

import states.screen.OptionMenu;
import states.screen.DialogState;
import World.IWorld;
import states.screen.OverworldState;

class FrogDialog extends DialogBase implements IActorDialog {

	override public function execute(actor:Actor, world:IWorld, overworld:OverworldState) {
        super.execute(actor, world, overworld);
        world.setGameState(new DialogState(actor.cy, [
            Text('Roger Frog:'),
            Cont('Sup.'),
            Para('I\'m just a very plain guy.'),
            Done(openOptionMenu)
        ]));
    }

    override function onOptionMenuKill() {
        if (actor.hasTag(CommonTags.INTRODUCED)){

        }else{
            
        }
    }
}
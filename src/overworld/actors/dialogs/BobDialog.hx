package overworld.actors.dialogs;

import states.screen.DialogState;
import World.IWorld;
import states.screen.OverworldState;

class BobDialog extends DialogBase {
    

    override function execute(actor:Actor, world:IWorld, overworld:OverworldState) {
        super.execute(actor, world, overworld);
        world.setGameState(new DialogState(actor.cy, [
            Text("Bob Beaver:"),
            Cont('Oiii! Mate!!'),
            Para("So goo' to see ya 'roud here!"),
            Cont("I collect blueprints eh!"),
            Para("Tryin' to learn that cookin'!"),
            Cont("It ain't no easy feat, eh?"),
            Done(openOptionMenu)
        ]));
    }

    override function onOptionMenuTalk() {
        world.setGameState(new DialogState(actor.cy, [
            Para("I ain't very far in my"),
            Cont("cookin' duties. It's hard!"),
            Para("unlike the people here,"),
            Cont("I ain't starvin'!"),
            Para("There's plenty bark here!"),
            Cont("So I try to figure"),
            Para("out that cookin' stuff"),
            Cont("for them."),
            Done(openOptionMenu)
        ]));
    }

    override function onOptionMenuFeed() {
        world.setGameState(new DialogState(actor.cy, [
            Para("Y'all, I ain't starvin'."),
            Cont("Plenty Bark 'round here"),
            Para("to gnaw on! Want some?"),
            Done(openOptionMenu)
        ]));
    }

    override function onOptionMenuKill() {
        world.setGameState(new DialogState(actor.cy, [
            Para("Not sure what you're doin'"),
            Cont("But I ain't sure Imma like it."),
            Done(menuMurderAnyway)
        ]));
    }
}
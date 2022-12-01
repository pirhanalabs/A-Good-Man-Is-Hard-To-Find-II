package overworld.actors.dialogs;

import states.screen.DialogState;
import World.IWorld;
import states.screen.OverworldState;

class SeleDialog extends DialogBase{
    
    public function new(){
        super();
    }

    override function execute(actor:Actor, world:IWorld, overworld:OverworldState) {
        super.execute(actor, world, overworld);
        world.setGameState(new DialogState(actor.cy, [
            Text("Sele Rat:"),
            Cont("Hey there."),
            Para("Just a warning."),
            Cont("People say I'm too"),
            Para("direct. I think of it"),
            Cont("as care and kindness."),
            Para("Don't go crying on me."),
            Done(openOptionMenu)
        ]));
    }

    override function onOptionMenuTalk() {
        world.setGameState(new DialogState(actor.cy, [
            Para("I'm really starving for"),
            Cont("something with sugar."),
            Para("I actually quite like honey."),
            Cont("It gives me lots of energy."),
            Para("Now go. You're annoying."),
            Cont("I'm working."),
            Done(openOptionMenu)
        ]));
    }

    override function onOptionMenuFeed() {
        if (world.inventory.has(Inventory.Items.HONEY)){
            actor.setTag(CommonTags.READY_TO_DIE);
            world.setGameState(new DialogState(actor.cy, [
                Para("Thanks."),
                Para("That helps with the"),
                Cont("growling my tummy's been."),
                Para("the culprit of. Others thought"),
                Cont("there were monsters around."),
                Done(openOptionMenu)
            ]));
        }else{
            world.setGameState(new DialogState(actor.cy, [
                Para("Got any honey?"),
                Cont("No? Well go find it."),
                Para("That's why you're here right?"),
                Done(openOptionMenu)
            ]));
        }
    }

    override function onOptionMenuKill() {
        if(actor.hasTag(CommonTags.READY_TO_DIE)){
            if(Npc.get(Npc.SABE).hasTag(CommonTags.DEAD)){
                world.setGameState(new DialogState(actor.cy, [
                    Para("My Wife Sabe is dead..."),
                    Cont("I think I'll stay here"),
                    Para("and take care of her grave."),
                    Para("otherwise, no one will."),
                    Done(openOptionMenu)
                ]));
            }else{
                world.setGameState(new DialogState(actor.cy, [
                    Para("Yeah... I guess you can."),
                    Para("I dunno what's up with cooks"),
                    Cont("and the constant killing needs."),
                    Done(menuMurderAnyway)
                ]));
            }
        }else{
            world.setGameState(new DialogState(actor.cy, [
                Para("Why would you kill me?"),
                Para("Are you crazy or what?"),
                Done(openOptionMenu)
            ]));
        }
    }
}
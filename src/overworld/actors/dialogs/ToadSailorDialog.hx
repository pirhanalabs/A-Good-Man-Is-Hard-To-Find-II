package overworld.actors.dialogs;

import states.screen.DialogState;
import World.IWorld;
import states.screen.OverworldState;

class ToadSailorDialog extends DialogBase {
    
    override function execute(actor:Actor, world:IWorld, overworld:OverworldState) {
        super.execute(actor, world, overworld);
        world.setGameState(new DialogState(actor.cy, [
            Text('Terry Toad Sailor:'),
            Cont('Uwwwaaaaaaa!!'),
            Para("I got lost in the river!"),
            Cont("I just wanted to give"),
            Para("my brother a gift for"),
            Cont("his birthday! But I"),
            Para("broke my legs on the"),
            Cont("hard path! Uwaaaaa!"),
            Done(openOptionMenu)
        ]));
    }

    override function onOptionMenuTalk() {
        if (!world.inventory.has(Inventory.Items.CRACKERS)){
            world.inventory.add(Inventory.Items.CRACKERS);
            world.setGameState(new DialogState(actor.cy, [
                Para('I saw a golden key'),
                Cont('in the odd fountain.'),
                Para("But I was looking for"),
                Cont("a snack for my brother."),
                Para("Then I got here and"),
                Cont("found those on the ground:"),
                Para("* Terry gives you"),
                Cont("PLAIN CRACKERS *"),
                Para("* Terry gives you"),
                Cont("PLAIN CRACKERS *"),
                Para("Would you give them"),
                Cont("to my brother please?"),
                Done(openOptionMenu)
            ]));
        }else{
            world.setGameState(new DialogState(actor.cy, [
                Para('It would mean the '),
                Cont('world to me if you'),
                Para("would give the crackers"),
                Cont("to my brother..."),
                Para("I know you have a good"),
                Cont("heart. Thank you."),
                Done(openOptionMenu)
            ]));
        }
    }

    override function onOptionMenuFeed() {
        world.setGameState(new DialogState(actor.cy, [
            Para('I found very bad crackers.'),
            Cont("I don't think I will need"),
            Para("them anymore..."),
            Cont("I can't move with"),
            Para("broken legs. It kinda"),
            Cont("cut my appetite..."),
            Done(openOptionMenu)
        ]));
    }

    override function onOptionMenuKill() {
        world.setGameState(new DialogState(actor.cy, [
            Para('My brother wants to see'),
            Cont("me that much?"),
            Para("Then could you carry me"),
            Cont("to him please?"),
            Done(menuMurderAnyway)
        ]));
    }
}
package overworld.actors.dialogs;

import states.screen.DialogState;
import World.IWorld;
import states.screen.OverworldState;

class CrabSailorDialog extends DialogBase {
    
    override function execute(actor:Actor, world:IWorld, overworld:OverworldState) {
        super.execute(actor, world, overworld);
        world.setGameState(new DialogState(actor.cy, [
            Text("Carl Crab Sailor:"),
            Cont('Sob... sob...'),
            Done(openOptionMenu)
        ]));
    }

    var introed = false;
    var givenpaper = false;

    override function onOptionMenuTalk() {
        
        if ((!world.inventory.has(Inventory.Items.BLUEPRINT_PAPER)) && !givenpaper){
            introed = true;
            world.setGameState(new DialogState(actor.cy, [
                Para("My brother... I've lost him!"),
                Cont("I don't know where he is..."),
                Para("I'm so sad... sob... sob..."),
                Cont("Do you have any paper "),
                Para("that I can use to wipe"),
                Cont("my tears out? sob..."),
                Done(openOptionMenu)
            ]));
        }else if (!givenpaper){
            givenpaper = true;
            world.inventory.remove(Inventory.Items.BLUEPRINT_PAPER);
            overworld.setTag(CommonTags.WATER_WALKING);
            overworld.checkWaterWalking();
            world.setGameState(new DialogState(actor.cy, [
                Para("My brother... I've lost him!"),
                Cont("I don't know where he is..."),
                Para("I'm so sad... sob... sob..."),
                Cont("Do you have any paper "),
                Para("that I can use to wipe"),
                Cont("my tears out? sob..."),
                Para("* You give blueprint"),
                Cont("paper to carl. *"),
                Para("Thank you... sob..."),
                Cont("Here's a gift for you."),
                Para("* You can now walk"),
                Cont("on water. *"),
                Para("Find my brother please..."),
                Done(openOptionMenu)
            ]));
            
        }else{
            world.setGameState(new DialogState(actor.cy, [
                Para("My brother... I've lost him!"),
                Cont("I don't know where he is..."),
                Para("I'm so sad... sob... sob..."),
                Done(openOptionMenu)
            ]));
        }
        
    }

    override function onOptionMenuFeed() {
        world.setGameState(new DialogState(actor.cy, [
            Para("I'm not hungry right now..."),
            Cont("I want my brother!"),
            Done(openOptionMenu)
        ]));
    }

    override function onOptionMenuKill() {
        if (Npc.get(Npc.SAILOR_TOAD).hasTag(CommonTags.DEAD)){
            world.setGameState(new DialogState(actor.cy, [
                Para("Now that you found"),
                Cont("my brother..."),
                Done(menuMurderAnyway)
            ]));
        }else{
            world.setGameState(new DialogState(actor.cy, [
                Para("I'll let you do that if you"),
                Cont("find my brother, promise!"),
                Done(openOptionMenu)
            ]));
        }
    }
}
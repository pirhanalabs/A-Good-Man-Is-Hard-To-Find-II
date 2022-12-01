package overworld.actors.dialogs;

import states.screen.OptionMenu;
import states.screen.DialogState;
import World.IWorld;
import states.screen.OverworldState;

class FishermoleDialog extends DialogBase {

    var mushAmount = 0;
    var mushMax = 6;
    
    public function new(){
        super();
    }

    override function execute(actor:Actor, world:IWorld, overworld:OverworldState) {
        super.execute(actor, world, overworld);

        world.setGameState(new DialogState(actor.cy, [
            Text('Finn Fishermole:'),
            Cont('Hey! You\'re the new cook!'),
            Para("I can't see for sure, since"),
            Cont("I'm a mole and I'm blind!"),
            Para("I'm so FUNNY!"),
            Done(openOptionMenu)
        ]));
    }

    private function openYesNoFishing(){
        world.setGameState(new OptionMenu(actor, [
            {label: "Yes", callback: onFishingYes},
            {label: "No", callback: onFishingNo},
            {label: "Insult", callback: onFishingInsult}
        ]));
    }

    private function onFishingYes(){
        overworld.setTag(CommonTags.FISHING_ROD);
        world.setGameState(new DialogState(actor.cy, [
            Para("You see those white blobs"),
            Cont('inside the water?'),
            Para("This is a fish! Like me, they hide"),
            Cont("in their hole and don't come out"),
            Para("unless it is time to fill their"),
            Cont("life purpose! I'm a fish mole!"),
            Para("I'm so FUNNY!"),
            Para("Bump into them and you will get"),
            Cont("a fish! Beware though, not all"),
            Para("water blobs will give the same"),
            Cont("type of fish!"),
            Done(openOptionMenu)
        ]));
    }

    private function onFishingNo(){
        world.setGameState(new DialogState(actor.cy, [
            Para("You cannot say no, after all,"),
            Para("I'm not a NOle, but a MOle!"),
            Cont("I'm so FUNNY!"),
            Done(openOptionMenu)
        ]));
    }

    private function onFishingInsult(){
        world.setGameState(new DialogState(actor.cy, [
            Para("Great insult, you f-fun person!"),
            Para("Let me write it in my notes"),
            Cont("so I can look at it again."),
            Para("Just kidding! I'm blind!"),
            Para("I'm so FUNNY!"),
            Done(openOptionMenu)
        ]));
    }

    override function onOptionMenuTalk() {
        if (overworld.hasTag(CommonTags.FISHING_ROD)){
            world.setGameState(new DialogState(actor.cy, [
                Para("Even if I am blind and"),
                Cont('live underground, I still'),
                Para("want to become the best"),
                Cont("fishermole that I can be."),
                Para("Being born with lesser luck"),
                Cont("doesn't mean it's impossible!"),
                Para("Better keep smiling, joking and"),
                Cont("most important,"),
                Para("doing your best!"),
                Done(openOptionMenu)
            ]));
        }else{
            world.setGameState(new DialogState(actor.cy, [
                Para("I'm the fisherman here."),
                Cont('But I prefer fisherMOLE!'),
                Para("I'm so FUNNY!"),
                // Para("Do you want to learn"),
                // Cont("how to catch a fish?"),
                Done(openOptionMenu)
            ]));
        }
    }

    override function onOptionMenuFeed() {
        if (world.inventory.has(Inventory.Items.BROWN_MUSHROOM)){
            world.inventory.remove(Inventory.Items.BROWN_MUSHROOM);
            mushAmount++;
            if (mushAmount == mushMax){
                actor.setTag(CommonTags.READY_TO_DIE);
                world.setGameState(new DialogState(actor.cy, [
                    Para("Nom! Mushrooms!"),
                    Cont("So delicious!"),
                    Para("*You give Finn a Mushroom*"),
                    Para("I'm happy."),
                    Done(openOptionMenu)
                ]));
            }else{
                world.setGameState(new DialogState(actor.cy, [
                    Para("Nom! Mushrooms!"),
                    Cont("So delicious!"),
                    Para("*You give Finn a Mushroom*"),
                    Para("To be truly happy, I would"),
                    Cont("like " + (mushMax - mushAmount) + " mushrooms!"),
                    Done(openOptionMenu)
                ]));
            }
            
        }else if (world.inventory.has(Inventory.Items.RED_MUSHROOM)){
            world.inventory.remove(Inventory.Items.RED_MUSHROOM);
            mushAmount++;
            if (mushAmount == mushMax){
                actor.setTag(CommonTags.READY_TO_DIE);
                world.setGameState(new DialogState(actor.cy, [
                    Para("Nom! Mushrooms!"),
                    Cont("So delicious!"),
                    Para("*You give Finn a Mushroom*"),
                    Para("I'm happy."),
                    Done(openOptionMenu)
                ]));
            }else{
                world.setGameState(new DialogState(actor.cy, [
                    Para("Nom! Mushrooms!"),
                    Cont("So delicious!"),
                    Para("*You give Finn a Mushroom*"),
                    Para("To be truly happy, I would"),
                    Cont("like " + (mushMax - mushAmount) + " mushrooms!"),
                    Done(openOptionMenu)
                ]));
            }
        }else{
            world.setGameState(new DialogState(actor.cy, [
                Para("Even if I am a fishermole,"),
                Cont("I actually do not eat fish."),
                Para("I don't really SEA the"),
                Cont("the point, you know."),
                Para("I'm so FUNNY!"),
                Para("However, I am a big fan of"),
                Cont("mushrooms. So delicious!"),
                Done(openOptionMenu)
            ]));
        }
        
    }

    override function onOptionMenuKill() {
        if (actor.hasTag(CommonTags.READY_TO_DIE)){
            world.setGameState(new DialogState(actor.cy, [
                Para("I'm feeling quite happy"),
                Cont("with all the mushrooms."),
                Done(menuMurderAnyway)
            ]));
        }else{
            world.setGameState(new DialogState(actor.cy, [
                Para("Why would you hunt me?"),
                Cont("I'm no fish. I am a..."),
                Para("FISHermole! Haha!"),
                Para("I'm so FUNNY!"),
                Done(openOptionMenu)
            ]));
        }
        
    }
}
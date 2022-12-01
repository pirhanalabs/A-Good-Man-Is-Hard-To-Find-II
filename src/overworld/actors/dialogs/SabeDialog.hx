package overworld.actors.dialogs;

import states.screen.DialogState;
import World.IWorld;
import states.screen.OverworldState;

class SabeDialog extends DialogBase {
    
    public function new(){
        super();
    }

    override function execute(actor:Actor, world:IWorld, overworld:OverworldState) {
        super.execute(actor, world, overworld);
        world.setGameState(new DialogState(actor.cy, [
            Text("Sabe Rat:"),
            Cont('Uhmm... Hi.'),
            Para("I'm a little shy, you see..."),
            Done(openOptionMenu)
        ]));
    }

    override function onOptionMenuTalk() {
        if (overworld.hasTag(CommonTags.HOE)){
            world.setGameState(new DialogState(actor.cy, [
                Para("It's so beautiful..."),
                Para("Uhh???"),
                Para("I'm not talking about you"),
                Cont("dummy! You're making me shy!"),
                Para("And I'm married, too..."),
                Cont("He works in the graveyard."),
                Para("He's always so busy..."),
                Para("I'm sorry! I'm rambling!"),
                Done(openOptionMenu)
            ]));
        }else{
            overworld.setTag(CommonTags.HOE);
            world.setGameState(new DialogState(actor.cy, [
                Para("Uhm you don't like"),
                Cont("spices, don't you?"),
                Para("Because I love spices!"),
                Cont("They're wonderful..."),
                Para("I dream one day to get the"),
                Cont("very rare golden spice..."),
                Para("It's right there, on the"),
                Cont("other side of the trees."),
                Para("I'm not good enough to get"),
                Cont("there on my own..."),
                Para("Maybe you could help me?"),
                Cont("Here. I'll give you my hoe."),
                Para("* You got a HOE! *"),
                Para("It allows you to harvest"),
                Cont("both spices and wheat!"),
                Para("Take good care of it please."),
                Done(openOptionMenu)
            ]));
        }
        
    }

    override function onOptionMenuFeed() {
        if (world.inventory.has(Inventory.Items.GOLD_SPICE)){
            actor.setTag(CommonTags.READY_TO_DIE);
            world.setGameState(new DialogState(actor.cy, [
                Para("Uhh???"),
                Para("You got it??"),
                Cont("And you're giving it to me?!"),
                Para("Thank you!!"),
                Para("* You give the GOLDEN SPICE"),
                Para("to Sabe *"),
                Done(openOptionMenu)
            ]));
        }else{
            world.setGameState(new DialogState(actor.cy, [
                Para("Do you have golden spice"),
                Cont("by any chance?"),
                Done(openOptionMenu)
            ]));
        }
    }

    override function onOptionMenuKill() {
        if (actor.hasTag(CommonTags.READY_TO_DIE)){
            world.setGameState(new DialogState(actor.cy, [
                Para("Well..."),
                Para("You've been so kind"),
                Cont("to me and all..."),
                Para("I can't say no."),
                Done(menuMurderAnyway)
            ]));
        }else{
            world.setGameState(new DialogState(actor.cy, [
                Para("Oh My God!"),
                Cont('I am so sorry...'),
                Para("I will have to turn down"),
                Cont('Your wonderful offer...'),
                Para("I'm not ready yet. I have"),
                Cont('not even accomplished my'),
                Para("dream! If only I could"),
                Cont('reach it... aww...'),
                Para("I'm so sad now."),
                Para("Oh sorry! I didn't mean to"),
                Cont('talk about my feelings...'),
                Done(openOptionMenu)
            ]));
        }
        
    }
}
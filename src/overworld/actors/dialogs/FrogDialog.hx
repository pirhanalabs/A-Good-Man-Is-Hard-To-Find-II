package overworld.actors.dialogs;

import states.screen.OptionMenu;
import states.screen.DialogState;
import World.IWorld;
import states.screen.OverworldState;

class FrogDialog extends DialogBase implements IActorDialog {

	override public function execute(actor:Actor, world:IWorld, overworld:OverworldState) {
        super.execute(actor, world, overworld);

        if (actor.hasTag('asked_kill')){
            world.setGameState(new DialogState(actor.cy, [
                Text('Roger Frog:'),
                Cont('Hey.'),
                Para('If I die, I bet my family'),
                Cont('would miss me dearly.'),
                Para('...'),
                Para("I'm just kidding."),
                Para("I don't have a family."),
                Done(openOptionMenu)
            ]));
        }else{
            world.setGameState(new DialogState(actor.cy, [
                Text('Roger Frog:'),
                Cont('Sup.'),
                Para('I\'m just a very plain guy.'),
                Done(openOptionMenu)
            ]));
        }
    }

    override function onOptionMenuTalk() {
        actor.setTag(CommonTags.INTRODUCED);
        world.setGameState(new DialogState(actor.cy, [
            Para("People here never learned"),
            Cont('how to do kitchen work.'),
            Para("Our last chef vanished"),
            Cont("mysteriously. He kept"),
            Para("spouting plain nonsense."),
            Para("Talked about some god or"),
            Cont("something like that and"),
            Para("how we all need to be"),
            Cont("sacrificed."),
            Para("He also said we needed"),
            Cont("to be fed and happy."),
            Para("Weird uh?"),
            Done(openOptionMenu)
        ]));
    }

    override function onOptionMenuFeed() {
        if (!world.inventory.has(Inventory.Items.CRACKERS)){
            world.setGameState(new DialogState(actor.cy, [
                Para("I am so hungry. I did"),
                Cont('not eat in forever.'),
                Para("I would die to eat some"),
                Cont("good old crackers."),
                Para("Plain, of course. I don't"),
                Cont("like things with flavour."),
                Done(openOptionMenu)
            ]));
        }else{
            world.inventory.remove(Inventory.Items.CRACKERS);
            actor.setTag(CommonTags.READY_TO_DIE);
            world.setGameState(new DialogState(actor.cy, [
                Para("I am so hungry. I did"),
                Cont('not eat in forever.'),
                Para("You got crackers? Nice!"),
                Para("* You give the crackers"),
                Cont("to Roger Frog *"),
                Done(openOptionMenu)
            ]));
        }
    }

    override function onOptionMenuShop() {
        world.setGameState(new DialogState(actor.cy, [
            Para("I have nothing to sell."),
            Cont('My flat only has a bed.'),
            Para("Maybe I can scratch your"),
            Cont("buying itch with some intel?"),
            Done(openOptionMenu)
        ]));
    }

    override function onOptionMenuKill() {
        actor.setTag('asked_kill');
        if (actor.hasTag(CommonTags.READY_TO_DIE)){
            world.setGameState(new DialogState(actor.cy, [
                Para("Fiiinneee."),
                Para('But do it quickly.'),
                Done(menuMurderAnyway)
            ]));
        }
        else if (actor.hasTag(CommonTags.INTRODUCED)){
            world.setGameState(new DialogState(actor.cy, [
                Para("You don't need to kill me."),
                Para('I will die starving anyway.'),
                Para("Bring me some crackers and"),
                Cont("I will let you do that."),
                Para("I have nothing to live for"),
                Cont("anyway, I'm so plain."),
                Done(openOptionMenu)
            ]));
        }else{
            world.setGameState(new DialogState(actor.cy, [
                Para("I don't feel like"),
                Cont('being murdered today.'),
                Para("But maybe we can talk first"),
                Cont("and see where it takes us?"),
                Done(openOptionMenu)
            ]));
        }
    }
}
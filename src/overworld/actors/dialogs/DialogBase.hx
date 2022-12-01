package overworld.actors.dialogs;

import states.screen.DialogState;
import states.screen.OptionMenu;
import states.screen.OverworldState;
import World.IWorld;

class DialogBase implements IActorDialog{

    var actor : Actor;
    var world : IWorld;
    var overworld : OverworldState;

    public function new(){

    }

    private function openOptionMenu(){
        world.setGameState(new OptionMenu(actor, [
            {label: "Talk", callback: onOptionMenuTalk},
            {label: "Feed", callback: onOptionMenuFeed},
            // {label: "Shop", callback: onOptionMenuShop},
            {label: "Kill", callback: onOptionMenuKill},
            {label: "Exit", callback: onOptionMenuExit},
        ]));
    }

    private function menuMurderAnyway(){
        world.setGameState(new OptionMenu(actor, [
            {label: "Murder.", callback: onMurder},
            {label: "Later :)", callback: openOptionMenu},
        ]));
    }

    private function onMurder(){
        var dialog = [
            Para("*You Killed "),
            Cont(actor.name + "*"),
        ];
        var npc:Npc = cast actor;
        if (npc != null){
            dialog.push(Para("You keep a souvenir: * Got"));
            dialog.push(Cont("1 " + npc.killReward + " *"));
            world.inventory.add(npc.killReward);
        }
        dialog.push(Done(null));
        actor.setTag(CommonTags.DEAD);
        world.setGameState(new DialogState(actor.cy, dialog));
    }

    private function onOptionMenuTalk(){

    }

    private function onOptionMenuFeed(){

    }

    private function onOptionMenuShop(){

    }

    private function onOptionMenuKill(){

    }

    private function onOptionMenuExit(){

    }
    

	public function execute(actor:Actor, world:IWorld, overworld:OverworldState) {
        this.actor = actor;
        this.world = world;
        this.overworld = overworld;
    }
}
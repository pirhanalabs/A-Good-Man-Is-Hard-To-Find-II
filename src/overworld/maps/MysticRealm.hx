package overworld.maps;

import states.screen.DialogState;
import states.screen.Transition;

class MysticRealm extends Level{
    
    override function init() {
        super.init();

        this.id = "mystic_realm";
        this.name = "Mystic Realm";

        this.width = 8;
        this.height = 8;

        this.env = [
            70, 71, 72, 73, 74, 75, 76, 77,
            80, 81, 82, 83, 84, 85, 86, 87,
            90, 91, 92, 93, 94, 95, 96, 97,
            54, 6 , 5 , 64, 65, 4 , 6 , 54,
            54, 6 , 5 , 2 , 2 , 4 , 6 , 54,
            54, 6 , 5 , 2 , 2 , 4 , 6 , 54,
            54, 6 , 5 , 2 , 2 , 4 , 6 , 54,
            54, 54, 54, 2 , 2 , 54, 54, 54,
        ];
    }

    override function onEnter(){
        super.onEnter();

        this.bumpTriggers = [];

        if (overworld.hasTag('intro')){
            env[convert(3, 7)] = 58;
            env[convert(4, 7)] = 59;
            bumpTriggers[convert(3, 7)] = onBump_Intro_LockedGoldDoor;
            bumpTriggers[convert(4, 7)] = onBump_Intro_LockedGoldDoor;
            bumpTriggers[convert(3, 3)] = onBump_Intro_SacrificialAltar; 
            bumpTriggers[convert(4, 3)] = onBump_Intro_SacrificialAltar; 
        }else{
            env[convert(3, 7)] = 2;
            env[convert(4, 7)] = 2;
        }
    }

    private function dialogIntroTryExitRoom(){
        world.setGameState(new DialogState([
            Text('Fool!'),
            Para('The gateway is forbidden.'),
            Para('Do not escape fate.'),
            Done(null)
        ]));
    }

    private function dialogIntroGoatGod(){
        world.setGameState(new DialogState([
            Text('MAHHH! MAH! MAH! MAH!'),
            Para('The cycle repeats itself...'),
            Para('You have been invoked'),
            Cont('to serve as my vassal.'),
            Para('I require 13 sacrifices'),
            Cont('in the next 5 days.'),
            Para('Do.'),
            Para('Not.'),
            Para('Disappoint Me!'),
            Done(dialogIntroGoatGodDone)
        ]));
    }

    private function onBump_Intro_LockedGoldDoor(){
        overworld.shake(dialogIntroTryExitRoom);
    }

    private function onBump_Intro_SacrificialAltar(){
        overworld.shake(dialogIntroGoatGod);
    }

    private function dialogIntroGoatGodDone(){
        overworld.shake(()->overworld.triggerTransition(function(){
            overworld.loadLevel(manager.getById('home'), 4, 4, true);
            world.sounds.playMusic(hxd.Res.music.dev.OMIHTF_ebauche4_vst__1_);
        }, null));
    }
}
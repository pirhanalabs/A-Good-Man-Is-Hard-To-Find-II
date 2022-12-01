package overworld.maps;

import states.screen.MainMenu;
import overworld.actors.CommonTags;
import overworld.actors.Npc;
import states.screen.DialogState;

class Map_3_1 extends Level{

    public static final ID = "mystic_realm";
    
    override function init() {
        super.init();

        this.id = Map_3_1.ID;
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

        if (overworld.hasTag('intro')){
            env[convert(3, 7)] = 58;
            env[convert(4, 7)] = 59;
            bumpTriggers[convert(3, 7)] = onBump_Intro_LockedGoldDoor;
            bumpTriggers[convert(4, 7)] = onBump_Intro_LockedGoldDoor;
            bumpTriggers[convert(3, 3)] = onBump_Intro_SacrificialAltar; 
            bumpTriggers[convert(4, 3)] = onBump_Intro_SacrificialAltar; 
        }else{
            env[convert(3, 7)] = 0;
            env[convert(4, 7)] = 0;
            bumpTriggers[convert(3, 3)] = onBump_SacrificialAltar; 
            bumpTriggers[convert(4, 3)] = onBump_SacrificialAltar;
        }

        world.sounds.playMusic(Assets.sounds.music_sacrifice, 1, 100);
    }

    private function dialogIntroTryExitRoom(index){
        world.sounds.stopOverlayLoop();
        world.setGameState(new DialogState(getY(index), [
            Text('???:'),
            Cont('Fool!'),
            Para('The gateway is forbidden.'),
            Para('Do not escape fate.'),
            Done(null)
        ], Assets.sounds.ambiant_dialog_god));
    }

    private function dialogIntroGoatGod(index){
        world.sounds.stopOverlayLoop();

        var num = 0;
        for (id=>npc in Npc.ALL){
            num++;
        }
        world.setGameState(new DialogState(getY(index), [
            Text('???:'),
            Cont('MAHHH! MAH! MAH! MAH!'),
            Para('The cycle repeat itself...'),
            Para('You have been invoked'),
            Cont('to serve as my vassal.'),
            Para('I require ${num} sacrifices.'),
            Cont('Happy, well fed, sacrifices.'),
            Para('I will accept nothing less!'),
            Para('Do.'),
            Para('Not.'),
            Para('Disappoint Me!'),
            Done(dialogIntroGoatGodDone)
        ], Assets.sounds.ambiant_dialog_god));
    }

    private function onBump_Intro_LockedGoldDoor(index){
        overworld.shake(()->dialogIntroTryExitRoom(index));
        world.sounds.playOverlayLoop(Assets.sounds.ambiant_dialog_shake);
    }

    private function onBump_Intro_SacrificialAltar(index){
        world.sounds.playOverlayLoop(Assets.sounds.ambiant_dialog_shake);
        overworld.shake(()->dialogIntroGoatGod(index));
    }

    private function onBump_SacrificialAltar(index){
        world.sounds.playOverlayLoop(Assets.sounds.ambiant_dialog_shake);
        overworld.shake(()->dialogGoatGod(index));
    }

    private function dialogIntroGoatGodDone(){
        overworld.removeTag("intro");
        world.sounds.playOverlayLoop(Assets.sounds.ambiant_dialog_shake);
        overworld.shake(function(){
            world.sounds.stopOverlayLoop();
            overworld.triggerTransition(function(){
                overworld.loadLevel(manager.getById('kitchen'), 4, 4, true);
            }, null);
        });
    }

    private function dialogGoatGod(index){
        world.sounds.stopOverlayLoop();
        var all = true;

        for (id=>npc in Npc.ALL){
            if (!npc.hasTag(CommonTags.DEAD)){
                all = false;
                break;
            }
        }

        if (all){
            world.setGameState(new DialogState(getY(index), [
                Text('God:'),
                Cont('You.... You!!!'),
                Para('You did it!'),
                Para('Congratulation, vassal.'),
                Cont('As a thank you, I shall'),
                Para('Let you live here, alone,'),
                Para('forever.'),
                Para('Farewell,'),
                Para('Vassal forgotten by'),
                Cont('the world.'),
                Done(null)
            ], Assets.sounds.ambiant_dialog_god));
        }else{
            world.setGameState(new DialogState(getY(index), [
                Text('God:'),
                Cont('You.... You!!!'),
                Para('You did NOT bring them.'),
                Para('I NEED them ALL!!'),
                Cont('You shall be erased...'),
                Para('A new vassal will take'),
                Cont('your place.'),
                Para('Farewell,'),
                Para('Vassal forgotten by'),
                Cont('the world.'),
                Done(dialogGoatGodDone)
            ], Assets.sounds.ambiant_dialog_god));
        }
        
    }

    private function dialogGoatGodDone(){
        world.sounds.playOverlayLoop(Assets.sounds.ambiant_dialog_shake);
        overworld.shake(function(){
            world.sounds.stopOverlayLoop();
            world.popGameState();
            world.setGameState(new MainMenu());
        });
    }
}
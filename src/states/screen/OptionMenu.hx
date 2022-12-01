package states.screen;

import overworld.actors.Actor;

typedef OptionMenuItem = {
    label : String,
    callback : ()->Void
}

class OptionMenu extends AbstractScreenState{

    var options : Array<OptionMenuItem>;
    var labels : Array<h2d.Text> = [];
    var selection : h2d.Bitmap;
    var selectionIndex : Int = 0;

    var container : h2d.Object;
    var actor : Actor;

    public function new(actor:Actor, options:Array<OptionMenuItem>){
        super();

        this.actor = actor;

        var width = 100;
        var height = 100;

        this.options = options;

        container = new h2d.Object(m_scene);

        var background = new h2d.ScaleGrid(Assets.getMisc('bg_menubox'), 8, 8, 8, 8, container);
        background.width = width;
        

        this.selection = new h2d.Bitmap(h2d.Tile.fromColor(0xb2b2b2, width - 6, 6), container);
        selection.x = 3;
        selection.y = 12 + selectionIndex * (Assets.font_reg.lineHeight);

        for (i in 0 ... options.length){
            var item = options[i];
            var label = new h2d.Text(Assets.font_reg, container);
            label.text = item.label;
            label.textColor = 0x000000;
            label.x = 8;
            label.y = 8 + i * label.font.lineHeight;
            labels.push(label);
        }

        background.height = options.length * Assets.font_reg.lineHeight + 16;
    }

    override function onEnter(?params:Dynamic) {
        super.onEnter(params);
    }

    private function handleInputs(dt:Float){
        var inputs = m_world.getInputs();
        if (inputs.isPressed(Down)){
            selectionIndex = hxd.Math.imin(options.length-1, selectionIndex+1);
            ftime = 0;
        }else if (inputs.isPressed(Up)){
            selectionIndex = hxd.Math.imax(0, selectionIndex-1);
            ftime = 0;
        }else if (inputs.isPressed(Interact)){
            m_world.popGameState();
            options[selectionIndex].callback();
        }
    }

	override public function update(dt:Float) {
        super.update(dt);
        handleInputs(dt);
    }

	public function postUpdate() {
        selection.x = 3;

        var dest = 12 + selectionIndex * (Assets.font_reg.lineHeight);

        if (selection.y != dest){
            selection.y += (dest - selection.y) * 0.45;
        }
        

        for (label in labels){
            if (label == labels[selectionIndex]){
                label.x = 8 + Tween.lerp(0, 7, Tween.spikeEaseOut((ftime % 30)/30));
            }else{
                dest = 8;
                if (label.x != dest){
                    label.x += (dest - label.x) * 0.45;
                }
            }
        }

        // if we are higher than half the screen
        // draw the menu at the top of the screen
        // else draw it at the bottom
        if (actor.cy > 5){
            this.container.y = 0;
        }else{
            this.container.y = Presets.VIEWPORT_HEI - this.container.getSize().height;
        }
        this.container.x = Presets.VIEWPORT_WID - this.container.getSize().width;
    }
}
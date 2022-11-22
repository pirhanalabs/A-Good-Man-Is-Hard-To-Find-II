package states.screen;

import h2d.Graphics;

enum DialogOption{
    
    /**
     * same as line.
     */
    Text(text:String);
    /**
     * normal line break
     */
    Line(text:String);
    /**
     * erases all text in the textbox.
     * similar to a double line break.
     */
    Para(text:String);

    /**
     * normal line break
     */
    Cont(text:String);

    /**
     * Signal when we should close the dialog box.
     * triggers a potential callback.
     */
    Done(callback:Void->Void);
}

class DialogState extends AbstractScreenState{

    var m_dialog : Array<DialogOption>;

    var m_line  : h2d.Text;
    var m_lineText : String = '';
    var m_lineX : Float;
    var m_lineY : Float;

    var m_cont  : h2d.Text;
    var m_contText : String = '';
    var m_contX : Float;
    var m_contY : Float;

    var m_cont2  : h2d.Text;
    var m_cont2Text : String = '';
    var m_cont2X : Float;
    var m_cont2Y : Float;

    var m_markerX : Int = 0;
    var m_markerY : Int = 0;
    var m_marker : h2d.Object;

    var m_time : Float = 0;

    var m_progress = 0.0;
    var m_progressMax : Float = 2;

    var m_target : h2d.Text;
    var m_lineIndex : Int;
    var m_currDialog : String;
    var m_text : String;
    var m_index : Int = 0;

    var m_allowContinue = false;
    var m_allowSkip = false;

    var m_skipTimer = 0.;
    var m_skipTimeMax = 60.0;

    public function new(dialog:Array<DialogOption>){
        super();
        m_dialog = dialog;
    }
    
    override function onEnter(?params:Dynamic) {
        super.onEnter(params);

        var box = new h2d.ScaleGrid(Assets.getMisc('bg_dialog'), 12, 6, 12 ,6);
        box.width = Presets.VIEWPORT_WID / 2;
        box.height = 30;
        box.scale(2);
        box.y = Presets.VIEWPORT_HEI - box.height * 2;
        m_scene.add(box, 1 );

        m_line = new h2d.Text(Assets.font_reg);
        m_line.text = 'You cannot escape your fate.';
        m_lineX = 30;
        m_lineY = box.y + 10;
        m_line.textColor = 0x000000;
        m_scene.add(m_line, 1);

        m_cont = new h2d.Text(Assets.font_reg);
        m_cont.text = '';
        m_contX = 30;
        m_contY = box.y + 25;
        m_cont.textColor = 0x000000;
        m_scene.add(m_cont, 1);

        var marker = new h2d.Bitmap(Assets.getMisc('dialog_marker'));
        m_markerX = 230;
        m_markerY = Math.floor(box.y + 48);
        m_marker = marker;
        m_scene.add(marker, 1);

        progress();
    }

    override function onExit() {
        super.onExit();
    }

    private function progress(){
        m_index = 0;
        m_text = "";
        m_progress = 0;
        m_allowSkip = true;
        m_allowContinue = false;
        switch(m_dialog[m_lineIndex]){
            case Text(text):
                m_skipTimer = 0;
                m_target = m_line;
                m_currDialog = text;
                m_text = m_currDialog.substr(0, m_index);
            case Line(text):
                m_target = m_line;
                m_currDialog = text;
                m_text = m_currDialog.substr(0, m_index);
            case Para(text):
                m_line.text = '';
                m_cont.text = '';
                m_skipTimer = 0;
                m_target = m_line;
                m_currDialog = text;
                m_text = m_currDialog.substr(0, m_index);
            case Cont(text):
                m_target = m_cont;
                m_currDialog = text;
                m_text = m_currDialog.substr(0, m_index);
            case Done(cb):
        }
    }

    private inline function getDialog(){
        return m_dialog[m_lineIndex];
    }

    private function continueDialog(){
        m_lineIndex++;
        switch(getDialog()){
            case Para(text):
                m_allowSkip = false;
                m_allowContinue = true;
            case Done(cb):
                m_allowSkip = false;
                m_allowContinue = true;
            default:
                progress();
        }
    }

    private function skipText(){
        m_index = m_currDialog.length-1;
        continueDialog();
        switch(getDialog()){
            case Line(text):
                skipText();
            case Text(text):
                skipText();
            case Cont(text):
                skipText();
            default:
        }
        m_index = m_currDialog.length-1;
    }

	public function update(dt:Float) {
        m_time += dt;
        m_time %= 45;
        m_progress += dt;

        var inputs = m_world.getInputs();

        if (m_text == m_currDialog && !m_marker.visible){
            m_time = 0;
            continueDialog();
        }

        if (!m_allowContinue && m_progress >= m_progressMax){
            m_progress -= m_progressMax;
            m_index++;
        }

        m_text = m_currDialog.substr(0, m_index);

        if (m_allowContinue){
            if (inputs.isPressed(Interact)){
                switch(getDialog()){
                    case Done(cb):
                        m_world.popGameState();
                        if (cb != null){
                            cb();
                        }
                    default:
                        progress();
                }
            }
        };

        if (m_allowSkip){
            m_skipTimer += dt;
            if (m_skipTimer >= m_skipTimeMax){
                if (inputs.isPressed(Interact)){
                    skipText();
                }
            }
        }

        

        
    }

	public function postUpdate() {

        m_marker.visible = m_allowContinue;

        m_line.x = m_lineX;
        m_line.y = m_lineY;

        m_cont.x = m_contX;
        m_cont.y = m_contY;

        var rellerpy = Tween.lerp(0, 1, Tween.spikeEaseOut(m_time/45));
        var lerpy = rellerpy * 5;

        m_marker.x = m_markerX;
        m_marker.y = m_markerY - lerpy;

        m_marker.scaleX = 1;
        m_marker.scaleY = 1;

        m_target.text = m_text;

        var min = 0.3;
        if (rellerpy <= min){
            var p = (min - rellerpy) / min;
            m_marker.scaleX += Tween.lerp(0, 0.5, Tween.easeOut(p));
            m_marker.scaleY -= Tween.lerp(0, 0.3, Tween.easeOut(p));
        }
    }
}
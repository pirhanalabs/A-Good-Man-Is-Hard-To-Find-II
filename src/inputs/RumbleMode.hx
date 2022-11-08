package inputs;

class RumbleMode{

        public static final FAIL_RECIPE = new RumbleMode(1, 0.2);

        var m_strength : Float;
        var m_time_s : Float;

        private function new(strength:Float, time_s:Float){
                m_strength = strength;
                m_time_s = time_s;
        }

        public function getStrength(){
                return m_strength;
        }

        public function getTimeS(){
                return m_time_s;
        }
}
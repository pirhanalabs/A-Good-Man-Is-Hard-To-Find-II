class Tween{

    public static function lerp(start:Float, end:Float, t:Float){
        return start + (end - start) * t;
    }

    public static function linear(t:Float){
        return t;
    }

    public static function easeIn(t:Float){
        return t * t;
    }

    public static function easeOut(t:Float){
        return flip(easeIn(flip(t)));
    }

    public static function easeInOut(t:Float){
        return lerp(easeIn(t), easeOut(t), t);
    }

    public static function spike(t:Float){
        if (t < 0.5){
            return easeIn(t / 0.5);
        }
        return easeIn(flip(t) / 0.5);
    }

    public static function spikeEaseOut(t:Float){
        if (t < 0.5){
            return easeOut(t / 0.5);
        }
        return easeOut(flip(t)/0.5);
    }

    public static function flip(x:Float){
        return 1 - x;
    }
}
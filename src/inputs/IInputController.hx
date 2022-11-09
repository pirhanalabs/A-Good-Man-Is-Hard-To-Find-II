package inputs;

interface IInputController<T:EnumValue> {
    
    function padAvailable():Bool;
    function getMode():InputMode;

    function getXAxis():Float;
    function getYAxis():Float;

    function getAnalogXAxis():Float;
    function getAnalogYAxis():Float;

    function getRightAnalogXAxis():Float;
    function getRightAnalogYAxis():Float;

    function getAxisDirection():Direction;
    function getAnalogDirection():Direction;
    function getRightAnalogDirection():Direction;

    function isPressed(val:T):Bool;
    function isDown(val:T):Bool;
    function isReleased(val:T):Bool;

    function forceMode(mode:InputMode):Void;
}
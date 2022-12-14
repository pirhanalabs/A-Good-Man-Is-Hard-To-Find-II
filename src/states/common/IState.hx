package states.common;

/**
 * interface defining a state for a
 * statemachine or statestack.
 */
interface IState{
    function onResume():Void; // used for state stack handling
    function onEnter(?params:Dynamic):Void;
    function onExit():Void;
    function update(dt:Float):Void;
    function postUpdate():Void;
}
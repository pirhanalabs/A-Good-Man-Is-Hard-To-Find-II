package states.screen;

import states.common.IState;

/**
 * state handling a dialog.
 * dialog is composed of:
 * text - writes on the same line as previous text.
 * line - writes at the second dialog line.
 * cont - writes at the second line, moving previous second line
 *        to the first one.
 * para - clears the previous lines and start anew.
 */
class DialogState implements IState{

}
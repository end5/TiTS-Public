package editor.Display.Panes {
    import editor.Display.Components.Box;
    import editor.Display.Components.InputField;
    import editor.Display.Components.StaticField;
    import editor.Display.Events.*;
    import editor.Display.Themes.*;
    import editor.Display.UIInfo;
    import editor.Evaluator;
    import editor.Lang.Errors.LangError;
    import flash.events.*;
    import flash.text.TextFormat;

    public class InputPane extends Box {
        private var inputField: InputField = new InputField();
        private var infoField: StaticField = new StaticField();
        private var evaluator: Evaluator;

        public function InputPane(evaluator: Evaluator) {
            this.evaluator = evaluator;

            addChild(inputField);
            addChild(infoField);

            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(event: Event): void {
            inputField.x = UIInfo.BORDER_SIZE;
            inputField.y = UIInfo.BORDER_SIZE;
            inputField.nsWidth = nsWidth - UIInfo.BORDER_SIZE;
            inputField.nsHeight = nsHeight - 30 - UIInfo.BORDER_SIZE;

            infoField.x = UIInfo.BORDER_SIZE;
            infoField.y = inputField.y + inputField.nsHeight + UIInfo.BORDER_SIZE;
            infoField.nsWidth = nsWidth - UIInfo.BORDER_SIZE;
            infoField.nsHeight = 30 - UIInfo.BORDER_SIZE;

            displayInfo(0, 0, 0);

            // Keyboard events update position info
            inputField.addEventListener(KeyboardEvent.KEY_DOWN, updatePositionInfo);
            inputField.addEventListener(KeyboardEvent.KEY_UP, updatePositionInfo);
            inputField.addEventListener(MouseEvent.CLICK, updatePositionInfo);

            // Display needs updating
            EditorEventDispatcher.instance.addEventListener(EditorEvents.THEME_CHANGE, resetMarkers);

            // Defer evaluating new text until frame update
            EditorEventDispatcher.instance.addEventListener(EditorEvents.EVAL_START, markForEval);
            inputField.addEventListener(Event.CHANGE, markForEval);

            // Listen for auto eval toggle event
            EditorEventDispatcher.instance.addEventListener(EditorEvents.TOGGLE_AUTO_EVAL, toggleAutoEval);

            // Evaluate text and update display
            stage.addEventListener(Event.ENTER_FRAME, update);
        }

        private function updatePositionInfo(event: Event): void {
            var caretIndex: int = inputField.caretIndex;
            var lines: Array = inputField.text.split('\r');
            
            var col: int = 0;
            var counter: int = 0;
            for (var line: int = 0; line < lines.length; line++) {
                if (counter + lines[line].length < caretIndex)
                    counter += lines[line].length + 1;
                else {
                    col = caretIndex - counter;
                    break;
                }
            }

            displayInfo(line, col, inputField.caretIndex);
        }

        private function displayInfo(line: int, col: int, offset: int): void {
            infoField.text = 'Line: ' + line + ' Col: ' + col + ' Offset: ' + offset + 
                ' [' + line + ':' + col + '/' + offset + ']';
        }

        private var evalInputText: Boolean = false;
        private var autoEval: Boolean = false;

        private function toggleAutoEval(e: Event): void {
            autoEval = !autoEval;
        }

        private function markForEval(e: Event): void {
            if ((autoEval && e.type === Event.CHANGE) || e.type === EditorEvents.EVAL_START)
                evalInputText = true;
        }

        private static const RENDERS_PER_FRAME: int = 10;
        private static const FRAME_DELAY: int = 12;
        private var delayCounter: int = 0;
        private var outputRangeIdx: int = 0;
        private var errorRangeIdx: int = 0;
        private var outputFormat: TextFormat = new TextFormat();
        private var errorFormat: TextFormat = new TextFormat();

        private function update(e: Event): void {
            if (evalInputText) {
                evalInputText = false;
                evaluator.eval(inputField.getText());
                resetMarkers(e);
                EditorEventDispatcher.instance.dispatchEvent(new Event(EditorEvents.EVAL_FINISHED));
            }
            else if (autoEval && delayCounter < FRAME_DELAY) {
                // Wait "FRAME_DELAY" amount of frames before highlighting the text
                delayCounter++;
            }
            else if (inputField.getText().length > 0) {
                // Update highlighting when we are not evaluating
                var outputRanges: Array = evaluator.evalRanges();
                if (outputRangeIdx < outputRanges.length) {
                    var counter: int = 0;

                    while (counter < RENDERS_PER_FRAME && outputRangeIdx < outputRanges.length) {
                        var startPos: int = outputRanges[outputRangeIdx].start.offset;

                        for (; outputRangeIdx + 1 < outputRanges.length; outputRangeIdx++) {
                            if (outputRanges[outputRangeIdx].end.offset !== outputRanges[outputRangeIdx + 1].start.offset) {
                                counter++;
                                break;
                            }
                        }

                        if (startPos !== outputRanges[outputRangeIdx].end.offset) {
                            inputField.setTextFormat(outputFormat, startPos, outputRanges[outputRangeIdx].end.offset);
                        }

                        outputRangeIdx++;
                    }
                }

                var errorRanges: Vector.<LangError> = evaluator.evalErrors();
                if (errorRangeIdx < errorRanges.length) {
                    counter = 0;

                    while (counter < RENDERS_PER_FRAME && errorRangeIdx < errorRanges.length) {
                        startPos = errorRanges[errorRangeIdx].range.start.offset;

                        for (; errorRangeIdx + 1 < errorRanges.length; errorRangeIdx++) {
                            if (errorRanges[errorRangeIdx].range.end.offset !== errorRanges[errorRangeIdx + 1].range.start.offset) {
                                counter++;
                                break;
                            }
                        }

                        if (startPos !== errorRanges[errorRangeIdx].range.end.offset) {
                            inputField.setTextFormat(errorFormat, startPos, errorRanges[errorRangeIdx].range.end.offset);
                        }

                        errorRangeIdx++;
                    }
                }
            }
        }

        private function resetMarkers(event: Event): void {
            errorFormat.color = ThemeManager.instance.currentTheme.base08;
            outputFormat.color = ThemeManager.instance.currentTheme.base0B;

            outputRangeIdx = 0;
            errorRangeIdx = 0;

            delayCounter = 0;

            // Reset input field format to normal
            inputField.setTextFormat(inputField.textFormat);
        }
    }
}
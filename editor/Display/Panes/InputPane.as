package editor.Display.Panes {
    import editor.Display.Components.Box;
    import editor.Display.Components.InputField;
    import editor.Display.Components.StaticField;
    import editor.Display.Events.*;
    import editor.Display.Themes.*;
    import editor.Display.UIInfo;
    import editor.Evaluator;
    import editor.Lang.Errors.LangError;
    import editor.Lang.TextRange;
    import flash.events.*;

    public class InputPane extends Box {
        private var inputField: InputField = new InputField();
        private var infoField: StaticField = new StaticField();
        private var evaluator: Evaluator;
        private var outputMarker: InputFieldMarker;
        private var errorMarker: InputFieldMarker;

        public function InputPane(evaluator: Evaluator) {
            outputMarker = new InputFieldMarker(this.inputField);
            errorMarker = new InputFieldMarker(this.inputField);

            this.evaluator = evaluator;

            inputField.addEventListener(Event.CHANGE, updatePositionInfo);
            inputField.addEventListener(KeyboardEvent.KEY_DOWN, updatePositionInfo);
            inputField.addEventListener(KeyboardEvent.KEY_UP, updatePositionInfo);
            inputField.addEventListener(MouseEvent.CLICK, updatePositionInfo);

            addChild(inputField);
            addChild(infoField);

            addEventListener(Event.ADDED_TO_STAGE, init);
            EditorEventDispatcher.instance.addEventListener(EditorEvents.THEME_CHANGE, resetMarkers);
            EditorEventDispatcher.instance.addEventListener(EditorEvents.EVAL_TEXT, resetMarkers);
            EditorEventDispatcher.instance.addEventListener(EditorEvents.UPDATE_TEXT, updateEval);
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

            this.stage.addEventListener(Event.ENTER_FRAME, this.updateMarkers);
        }

        public function updateEval(event: Event): void {
            evaluator.eval(inputField.getText());
            EditorEventDispatcher.instance.dispatchEvent(new Event(EditorEvents.EVAL_TEXT));
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

        private function updateMarkers(e: Event): void {
            this.errorMarker.update();
            this.outputMarker.update();
        }

        private function resetMarkers(event: Event): void {
            this.errorMarker.setColor(ThemeManager.instance.currentTheme.base08);
            this.outputMarker.setColor(ThemeManager.instance.currentTheme.base0B);

            var arr: Vector.<TextRange> = new Vector.<TextRange>();
            for each (var error: LangError in evaluator.evalErrors())
                arr.push(error.range);

            this.errorMarker.setRanges(arr);

            arr = new Vector.<TextRange>();
            for each (var range: TextRange in evaluator.evalRanges())
                arr.push(range);

            this.outputMarker.setRanges(arr);

            // Reset input field format to normal
            this.inputField.setTextFormat(this.inputField.textFormat);
        }
    }
}
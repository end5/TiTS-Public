package editor.Display.Panes {
    import editor.Display.Components.Box;
    import editor.Display.Components.StaticField;
    import editor.Display.Events.*;
    import editor.Evaluator;
    import flash.events.*;

    public class DebugPane extends Box {
        private static const SUBSTR_LENGTH: int = 1000;

        private var debugField: StaticField = new StaticField();
        private var evaluator: Evaluator;
        private var subStrs: Array = [];
        private var subStrIdx: int = 0;

        public function DebugPane(evaluator: Evaluator) {
            this.evaluator = evaluator;
            
            addChild(debugField);

            addEventListener(Event.ADDED_TO_STAGE, init);
            EditorEventDispatcher.instance.addEventListener(EditorEvents.EVAL_TEXT, updateDebug);
        }

        private function init(event: Event): void {
            debugField.x = 0;
            debugField.y = 0;
            debugField.nsWidth = nsWidth;
            debugField.nsHeight = nsHeight;

            this.stage.addEventListener(Event.ENTER_FRAME, this.renderText);
        }

        private function renderText(e: Event): void {
            if (subStrIdx < subStrs.length) {
                debugField.appendText(subStrs[subStrIdx]);
                subStrIdx++;
            }
        }

        public function updateDebug(event: Event): void {
            subStrIdx = 0;
            subStrs = [];
            debugField.text = '';

            var text: String = evaluator.debugText();
            for (var idx: int = 0; idx + SUBSTR_LENGTH < text.length; idx += SUBSTR_LENGTH) {
                subStrs.push(text.substring(idx, idx + SUBSTR_LENGTH));
            }

            if (idx < text.length) {
                subStrs.push(text.substring(idx, text.length));
            }
        }
    }
}
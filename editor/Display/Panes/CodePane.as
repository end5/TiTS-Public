package editor.Display.Panes {
    import editor.Display.Components.Box;
    import editor.Display.Components.StaticField;
    import editor.Display.Events.*;
    import editor.Evaluator;
    import flash.events.*;

    public class CodePane extends Box {
        private var codeField: StaticField = new StaticField();
        private var evaluator: Evaluator;

        public function CodePane(evaluator: Evaluator) {
            this.evaluator = evaluator;
            
            addChild(codeField);

            addEventListener(Event.ADDED_TO_STAGE, init);

        }

        private function init(event: Event): void {
            codeField.x = 0;
            codeField.y = 0;
            codeField.nsWidth = nsWidth;
            codeField.nsHeight = nsHeight;

            // Defer evaluating new text until frame update
            EditorEventDispatcher.instance.addEventListener(EditorEvents.EVAL_FINISHED, markFrameUpdate);

            // Evaluate text and update display
            stage.addEventListener(Event.ENTER_FRAME, frameUpdate);
        }

        private var updateOutput: Boolean = false;

        private function markFrameUpdate(e: Event): void {
            updateOutput = true;
        }

        private function frameUpdate(event: Event): void {
            if (updateOutput) {
                updateOutput = false;
                codeField.text = evaluator.outputCode();
            }
        }
    }
}
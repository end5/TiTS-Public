package editor.Display.Panes {
    import editor.Display.Themes.*;
    import editor.Display.Components.Box;
    import editor.Display.Components.Button;
    import editor.Display.Events.*;
    import editor.Display.UIInfo;
    import editor.Evaluator;
    import flash.events.*;

    public class SettingsPane extends Box {
        private var evaluator: Evaluator;
        private var themeButton: Button = new Button('Change Theme');
        private var autoEvalButton: Button = new Button('Auto-Evaluate: Off');
        private var autoEval: Boolean = false;

        public function SettingsPane(evaluator: Evaluator) {
            this.evaluator = evaluator;

            themeButton.addEventListener(MouseEvent.CLICK, dispatchThemeChange);
            autoEvalButton.addEventListener(MouseEvent.CLICK, dispatchToggleAutoEval);

            addChild(themeButton);
            addChild(autoEvalButton);
            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(event: Event): void {
            themeButton.x = 0;
            themeButton.y = 0;
            themeButton.nsWidth = nsWidth;
            themeButton.nsHeight = 50;

            autoEvalButton.x = 0;
            autoEvalButton.y = themeButton.y + themeButton.nsHeight + UIInfo.BORDER_SIZE;
            autoEvalButton.nsWidth = nsWidth;
            autoEvalButton.nsHeight = 50;
        }

        private function dispatchThemeChange(event: Event): void {
            ThemeManager.instance.changeTheme();
            EditorEventDispatcher.instance.dispatchEvent(new Event(EditorEvents.THEME_CHANGE));
        }

        private function dispatchToggleAutoEval(event: Event): void {
            autoEval = !autoEval;
            autoEvalButton.text = 'Auto-Evaluate: ' + (autoEval ? 'On' : 'Off');
            EditorEventDispatcher.instance.dispatchEvent(new Event(EditorEvents.TOGGLE_AUTO_EVAL));
        }

        public function show(): void {
            visible = true;
        }

        public function hide(): void {
            visible = false;
        }
    }
}
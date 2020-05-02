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

        public function SettingsPane(evaluator: Evaluator) {
            this.evaluator = evaluator;

            themeButton.addEventListener(MouseEvent.CLICK, dispatchThemeChange);

            addChild(themeButton);
            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(event: Event): void {
            themeButton.x = 0;
            themeButton.y = 0;
            themeButton.nsWidth = nsWidth;
            themeButton.nsHeight = 50;
        }

        private function dispatchThemeChange(event: Event): void {
            ThemeManager.instance.changeTheme();
            EditorEventDispatcher.instance.dispatchEvent(new Event(EditorEvents.THEME_CHANGE));
        }

        public function show(): void {
            visible = true;
        }

        public function hide(): void {
            visible = false;
        }
    }
}
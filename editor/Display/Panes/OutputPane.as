package editor.Display.Panes {
    import editor.Display.Components.Box;
    import editor.Display.Components.Button;
    import editor.Display.UIInfo;
    import editor.Evaluator;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import editor.Display.Events.EditorEventDispatcher;
    import editor.Display.Events.EditorEvents;

    public class OutputPane extends Box {
        private const buttonContainer: Box = new Box();
        private const tabButtonContainer: Box = new Box();
        private const paneContainer: Box = new Box();
        private const buttons: Array = new Array();
        private const panes: Array = new Array();
        private const runButton: Button = new Button('Evaluate');

        public function OutputPane(evaluator: Evaluator) {
            var newButton: Button;
            for each (var name: String in ['Result', 'Code', 'Debug', 'Settings']) {
                newButton = new Button(name);
                newButton.addEventListener(MouseEvent.CLICK, switchPane);
                buttons.push(newButton);
                tabButtonContainer.addChild(newButton);
            }

            panes.push(new ResultPane(evaluator));
            panes.push(new CodePane(evaluator));
            panes.push(new DebugPane(evaluator));
            panes.push(new SettingsPane(evaluator));

            for each (var pane: * in panes) {
                paneContainer.addChild(pane);
                pane.visible = false;
            }
            panes[0].visible = true;

            addChild(buttonContainer);
            addChild(tabButtonContainer);
            addChild(paneContainer);
            addChild(runButton);

            addEventListener(Event.ADDED_TO_STAGE, init);
            runButton.addEventListener(MouseEvent.CLICK, evaluateText);
        }

        private function init(event: Event): void {
            runButton.x = UIInfo.BORDER_SIZE;
            runButton.y = UIInfo.BORDER_SIZE;
            runButton.nsWidth = nsWidth - (50 + UIInfo.BORDER_SIZE * 2) - UIInfo.BORDER_SIZE;
            runButton.nsHeight = 30 - UIInfo.BORDER_SIZE;

            tabButtonContainer.x = 0;
            tabButtonContainer.y = runButton.y + runButton.nsHeight;
            tabButtonContainer.nsWidth = nsWidth;
            tabButtonContainer.nsHeight = 30;

            const buttonWidth: Number = (tabButtonContainer.nsWidth - UIInfo.BORDER_SIZE) / buttons.length;
            for (var idx: int = 0; idx < buttons.length; idx++) {
                buttons[idx].x = buttonWidth * idx + UIInfo.BORDER_SIZE;
                buttons[idx].y = UIInfo.BORDER_SIZE;
                buttons[idx].nsWidth = buttonWidth - UIInfo.BORDER_SIZE;
                buttons[idx].nsHeight = tabButtonContainer.nsHeight - UIInfo.BORDER_SIZE;
            }

            paneContainer.x = 0;
            paneContainer.y = tabButtonContainer.y + tabButtonContainer.nsHeight;
            paneContainer.nsWidth = nsWidth;
            paneContainer.nsHeight = nsHeight - runButton.nsHeight - tabButtonContainer.nsHeight;

            for (idx = 0; idx < panes.length; idx++) {
                panes[idx].x = UIInfo.BORDER_SIZE;
                panes[idx].y = UIInfo.BORDER_SIZE;
                panes[idx].nsWidth = paneContainer.nsWidth - UIInfo.BORDER_SIZE * 2;
                panes[idx].nsHeight = paneContainer.nsHeight - UIInfo.BORDER_SIZE * 2;
            }
        }

        public function evaluateText(event: Event): void {
            EditorEventDispatcher.instance.dispatchEvent(new Event(EditorEvents.EVAL_START));
        }

        private function switchPane(event: Event): void {
            for each (var pane: * in panes)
                pane.visible = false;
            var idx: int = buttons.indexOf(event.target);
            if (idx >= 0)
                panes[idx].visible = true;
        }
    }
}
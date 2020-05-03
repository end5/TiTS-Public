package editor.Display.Components {
    import editor.Display.Events.*;
    import editor.Display.Themes.ThemeManager;
    import flash.events.Event;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.events.MouseEvent;

    public class Button extends TextBox {
        private const textFormat: TextFormat = new TextFormat();
        private var activeColor: uint = 0;
        private var inactiveColor: uint = 0;
        private var mouseInside: Boolean = false;

        public function Button(text: String) {        
            textFormat.size = 18;
            textFormat.align = TextFormatAlign.CENTER;
            textFormat.font = 'Consolas';
            textFormat.leading = 0;
            textFormat.kerning = true;

            selectable = false;
            background = true;

            this.text = text;
            
            EditorEventDispatcher.instance.addEventListener(EditorEvents.THEME_CHANGE, themeUpdate);
            addEventListener(MouseEvent.MOUSE_OVER, mouseEnter);
            addEventListener(MouseEvent.MOUSE_OUT, mouseLeave);
        }

        public function themeUpdate(event: Event): void {
            textFormat.color = ThemeManager.instance.currentTheme.base05;
            inactiveColor = ThemeManager.instance.currentTheme.base00;
            activeColor = ThemeManager.instance.currentTheme.base03;
            backgroundColor = mouseInside ? activeColor : inactiveColor;
            setTextFormat(textFormat);
            defaultTextFormat = textFormat;
        }

        public function mouseEnter(e: Event): void {
            mouseInside = true;
            backgroundColor = activeColor;
        }

        public function mouseLeave(e: Event): void {
            mouseInside = false;
            backgroundColor = inactiveColor;
        }
    }
}
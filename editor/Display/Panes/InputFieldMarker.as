package editor.Display.Panes {
    import editor.Display.Components.InputField;
    import editor.Lang.TextRange;
    import flash.text.TextFormat;

    public class InputFieldMarker {
        private static const RENDERS_PER_FRAME: int = 10;

        private var field: InputField;
        private var format: TextFormat = new TextFormat();
        private var ranges: Vector.<TextRange>;
        private var rangeIdx: int = 0;
        private var length: int = 0;

        public function InputFieldMarker(field: InputField) {
            this.field = field;
            this.format = format;
        }

        public function setColor(color: uint): void {
            this.format.color = color;
        }

        public function setRanges(ranges: Vector.<TextRange>): void {
            this.ranges = ranges;
            this.length = ranges.length;
            this.rangeIdx = 0;
        }

        public function update(): void {
            for (var idx: int = 0; idx < RENDERS_PER_FRAME && this.rangeIdx + idx < this.length; idx++) {
                var range: TextRange = this.ranges[this.rangeIdx + idx];
                if (range.start.offset !== range.end.offset)
                    if (range.end.offset > this.field.text.length)
                        this.field.setTextFormat(this.format, range.start.offset, this.field.text.length);
                    else
                        this.field.setTextFormat(this.format, range.start.offset, range.end.offset);
            }
            this.rangeIdx += idx;
        }
    }
}
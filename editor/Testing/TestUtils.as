package editor.Testing {
    import editor.Lang.TextRange;

    public class TestUtils {
        public static function failed(type: String, value1: *, value2: *): String {
            return 'Failed: Supplied ' + type + ' "' + value1 + '" !== computed "' + value2 + '"';
        }

        public static function compareTextRange(name: String, test: TextRange, computed: TextRange): Array {
            var out: Array = [];
            if (test.start.offset !== computed.start.offset) out.push(failed(name + 'offsetStart', test.start.offset, computed.start.offset));
            if (test.start.line !== computed.start.line) out.push(failed(name + 'lineStart', test.start.line, computed.start.line));
            if (test.start.col !== computed.start.col) out.push(failed(name + 'columnStart', test.start.col, computed.start.col));
            if (test.end.offset !== computed.end.offset) out.push(failed(name + 'offsetEnd', test.end.offset, computed.end.offset));
            if (test.end.line !== computed.end.line) out.push(failed(name + 'lineEnd', test.end.line, computed.end.line));
            if (test.end.col !== computed.end.col) out.push(failed(name + 'columnEnd', test.end.col, computed.end.col));
            return out;
        }
    }
}
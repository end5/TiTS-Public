package editor.Lang.Errors {
    import editor.Lang.TextRange;

    public class LangError {
        public var msg: String;
        public var range: TextRange;

        public function LangError(range: TextRange, msg: String) {
            this.msg = msg;
            this.range = range;
        }

        public function toString(): String {
            return this.range + ' Error: ' + this.msg;
        }
    }
}
package editor.Lang.Codify {
    public class CodeNode {
        public static const Invalid: int = 0;
        public static const Text: int = 1;
        public static const Code: int = 2;

        public static const Names: Array = [
            'Invalid',
            'Text',
            'Code'
        ];

        // Type above
        public var type: int;
        public var value: String;
        public var body: Array;

        public function CodeNode(type: int, value: String, children: Array = null) {
            this.type = type;
            this.value = value;
            this.body = children;
        }
    }
}
package editor.Lang.Interpret {
    public class VariableInfo {
        public var name: String;
        public var value: *;
        public var parent: Object;
        public var caps: Boolean;
        public var func: *;

        public function VariableInfo(name: String, value: *, parent: Object, caps: Boolean, func: *) {
            this.name = name;
            this.value = value;
            this.parent = parent;
            this.caps = caps;
            this.func = func;
        }
    }
}
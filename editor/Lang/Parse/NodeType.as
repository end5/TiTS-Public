package editor.Lang.Parse {
    public class NodeType {
        public static var Identity: int = 0;
        public static var String: int = 1;
        public static var Number: int = 2;
        public static var Concat: int = 3;
        public static var Eval: int = 4;
        public static var Retrieve: int = 5;
        public static var Args: int = 6;
        public static var Results: int = 7;
        public static var Text: int = 8;
        public static var Select: int = 9;
        
        public static var Names: Array = [
            'Identifier',
            'String',
            'Number',
            'Concat',
            'Eval',
            'Retrieve',
            'Args',
            'Results',
            'Text',
            'Select'
        ];
    }
}
package editor.Lang.Tokenize {
    public class TokenType {
        public static const EOS: int = 0;
        public static const Text: int = 1;
        public static const LeftBracket: int = 2;
        public static const RightBracket: int = 3;
        public static const Dot: int = 4;
        public static const Pipe: int = 5;
        public static const ArgsStart: int = 6;
        public static const ResultsStart: int = 7;
        public static const QuestionMark: int = 8;
        
        public static const Names: Array = [
            'EOS',
            'Text',
            'LeftBracket',
            'RightBracket',
            'Dot',
            'Pipe',
            'ArgsStart',
            'ResultsStart',
            'QuestionMark'
        ];
    }
}
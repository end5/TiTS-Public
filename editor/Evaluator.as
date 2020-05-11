package editor {
    import classes.TiTS;
    import editor.Lang.Errors.LangError;
    import editor.Lang.Interpret.Codifier;
    import editor.Lang.Interpret.Interpreter;
    import editor.Lang.Parse.Node;
    import editor.Lang.Parse.NodeType;
    import editor.Lang.Parse.Parser;
    import editor.Lang.Tokenize.Tokenizer;
    import editor.Lang.Tokenize.TokenType;
    // import editor.Parsers.Normal.CodeMap.TiTSCodeMap;
    // import editor.Parsers.Normal.Info.TiTSInfo;
    // import editor.Parsers.Normal.Wrapper.TiTSWrapper;
    // import editor.Parsers.Query.CodeMap.TiTSCodeMap;
    // import editor.Parsers.Query.Info.TiTSInfo;
    // import editor.Parsers.Query.Wrapper.TiTSWrapper;
    import editor.Game.Wrapper.TiTSWrapper;
    import editor.Game.Info.TiTSInfo;
    import editor.Game.CodeMap.TiTSCodeMap;

    public class Evaluator {
        private const parser: Parser = new Parser();
        private var interpreter: Interpreter;
        private var codifier: Codifier;

        private var errors: Vector.<LangError>;

        private var root: Node;
        private var result: String;
        private var ranges: Array;
        private var code: String;

        public var debugActive: Boolean = false;
        private var debugStr: String;
        private var parserDuration: Number;
        private var interpreterDuration: Number;
        private var codifierDuration: Number;

        private var tits: TiTS;

        private var oldParsersWrapper: Object;
        private var oldParsersInfo: Object;
        private var oldParsersCodeMap: Object;

        private var newParsersWrapper: Object;
        private var newParsersInfo: Object;
        private var newParsersCodeMap: Object;

        public function Evaluator(globalObj: Object, infoObj: Object, codeMapObj: Object, tits: TiTS) {
            this.tits = tits;

            // this.oldParsersWrapper = new editor.Parsers.Normal.Wrapper.TiTSWrapper(tits);
            // this.oldParsersInfo = new editor.Parsers.Normal.Info.TiTSInfo(tits);
            // this.oldParsersCodeMap = new editor.Parsers.Normal.CodeMap.TiTSCodeMap(tits);

            // this.newParsersWrapper = new editor.Parsers.Query.Wrapper.TiTSWrapper(tits);
            // this.newParsersInfo = new editor.Parsers.Query.Info.TiTSInfo(tits);
            // this.newParsersCodeMap = new editor.Parsers.Query.CodeMap.TiTSCodeMap(tits);

            this.oldParsersWrapper = new editor.Game.Wrapper.TiTSWrapper(tits);
            this.oldParsersInfo = new editor.Game.Info.TiTSInfo(tits);
            this.oldParsersCodeMap = new editor.Game.CodeMap.TiTSCodeMap(tits);

            this.newParsersWrapper = this.oldParsersWrapper;
            this.newParsersInfo = this.oldParsersInfo;
            this.newParsersCodeMap = this.oldParsersCodeMap;

            interpreter = new Interpreter(oldParsersWrapper, oldParsersInfo, newParsersWrapper, newParsersInfo);
            codifier = new Codifier(oldParsersCodeMap, newParsersCodeMap);
        }

        public function eval(text: String): void {
            this.parserDuration = new Date().time;
            this.parser.parse(text);
            this.parserDuration = new Date().time - this.parserDuration;

            this.root = this.parser.root;
            this.errors = this.parser.errors;

            this.interpreterDuration = new Date().time;
            this.interpreter.interpret(this.root);
            this.interpreterDuration = new Date().time - this.interpreterDuration;

            this.codifierDuration = new Date().time;
            this.codifier.interpret(this.root);
            this.codifierDuration = new Date().time - this.codifierDuration;

            // Results
            this.result = this.interpreter.result;
            this.ranges = this.interpreter.ranges;
            this.code = this.codifier.result;

            this.errors = this.errors.concat(this.interpreter.errors, this.codifier.errors);

            this.debugStr = (!this.debugActive ? 'Debug is not active' : (timing(text) + debugLexer(text) + debugParser() + debugRanges()));
        }

        public function outputText(): String {
            return this.result;
        }

        public function outputRanges(): Array/*TextRange*/ {
            return this.ranges;
        }

        public function outputCode(): String {
            return this.code;
        }
        
        public function outputErrors(): Vector.<LangError> {
            return this.errors;
        }

        private function timing(text: String): String {
            var outText: String = '| -- Time' + 
                '\n| Editor';

            var tokenizer: Tokenizer = new Tokenizer(text);

            var start: Number = new Date().time;

            var type: int = tokenizer.peek();
            while (type !== TokenType.EOS) {
                type = tokenizer.advance();
            }

            var end: Number = new Date().time;
            outText += '\n|   Tokenizer: ' + (end - start) + 'ms';
            outText += '\n|   Parser: ' + this.parserDuration + 'ms';
            outText += '\n|   Interpret: ' + this.interpreterDuration + 'ms';
            outText += '\n|   Codifier: ' + this.codifierDuration + 'ms';
            outText += '\n|   ------------------';
            outText += '\n|   Total: ' + (this.parserDuration + this.interpreterDuration) + 'ms';

            start = new Date().time;

            this.tits.parser.recursiveParser(text);

            end = new Date().time;
            outText += '\n| Game' +
                '\n|   Parser: ' + (end - start) + 'ms';

            return outText + '\n';
        }

        private function debugLexer(text: String): String {
            const tokenizer: Tokenizer = new Tokenizer(text);

            var log: String = '| -- Tokenizer';
            var token: int = tokenizer.peek();
            while (token !== TokenType.EOS) {
                log += '\n| [' + 
                    tokenizer.lineStart + ':' + tokenizer.colStart + '/' + tokenizer.offsetStart + '|' + 
                    tokenizer.lineEnd + ':' + tokenizer.colEnd + '/' + tokenizer.offsetEnd + '] ' +
                    TokenType.Names[token] + ' ' +
                    tokenizer.getText();
                token = tokenizer.advance();
            }

            return log;
        }

        private function debugParser(): String {
            return '\n| -- Parser' + printNode(this.root);
        }

        private function debugRanges(): String {
            return '\n| -- Ranges' + '\n| ' + this.ranges;
        }

        public function debugText(): String {
            return debugStr || '';
        }

        private function printNode(root: Node): String {
            var nodeStack: Array = [root];
            var indentStack: Array = [0];

            var outText: String = '';

            var indent: int;
            var node: Node;
            while (nodeStack.length > 0) {
                node = nodeStack.pop();
                indent = indentStack.pop();

                outText += '\n| ';
                for (var count: int = 0; count < indent; count++)
                    outText += '  ';

                outText += '[' + 
                    node.range.start.line + ':' + node.range.start.col + '/' + node.range.start.offset + '|' +
                    node.range.end.line + ':' + node.range.end.col + '/' + node.range.end.offset + '] ' +
                    NodeType.Names[node.type];

                if (node.value != null)
                    outText += ' "' + node.value + '"';

                if (node.children != null)
                    for (var idx: int = node.children.length - 1; idx >= 0; idx--) {
                        nodeStack.push(node.children[idx]);
                        indentStack.push(indent + 1);
                    }
            }
            return outText;
        }
    }
}
package editor {
    import classes.TiTS;
    import editor.Lang.Codify.CodePrinter;
    import editor.Lang.Codify.CodeNode;
    import editor.Lang.Codify.CodeTranslator;
    import editor.Lang.Errors.LangError;
    import editor.Lang.Interpret.Interpreter;
    import editor.Lang.Parse.Node;
    import editor.Lang.Parse.NodeType;
    import editor.Lang.Parse.Parser;
    import editor.Lang.Tokenize.Tokenizer;
    import editor.Lang.Tokenize.TokenType;
    import editor.Parsers.Functional.CodeMap.TiTSCodeMap;
    import editor.Parsers.Functional.Info.TiTSInfo;
    import editor.Parsers.Functional.Wrapper.TiTSWrapper;
    import editor.Parsers.Selecting.CodeMap.TiTSCodeMap;
    import editor.Parsers.Selecting.Info.TiTSInfo;
    import editor.Parsers.Selecting.Wrapper.TiTSWrapper;

    public class Evaluator {
        private const parser: Parser = new Parser();
        private var interpreter: Interpreter;
        private var codeTranslator: CodeTranslator;
        private var codePrinter: CodePrinter;

        private var errors: Vector.<LangError>;

        private var root: Node;
        private var result: String;
        private var ranges: Array;
        private var codeBody: Array;
        private var code: String;

        public var debugActive: Boolean = false;
        private var debugStr: String;
        private var parserDuration: Number;
        private var interpreterDuration: Number;
        private var codeTranslatorDuration: Number;
        private var codePrinterDuration: Number;

        private var tits: TiTS;

        private var functionalParsersWrapper: Object;
        private var functionalParsersInfo: Object;
        private var functionalParsersCodeMap: Object;

        private var selectionParsersWrapper: Object;
        private var selectionParsersInfo: Object;
        private var selectionParsersCodeMap: Object;

        public function Evaluator(globalObj: Object, infoObj: Object, codeMapObj: Object, tits: TiTS) {
            this.tits = tits;

            this.functionalParsersWrapper = new editor.Parsers.Functional.Wrapper.TiTSWrapper(tits);
            this.functionalParsersInfo = new editor.Parsers.Functional.Info.TiTSInfo(tits);
            this.functionalParsersCodeMap = new editor.Parsers.Functional.CodeMap.TiTSCodeMap(tits);

            this.selectionParsersWrapper = new editor.Parsers.Selecting.Wrapper.TiTSWrapper(tits);
            this.selectionParsersInfo = new editor.Parsers.Selecting.Info.TiTSInfo(tits);
            this.selectionParsersCodeMap = new editor.Parsers.Selecting.CodeMap.TiTSCodeMap(tits);

            interpreter = new Interpreter(functionalParsersWrapper, functionalParsersInfo, selectionParsersWrapper, selectionParsersInfo);
            codeTranslator = new CodeTranslator(functionalParsersCodeMap, selectionParsersCodeMap);
            codePrinter = new CodePrinter('outputText');
        }

        public function eval(text: String): void {
            // Parse input text to Lang AST
            if (this.debugActive) this.parserDuration = new Date().time;
            this.parser.parse(text);
            if (this.debugActive) this.parserDuration = new Date().time - this.parserDuration;

            this.root = this.parser.root;
            this.errors = this.parser.errors;

            // Interpret Lang AST to output text and ranges
            if (this.debugActive) this.interpreterDuration = new Date().time;
            this.interpreter.interpret(this.root);
            if (this.debugActive) this.interpreterDuration = new Date().time - this.interpreterDuration;

            this.result = this.interpreter.result;
            this.ranges = this.interpreter.ranges;

            // Convert Lang AST to Code AST
            if (this.debugActive) this.codeTranslatorDuration = new Date().time;
            const codeBody: Array = this.codeTranslator.translate(this.root);
            if (this.debugActive) this.codeTranslatorDuration = new Date().time - this.codeTranslatorDuration;

            this.codeBody = codeBody;

            // Interpret Code AST to code 
            if (this.debugActive) this.codePrinterDuration = new Date().time;
            const code: String = this.codePrinter.print(this.codeBody);
            if (this.debugActive) this.codePrinterDuration = new Date().time - this.codePrinterDuration;

            this.code = code;

            // Combine errors
            this.errors = this.errors.concat(this.interpreter.errors, this.codeTranslator.errors);

            // Debug text
            this.debugStr = (!this.debugActive ? 'Debug is not active' : (timing(text) + resultInfo(text)));
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
            outText += '\n|   Code Translator: ' + this.codeTranslatorDuration + 'ms';
            outText += '\n|   Code Printer: ' + this.codePrinterDuration + 'ms';
            outText += '\n|   ------------------';
            outText += '\n|   Parser + Interpreter: ' + (this.parserDuration + this.interpreterDuration) + 'ms';
            outText += '\n|   Code Translator + Printer: ' + (this.codeTranslatorDuration + this.codePrinterDuration) + 'ms';

            start = new Date().time;

            this.tits.parser.recursiveParser(text);

            end = new Date().time;
            outText += '\n| Game' +
                '\n|   Parser: ' + (end - start) + 'ms';

            return outText + '\n';
        }

        private function resultInfo(text: String): String {
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

            log += '\n| -- Parser' + printNode(this.root);
            log += '\n| -- Ranges' + '\n| ' + this.ranges;
            log += '\n| -- Code Body' + '\n| ' + this.printCodeNode(this.codeBody);

            return log;
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

        private function printCodeNode(root: Array): String {
            var nodeStack: Array = root.concat().reverse();
            var indentStack: Array = [0];

            var outText: String = '';

            var indent: int;
            var node: CodeNode;
            while (nodeStack.length > 0) {
                node = nodeStack.pop();
                indent = indentStack.pop();

                outText += '\n| ';
                for (var count: int = 0; count < indent; count++)
                    outText += '  ';

                outText += CodeNode.Names[node.type];

                if (node.value != null)
                    outText += ' "' + node.value + '"';

                if (node.body != null)
                    for (var idx: int = node.body.length - 1; idx >= 0; idx--) {
                        nodeStack.push(node.body[idx]);
                        indentStack.push(indent + 1);
                    }
            }
            return outText;
        }
    }
}
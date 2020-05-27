package editor.Lang.Parse {

    import editor.Lang.Tokenize.Tokenizer;
    import editor.Lang.Errors.LangError;
    import editor.Lang.Tokenize.TokenType;
    import editor.Lang.TextRange;
    import editor.Lang.TextPosition;
    import editor.Lang.Tokenize.Symbols;

    public class Parser {
        private var tokenizer: Tokenizer;
        public var errors: Vector.<LangError>;
        public var root: Node;

        /**
         * Parses text generating a ParseResult
         * @param text
         * @return
         */
        public function parse(text: String): void {
            this.tokenizer = new Tokenizer(text);
            this.errors = new Vector.<LangError>();
            this.root = this.parseText();
        }

        private function parseText(): Node {
            const concat: Array = [];

            var token: int = this.tokenizer.peek();
            while (token !== TokenType.EOS) {
                // The next token should be "[" or Text
                // Text followed by Text should be handled in the Tokenizer

                if (token === TokenType.LeftBracket) {
                    var code: Node = this.parseCode();
                    if (code != null) concat.push(code);

                    token = this.tokenizer.peek();
                }
                else {
                    concat.push(new Node(
                        NodeType.Text,
                        new TextRange(
                            new TextPosition(this.tokenizer.lineStart, this.tokenizer.colStart, this.tokenizer.offsetStart),
                            new TextPosition(this.tokenizer.lineEnd, this.tokenizer.colEnd, this.tokenizer.offsetEnd)
                        ),
                        null,
                        this.tokenizer.getText()
                    ));

                    token = this.tokenizer.advance();
                }
            }

            if (concat.length === 0)
                return new Node(
                    NodeType.Text,
                    new TextRange(),
                    null,
                    ''
                );
            else if (concat.length === 1)
                return concat[0];
            else
                return new Node(
                    NodeType.Concat,
                    new TextRange(concat[0].range.start, concat[concat.length - 1].range.end),
                    concat,
                    null
                );
        }

        private static function constructErrorMsg(... symbols): String {
            return 'Expected one of the following characters at the end: "' + symbols.join('", "') + '"';
        }

        private const missingIdentity: String = 'Expected the name of a parser here';
        private const missingSymbolIdentity: String = constructErrorMsg(Symbols.Space, Symbols.Colon, Symbols.RightBracket);
        private const missingSymbolArg: String = constructErrorMsg(Symbols.Colon, Symbols.Pipe, Symbols.RightBracket);
        private const missingSymbolResult: String = constructErrorMsg(Symbols.Pipe, Symbols.RightBracket);

        private function parseCode(): Node {
            const codeLineStart: int = this.tokenizer.lineStart;
            const codeColStart: int = this.tokenizer.colStart;
            const codeOffsetStart: int = this.tokenizer.offsetStart;

            // Token is "["
            var token: int = this.tokenizer.advance();

            var query: Boolean = false;
            if (token === TokenType.QuestionMark) {
                token = this.tokenizer.advance();
                query = true;
            }

            const identityArr: Array = [];

            // This section reads alternating Text and "."
            while (token === TokenType.Text) {
                identityArr.push(new Node(
                    NodeType.Identity,
                    new TextRange(
                        new TextPosition(this.tokenizer.lineStart, this.tokenizer.colStart, this.tokenizer.offsetStart),
                        new TextPosition(this.tokenizer.lineEnd, this.tokenizer.colEnd, this.tokenizer.offsetEnd)
                    ),
                    null,
                    this.tokenizer.getText()
                ));

                token = this.tokenizer.advance();

                if (token === TokenType.Dot) {
                    token = this.tokenizer.advance();
                }
                else {
                    break;
                }
            }

            if (identityArr.length === 0) {
                this.errors.push(new LangError(
                    new TextRange(
                        new TextPosition(codeLineStart, codeColStart, codeOffsetStart),
                        new TextPosition(this.tokenizer.lineStart, this.tokenizer.colStart, this.tokenizer.offsetStart)
                    ),
                    this.missingIdentity
                ));
                return null;
            }

            if (token !== TokenType.ArgsStart && token !== TokenType.ResultsStart && token !== TokenType.RightBracket) {
                this.errors.push(new LangError(
                    new TextRange(
                        new TextPosition(codeLineStart, codeColStart, codeOffsetStart),
                        new TextPosition(this.tokenizer.lineStart, this.tokenizer.colStart, this.tokenizer.offsetStart)
                    ),
                    this.missingSymbolIdentity
                ));
                return null;
            }

            const retrieve: Node = new Node(
                NodeType.Retrieve,
                new TextRange(
                    identityArr[0].range.start,
                    identityArr[identityArr.length - 1].range.end
                ),
                identityArr,
                query
            );

            const argsArr: Array = [];
            const argsLineStart: int = this.tokenizer.lineStart;
            const argsColStart: int = this.tokenizer.colStart;
            const argsOffsetStart: int = this.tokenizer.offsetStart;

            if (token === TokenType.ArgsStart) {
                token = this.tokenizer.advance();

                var concat: Array = [];

                var argLineStart: int = this.tokenizer.lineStart;
                var argColStart: int = this.tokenizer.colStart;
                var argOffsetStart: int = this.tokenizer.offsetStart;

                var textArr: Array = [];

                while (token !== TokenType.EOS) {
                    if (token === TokenType.Text) {
                        var text: String = this.tokenizer.getText();
                        var maybeNum: Number = Number(text);
                        var isNumber: Boolean = text.length > 0 && !isNaN(maybeNum);

                        concat.push(new Node(
                            isNumber ? NodeType.Number : NodeType.String,
                            new TextRange(
                                new TextPosition(argLineStart, argColStart, argOffsetStart),
                                new TextPosition(this.tokenizer.lineEnd, this.tokenizer.colEnd, this.tokenizer.offsetEnd)
                            ),
                            null,
                            isNumber ? maybeNum : text
                        ));

                        token = this.tokenizer.advance();
                    }
                    else if (token === TokenType.LeftBracket) {
                        var code: Node = this.parseCode();
                        if (code != null) concat.push(code);

                        token = this.tokenizer.peek();
                    }
                    else if (
                        token === TokenType.Pipe ||
                        token === TokenType.ResultsStart ||
                        token === TokenType.RightBracket
                    ) {
                        if (concat.length > 1)
                            argsArr.push(new Node(
                                NodeType.Concat,
                                new TextRange(
                                    new TextPosition(argLineStart, argColStart, argOffsetStart),
                                    new TextPosition(this.tokenizer.lineStart, this.tokenizer.colStart, this.tokenizer.offsetStart)
                                ),
                                concat,
                                null
                            ));
                        else if (concat.length > 0)
                            argsArr.push(concat[0]);

                        if (token === TokenType.Pipe) {
                            token = this.tokenizer.advance();

                            // Reset
                            concat = [];

                            argLineStart = this.tokenizer.lineStart;
                            argColStart = this.tokenizer.colStart;
                            argOffsetStart = this.tokenizer.offsetStart;
                        }
                        else break; // Colon, RightBracket
                    }
                    else break;
                }
            }

            if (token !== TokenType.ResultsStart && token !== TokenType.RightBracket) {
                this.errors.push(new LangError(
                    new TextRange(
                        new TextPosition(codeLineStart, codeColStart, codeOffsetStart),
                        new TextPosition(this.tokenizer.lineStart, this.tokenizer.colStart, this.tokenizer.offsetStart)
                    ),
                    this.missingSymbolArg
                ));
                return null;
            }

            const args: Node = new Node(
                NodeType.Args,
                new TextRange(
                    new TextPosition(argsLineStart, argsColStart, argsOffsetStart),
                    new TextPosition(this.tokenizer.lineStart, this.tokenizer.colStart, this.tokenizer.offsetStart)
                ),
                argsArr,
                null
            );

            const resultsArr: Array = [];
            const resultsLineStart: int = this.tokenizer.lineStart;
            const resultsColStart: int = this.tokenizer.colStart;
            const resultsOffsetStart: int = this.tokenizer.offsetStart;

            if (token === TokenType.ResultsStart) {
                token = this.tokenizer.advance();

                concat = [];

                argLineStart = this.tokenizer.lineStart;
                argColStart = this.tokenizer.colStart;
                argOffsetStart = this.tokenizer.offsetStart;

                while (token !== TokenType.EOS) {
                    if (token === TokenType.Text) {
                        concat.push(new Node(
                            NodeType.Text,
                            new TextRange(
                                new TextPosition(this.tokenizer.lineStart, this.tokenizer.colStart, this.tokenizer.offsetStart),
                                new TextPosition(this.tokenizer.lineEnd, this.tokenizer.colEnd, this.tokenizer.offsetEnd)
                            ),
                            null,
                            this.tokenizer.getText()
                        ));
                        token = this.tokenizer.advance();
                    }
                    else if (token === TokenType.LeftBracket) {
                        code = this.parseCode();
                        if (code != null) concat.push(code);

                        token = this.tokenizer.peek();
                    }
                    else if (token === TokenType.Pipe || token === TokenType.RightBracket) {
                        if (concat.length > 1)
                            resultsArr.push(new Node(
                                NodeType.Concat,
                                new TextRange(
                                    new TextPosition(argLineStart, argColStart, argOffsetStart),
                                    new TextPosition(this.tokenizer.lineStart, this.tokenizer.colStart, this.tokenizer.offsetStart)
                                ),
                                concat,
                                null
                            ));
                        else if (concat.length > 0)
                            resultsArr.push(concat[0]);
                        else if (concat.length === 0)
                            resultsArr.push(new Node(
                                NodeType.Text,
                                new TextRange(
                                    new TextPosition(argLineStart, argColStart, argOffsetStart),
                                    new TextPosition(this.tokenizer.lineStart, this.tokenizer.colStart, this.tokenizer.offsetStart)
                                ),
                                null,
                                ''
                            ));

                        if (token === TokenType.Pipe) {
                            token = this.tokenizer.advance();

                            // Reset
                            concat = [];

                            argLineStart = this.tokenizer.lineStart;
                            argColStart = this.tokenizer.colStart;
                            argOffsetStart = this.tokenizer.offsetStart;
                        }
                        else break; // RightBracket
                    }
                    else {
                        throw new Error('Unknown token type ' + this.tokenizer.peek() + ' ' + this.tokenizer.offsetStart + ':' + this.tokenizer.offsetEnd);
                    }
                }
            }

            const results: Node = new Node(
                NodeType.Results,
                new TextRange(
                    new TextPosition(resultsLineStart, resultsColStart, resultsOffsetStart),
                    new TextPosition(this.tokenizer.lineStart, this.tokenizer.colStart, this.tokenizer.offsetStart)
                ),
                resultsArr,
                null
            );

            if (token === TokenType.RightBracket)
                token = this.tokenizer.advance();
            else {
                this.errors.push(new LangError(
                    new TextRange(
                        new TextPosition(codeLineStart, codeColStart, codeOffsetStart),
                        new TextPosition(this.tokenizer.lineStart, this.tokenizer.colStart, this.tokenizer.offsetStart)
                    ),
                    this.missingSymbolResult
                ));
                return null;
            }

            return new Node(
                NodeType.Eval,
                new TextRange(
                    new TextPosition(codeLineStart, codeColStart, codeOffsetStart),
                    new TextPosition(this.tokenizer.lineStart, this.tokenizer.colStart, this.tokenizer.offsetStart)
                ),
                [retrieve, args, results],
                null
            );
        }
    }
}
package editor.Lang.Tokenize {

    public class Tokenizer {

        // Internal
        private var pos: int = 0;
        private var lineNum: int = 0;
        private var offset: int = 0;

        // Token start
        public var lineStart: int = 0;
        public var colStart: int = 0;
        public var offsetStart: int = 0;

        // Token end
        public var lineEnd: int = 0;
        public var colEnd: int = 0;
        public var offsetEnd: int = 0;

        private var ignoreNextWhitespace: Boolean = false;

        private var token: int; // or null
        private var text: String;
        private var tokenText: String;

        private static const STATE_TEXT: int = 0;
        private static const STATE_CODE: int = 1;
        private static const STATE_ARGS: int = 2;
        private static const STATE_RESULTS: int = 3;
        private var mode: Vector.<int> = new Vector.<int>();

        public function Tokenizer(text: String) {
            this.text = text;
            this.mode.push(STATE_TEXT); // Enter text
        }

        // Token start
        // public function get lineStart(): int { return this.lastLine; }
        // public function get colStart(): int { return this.lastCol; }
        // public function get offsetStart(): int { return this.lastOffset; };

        // Token end
        // public function get lineEnd(): int { return this.lineNum; }
        // public function get colEnd(): int { return this.col; }
        // public function get offsetEnd(): int { return this.offset; };

        /**
         * Repeatedly eats characters that match the given characters. Returns true if any characters were eaten.
         * @param chars String Array. Characters that match the string
         */
        private function eatWhile(start: int, ...chars: Array): int {
            var idx: int = 0;
            while (idx < chars.length) {
                if (this.text.charAt(start) !== chars[idx])
                    idx++;
                else {
                    start++;
                    idx = 0;
                }
            }
            return start;
        }

        /**
         * Repeatedly eats characters that do not match the given characters. Returns true if any characters were eaten.
         * @param notChars String Array. Characters that do not match the string
         */
        private function eatWhileNot(start: int, ...notChars: Array): int {
            var matchPos: int = start;
            var jumpPos: int = start;
            var matchFound: Boolean = false;

            var notCharsLength: int = notChars.length;
            for (var idx: int = 0; idx < notCharsLength; ++idx) {
                matchPos = this.text.indexOf(notChars[idx], start);

                // Match was found
                if (~matchPos) {
                    matchFound = true;
                    // char found at start position
                    // cannnot progress
                    if (matchPos === start) {
                        jumpPos = start;
                        break;
                    }
                    // Match found at farther position
                    if (jumpPos > matchPos || jumpPos === start)
                        jumpPos = matchPos;
                }
            }

            // Nothing matched so the rest of the string is ok
            if (!matchFound)
                return this.text.length;
            else
                return jumpPos;
        }

        public function getText(): String {
            return this.tokenText;
        }

        public function peek(): int {
            if (!this.token)
                this.token = this.advance();
            return this.token;
        }

        public function advance(): int {
            if (this.ignoreNextWhitespace) {
                this.ignoreNextWhitespace = false;
                // Advance while the next character is " " or "\n"
                while (this.pos < this.text.length && this.text.indexOf(Symbols.Newline, this.pos) == this.pos) {
                    this.lineNum++;
                    this.offset = ++this.pos;
                    while (this.pos < this.text.length && this.text.indexOf(Symbols.Space, this.pos) == this.pos)
                        ++this.pos;
                }
            }

            this.lineStart = this.lineNum;
            this.colStart = this.pos - this.offset;
            this.offsetStart = this.pos;

            this.token = this.tokenize();

            return this.token;
        }

        private function tokenize(): int {
            if (this.pos >= this.text.length)
                return TokenType.EOS;

            switch (this.mode[this.mode.length - 1]) {
                case STATE_TEXT: return this.textMode();
                case STATE_CODE: return this.codeMode();
                case STATE_ARGS: return this.argsMode();
                case STATE_RESULTS: return this.resultsMode();
                default: throw new Error('Invalid Tokenizer Mode');
            }
        }


        // Rewrite to switch tokenization between old and new parser
        // because dealing with spaces as a delimiter is such a pain.


        private function textMode(): int {
            this.tokenText = this.text.charAt(this.pos);
            switch (this.tokenText) {
                case Symbols.LeftBracket: {
                    this.mode.push(STATE_CODE); // Enter code

                    ++this.pos;
                    this.lineEnd = this.lineNum;
                    this.colEnd = this.pos - this.offset;
                    this.offsetEnd = this.pos;

                    this.ignoreNextWhitespace = true;

                    return TokenType.LeftBracket;
                }
                default: {
                    this.tokenText = '';
                    while (this.pos < this.text.length) {
                        var subStrStart: int = this.pos;

                        this.pos = this.eatWhileNot(
                            this.pos,
                            Symbols.Newline,
                            Symbols.Backslash, 
                            Symbols.LeftBracket
                        );

                        this.tokenText += this.text.substring(subStrStart, this.pos);

                        var char: String = this.text.charAt(this.pos);
                        if (char === Symbols.Backslash) {
                            this.tokenText += this.text.charAt(this.pos + 1);
                            this.pos += 2;
                        }
                        else if (char === Symbols.Newline) {
                            this.lineNum++;
                            this.offset = ++this.pos;
                            this.tokenText += Symbols.Newline;
                        }
                        else {
                            break;
                        }
                    }

                    this.lineEnd = this.lineNum;
                    this.colEnd = this.pos - this.offset;
                    this.offsetEnd = this.pos;

                    return TokenType.Text;
                }
            }
        }

        private function codeMode(): int {
            var token: int;
            this.tokenText = this.text.charAt(this.pos);
            switch (this.tokenText) {
                case Symbols.QuestionMark: {
                    ++this.pos;
                    this.ignoreNextWhitespace = true;

                    token = TokenType.QuestionMark;
                    break;
                }
                case Symbols.Colon: {
                    this.mode.push(STATE_RESULTS); // Enter results

                    ++this.pos;
                    this.ignoreNextWhitespace = true;

                    token = TokenType.ResultsStart;
                    break;
                }
                case Symbols.RightBracket: {
                    this.mode.pop(); // Exit code

                    ++this.pos;

                    token = TokenType.RightBracket;
                    break;
                }
                case Symbols.Dot: {
                    ++this.pos;

                    token = TokenType.Dot;
                    break;
                }
                case Symbols.Newline:
                case Symbols.Space: {
                    this.mode.push(STATE_ARGS); // Enter args

                    // Advance while the next character is " " or "\n"
                    while (this.pos < this.text.length) {
                        if (this.text.indexOf(Symbols.Space, this.pos) == this.pos)
                            ++this.pos;
                        else if (this.text.indexOf(Symbols.Newline, this.pos) == this.pos) {
                            this.lineNum++;
                            this.offset = ++this.pos;
                        }
                        else break;
                    }

                    token = TokenType.ArgsStart;
                    break;
                }
                default: {
                    var startPos: int = this.pos;

                    this.pos = this.eatWhileNot(
                        this.pos,
                        Symbols.Newline,
                        Symbols.Dot,
                        Symbols.Space,
                        Symbols.Colon,
                        Symbols.RightBracket
                    );

                    this.tokenText = this.text.substring(startPos, this.pos);

                    token = TokenType.Text;
                    break;
                }
            }

            this.lineEnd = this.lineNum;
            this.colEnd = this.pos - this.offset;
            this.offsetEnd = this.pos;

            return token;
        }

        private function argsMode(): int {
            this.tokenText = this.text.charAt(this.pos);
            switch (this.tokenText) {
                case Symbols.LeftBracket:
                case Symbols.RightBracket:
                case Symbols.Pipe:
                case Symbols.Colon: {
                    switch (this.tokenText) {
                        case Symbols.LeftBracket: {
                            this.mode.push(STATE_CODE); // Enter code
                            break;
                        }
                        case Symbols.RightBracket: {
                            this.mode.pop(); // Exit args
                            this.mode.pop(); // Exit code
                            break;
                        }
                        case Symbols.Colon: {
                            this.mode.pop(); // Exit args
                            this.mode.push(STATE_RESULTS); // Enter results
                            break;
                        }
                    }

                    ++this.pos;
                    this.lineEnd = this.lineNum;
                    this.colEnd = this.pos - this.offset;
                    this.offsetEnd = this.pos;
                    this.ignoreNextWhitespace = this.tokenText !== Symbols.RightBracket;

                    switch (this.tokenText) {
                        case Symbols.LeftBracket: return TokenType.LeftBracket;
                        case Symbols.RightBracket: return TokenType.RightBracket;
                        case Symbols.Pipe: return TokenType.Pipe;
                        case Symbols.Colon: return TokenType.ResultsStart;
                    }
                }
                default: {
                    this.tokenText = '';
                    var whitespace: String = '';
                    while (this.pos < this.text.length) {
                        var subStrStart: int = this.pos;

                        this.pos = this.eatWhileNot(
                            this.pos,
                            Symbols.Newline,
                            Symbols.LeftBracket,
                            Symbols.RightBracket,
                            Symbols.Pipe,
                            Symbols.Colon,
                            Symbols.Backslash
                        );

                        if (subStrStart < this.pos) {
                            if (whitespace.length > 0) {
                                this.tokenText += whitespace + this.text.substring(subStrStart, this.pos);
                                whitespace = '';
                            }
                            else {
                                this.tokenText += this.text.substring(subStrStart, this.pos);
                            }
                        }

                        this.lineEnd = this.lineNum;
                        this.colEnd = this.pos - this.offset;
                        this.offsetEnd = this.pos;

                        var char: String = this.text.charAt(this.pos);
                        if (char === Symbols.Backslash) {
                            this.tokenText += this.text.charAt(++this.pos);
                            ++this.pos;
                        }
                        else if (char === Symbols.Newline) {
                            this.lineNum++;
                            this.offset = ++this.pos;
                            whitespace += Symbols.Newline;

                            // Advance while the next character is " "
                            while (this.text.indexOf(Symbols.Space, this.pos) == this.pos) ++this.pos;
                        }
                        else {
                            break;
                        }
                    }

                    return TokenType.Text;
                }
            }
        }

        private function resultsMode(): int {
            this.tokenText = this.text.charAt(this.pos);
            switch (this.text.charAt(this.pos)) {
                case Symbols.LeftBracket:
                case Symbols.RightBracket:
                case Symbols.Pipe: {
                    switch (this.tokenText) {
                        case Symbols.LeftBracket: {
                            this.mode.push(STATE_CODE); // Enter code
                            break;
                        }
                        case Symbols.RightBracket: {
                            this.mode.pop(); // Exit results
                            this.mode.pop(); // Exit code
                            break;
                        }
                    }

                    ++this.pos;
                    this.lineEnd = this.lineNum;
                    this.colEnd = this.pos - this.offset;
                    this.offsetEnd = this.pos;
                    this.ignoreNextWhitespace = this.tokenText !== Symbols.RightBracket;

                    switch (this.tokenText) {
                        case Symbols.LeftBracket: return TokenType.LeftBracket;
                        case Symbols.RightBracket: return TokenType.RightBracket;
                        case Symbols.Pipe: return TokenType.Pipe;
                    }
                }
                default: {
                    this.tokenText = '';
                    var whitespace: String = '';
                    while (this.pos < this.text.length) {
                        var subStrStart: int = this.pos;

                        this.pos = this.eatWhileNot(
                            this.pos,
                            Symbols.Newline,
                            Symbols.LeftBracket,
                            Symbols.RightBracket,
                            Symbols.Pipe,
                            Symbols.Backslash
                        );

                        if (subStrStart < this.pos) {
                            if (whitespace.length > 0) {
                                this.tokenText += whitespace + this.text.substring(subStrStart, this.pos);
                                whitespace = '';
                            }
                            else {
                                this.tokenText += this.text.substring(subStrStart, this.pos);
                            }
                        }

                        this.lineEnd = this.lineNum;
                        this.colEnd = this.pos - this.offset;
                        this.offsetEnd = this.pos;

                        var char: String = this.text.charAt(this.pos);
                        if (char === Symbols.Backslash) {
                            this.tokenText += this.text.charAt(this.pos + 1);
                            this.pos += 2;
                            this.offset = this.pos;
                        }
                        else if (char === Symbols.Newline) {
                            this.lineNum++;
                            this.offset = ++this.pos;
                            whitespace += Symbols.Newline;

                            // Advance while the next character is " "
                            this.pos = this.eatWhile(this.pos, Symbols.Space);
                        }
                        else {
                            break;
                        }
                    }

                    return TokenType.Text;
                }
            }
        }
    }
}
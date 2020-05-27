package editor.Testing {
    import editor.Lang.Tokenize.Tokenizer;
    import editor.Lang.Tokenize.TokenType;

    public class TokenizerTests implements ITests {
        private function failed(type: String, value1: *, value2: *): String {
            return 'Failed: Supplied ' + type + ' "' + value1 + '" !== computed "' + value2 + '"';
        }

        private function match(text: String, tokens: Array): String {
            var tokenizer: Tokenizer = new Tokenizer(text);

            for each (var token: Object in tokens) {
                if (token.type !== tokenizer.peek()) {
                    return failed('type', token.type, tokenizer.peek());
                }
                if (token.text !== tokenizer.getText()) {
                    return failed('text', token.text, tokenizer.getText());
                }
                if (token.offsetStart !== tokenizer.offsetStart) {
                    return failed('offsetStart', token.offsetStart, tokenizer.offsetStart);
                }
                if (token.offsetEnd !== tokenizer.offsetEnd) {
                    return failed('offsetEnd', token.offsetEnd, tokenizer.offsetEnd);
                }
                if (token.lineStart !== tokenizer.lineStart) {
                    return failed('lineStart', token.lineStart, tokenizer.lineStart);
                }
                if (token.lineEnd !== tokenizer.lineEnd) {
                    return failed('lineEnd', token.lineEnd, tokenizer.lineEnd);
                }
                if (token.colStart !== tokenizer.colStart) {
                    return failed('columnStart', token.colStart, tokenizer.colStart);
                }
                if (token.colEnd !== tokenizer.colEnd) {
                    return failed('columnEnd', token.colEnd, tokenizer.colEnd);
                }

                tokenizer.advance();
            }
            return 'Success';
        }

        private function test(title: String, text: String, tokens: Array): void {
            out += '  ' + title + ' ... ' + match(text, tokens) + '\n';
        }

        private var out: String;

        public function run(): String {
            out = 'Tokenizer\n';
            test('Text',
                'asdf',
                [{
                    type: TokenType.Text,
                    text: 'asdf',
                    offsetStart: 0, offsetEnd: 4,
                    lineStart: 0, lineEnd: 0,
                    colStart: 0, colEnd: 4
                }]
            );

            test('Text with newline',
                'a\nb',
                [{
                    type: TokenType.Text,
                    text: 'a\nb',
                    offsetStart: 0, offsetEnd: 3,
                    lineStart: 0, lineEnd: 1,
                    colStart: 0, colEnd: 1
                }]
            );

            test('Parser',
                '[a]',
                [{
                    type: TokenType.LeftBracket,
                    text: '[',
                    offsetStart: 0, offsetEnd: 1,
                    lineStart: 0, lineEnd: 0,
                    colStart: 0, colEnd: 1
                },
                {
                    type: TokenType.Text,
                    text: 'a',
                    offsetStart: 1, offsetEnd: 2,
                    lineStart: 0, lineEnd: 0,
                    colStart: 1, colEnd: 2
                },
                {
                    type: TokenType.RightBracket,
                    text: ']',
                    offsetStart: 2, offsetEnd: 3,
                    lineStart: 0, lineEnd: 0,
                    colStart: 2, colEnd: 3
                }]
            );

            test('Parser with dot',
                '[a.b]',
                [{
                    type: TokenType.LeftBracket,
                    text: '[',
                    offsetStart: 0, offsetEnd: 1,
                    lineStart: 0, lineEnd: 0,
                    colStart: 0, colEnd: 1
                },
                {
                    type: TokenType.Text,
                    text: 'a',
                    offsetStart: 1, offsetEnd: 2,
                    lineStart: 0, lineEnd: 0,
                    colStart: 1, colEnd: 2
                },
                {
                    type: TokenType.Dot,
                    text: '.',
                    offsetStart: 2, offsetEnd: 3,
                    lineStart: 0, lineEnd: 0,
                    colStart: 2, colEnd: 3
                },
                {
                    type: TokenType.Text,
                    text: 'b',
                    offsetStart: 3, offsetEnd: 4,
                    lineStart: 0, lineEnd: 0,
                    colStart: 3, colEnd: 4
                },
                {
                    type: TokenType.RightBracket,
                    text: ']',
                    offsetStart: 4, offsetEnd: 5,
                    lineStart: 0, lineEnd: 0,
                    colStart: 4, colEnd: 5
                }]
            );

            test('Parser with args',
                '[a 1|2]',
                [{
                    type: TokenType.LeftBracket,
                    text: '[',
                    offsetStart: 0, offsetEnd: 1,
                    lineStart: 0, lineEnd: 0,
                    colStart: 0, colEnd: 1
                },
                {
                    type: TokenType.Text,
                    text: 'a',
                    offsetStart: 1, offsetEnd: 2,
                    lineStart: 0, lineEnd: 0,
                    colStart: 1, colEnd: 2
                },
                {
                    type: TokenType.ArgsStart,
                    text: ' ',
                    offsetStart: 2, offsetEnd: 3,
                    lineStart: 0, lineEnd: 0,
                    colStart: 2, colEnd: 3
                },
                {
                    type: TokenType.Text,
                    text: '1',
                    offsetStart: 3, offsetEnd: 4,
                    lineStart: 0, lineEnd: 0,
                    colStart: 3, colEnd: 4
                },
                {
                    type: TokenType.Pipe,
                    text: '|',
                    offsetStart: 4, offsetEnd: 5,
                    lineStart: 0, lineEnd: 0,
                    colStart: 4, colEnd: 5
                },
                {
                    type: TokenType.Text,
                    text: '2',
                    offsetStart: 5, offsetEnd: 6,
                    lineStart: 0, lineEnd: 0,
                    colStart: 5, colEnd: 6
                },
                {
                    type: TokenType.RightBracket,
                    text: ']',
                    offsetStart: 6, offsetEnd: 7,
                    lineStart: 0, lineEnd: 0,
                    colStart: 6, colEnd: 7
                }]
            );

            test('Parser with results',
                '[a:1|2]',
                [{
                    type: TokenType.LeftBracket,
                    text: '[',
                    offsetStart: 0, offsetEnd: 1,
                    lineStart: 0, lineEnd: 0,
                    colStart: 0, colEnd: 1
                },
                {
                    type: TokenType.Text,
                    text: 'a',
                    offsetStart: 1, offsetEnd: 2,
                    lineStart: 0, lineEnd: 0,
                    colStart: 1, colEnd: 2
                },
                {
                    type: TokenType.ResultsStart,
                    text: ':',
                    offsetStart: 2, offsetEnd: 3,
                    lineStart: 0, lineEnd: 0,
                    colStart: 2, colEnd: 3
                },
                {
                    type: TokenType.Text,
                    text: '1',
                    offsetStart: 3, offsetEnd: 4,
                    lineStart: 0, lineEnd: 0,
                    colStart: 3, colEnd: 4
                },
                {
                    type: TokenType.Pipe,
                    text: '|',
                    offsetStart: 4, offsetEnd: 5,
                    lineStart: 0, lineEnd: 0,
                    colStart: 4, colEnd: 5
                },
                {
                    type: TokenType.Text,
                    text: '2',
                    offsetStart: 5, offsetEnd: 6,
                    lineStart: 0, lineEnd: 0,
                    colStart: 5, colEnd: 6
                },
                {
                    type: TokenType.RightBracket,
                    text: ']',
                    offsetStart: 6, offsetEnd: 7,
                    lineStart: 0, lineEnd: 0,
                    colStart: 6, colEnd: 7
                }]
            );

            test('Parser with args and results',
                '[a 1:2]',
                [{
                    type: TokenType.LeftBracket,
                    text: '[',
                    offsetStart: 0, offsetEnd: 1,
                    lineStart: 0, lineEnd: 0,
                    colStart: 0, colEnd: 1
                },
                {
                    type: TokenType.Text,
                    text: 'a',
                    offsetStart: 1, offsetEnd: 2,
                    lineStart: 0, lineEnd: 0,
                    colStart: 1, colEnd: 2
                },
                {
                    type: TokenType.ArgsStart,
                    text: ' ',
                    offsetStart: 2, offsetEnd: 3,
                    lineStart: 0, lineEnd: 0,
                    colStart: 2, colEnd: 3
                },
                {
                    type: TokenType.Text,
                    text: '1',
                    offsetStart: 3, offsetEnd: 4,
                    lineStart: 0, lineEnd: 0,
                    colStart: 3, colEnd: 4
                },
                {
                    type: TokenType.ResultsStart,
                    text: ':',
                    offsetStart: 4, offsetEnd: 5,
                    lineStart: 0, lineEnd: 0,
                    colStart: 4, colEnd: 5
                },
                {
                    type: TokenType.Text,
                    text: '2',
                    offsetStart: 5, offsetEnd: 6,
                    lineStart: 0, lineEnd: 0,
                    colStart: 5, colEnd: 6
                },
                {
                    type: TokenType.RightBracket,
                    text: ']',
                    offsetStart: 6, offsetEnd: 7,
                    lineStart: 0, lineEnd: 0,
                    colStart: 6, colEnd: 7
                }]
            );

            return out;
        }
    }
}
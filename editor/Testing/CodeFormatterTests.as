package editor.Testing {
    import editor.Lang.Codify.CodeNode;
    import editor.Lang.Codify.CodeFormatter;

    public class CodeFormatterTests implements ITests {

        private function match(body: Array, testText: String): String {
            var formatter: CodeFormatter = new CodeFormatter('outputText');

            formatter.interpret(body);

            var compResult: String = formatter.result;

            if (testText !== compResult) return TestUtils.failed('text', testText, compResult);

            return 'Success';
        }

        private function test(title: String, body: Array, resultText: String): void {
            out += '  ' + title + ' ... ' + match(body, resultText) + '\n';
        }

        private var out: String = '';
        public function run(): String {
            out = 'Codifier\n';

            test('Text - "asdf"', 
                [
                    new CodeNode(CodeNode.Text, 'asdf')
                ],
                'outputText("asdf");\n'
            );
            
            test('Code - "asdf"',
                [
                    new CodeNode(CodeNode.Code, 'asdf')
                ],
                'asdf\n'
            );

            test('Join text',
                [
                    new CodeNode(CodeNode.Text, '<b>'),
                    new CodeNode(CodeNode.Text, 'this'),
                    new CodeNode(CodeNode.Text, '</b>')
                ],
                'outputText("<b>this</b>");\n'
            );

            test('Code blocks',
                [
                    new CodeNode(CodeNode.Code, 'if (a === b)',
                    [
                        new CodeNode(CodeNode.Text, 'a === b')
                    ]),
                    new CodeNode(CodeNode.Code, 'else',
                    [
                        new CodeNode(CodeNode.Text, 'a !== b')
                    ])
                ],
                'if (a === b) {\n' +
                '    outputText("a === b");\n' +
                '}\n' +
                'else {\n' +
                '    outputText("a !== b");\n' +
                '}\n'
            );

            return out;
        }
    }
}
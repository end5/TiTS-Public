package editor.Testing {
    import editor.Lang.Codify.CodeTranslator;
    import editor.Lang.Parse.Node;
    import editor.Lang.Errors.LangError;
    import editor.Lang.Codify.CodeNode;
    import editor.Lang.Parse.NodeType;
    import editor.Lang.TextRange;
    import editor.Lang.TextPosition;

    public class CodeTranslatorTests implements ITests {
        private function compareNodes(node1: CodeNode, node2: CodeNode): Array {
            var out: Array = [];
    
            if (node1.type !== node2.type)
                out.push(TestUtils.failed('type', node1.type, node2.type));
    
            if (node1.value !== node2.value)
                out.push(TestUtils.failed('value', node1.value, node2.value));
    
            if ((node1.body == null && node2.body != null) || (node1.body != null && node2.body == null))
                out.push(TestUtils.failed('children', node1.body, node2.body));
    
            if (node1.body != null && node2.body != null && node1.body.length !== node2.body.length)
                out.push(TestUtils.failed('children.length', node1.body.length, node2.body.length));

            return out;
        }

        private function match(root: Node, global: Object, testCodeNodes: Array, testErrors: Array): String {
            var codifier: CodeTranslator = new CodeTranslator(global, global);

            const testSearch: Array = testCodeNodes.concat();
            const compSearch: Array = codifier.translate(root);

            var testNode: CodeNode;
            var compNode: CodeNode;

            while (compSearch.length > 0) {

                testNode = testSearch[testSearch.length - 1];
                compNode = compSearch[compSearch.length - 1];
                
                var failed: Array = compareNodes(testNode, compNode);
                if (failed.length > 0) {
                    return 'Failed: \n' + 
                        '    ' + failed.join('\n    ') + '\n' +
                        '    Test stack\n' +
                        '      ' + testSearch.join('\n      ') + '\n' +
                        '    Computed stack\n' +
                        '      ' + compSearch.join('\n      ');
                }

                testSearch.pop();
                compSearch.pop();

                if (testNode.body)
                    for (var idx: int = testNode.body.length - 1; idx >= 0; --idx) {
                        testSearch.push(testNode.body[idx]);
                    }

                if (compNode.body)
                    for (idx = compNode.body.length - 1; idx >= 0; --idx) {
                        compSearch.push(compNode.body[idx]);
                    }
            }

            var compErrors: Vector.<LangError> = codifier.errors;

            if (testErrors.length !== compErrors.length) return TestUtils.failed('error length', testErrors.length, compErrors.length);

            for (idx = 0; idx < compErrors.length; idx++) {
                var testError: LangError = testErrors[idx];
                var compError: LangError = compErrors[idx];

                var out: Array = TestUtils.compareTextRange('error ', testError.range, compError.range);
    
                if (testError.msg !== compError.msg)
                    out.push(TestUtils.failed('error message', testError.msg, compError.msg));

                if (out.length > 0)
                    return '    ' + out.join('\n    ') + '\n';
            }

            return 'Success';
        }

        private function test(title: String, root: Node, global: Object, resultNodes: Array, resultErrors: Array): void {
            out += '  ' + title + ' ... ' + match(root, global, resultNodes, resultErrors) + '\n';
        }

        private function offsetRange(start: int, end: int): TextRange {
            return new TextRange(new TextPosition(0, start, start), new TextPosition(0, end, end));
        }

        private function range(lineStart: int, colStart: int, offsetStart: int, lineEnd: int, colEnd: int, offsetEnd: int): TextRange {
            return new TextRange(new TextPosition(lineStart, colStart, offsetStart), new TextPosition(lineEnd, colEnd, offsetEnd));
        }

        private var out: String = '';
        public function run(): String {
            out = 'CodeTranslator\n';

            test('Text - "asdf"', new Node(NodeType.Text, offsetRange(0, 4), null, 'asdf'), {}, [new CodeNode(CodeNode.Text, 'asdf')], []);
            
            test('No arg or results - "[a]"',
                new Node(NodeType.Eval, offsetRange(0, 3),
                    [
                        new Node(NodeType.Retrieve, offsetRange(1, 2),
                            [
                                new Node(NodeType.Identity, offsetRange(1, 2), null, 'a')
                            ],
                            false
                        ),
                        new Node(NodeType.Args, offsetRange(2, 2), [], null),
                        new Node(NodeType.Results, offsetRange(2, 2), [], null)
                    ],
                    null
                ),
                {
                    a: function (identifier: String, args: Array, results: Array): Array {
                        return [new CodeNode(CodeNode.Code, 'aaaaa')];
                    }
                },
                [
                    new CodeNode(CodeNode.Code, 'aaaaa')
                ],
                []
            );

            test('One arg - "[bold this]"',
                new Node(NodeType.Eval, offsetRange(0, 11),
                    [
                        new Node(NodeType.Retrieve, offsetRange(1, 5),
                            [
                                new Node(NodeType.Identity, offsetRange(1, 5), null, 'bold')
                            ],
                            false
                        ),
                        new Node(NodeType.Args, offsetRange(5, 10),
                            [
                                new Node(NodeType.String, offsetRange(6, 10), null, 'this')
                            ],
                            null
                        ),
                        new Node(NodeType.Results, offsetRange(10, 10), [], null)
                    ],
                    null
                ),
                {
                    bold: function (identifier: String, args: Array, results: Array): Array {
                        var code: Array = [new CodeNode(CodeNode.Text, '<b>')];
                        for each (var child: * in args[0]) {
                            code.push(child);
                        }
                        code.push(new CodeNode(CodeNode.Text, '</b>'));
                        return code;
                    }
                },
                [
                    new CodeNode(CodeNode.Text, '<b>'),
                    new CodeNode(CodeNode.Text, 'this'),
                    new CodeNode(CodeNode.Text, '</b>')
                ],
                []
            );

            return out;
        }
    }
}
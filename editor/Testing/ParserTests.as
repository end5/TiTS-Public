package editor.Testing {
    import editor.Lang.Parse.Node;
    import editor.Lang.Parse.NodeType;
    import editor.Lang.TextRange;
    import editor.Lang.TextPosition;
    import editor.Lang.Parse.Parser;

    public class ParserTests implements ITests {

        private function compareNodes(node1: Node, node2: Node): Array {
            var out: Array = TestUtils.compareTextRange('node ', node1.range, node2.range);
    
            if (node1.type !== node2.type)
                out.push(TestUtils.failed('type', node1.type, node2.type));
    
            if (node1.value !== node2.value)
                out.push(TestUtils.failed('value', node1.value, node2.value));
    
            if ((node1.children == null && node2.children != null) || (node1.children != null && node2.children == null))
                out.push(TestUtils.failed('children', node1.children, node2.children));
    
            if (node1.children != null && node2.children != null && node1.children.length !== node2.children.length)
                out.push(TestUtils.failed('children.length', node1.children.length, node2.children.length));

            return out;
        }

        private function offsetRange(start: int, end: int): TextRange {
            return new TextRange(new TextPosition(0, start, start), new TextPosition(0, end, end));
        }

        private function range(lineStart: int, colStart: int, offsetStart: int, lineEnd: int, colEnd: int, offsetEnd: int): TextRange {
            return new TextRange(new TextPosition(lineStart, colStart, offsetStart), new TextPosition(lineEnd, colEnd, offsetEnd));
        }

        private function match(text: String, testRoot: Node): String {
            const parser: Parser = new Parser();
            parser.parse(text);
            
            const testSearch: Array = [testRoot];
            const compSearch: Array = [parser.root];

            var testNode: Node;
            var compNode: Node;

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

                if (testNode.children)
                    for (var idx: int = testNode.children.length - 1; idx >= 0; --idx) {
                        testSearch.push(testNode.children[idx]);
                    }

                if (compNode.children)
                    for (idx = compNode.children.length - 1; idx >= 0; --idx) {
                        compSearch.push(compNode.children[idx]);
                    }
            }

            return 'Success';
        }

        private function test(title: String, text: String, root: Node): void {
            out += '  ' + title + ' ... ' + match(text, root) + '\n';
        }

        private var out: String;

        public function run(): String {
            out = 'Parser\n';
            test('Text',
                'asdf',
                new Node(NodeType.Text, offsetRange(0, 4), null, 'asdf')
            );

            test('Parser',
                '[a]',
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
                )
            );

            test('Parser with args',
                '[a 1|b]',
                new Node(NodeType.Eval, offsetRange(0, 7),
                    [
                        new Node(NodeType.Retrieve, offsetRange(1, 2),
                            [
                                new Node(NodeType.Identity, offsetRange(1, 2), null, 'a')
                            ],
                            false
                        ),
                        new Node(NodeType.Args, offsetRange(2, 6),
                            [
                                new Node(NodeType.Number, offsetRange(3, 4), null, 1),
                                new Node(NodeType.String, offsetRange(5, 6), null, 'b')
                            ],
                            null
                        ),
                        new Node(NodeType.Results, offsetRange(6, 6), [], null)
                    ],
                    null
                )
            );

            test('Parser with arg and arg concat',
                '[a 1|b[c]]',
                new Node(NodeType.Eval, offsetRange(0, 10),
                    [
                        new Node(NodeType.Retrieve, offsetRange(1, 2),
                            [
                                new Node(NodeType.Identity, offsetRange(1, 2), null, 'a')
                            ],
                            false
                        ),
                        new Node(NodeType.Args, offsetRange(2, 9),
                            [
                                new Node(NodeType.Number, offsetRange(3, 4), null, 1),
                                new Node(NodeType.Concat, offsetRange(5, 9),
                                    [
                                        new Node(NodeType.String, offsetRange(5, 6), null, 'b'),
                                        new Node(NodeType.Eval, offsetRange(6, 9),
                                            [
                                                new Node(NodeType.Retrieve, offsetRange(7, 8),
                                                    [
                                                        new Node(NodeType.Identity, offsetRange(7, 8), null, 'c')
                                                    ],
                                                    false
                                                ),
                                                new Node(NodeType.Args, offsetRange(8, 8), [], null),
                                                new Node(NodeType.Results, offsetRange(8, 8), [], null)
                                            ],
                                            null
                                        )
                                    ],
                                    null
                                )
                            ],
                            null
                        ),
                        new Node(NodeType.Results, offsetRange(9, 9), [], null)
                    ], null
                )
            );

            test('Parser with results',
                '[a:1|b]',
                new Node(NodeType.Eval, offsetRange(0, 7),
                    [
                        new Node(NodeType.Retrieve, offsetRange(1, 2),
                            [
                                new Node(NodeType.Identity, offsetRange(1, 2), null, 'a')
                            ],
                            true
                        ),
                        new Node(NodeType.Args, offsetRange(2, 2), [], null),
                        new Node(NodeType.Results, offsetRange(2, 6),
                            [
                                new Node(NodeType.Text, offsetRange(3, 4), null, '1'),
                                new Node(NodeType.Text, offsetRange(5, 6), null, 'b')
                            ],
                            null
                        )
                    ],
                    null
                )
            );

            test('Parser with result and result concat',
                '[a:1|b[c]]',
                new Node(NodeType.Eval, offsetRange(0, 10),
                    [
                        new Node(NodeType.Retrieve, offsetRange(1, 2),
                            [
                                new Node(NodeType.Identity, offsetRange(1, 2), null, 'a')
                            ],
                            true
                        ),
                        new Node(NodeType.Args, offsetRange(2, 2), [], null),
                        new Node(NodeType.Results, offsetRange(2, 9),
                            [
                                new Node(NodeType.Text, offsetRange(3, 4), null, '1'),
                                new Node(NodeType.Concat, offsetRange(5, 9),
                                    [
                                        new Node(NodeType.Text, offsetRange(5, 6), null, 'b'),
                                        new Node(NodeType.Eval, offsetRange(6, 9),
                                            [
                                                new Node(NodeType.Retrieve, offsetRange(7, 8),
                                                    [
                                                        new Node(NodeType.Identity, offsetRange(7, 8), null, 'c')
                                                    ],
                                                    false
                                                ),
                                                new Node(NodeType.Args, offsetRange(8, 8), [], null),
                                                new Node(NodeType.Results, offsetRange(8, 8), [], null)
                                            ],
                                            null
                                        )
                                    ],
                                    null
                                )
                            ],
                            null
                        )
                    ],
                    null
                )
            );

            test('Concat',
                '[a]a',
                new Node(NodeType.Concat, offsetRange(0, 4),
                    [
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
                        new Node(NodeType.Text, offsetRange(3, 4), null, 'a'),
                    ],
                    null
                )
            );

            test('Spaces',
                '[a 1 : b ]',
                new Node(NodeType.Eval, offsetRange(0, 10),
                    [
                        new Node(NodeType.Retrieve, offsetRange(1, 2),
                            [
                                new Node(NodeType.Identity, offsetRange(1, 2), null, 'a')
                            ],
                            true
                        ),
                        new Node(NodeType.Args, offsetRange(2, 5),
                            [
                                new Node(NodeType.String, offsetRange(3, 5), null, '1 ')
                            ],
                            null
                        ),
                        new Node(NodeType.Results, offsetRange(5, 9),
                            [
                                new Node(NodeType.Text, offsetRange(6, 9), null, ' b ')
                            ],
                            null
                        )
                    ],
                    null
                )
            );

            test('Newlines',
                '[\na\n1\n:\nb\n]',
                new Node(NodeType.Eval, range(0,0,0, 5,1,11),
                    [
                        new Node(NodeType.Retrieve, range(1,0,2, 1,1,3),
                            [
                                new Node(NodeType.Identity, range(1,0,2, 1,1,3), null, 'a')
                            ],
                            true
                        ),
                        new Node(NodeType.Args, range(1,1,3, 3,0,6),
                            [
                                new Node(NodeType.Number, range(2,0,4, 2,1,5), null, 1)
                            ],
                            null
                        ),
                        new Node(NodeType.Results, range(3,0,6, 5,0,10),
                            [
                                new Node(NodeType.Text, range(4,0,8, 4,1,9), null, 'b')
                            ],
                            null
                        )
                    ],
                    null
                )
            );

            return out;
        }

    }
}
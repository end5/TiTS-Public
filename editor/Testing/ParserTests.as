package editor.Testing {
    import editor.Lang.Parse.Node;
    import editor.Lang.Parse.NodeType;
    import editor.Lang.TextRange;
    import editor.Lang.TextPosition;
    import editor.Lang.Parse.Parser;

    public class ParserTests implements ITests {

        private function failed(type: String, value1: *, value2: *): String {
            return 'Failed: Supplied ' + type + ' "' + value1 + '" !== computed "' + value2 + '"';
        }

        private function compareNodes(node1: Node, node2: Node): String {
            if (node1.type !== node2.type) return failed('type', node1.type, node2.type);
            if (node1.value !== node2.value) return failed('value', node1.value, node2.value);
            if (node1.range.start.offset !== node2.range.start.offset) return failed('offsetStart', node1.range.start.offset, node2.range.start.offset);
            if (node1.range.start.line !== node2.range.start.line) return failed('lineStart', node1.range.start.line, node2.range.start.line);
            if (node1.range.start.col !== node2.range.start.col) return failed('columnStart', node1.range.start.col, node2.range.start.col);
            if (node1.range.end.offset !== node2.range.end.offset) return failed('offsetEnd', node1.range.end.offset, node2.range.end.offset);
            if (node1.range.end.line !== node2.range.end.line) return failed('lineEnd', node1.range.end.line, node2.range.end.line);
            if (node1.range.end.col !== node2.range.end.col) return failed('columnEnd', node1.range.end.col, node2.range.end.col);
            if ((node1.children == null && node2.children != null) || (node1.children != null && node2.children == null)) return failed('children', node1.children, node2.children);
            if (node1.children != null && node2.children != null && node1.children.length !== node2.children.length) return failed('children.length', node1.children.length, node2.children.length);

            return null;
        }

        private function match(text: String, testRoot: Node): String {
            const parser: Parser = new Parser();
            parser.parse(text);
            
            const testSearch: Array = [testRoot];
            const compSearch: Array = [parser.root];

            var testNode: Node;
            var compNode: Node;

            var failed: String;

            while (compSearch.length > 0) {

                testNode = testSearch[testSearch.length - 1];
                compNode = compSearch[compSearch.length - 1];
                
                failed = compareNodes(testNode, compNode);
                if (failed !== null) {
                    return 'Failed: ' + failed + '\n' +
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
                new Node(NodeType.Text, new TextRange(new TextPosition(0,0,0), new TextPosition(0,4,4)), null, 'asdf')
            );

            test('Parser',
                '[a]',
                new Node(
                    NodeType.Eval, 
                    new TextRange(new TextPosition(0,0,0), new TextPosition(0,3,3)),
                    [
                        new Node(
                            NodeType.Retrieve,
                            new TextRange(new TextPosition(0,1,1), new TextPosition(0,2,2)),
                            [
                                new Node(
                                    NodeType.Identity,
                                    new TextRange(new TextPosition(0,1,1), new TextPosition(0,2,2)),
                                    null,
                                    'a'
                                )
                            ],
                            false
                        ),
                        new Node(
                            NodeType.Args,
                            new TextRange(new TextPosition(0,2,2), new TextPosition(0,2,2)),
                            [],
                            null
                        ),
                        new Node(
                            NodeType.Results,
                            new TextRange(new TextPosition(0,2,2), new TextPosition(0,2,2)),
                            [],
                            null
                        )
                    ],
                    null
                )
            );

            test('Parser with args',
                '[a 1|b]',
                new Node(
                    NodeType.Eval, 
                    new TextRange(new TextPosition(0,0,0), new TextPosition(0,7,7)),
                    [
                        new Node(
                            NodeType.Retrieve,
                            new TextRange(new TextPosition(0,1,1), new TextPosition(0,2,2)),
                            [
                                new Node(
                                    NodeType.Identity,
                                    new TextRange(new TextPosition(0,1,1), new TextPosition(0,2,2)),
                                    null,
                                    'a'
                                )
                            ],
                            false
                        ),
                        new Node(
                            NodeType.Args,
                            new TextRange(new TextPosition(0,2,2), new TextPosition(0,6,6)),
                            [
                                new Node(
                                    NodeType.Number,
                                    new TextRange(new TextPosition(0,3,3), new TextPosition(0,4,4)),
                                    null,
                                    1
                                ),
                                new Node(
                                    NodeType.String,
                                    new TextRange(new TextPosition(0,5,5), new TextPosition(0,6,6)),
                                    null,
                                    'b'
                                )
                            ],
                            null
                        ),
                        new Node(
                            NodeType.Results,
                            new TextRange(new TextPosition(0,6,6), new TextPosition(0,6,6)),
                            [],
                            null
                        )
                    ],
                    null
                )
            );

            test('Parser with arg and arg concat',
                '[a 1|b[c]]',
                new Node(
                    NodeType.Eval, 
                    new TextRange(new TextPosition(0,0,0), new TextPosition(0,10,10)),
                    [
                        new Node(
                            NodeType.Retrieve,
                            new TextRange(new TextPosition(0,1,1), new TextPosition(0,2,2)),
                            [
                                new Node(
                                    NodeType.Identity,
                                    new TextRange(new TextPosition(0,1,1), new TextPosition(0,2,2)),
                                    null,
                                    'a'
                                )
                            ],
                            false
                        ),
                        new Node(
                            NodeType.Args,
                            new TextRange(new TextPosition(0,2,2), new TextPosition(0,9,9)),
                            [
                                new Node(
                                    NodeType.Number,
                                    new TextRange(new TextPosition(0,3,3), new TextPosition(0,4,4)),
                                    null,
                                    1
                                ),
                                new Node(
                                    NodeType.Concat, 
                                    new TextRange(new TextPosition(0,5,5), new TextPosition(0,9,9)),
                                    [
                                        new Node(
                                            NodeType.String,
                                            new TextRange(new TextPosition(0,5,5), new TextPosition(0,6,6)),
                                            null,
                                            'b'
                                        ),
                                        new Node(
                                            NodeType.Eval, 
                                            new TextRange(new TextPosition(0,6,6), new TextPosition(0,9,9)),
                                            [
                                                new Node(
                                                    NodeType.Retrieve,
                                                    new TextRange(new TextPosition(0,7,7), new TextPosition(0,8,8)),
                                                    [
                                                        new Node(
                                                            NodeType.Identity,
                                                            new TextRange(new TextPosition(0,7,7), new TextPosition(0,8,8)),
                                                            null,
                                                            'c'
                                                        )
                                                    ],
                                                    false
                                                ),
                                                new Node(
                                                    NodeType.Args,
                                                    new TextRange(new TextPosition(0,8,8), new TextPosition(0,8,8)),
                                                    [],
                                                    null
                                                ),
                                                new Node(
                                                    NodeType.Results,
                                                    new TextRange(new TextPosition(0,8,8), new TextPosition(0,8,8)),
                                                    [],
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
                        ),
                        new Node(
                            NodeType.Results,
                            new TextRange(new TextPosition(0,9,9), new TextPosition(0,9,9)),
                            [],
                            null
                        )
                    ],
                    null
                )
            );

            test('Parser with results',
                '[a:1|b]',
                new Node(
                    NodeType.Eval, 
                    new TextRange(new TextPosition(0,0,0), new TextPosition(0,7,7)),
                    [
                        new Node(
                            NodeType.Retrieve,
                            new TextRange(new TextPosition(0,1,1), new TextPosition(0,2,2)),
                            [
                                new Node(
                                    NodeType.Identity,
                                    new TextRange(new TextPosition(0,1,1), new TextPosition(0,2,2)),
                                    null,
                                    'a'
                                )
                            ],
                            false
                        ),
                        new Node(
                            NodeType.Args,
                            new TextRange(new TextPosition(0,2,2), new TextPosition(0,2,2)),
                            [],
                            null
                        ),
                        new Node(
                            NodeType.Results,
                            new TextRange(new TextPosition(0,2,2), new TextPosition(0,6,6)),
                            [
                                new Node(
                                    NodeType.Text,
                                    new TextRange(new TextPosition(0,3,3), new TextPosition(0,4,4)),
                                    null,
                                    '1'
                                ),
                                new Node(
                                    NodeType.Text,
                                    new TextRange(new TextPosition(0,5,5), new TextPosition(0,6,6)),
                                    null,
                                    'b'
                                )
                            ],
                            null
                        )
                    ],
                    null
                )
            );

            test('Parser with result and result concat',
                '[a:1|b[c]]',
                new Node(
                    NodeType.Eval, 
                    new TextRange(new TextPosition(0,0,0), new TextPosition(0,10,10)),
                    [
                        new Node(
                            NodeType.Retrieve,
                            new TextRange(new TextPosition(0,1,1), new TextPosition(0,2,2)),
                            [
                                new Node(
                                    NodeType.Identity,
                                    new TextRange(new TextPosition(0,1,1), new TextPosition(0,2,2)),
                                    null,
                                    'a'
                                )
                            ],
                            false
                        ),
                        new Node(
                            NodeType.Args,
                            new TextRange(new TextPosition(0,2,2), new TextPosition(0,2,2)),
                            [],
                            null
                        ),
                        new Node(
                            NodeType.Results,
                            new TextRange(new TextPosition(0,2,2), new TextPosition(0,9,9)),
                            [
                                new Node(
                                    NodeType.Text,
                                    new TextRange(new TextPosition(0,3,3), new TextPosition(0,4,4)),
                                    null,
                                    '1'
                                ),
                                new Node(
                                    NodeType.Concat, 
                                    new TextRange(new TextPosition(0,5,5), new TextPosition(0,9,9)),
                                    [
                                        new Node(
                                            NodeType.Text,
                                            new TextRange(new TextPosition(0,5,5), new TextPosition(0,6,6)),
                                            null,
                                            'b'
                                        ),
                                        new Node(
                                            NodeType.Eval, 
                                            new TextRange(new TextPosition(0,6,6), new TextPosition(0,9,9)),
                                            [
                                                new Node(
                                                    NodeType.Retrieve,
                                                    new TextRange(new TextPosition(0,7,7), new TextPosition(0,8,8)),
                                                    [
                                                        new Node(
                                                            NodeType.Identity,
                                                            new TextRange(new TextPosition(0,7,7), new TextPosition(0,8,8)),
                                                            null,
                                                            'c'
                                                        )
                                                    ],
                                                    false
                                                ),
                                                new Node(
                                                    NodeType.Args,
                                                    new TextRange(new TextPosition(0,8,8), new TextPosition(0,8,8)),
                                                    [],
                                                    null
                                                ),
                                                new Node(
                                                    NodeType.Results,
                                                    new TextRange(new TextPosition(0,8,8), new TextPosition(0,8,8)),
                                                    [],
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
                    ],
                    null
                )
            );

            test('Concat',
                '[a]a',
                new Node(
                    NodeType.Concat, 
                    new TextRange(new TextPosition(0,0,0), new TextPosition(0,4,4)),
                    [
                        new Node(
                            NodeType.Eval, 
                            new TextRange(new TextPosition(0,0,0), new TextPosition(0,3,3)),
                            [
                                new Node(
                                    NodeType.Retrieve,
                                    new TextRange(new TextPosition(0,1,1), new TextPosition(0,2,2)),
                                    [
                                        new Node(
                                            NodeType.Identity,
                                            new TextRange(new TextPosition(0,1,1), new TextPosition(0,2,2)),
                                            null,
                                            'a'
                                        )
                                    ],
                                    false
                                ),
                                new Node(
                                    NodeType.Args,
                                    new TextRange(new TextPosition(0,2,2), new TextPosition(0,2,2)),
                                    [],
                                    null
                                ),
                                new Node(
                                    NodeType.Results,
                                    new TextRange(new TextPosition(0,2,2), new TextPosition(0,2,2)),
                                    [],
                                    null
                                )
                            ],
                            null
                        ),
                        new Node(
                            NodeType.Text,
                            new TextRange(new TextPosition(0,3,3), new TextPosition(0,4,4)),
                            null,
                            'a'
                        ),
                    ],
                    null
                )
            );

            return out;
        }

    }
}
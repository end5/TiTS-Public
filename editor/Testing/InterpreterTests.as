package editor.Testing {
    import editor.Lang.Errors.LangError;
    import editor.Lang.Interpret.Interpreter;
    import editor.Lang.Parse.Node;
    import editor.Lang.Parse.NodeType;
    import editor.Lang.TextPosition;
    import editor.Lang.TextRange;

    public class InterpreterTests implements ITests {
        private function match(root: Node, info: Object, global: Object, testText: String, testErrors: Array): String {
            var interpreter: Interpreter = new Interpreter(global, info, global, info);

            interpreter.interpret(root);

            var compResult: String = interpreter.result;
            var compErrors: Vector.<LangError> = interpreter.errors;

            if (testText !== compResult) return TestUtils.failed('text', testText, compResult);
            if (testErrors.length !== compErrors.length) return TestUtils.failed('error length', testErrors.length, compErrors.length);

            for (var idx: int = 0; idx < compErrors.length; idx++) {
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

        private function test(title: String, root: Node, info: Object, global: Object, resultText: String, resultErrors: Array): void {
            out += '  ' + title + ' ... ' + match(root, info, global, resultText, resultErrors) + '\n';
        }

        private function offsetRange(start: int, end: int): TextRange {
            return new TextRange(new TextPosition(0, start, start), new TextPosition(0, end, end));
        }

        private function range(lineStart: int, colStart: int, offsetStart: int, lineEnd: int, colEnd: int, offsetEnd: int): TextRange {
            return new TextRange(new TextPosition(lineStart, colStart, offsetStart), new TextPosition(lineEnd, colEnd, offsetEnd));
        }

        private var out: String = '';
        public function run(): String {
            out = 'Interpreter\n';

            test('Text - "asdf"', new Node(NodeType.Text, offsetRange(0, 4), null, 'asdf'), {}, {}, 'asdf', []);
            
            test('No arg or results - "[a]"',
                // "[a]",
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
                    a: function (args: Array, results: int): String {
                        if (args.length > 0) return 'Too many args';
                        if (results > 0) return 'Too many results';
                        return null;
                    }
                },
                {
                    a: function (): String {
                        return 'aaaaa';
                    }
                },
                'aaaaa',
                []
            );

            test('One arg - "[bold this]"',
                // "[bold this]",
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
                    bold: function (args: Array, results: int): String {
                        if (args.length === 0) return 'Needs at least one arg';
                        if (args.length > 1) return 'Too many args';
                        if (results > 0) return 'Too many results';
                        return null;
                    }
                },
                {
                    bold: function (text: String): String {
                        return '<b>' + text + '</b>';
                    }
                },
                '<b>this</b>',
                []
            );

            test('Select result - "[first:one|two|three|four|five]"',
                // '[first:one|two|three|four|five]',
                new Node(NodeType.Eval, offsetRange(0, 32),
                    [
                        new Node(NodeType.Retrieve, offsetRange(1, 6),
                            [
                                new Node(NodeType.Identity, offsetRange(1, 6), null, 'first')
                            ],
                            false
                        ),
                        new Node(NodeType.Args, offsetRange(6, 6), [], null),
                        new Node(NodeType.Results, offsetRange(7, 31),
                            [
                                new Node(NodeType.String, offsetRange(8, 11), null, 'one'),
                                new Node(NodeType.String, offsetRange(12, 15), null, 'two'),
                                new Node(NodeType.String, offsetRange(16, 21), null, 'three'),
                                new Node(NodeType.String, offsetRange(22, 26), null, 'four'),
                                new Node(NodeType.String, offsetRange(27, 31), null, 'five')
                            ],
                            null
                        )
                    ],
                    null
                ),
                {
                    first: function (args: Array, results: int): String {
                        if (args.length > 0) return 'Too many args';
                        if (results === 0) return 'Needs at least one result';
                        return null;
                    }
                },
                {
                    first: function (): int {
                        return 0;
                    }
                },
                'one',
                []
            );

            test('Select result, concat in result - "[first:o[first:n]e]"',
                // '[first:o[first:n]e]',
                new Node(NodeType.Eval, offsetRange(0, 20),
                    [
                        new Node(NodeType.Retrieve, offsetRange(1, 6),
                            [
                                new Node(NodeType.Identity, offsetRange(1, 6), null, 'first')
                            ],
                            false
                        ),
                        new Node(NodeType.Args, offsetRange(6, 6), [], null),
                        new Node(NodeType.Results, offsetRange(7, 19),
                            [
                                new Node(NodeType.Concat, offsetRange(8, 19), 
                                [
                                    new Node(NodeType.String, offsetRange(8, 9), null, 'o'),
                                    new Node(NodeType.Eval, offsetRange(9, 18),
                                        [
                                            new Node(NodeType.Retrieve, offsetRange(10, 15),
                                                [
                                                    new Node(NodeType.Identity, offsetRange(10, 15), null, 'first')
                                                ],
                                                false
                                            ),
                                            new Node(NodeType.Args, offsetRange(15, 15), [], null),
                                            new Node(NodeType.Results, offsetRange(15, 17),
                                                [
                                                    new Node(NodeType.String, offsetRange(16, 17), null, 'n')
                                                ],
                                                null
                                            )
                                        ],
                                        null
                                    ),
                                    new Node(NodeType.String, offsetRange(18, 19), null, 'e')
                                ],
                                null
                                )
                            ],
                            null
                        )
                    ],
                    null
                ),
                {
                    first: function (args: Array, results: int): String {
                        if (args.length > 0) return 'Too many args';
                        if (results === 0) return 'Needs at least one result';
                        return null;
                    }
                },
                {
                    first: function (): int {
                        return 0;
                    }
                },
                'one',
                []
            );

            test('Args + results - "[select 0:zero|one]"',
                // '[select 0:zero|one]',
                new Node(NodeType.Eval, offsetRange(0, 19),
                    [
                        new Node(NodeType.Retrieve, offsetRange(1, 7),
                            [
                                new Node(NodeType.Identity, offsetRange(1, 7), null, 'select')
                            ],
                            false
                        ),
                        new Node(NodeType.Args, offsetRange(7, 9),
                            [
                                new Node(NodeType.Number, offsetRange(8, 9), null, '0'),
                            ],
                            null
                        ),
                        new Node(NodeType.Results, offsetRange(9, 18),
                            [
                                new Node(NodeType.String, offsetRange(10, 14), null, 'zero'),
                                new Node(NodeType.String, offsetRange(15, 18), null, 'one')
                            ],
                            null
                        )
                    ],
                    null
                ),
                {
                    select: function (args: Array, results: int): String {
                        if (args.length === 0) return 'Needs at least one arg';
                        if (args.length > 1) return 'Too many args';
                        if (results === 0) return 'Needs at least one result';
                        return null;
                    }
                },
                {
                    select: function (index: int): int {
                        return index;
                    }
                },
                'zero',
                []
            );

            test('Spaces, args + results - "[select    0    :    zero    |    one    ]"',
                // '[select    0    :    zero    |    one    ]',
                new Node(NodeType.Eval, offsetRange(0, 42),
                    [
                        new Node(NodeType.Retrieve, offsetRange(1, 7),
                            [
                                new Node(NodeType.Identity, offsetRange(1, 7), null, 'select')
                            ],
                            false
                        ),
                        new Node(NodeType.Args, offsetRange(7, 16),
                            [
                                new Node(NodeType.Number, offsetRange(11, 12), null, '0'),
                            ],
                            null
                        ),
                        new Node(NodeType.Results, offsetRange(16, 42),
                            [
                                new Node(NodeType.String, offsetRange(17, 29), null, '    zero    '),
                                new Node(NodeType.String, offsetRange(30, 41), null, '    one    ')
                            ],
                            null
                        )
                    ],
                    null
                ),
                {
                    select: function (args: Array, results: int): String {
                        if (args.length === 0) return 'Needs at least one arg';
                        if (args.length > 1) return 'Too many args';
                        if (results === 0) return 'Needs at least one result';
                        return null;
                    }
                },
                {
                    select: function (index: int): int {
                        return index;
                    }
                },
                '    zero    ',
                []
            );

            test('Newlines, args + results - "[\\nselect\\n0\\n:\\nzero\\n|\\none\\n]"',
                // '[\nselect\n0\n:\nzero\n|\none\n]',
                new Node(NodeType.Eval, range(0,0,0, 7,1,25),
                    [
                        new Node(NodeType.Retrieve, range(1,0,2, 1,6,8),
                            [
                                new Node(NodeType.Identity, range(1,0,2, 1,6,8), null, 'select')
                            ],
                            false
                        ),
                        new Node(NodeType.Args, range(2,0,8, 3,0,11),
                            [
                                new Node(NodeType.Number, range(2,0,9, 2,1,10), null, '0'),
                            ],
                            null
                        ),
                        new Node(NodeType.Results, range(3,0,11, 7,0,24),
                            [
                                new Node(NodeType.String, range(4,0,13, 4,4,17), null, 'zero'),
                                new Node(NodeType.String, range(6,0,20, 6,3,23), null, 'one')
                            ],
                            null
                        )
                    ],
                    null
                ),
                {
                    select: function (args: Array, results: int): String {
                        if (args.length === 0) return 'Needs at least one arg';
                        if (args.length > 1) return 'Too many args';
                        if (results === 0) return 'Needs at least one result';
                        return null;
                    }
                },
                {
                    select: function (index: int): int {
                        return index;
                    }
                },
                'zero',
                []
            );

            test('Newlines + spaces, args + results - "[\\n    select\\n    0\\n    :\\n    zero\\n    |\\n    one\\n    ]"',
                // '[\n    select\n    0\n    :\n    zero\n    |\n    one\n    ]',
                new Node(NodeType.Eval, range(0,0,0, 7,1,52),
                    [
                        new Node(NodeType.Retrieve, range(1,0,5, 2,0,12),
                            [
                                new Node(NodeType.Identity, range(1,4,6, 1,10,12), null, 'select')
                            ],
                            false
                        ),
                        new Node(NodeType.Args, range(2,0,12, 3,0,23),
                            [
                                new Node(NodeType.Number, range(2,4,17, 2,5,18), null, '0'),
                            ],
                            null
                        ),
                        new Node(NodeType.Results, range(3,0,23, 7,0,51),
                            [
                                new Node(NodeType.String, range(4,4,28, 4,8,32), null, 'zero'),
                                new Node(NodeType.String, range(6,4,43, 6,7,46), null, 'one')
                            ],
                            null
                        )
                    ],
                    null
                ),
                {
                    select: function (args: Array, results: int): String {
                        if (args.length === 0) return 'Needs at least one arg';
                        if (args.length > 1) return 'Too many args';
                        if (results === 0) return 'Needs at least one result';
                        return null;
                    }
                },
                {
                    select: function (index: int): int {
                        return index;
                    }
                },
                'zero',
                []
            );

            test('Concat text with parser - "b[a]b"',
                // 'b[a]b',
                new Node(NodeType.Concat, offsetRange(0, 5),
                    [
                        new Node(NodeType.String, offsetRange(0, 1), null, 'b'),
                        new Node(NodeType.Eval, offsetRange(1, 4),
                            [
                                new Node(NodeType.Retrieve, offsetRange(2, 3),
                                    [
                                        new Node(NodeType.Identity, offsetRange(2, 3), null, 'a')
                                    ],
                                    false
                                ),
                                new Node(NodeType.Args, offsetRange(3, 3), [], null),
                                new Node(NodeType.Results, offsetRange(3, 3), [], null)
                            ],
                            null
                        ),
                        new Node(NodeType.String, offsetRange(4, 5), null, 'b')
                    ],
                    null
                ),
                {
                    a: function (args: Array, results: int): String {
                        if (args.length > 0) return 'Too many args';
                        if (results > 0) return 'Too many results';
                        return null;
                    }
                },
                {
                    a: function (): String {
                        return 'aaaaa';
                    }
                },
                'baaaaab',
                []
            );

            return out;
        }
    }
}
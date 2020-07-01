package editor.Parsers {
    import editor.Lang.Codify.CodeNode;

    public class ToCode {
        public static const INDENT: String = '    ';

        public static function indentText(text: String): String {
            var newText: String = '' + INDENT;
            var start: int = 0;
            var pos: int = text.indexOf('\n');
            while (~pos && pos < text.length) {
                newText += text.substring(start, pos) + '\n' + INDENT;
                start = ++pos;
                pos = text.indexOf('\n', start);
            }
            return newText + text.substring(start);
        }

        public static function combineIdentities(list: Array): String {
            return list.map(getValue).join('.');
        }

        public static function getFirstArgValue(nodes: *, idx: int, arr: Array): String {
            return nodes[0].value;
        }

        public static function getArgValues(args: Array): Array {
            return args.map(getFirstArgValue);
        }

        public static function oldParser(identities: Array, args: Array, results: Array): Array {
            var text: String = '[' + combineIdentities(identities);
            if (args.length > 0)
                text += ' ' + args.map(getFirstArgValue).join(' ');
            text += ']';
            return [new CodeNode(CodeNode.Text, text)];
        }

        public static function funcCall(identifier: String, args: Array): String {
            return identifier + '(' + args.map(getFirstArgValue).join(', ') +  ')';
        }

        public static function rangeConditions(identifier: String, args: Array): Array {
            const conds: Array = [];
            for (var idx: int = 0; idx < args.length; idx++) {
                conds.push(args[idx] + ' <= ' + identifier + (idx < args.length - 1 ? ' && ' + identifier + ' < ' + args[idx + 1] : ''));
            }
            return conds;
        }

        public static function equalsConditions(identifier: String, args: Array): Array {
            const conds: Array = [];
            for (var idx: int = 0; idx < args.length; idx++) {
                conds.push(identifier + ' == ' + args[idx]);
            }
            return conds;
        }

        public static function callConditions(identifier: String, args: Array): Array {
            const conds: Array = [];
            for (var idx: int = 0; idx < args.length; idx++) {
                conds.push(identifier + '( ' + args[idx] + ')');
            }
            return conds;
        }

        /**
         * Creates If-Else chain not or-ing conditions of empty results.
         * [thing a|b|c|d:1|||2]
         *   if (thing(a)) { output(1) }
         *   else if (!(thing(b) || thing(c))) { output(2) }
         */
        public static function ifElseChain(conditions: Array, results: Array): Array {
            var condLen: int = conditions.length;
            var ifCounter: int = 0;
            var notConditions: String = '';
            var condition: String;
            var node: CodeNode;
            var body: Array = [];
            var codeText: String;

            for (var idx: int = 0; idx < results.length; idx++) {
                condition = idx < condLen ? conditions[idx] : null;

                // Check the current result to see if it is empty.
                // If previous condition already exists, or ("||") with current condition.
                // Continue to next condition.
                if (results[idx].length === 0) {
                    if (notConditions) notConditions += ' || ';
                    notConditions += condition;
                    continue;
                }

                codeText = '';

                // If an "if" statement has already been added, so add "else " to the code text.
                if (ifCounter > 0) codeText += 'else ';

                // The current result has an condition at the same index, so add "if" statement using the current condition.
                if (condition) {
                    codeText += 'if (' + condition + ')';
                }
                // The current result has no argument, so add a "if not" statement using the previous condition(s).
                else if (ifCounter === 0 || notConditions) {
                    codeText += 'if (!(' + notConditions + '))';
                }
                // The current result has no argument, there are previous "if" statements, and no previous conditions,
                // so add an "else" statement.
                else {
                    codeText = 'else';
                }

                if (codeText) {
                    node = new CodeNode(CodeNode.Code, codeText);
                    body.push(node);
                }

                node.body = results[idx];
                ifCounter++;
            }
            return body;
        }

        /**
         * Creates If-Else chain skipping over conditions of empty results.
         * Conditions must be the same length as results or they will be ignored.
         * [thing a|b|c|d:1|||2]
         *   if (thing(a)) { output(1) }
         *   else if (thing(d)) { output(2) }
         */
        public static function skippingIfElseChain(conditions: Array, results: Array): Array {
            var condLen: int = conditions.length;
            var ifCounter: int = 0;
            var node: CodeNode;
            var body: Array = [];
            var codeText: String;

            for (var idx: int = 0; idx < results.length && idx < condLen; idx++) {
                // Skip current condition, if no result.
                if (results[idx].length === 0) {
                    continue;
                }

                codeText = (ifCounter > 0 ? 'else ' : '') + 'if (' + conditions[idx] + ')';

                if (codeText) {
                    node = new CodeNode(CodeNode.Code, codeText);
                    body.push(node);
                }

                node.body = results[idx];
                ifCounter++;
            }
            return body;
        }

        public static function getValue(node: CodeNode, idx: int, arr: Array): String {
            return node.value;
        }

        public static function getAccessPath(identities: Array): String {
            return identities.map(getValue).slice(0, identities.length - 1).join('.');
        }
    }
}
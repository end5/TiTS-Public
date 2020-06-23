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

        public static function oldParser(identities: Array, args: Array, results: Array): Array {
            var text: String = '[' + combineIdentities(identities);
            if (args.length > 0)
                text += ' ' + args.map(getFirstArgValue).join(' ');
            text += ']';
            return [new CodeNode(CodeNode.Text, text)];
        }

        private static function rangeCondition(idx: int, identifier: String, args: Array, results: Array): String {
            return args[idx] + ' <= ' + identifier + (idx < args.length - 1 ? ' && ' + identifier + ' < ' + args[idx + 1] : '');
        }

        private static function equalsCondition(idx: int, identifier: String, args: Array, results: Array): String {
            return identifier + ' == ' + args[idx];
        }

        private static function callCondition(idx: int, identifier: String, args: Array, results: Array): String {
            return identifier + '( ' + args[idx] + ')';
        }

        public static function range(identifier: String, args: Array, results: Array): Array {
            return chain(rangeCondition, identifier, args, results);
        }

        public static function equals(identifier: String, args: Array, results: Array): Array {
            return chain(equalsCondition, identifier, args, results);
        }

        public static function callRange(identifier: String, args: Array, results: Array): Array {
            return chain(callCondition, identifier, args, results);
        }

        private static function chain(conditionFunc: Function, identifier: String, args: Array, results: Array): Array {
            // var code: String = "";
            var argsLen: int = args.length;
            var counter: int = 0;
            var stored: String = '';
            var condition: String;
            var node: CodeNode;
            var body: Array = [];

            for (var idx: int = 0; idx < results.length; idx++) {
                condition = conditionFunc(idx, identifier, args.map(getFirstArgValue), results);

                // Skip empty results
                if (!results[idx]) {
                    if (stored) stored += ' || ';
                    stored += condition;
                    continue;
                }

                // Every condition after the first
                if (counter > 0) {
                    node = new CodeNode(CodeNode.Code, 'else');
                    body.push(node);
                    // code += '\nelse ';
                }

                // Arg with result
                if (idx < argsLen) {
                    node = new CodeNode(CodeNode.Code, 'if (' + condition + ')');
                    body.push(node);
                    // code += 'if (' + condition + ') ';
                }
                // No args with results, not ! args with else-result
                else if (counter === 0 || stored) {
                    node = new CodeNode(CodeNode.Code, 'if (!(' + stored + '))');
                    body.push(node);
                    // code += 'if (!(' + stored + ')) ';
                }

                node.body = results[idx];
                // code += '{\n' +  results[idx] +'\n}';
                counter++;
            }
            return body;
        }

        public static function boolean(identifier: String, results: Array): Array {
            if ((results.length === 1 && results[0]) || (results.length > 1 && !results[1]))
                return [new CodeNode(CodeNode.Code, 'if (' + identifier + ')', results[0])];
            else if (results.length > 1)
                if (!results[0])
                    return [new CodeNode(CodeNode.Code, 'if (!' + identifier + ')', results[1])];
                else if (results[1])
                    return [new CodeNode(CodeNode.Code, 'if (' + identifier + ')', results[0]), new CodeNode(CodeNode.Code, 'else', results[1])];
            return [];
        }

        public static function funcCall(identifier: String, args: Array): String {
            return identifier + '(' + args.map(getFirstArgValue).join(', ') +  ')';
        }

        public static function replaceIdentity(identities: Array, amount: int, ... newIdent): String {
            // var arr: Array = oldIdent.split('.');
            // return arr.slice(0, arr.length - amount).concat(newIdent).join('.');
            return identities.map(getValue).slice(0, identities.length - amount).concat(newIdent).join('.');
        }

        public static function getValue(node: CodeNode, idx: int, arr: Array): String {
            return node.value;
        }

        public static function combineIdentities(list: Array): String {
            return list.map(getValue).join('.');
        }

        public static function getFirstArgValue(nodes: *, idx: int, arr: Array): String {
            return nodes[0].value;
        }
    }
}
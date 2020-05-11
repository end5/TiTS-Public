package editor.Game.CodeMap {
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

        public static function oldParser(identifier: String, args: Array, results: Array): String {
            var text: String = 'output("[' + identifier;
            if (args.length > 0)
                text += ' ' + args.join(' ')
            text += ']");';
            return text;
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

        public static function range(identifier: String, args: Array, results: Array): String {
            return chain(rangeCondition, identifier, args, results);
        }

        public static function equals(identifier: String, args: Array, results: Array): String {
            return chain(equalsCondition, identifier, args, results);
        }

        public static function callRange(identifier: String, args: Array, results: Array): String {
            return chain(callCondition, identifier, args, results);
        }

        private static function chain(conditionFunc: Function, identifier: String, args: Array, results: Array): String {
            var code: String = "";
            var argsLen: int = args.length;
            var counter: int = 0;
            var stored: String = '';
            var condition: String;

            for (var idx: int = 0; idx < results.length; idx++) {
                condition = conditionFunc(idx, identifier, args, results);

                // Skip empty results
                if (!results[idx]) {
                    if (stored) stored += ' || ';
                    stored += condition;
                    continue;
                }

                // Every condition after the first
                if (counter > 0) {
                    code += '\nelse ';
                }

                // Arg with result
                if (idx < argsLen) {
                    code += 'if (' + condition + ') ';
                }
                // No args with results, not ! args with else-result
                else if (counter === 0 || stored) {
                    code += 'if (!(' + stored + ')) ';
                }

                code += '{\n' +  results[idx] +'\n}';
                counter++;
            }
            return code;
        }

        public static function boolean(identifier: String, results: Array): String {
            if ((results.length === 1 && results[0]) || (results.length > 1 && !results[1]))
                return 'if (' + identifier + ') {\n' +  results[0] +'\n}';
            else if (results.length > 1)
                if (!results[0])
                    return 'if (!' + identifier + ') {\n' +  results[1] +'\n}';
                else if (results[1])
                    return 'if (' + identifier + ') {\n' +  results[0] +'\n}\nelse {\n' +  results[1] +'\n}';
            return '';
        }

        public static function funcCall(identifier: String, args: Array): String {
            return identifier + '(' + args.join(', ') +  ')';
        }

        public static function replaceIdentity(oldIdent: String, amount: int, ... newIdent): String {
            var arr: Array = oldIdent.split('.');
            return arr.slice(0, arr.length - amount).concat(newIdent).join('.');
        }
    }
}
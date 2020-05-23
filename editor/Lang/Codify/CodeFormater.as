package editor.Lang.Codify {
    public class CodeFormater {
        private static const INDENT: String = '    ';

        public var result: String;
        private var indentAmt: int = 0;

        public function interpret(body: Array): void {
            this.indentAmt = 0;
            this.result = this.processBody(body);
        }

        private function indent(): String {
            var str: String = '';
            for (var idx: int = this.indentAmt; idx > 0; idx--)
                str += INDENT;
            return str;
        }

        private function processBody(body: Array): String {
            if (body == null || body.length === 0) return '';

            var text: String = '';
            var node: CodeNode;
            var lastType: int;

            for (var idx: int = 0; idx < body.length; idx++) {

                node = body[idx];
                lastType = (0 < idx ? body[idx - 1].type : CodeNode.Invalid);

                // To Text from Code, Invalid
                // >>output("
                if (node.type === CodeNode.Text && lastType !== node.type) {
                    text += this.indent() + 'output("' + node.value;
                }
                // To Code from Text
                // ");\n>>
                else if (node.type === CodeNode.Code && lastType === CodeNode.Text) {
                    text += '");\n' + this.indent() + node.value;
                }
                // To Code from Code, Invalid
                // >>
                else if (node.type === CodeNode.Code) {
                    text += this.indent() + node.value;
                }
                else {
                    text += node.value;
                }

                if (node.body && node.body.length > 0) {
                    this.indentAmt++;
                    text += ' {\n';

                    text += this.processBody(node.body);

                    this.indentAmt--;
                    text += this.indent() + '}\n';
                }
                else if (node.type === CodeNode.Code) {
                    text += '\n';
                }
            }

            // Text finisher
            if (body[body.length - 1].type === CodeNode.Text) {
                text += '");\n';
            }

            return text;
        }
    }
}
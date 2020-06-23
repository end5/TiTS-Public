package editor.Lang.Codify {

    import editor.Lang.Errors.LangError;
    import editor.Lang.Parse.Node;
    import editor.Lang.Parse.NodeType;

    public class CodeTranslator {
        private const escapePairs: Array = [[/\n/g, '\\n'], [/'/g, '\\\''], [/"/g, '\\"']];
        public var errors: Vector.<LangError>;
        public var result: Array;
        private var oldCodeMap: Object;
        private var newCodeMap: Object;

        public function CodeTranslator(oldCodeMap: Object, newCodeMap: Object) {
            this.oldCodeMap = oldCodeMap;
            this.newCodeMap = newCodeMap;
        }

        private function escape(text: String): String {
            var escapedText: String = text;
            for each (var pair: Array in escapePairs) {
                escapedText = escapedText.replace(pair[0], pair[1]);
            }
            return escapedText;
        }

        public function translate(node: Node): Array {
            this.errors = new Vector.<LangError>();
            var output: Array;
            try {
                output = this.processNode(node);
            }
            catch (err: Error) {
                errors.push(new LangError(node.range, err + '\n' + err.getStackTrace()));
                return [new CodeNode(CodeNode.Text, '')];
            }

            return output;
        }

        private function processNode(node: Node): Array {
            // If performance becomes a problem here, rewrite this to be an iterative post-order depth first search.

            var childProducts: Array = [];
            if (node.children && node.children.length > 0) {
                for each (var child: Node in node.children) {
                    childProducts.push(this.processNode(child));
                }
            }

            switch (node.type) {
                default: throw new Error('NodeType ' + node.type + ' does not exist');

                case NodeType.Identity:
                case NodeType.Number: {
                    // return: [CodeNode]

                    return [new CodeNode(CodeNode.Text, node.value + '')];
                }
                case NodeType.String: {
                    // return: [CodeNode]

                    return [new CodeNode(CodeNode.Text, this.escape(node.value))];
                }
                case NodeType.Text: {
                    // return: [CodeNode]

                    if (node.value)
                        return [new CodeNode(CodeNode.Text, this.escape(node.value))];
                    else
                        return [new CodeNode(CodeNode.Text, '')];
                }
                case NodeType.Concat: {
                    // childProducts: CodeNode[] or CodeNode[][]
                    // return: CodeNode[]

                    // Flatten
                    var concat: Array = [];

                    for each (var lvl0: * in childProducts) {
                        if (!(lvl0 is Array))
                            concat.push(lvl0);
                        else {
                            for each (var lvl1: * in lvl0) {
                                concat.push(lvl1);
                            }
                        }
                    }
                    return concat;
                }
                case NodeType.Retrieve: {
                    // childProducts: [CodeNode][]
                    // return: CodeNode[]

                    // Flatten
                    var identities: Array = [];

                    for each (var product: * in childProducts) {
                        identities.push(product[0]);
                    }
                    return identities;
                }
                case NodeType.Args:
                case NodeType.Results: {
                    // childProducts: CodeNode[] or CodeNode[][]
                    // return: CodeNode[] or CodeNode[][]

                    return childProducts;
                }
                case NodeType.Eval: {
                    // childProducts: [CodeNode[], CodeNode[][], CodeNode[][]]
                    // return: CodeNode[]

                    const retrieve: Array = childProducts[0];
                    const args: Array = childProducts[1];
                    const results: Array = childProducts[2];

                    var obj: * = !node.value ? this.oldCodeMap : this.newCodeMap;

                    var identity: String;
                    var lowerCaseIdentity: String;

                    for (var idx: int = 0; idx < retrieve.length; idx++) {
                        identity = retrieve[idx].value;

                        // Determine if capitalization is needed
                        if (idx === retrieve.length - 1) {
                            lowerCaseIdentity = identity.charAt(0).toLocaleLowerCase() + identity.substring(1);
                            if (obj != null && !(identity in obj) && lowerCaseIdentity in obj) {
                                identity = lowerCaseIdentity;
                            }
                        }

                        // Error check
                        if (obj == null || typeof obj !== 'object' || !(identity in obj)) {
                            // This check exists in the Interpreter
                            // No need to report it again for now
                            // this.errors.push(new LangError(
                            //     node.range,
                            //     'cannot find "' + identity + '"'
                            // ));
                            return [];
                        }

                        obj = obj[identity];
                    }

                    if (typeof obj !== 'function') {
                        this.errors.push(new LangError(
                            node.range,
                            'Cannot generate code for "' + identity + '"'
                        ));
                        return [];
                    }

                    return obj(retrieve, args, results);
                }
            }
        }
    }
}
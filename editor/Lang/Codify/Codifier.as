package editor.Lang.Codify {

    import editor.Lang.Errors.LangError;
    import editor.Lang.Parse.Node;
    import editor.Lang.Parse.NodeType;

    public class Codifier {
        private const escapePairs: Array = [[/\n/g, '\\n'], [/'/g, '\\\''], [/"/g, '\\"']];
        public var errors: Vector.<LangError>;
        public var result: Array;
        private var oldCodeMap: Object;
        private var newCodeMap: Object;

        public function Codifier(oldCodeMap: Object, newCodeMap: Object) {
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

        public function interpret(node: Node): void {
            this.errors = new Vector.<LangError>();
            var output: Array;
            try {
                output = this.processNode(node);
            }
            catch (err: Error) {
                errors.push(new LangError(node.range, err + '\n' + err.getStackTrace()));
                this.result = [new CodeNode(CodeNode.Text, '')];
                return;
            }

            this.result = output;
        }

        private function processNode(root: Node): Array {
            const search: Vector.<Node> = new Vector.<Node>();
            search.push(root);

            const discovered: Vector.<Node> = new Vector.<Node>();
            const stack: Array = []; // CodeNode[][][]
            stack.push([]); // root result
            stack.push([]); // root children result

            var node: Node;
            var discoverNode: Node;
            var curScope: Array; // CodeNode[][]
            var childProducts: Array; // CodeNode[] | CodeNode[][] | CodeNode[][][]

            // This is iterative post order dfs
            while (search.length > 0) {

                node = search[search.length - 1];
                discoverNode = (discovered.length > 0 ? discovered[discovered.length - 1] : null);

                if (node !== discoverNode) {
                    if (node.children && node.children.length > 0) {
                        discovered.push(node);
                        stack.push([]);

                        for (var idx: int = node.children.length - 1; idx >= 0; --idx) {
                            search.push(node.children[idx]);
                        }

                        continue;
                    }
                    else {
                        childProducts = [];
                    }
                }
                else {
                    discovered.pop();
                    childProducts = stack.pop();
                }

                search.pop();
                curScope = stack[stack.length - 1];

                switch (node.type) {
                    case NodeType.Identity:
                    case NodeType.Number: {
                        curScope.push([new CodeNode(CodeNode.Text, node.value + '')]);
                        break;
                    }
                    case NodeType.String: {
                        curScope.push([new CodeNode(CodeNode.Text, this.escape(node.value))]);
                        break;
                    }
                    case NodeType.Text: {
                        if (node.value)
                            curScope.push([new CodeNode(CodeNode.Text, this.escape(node.value))]);
                        else
                            curScope.push([new CodeNode(CodeNode.Text, '')]);
                        break;
                    }
                    case NodeType.Concat: {
                        // Flatten
                        var concat: Array = [];
                        // childProducts: CodeNode[] | CodeNode[][] | CodeNode[][][]
                        for each (var lvl0: * in childProducts) {
                            if (!(lvl0 is Array))
                                concat.push(lvl0);
                            else
                                for each (var lvl1: * in lvl0) {
                                    if (!(lvl1 is Array))
                                        concat.push(lvl1);
                                    else
                                        for each (var lvl2: * in lvl1) {
                                            concat.push(lvl2);
                                        }
                                }
                        }
                        curScope.push(concat);
                        break;
                    }
                    case NodeType.Retrieve: {
                        // Flatten
                        var identities: Array = [];
                        // childProducts: CodeNode[][]
                        for each (var product: * in childProducts) {
                            identities.push(product[0]);
                        }
                        curScope.push(identities);
                        break;
                    }
                    case NodeType.Args:
                    case NodeType.Results: {
                        // childProducts: CodeNode[]
                        curScope.push(childProducts);
                        break;
                    }
                    case NodeType.Eval: {
                        // childProducts: [CodeNode[], CodeNode[][], CodeNode[][]]
                        const retrieve: Array = childProducts[0];
                        const args: Array = childProducts[1];
                        const results: Array = childProducts[2];

                        var obj: * = !node.value ? this.oldCodeMap : this.newCodeMap;

                        var identity: String;
                        var lowerCaseIdentity: String;

                        for (idx = 0; idx < retrieve.length; idx++) {
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
                                curScope.push([]);
                                break;
                            }

                            obj = obj[identity];
                        }

                        if (typeof obj !== 'function') {
                            this.errors.push(new LangError(
                                node.range,
                                'Cannot generate code for "' + identity + '"'
                            ));
                            curScope.push([]);
                            break;
                        }

                        curScope.push(obj(retrieve, args, results));
                        break;
                    }
                }
            }
            return curScope[0];
        }
    }
}
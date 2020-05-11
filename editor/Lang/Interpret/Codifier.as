package editor.Lang.Interpret {

    import editor.Lang.Errors.LangError;
    import editor.Lang.Parse.Node;
    import editor.Lang.Parse.NodeType;
    import editor.Parsers.Query.CodeMap.ToCode;

    public class Codifier {
        private const escapePairs: Array = [[/\n/g, '\\n'], [/'/g, '\\\''], [/"/g, '\\"']];
        public var errors: Vector.<LangError>;
        public var result: String;
        private var oldCodeMap: Object;
        private var newCodeMap: Object;

        public function Codifier(oldCodeMap: Object, newCodeMap: Object) {
            this.oldCodeMap = oldCodeMap;
            this.newCodeMap = newCodeMap;
        }

        /**
         * Escapes newline and quotes
         * @param text
         * @return
         */
        private function escape(text: String): String {
            var escapedText: String = text;
            for each (var pair: Array in escapePairs) {
                escapedText = escapedText.replace(pair[0], pair[1]);
            }
            return escapedText;
        }

        /**
         * Interprets a tree of Nodes
         * All errors will be caught and placed into the result
         * @param node The root node
         * @param globals The memory/object to access
         * @return
         */
        public function interpret(node: Node): void {
            this.errors = new Vector.<LangError>();
            var output: String;
            try {
                output = this.processNode(node);
            }
            catch (err: Error) {
                errors.push(new LangError(node.range, err + '\n' + err.getStackTrace()));
                this.result = '';
                return;
            }

            this.result = output;
        }

        /**
         * Processes a node by its type
         * @param node Node
         * @return
         */
        private function processNode(root: Node): String {
            const search: Vector.<Node> = new Vector.<Node>();
            search.push(root);

            const discovered: Vector.<Node> = new Vector.<Node>();
            const products: Array = [];
            products.push([]);
            products.push([]);

            var node: Node;
            var discoverNode: Node;
            var parent: Array;
            var childProducts: Array;

            while (search.length > 0) {

                node = search[search.length - 1];
                discoverNode = (discovered.length > 0 ? discovered[discovered.length - 1] : null);

                if (node !== discoverNode) {
                    if (node.children && node.children.length > 0) {
                        discovered.push(node);
                        products.push([]);

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
                    childProducts = products.pop();
                }

                search.pop();
                parent = products[products.length - 1];
                switch (node.type) {
                    case NodeType.Identity:
                    case NodeType.Number: {
                        parent.push(node.value + '');
                        break;
                    }
                    case NodeType.String: {
                        parent.push('"' + escape(node.value) + '"');
                        break;
                    }
                    case NodeType.Text: {
                        if (node.value)
                            parent.push('output("' + escape(node.value) + '");');
                        else
                            parent.push('');
                        break;
                    }
                    case NodeType.Concat: {
                        var codeStr: String = '';
                        for each (var product: String in childProducts) {
                            if (codeStr.length > 0)
                                codeStr += '\n';
                            codeStr += product;
                        }
                        parent.push(codeStr);
                        break;
                    }
                    case NodeType.Retrieve:
                    case NodeType.Args: {
                        parent.push(childProducts);
                        break;
                    }
                    case NodeType.Results: {
                        var resultStrs: Array = [];
                        for each (product in childProducts) {
                            resultStrs.push(ToCode.indentText(product));
                        }
                        parent.push(resultStrs);
                        break;
                    }
                    case NodeType.Eval: {
                        const retrieve: Array = childProducts[0];
                        const args: Array = childProducts[1];
                        const results: Array = childProducts[2];

                        var obj: * = !node.value ? this.oldCodeMap : this.newCodeMap;
                        var name: String = '';

                        var identity: String;
                        var lowerCaseIdentity: String;
                        var failedToFindCodeFunc: Boolean = false;

                        for (idx = 0; idx < retrieve.length; idx++) {
                            identity = retrieve[idx];

                            // Determine if capitalization is needed
                            if (idx === retrieve.length - 1) {
                                lowerCaseIdentity = identity.charAt(0).toLocaleLowerCase() + identity.substring(1);
                                if (obj != null && !(identity in obj) && lowerCaseIdentity in obj) {
                                    identity = lowerCaseIdentity;
                                }
                            }

                            // Error check
                            if (obj == null || typeof obj !== 'object' || !(identity in obj)) {
                                // Do not need to report error here
                                // This check already exists in the Interpreter
                                parent.push('""');
                                failedToFindCodeFunc = true;
                                break;
                            }

                            obj = obj[identity];
                        }

                        if (!failedToFindCodeFunc) {
                            if (typeof obj !== 'function') {
                                this.errors.push(new LangError(
                                    node.range,
                                    'Cannot generate code for "' + identity + '"'
                                ));
                                parent.push('""');
                                break;
                            }

                            parent.push(obj(retrieve.join('.'), args, results));
                        }
                        break;
                    }
                }
            }
            return parent[0];
        }
    }
}
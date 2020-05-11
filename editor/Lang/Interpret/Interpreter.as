package editor.Lang.Interpret {

    import editor.Lang.Errors.LangError;
    import editor.Lang.Parse.Node;
    import editor.Lang.Parse.NodeType;
    import editor.Lang.TextRange;

    public class Interpreter {
        public var errors: Vector.<LangError>;
        public var result: *;
        public var ranges: *;
        private var oldWrapper: Object;
        private var oldInfo: Object;
        private var newWrapper: Object;
        private var newInfo: Object;

        public function Interpreter(oldWrapper: Object, oldInfo: Object, newWrapper: Object, newInfo: Object) {
            this.oldWrapper = oldWrapper;
            this.oldInfo = oldInfo;

            this.newWrapper = newWrapper;
            this.newInfo = newInfo;
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
            var output: *;
            try {
                output = this.processNode(node);
            }
            catch (err: Error) {
                errors.push(new LangError(node.range, err + '\n' + err.getStackTrace()));
                this.result = '';
                this.ranges = [node.range];
                return;
            }

            this.result = output.value;
            this.ranges = (output.range is Array ? output.range : [output.range]);
        }

        /**
         * Processes a node by its type
         * @param node Node
         * @return
         */
        private function processNode(root: *): Product {
            const search: Vector.<Node> = new Vector.<Node>();
            search.push(root);

            const discovered: Vector.<Node> = new Vector.<Node>();
            const products: Vector.<Vector.<Product>> = new Vector.<Vector.<Product>>();
            products.push(new Vector.<Product>());
            products.push(new Vector.<Product>());

            var node: Node;
            var discoverNode: Node;
            var parent: Vector.<Product>;
            var childProducts: Vector.<Product>;

            while (search.length > 0) {

                node = search[search.length - 1];
                discoverNode = (discovered.length > 0 ? discovered[discovered.length - 1] : null);

                if (node !== discoverNode) {
                    if (node.children && node.children.length > 0) {
                        discovered.push(node);
                        products.push(new Vector.<Product>());

                        if (node.type === NodeType.Eval)
                            search.push(node.children[1], node.children[0]);
                        else
                            for (var idx: int = node.children.length - 1; idx >= 0; --idx) {
                                search.push(node.children[idx]);
                            }

                        continue;
                    }
                    else {
                        childProducts = new Vector.<Product>();
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
                    case NodeType.String:
                    case NodeType.Number:
                    case NodeType.Text: {
                        parent.push(new Product(
                            node.range,
                            node.value
                        ));
                        break;
                    }
                    case NodeType.Concat: {
                        var ranges: Array = [];
                        var valueStr: String = '';
                        for each (var product: * in childProducts) {
                            // Squashes ranges
                            if (product.range is Array)
                                for each (var childRange: * in product.range)
                                    ranges.push(childRange);
                            else
                                ranges.push(product.range);

                            valueStr += product.value;
                        }

                        parent.push(new Product(
                            ranges,
                            valueStr
                        ));

                        break;
                    }
                    case NodeType.Retrieve: {
                        var obj: * = !node.value ? this.oldWrapper : this.newWrapper;
                        var infoFunc: * = !node.value ? this.oldInfo : this.newInfo;
                        var name: String = '';

                        var identity: String;
                        var parentObj: *;
                        var caps: Boolean = false;
                        var lowerCaseIdentity: String;
                        var errorBreak: Boolean = false;

                        for (idx = 0; idx < childProducts.length; idx++) {
                            identity = childProducts[idx].value;

                            // Determine if capitalization is needed
                            if (idx === childProducts.length - 1) {
                                lowerCaseIdentity = identity.charAt(0).toLocaleLowerCase() + identity.substring(1);
                                if (obj != null && !(identity in obj) && lowerCaseIdentity in obj) {
                                    caps = true;
                                    identity = lowerCaseIdentity;
                                }
                            }

                            // Error check
                            if (obj == null || typeof obj !== 'object' || !(identity in obj)) {
                                errors.push(new LangError(
                                    node.range,
                                    '"' + identity + '" does not exist' + (name ? ' in "' + name + '"' : '')
                                ));
                                parent.push(new Product(
                                    node.range,
                                    null
                                ));
                                errorBreak = true;
                                break;
                            }

                            // Get info
                            if (typeof infoFunc === 'object' && identity in infoFunc) {
                                infoFunc = infoFunc[identity];
                            }

                            parentObj = obj;
                            obj = obj[identity];
                            if (name.length > 0) {
                                name += '.';
                            }
                            name += identity;
                        }

                        if (!errorBreak)
                            parent.push(new Product(
                                node.range,
                                new VariableInfo(name, obj, parentObj, caps, infoFunc)
                            ));
                        break;
                    }
                    case NodeType.Args:
                    case NodeType.Results: {
                        parent.push(new Product(
                            node.range,
                            childProducts
                        ));
                        break;
                    }
                    case NodeType.Eval: {

                        const retrieve: Product = childProducts[0];
                        const args: Product = childProducts[1];
                        const info: VariableInfo = retrieve.value;

                        if (!info) {
                            parent.push(new Product(new TextRange(node.range.start, node.range.start), ''));
                            break;
                        }

                        const identifier: String = info.name;
                        var resultValue: * = info.value;

                        const argsValueArr: Array = [];
                        for each (var child: * in args.value) {
                            argsValueArr.push(child.value);
                        }

                        const results: Array = node.children[2].children;

                        // TODO: Args check needs to happen here if not a function
                        // Maybe force info function for everything

                        if (typeof resultValue === 'function') {
                            // Validate args and results
                            if (info.func && typeof info.func === 'function') {
                                const validResult: * = info.func(argsValueArr, results.length);
                                if (validResult != null) {
                                    errors.push(new LangError(node.range, '"' + identifier + '" ' + validResult));
                                    parent.push(new Product(new TextRange(node.range.start, node.range.start), ''));
                                    break;
                                }
                            }

                            // Evaluate
                            resultValue = resultValue.apply(info.parent, argsValueArr);

                            if (resultValue == null) {
                                errors.push(new LangError(node.range, '"' + identifier + '" is ' + resultValue));
                                parent.push(new Product(new TextRange(node.range.start, node.range.start), ''));
                                break;
                            }
                        }

                        if (info.caps && typeof resultValue === 'string' && resultValue.length > 0) {
                            resultValue = resultValue.charAt(0).toLocaleUpperCase() + resultValue.substring(1);
                        }

                        // Error checking
                        var errorStart: int = errors.length;
                        switch (typeof resultValue) {
                            case 'boolean': {
                                if (results.length === 0) {
                                    errors.push(new LangError(node.range, '"' + identifier + '" needs at least 1 result'));
                                }
                                else if (results.length > 2) {
                                    errors.push(new LangError(node.range, '"' + identifier + '" has ' + (results.length - 2) + ' results than needed'));
                                }
                                break;
                            }
                            case 'xml':
                            case 'object': {
                                errors.push(new LangError(node.range, '"' + identifier + '" cannot be displayed'));
                                break;
                            }
                        }
                        if (errorStart !== errors.length) {
                            parent.push(new Product(new TextRange(node.range.start, node.range.start), ''));
                            break;
                        }

                        var selectedNode: Node;
                        if (typeof resultValue === 'number') {
                            // Evaluate
                            if (results.length > resultValue) {
                                selectedNode = results[resultValue];
                            }
                            else {
                                selectedNode = new Node(NodeType.Text, new TextRange(node.range.end, node.range.end), null, '');
                            }
                        }
                        else if (typeof resultValue === 'boolean') {
                            // Evaluate
                            // condition ? [result1] : result2
                            if (resultValue && results.length > 0) {
                                selectedNode = results[0];
                            }
                            // condition ? result1 : [result2]
                            else if (!resultValue && results.length > 1) {
                                selectedNode = results[1];
                            }
                            // condition ? result1 : []
                            // condition ? [] : result2
                            else {
                                selectedNode = new Node(NodeType.Text, new TextRange(node.range.end, node.range.end), null, '');
                            }
                        }
                        else {
                            parent.push(new Product(node.range, resultValue));
                            break;
                        }

                        search.push(selectedNode);
                        break;
                    }
                    default: throw new Error('NodeType ' + root.type + ' does not exist');
                }
            }
            return parent[0];
        }
    }
}
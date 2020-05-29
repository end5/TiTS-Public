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
        private function processNode(node: Node): Product {
            // If performance becomes a problem here, rewrite this to be an iterative post-order depth first search.
            // Do not forget to handle selecting and evaluating the correct result while ignoring others.

            var childProducts: Array = [];
            if (node.children && node.children.length > 0) {
                // Do not evaluate results. 
                if (node.type === NodeType.Eval) {
                    childProducts.push(this.processNode(node.children[0])); // Retrieve
                    childProducts.push(this.processNode(node.children[1])); // Args
                }
                else
                    for each (var child: Node in node.children) {
                        childProducts.push(this.processNode(child));
                    }
            }

            switch (node.type) {
                default: throw new Error('NodeType ' + node.type + ' does not exist');

                case NodeType.Identity:
                case NodeType.String:
                case NodeType.Number:
                case NodeType.Text: {
                    // node.value: String, int
                    // childProducts: []
                    // product.value: String, int
                    return new Product(
                        node.range,
                        node.value
                    );
                }
                case NodeType.Concat: {
                    // node.value: null
                    // childProducts: Product<String, int>[]
                    // product.value: String
                    var ranges: Array = [];
                    var valueStr: String = '';
                    for each (var product: Product in childProducts) {
                        // Squashes ranges
                        if (product.range is Array)
                            for each (var childRange: * in product.range)
                                ranges.push(childRange);
                        else
                            ranges.push(product.range);

                        valueStr += product.value;
                    }

                    return new Product(
                        ranges,
                        valueStr
                    );
                }
                case NodeType.Retrieve: {
                    // node.value: Boolean
                    // childProducts: Product<String>[]
                    // product.value: VariableInfo
                    var obj: * = !node.value ? this.oldWrapper : this.newWrapper;
                    var infoFunc: * = !node.value ? this.oldInfo : this.newInfo;
                    var name: String = '';

                    var identity: String;
                    var parentObj: *;
                    var caps: Boolean = false;
                    var lowerCaseIdentity: String;

                    for (var idx: int = 0; idx < childProducts.length; idx++) {
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
                            return new Product(
                                node.range,
                                null
                            );
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

                    return new Product(
                        node.range,
                        new VariableInfo(name, obj, parentObj, caps, infoFunc)
                    );
                }
                case NodeType.Args:
                case NodeType.Results: {
                    // node.value: null
                    // childProducts: Product<any>[]
                    // product.value: Product<any>[]
                    return new Product(
                        node.range,
                        childProducts
                    );
                }
                case NodeType.Eval: {
                    // node.value: null
                    // childProducts: [Product<VariableInfo>, Product<Product<String, int>[]>]
                    // product.value: String

                    const retrieve: Product = childProducts[0]; // Product<VariableInfo>
                    const args: Product = childProducts[1]; // Product<Product<String, int>[]>
                    const info: VariableInfo = retrieve.value;

                    if (!info) {
                        return new Product(new TextRange(node.range.start, node.range.start), '');
                    }

                    const identifier: String = info.name;
                    var resultValue: * = info.value;

                    const argsValueArr: Array = [];
                    for each (var argChild: * in args.value) {
                        argsValueArr.push(argChild.value);
                    }

                    const results: Array = node.children[2].children; // Eval -> Results.children
                    const resultCount: int = results.length;

                    if (typeof resultValue === 'function') {
                        // Check for info function
                        if (info.func && typeof info.func === 'function') {
                            // Validate arguments and result count
                            // return: String or null
                            const validResult: * = info.func(argsValueArr, resultCount);
                            if (validResult != null) {
                                errors.push(new LangError(node.range, '"' + identifier + '" ' + validResult));
                                return new Product(new TextRange(node.range.start, node.range.start), '');
                            }
                        }

                        // Evaluate
                        // Can reuse resultValue
                        resultValue = resultValue.apply(info.parent, argsValueArr);

                        if (resultValue == null) {
                            errors.push(new LangError(node.range, '"' + identifier + '" is ' + resultValue));
                            return new Product(new TextRange(node.range.start, node.range.start), '');
                        }
                    }

                    // Captialize result
                    if (info.caps && typeof resultValue === 'string' && resultValue.length > 0) {
                        resultValue = resultValue.charAt(0).toLocaleUpperCase() + resultValue.substring(1);
                    }

                    // Error checking
                    var errorStart: int = errors.length;
                    switch (typeof resultValue) {
                        case 'boolean': {
                            if (resultCount === 0) {
                                errors.push(new LangError(node.range, '"' + identifier + '" needs at least 1 result'));
                            }
                            else if (resultCount > 2) {
                                errors.push(new LangError(node.range, '"' + identifier + '" has ' + (resultCount - 2) + ' results than needed'));
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
                        return new Product(new TextRange(node.range.start, node.range.start), '');
                    }

                    var selectedNode: Node;
                    if (typeof resultValue === 'number') {
                        // Select and evaluate the correct result
                        if (resultCount > resultValue) {
                            return this.processNode(results[resultValue]);
                        }
                        else {
                            return new Product(new TextRange(node.range.end, node.range.end), '');
                        }
                    }
                    else if (typeof resultValue === 'boolean') {
                        // Evaluate
                        // condition ? [result1] : result2
                        if (resultValue && resultCount > 0) {
                            return this.processNode(results[0]);
                        }
                        // condition ? result1 : [result2]
                        else if (!resultValue && resultCount > 1) {
                            return this.processNode(results[1]);
                        }
                        // condition ? result1 : []
                        // condition ? [] : result2
                        else {
                            return new Product(new TextRange(node.range.end, node.range.end), '');
                        }
                    }
                    else {
                        return new Product(node.range, resultValue);
                    }
                }
            }
        }
    }
}
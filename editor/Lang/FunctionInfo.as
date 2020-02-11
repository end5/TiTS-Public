package editor.Lang {
    /**
     * Information about the specified function
     */
    public class FunctionInfo {
        private var _argResultValidators: Array = new Array();
        private var _mapArgsCallbacks: Array = new Array();
        private var _toCode: Function;
        private var _desc: String;
        private var _includeResults: Boolean = false;
        private var _identOverride: String;

        /**
         * Sets function used to determine if the Args and Results passed to the matching function are correct
         * If error, return a String describing the error
         * If no error, return null
         * @param func function(args: Array of String or Number, results: Array of String): String or null
         * @return self
         */
        public function addArgResultValidator(func: Function): FunctionInfo {
            this._argResultValidators.push(func);
            return this;
        }
        /**
         * Used to determine if the Args and Results passed to the matching function are correct
         * Type "function(args: Array of String or Number, results: Array of String): String or null"
         * Strings in results will be surrounded with '"'
         * If error, return a String describing the error
         * If no error, return null
         */
        public function get argResultValidator(): Array {
            return this._argResultValidators;
        }

        /**
         * Used to map Args before being passed to "toCode"
         * Useful for converting types or flags to their index number
         * Strings will be surrounded with '"'
         * @param func function(args: Array of String or Number): Array of String or Number
         * @return self
         */
        public function addMapArgs(func: Function): FunctionInfo {
            this._mapArgsCallbacks.push(func);
            return this;
        }
        /**
         * Array of preprocessors for Args
         * Type "function(args: Array of String or Number): Array of String or Number"
         * Strings in results will be surrounded with '"'
         */
        public function get mapArgsCallbacks(): Array {
            return this._mapArgsCallbacks;
        }

        /**
         * Sets function for custom code output
         * Strings in results will be surrounded with '"'
         * @param func function(identity: String, args: Array of String or Number, results: Array of String): String
         * @return self
         */
        public function setToCodeFunc(func: Function): FunctionInfo {
            this._toCode = func;
            return this;
        }
        /**
         * Function for custom code output
         * Type "function(identity: String, args: Array of String or Number, results: Array of String): String"
         * Strings in results will be surrounded with '"'
         */
        public function get toCode(): Function {
            return this._toCode;
        }

        /**
         * Description of what the parser does
         * @param desc String
         * @return self
         */
        public function setDesc(desc: String): FunctionInfo {
            this._desc = desc;
            return this;
        }
        /**
         * Description of what the parser does
         */
        public function getDesc(): String {
            return this._desc || '';
        }

        /**
         * Sets flag to pass argument and result arrays when calling
         * This will force the function definition to be:
         * function (args: Array, results: Array)
         */
        public function setIncludeResults(): FunctionInfo {
            this._includeResults = true;
            return this;
        }

        /**
         * Whether or not to pass argument and result arrays when calling
         */
        public function get includeResults(): Boolean {
            return this._includeResults;
        }

        /**
         * Overrides the `identity` used when generating code
         * @param identity String
         */
        public function setIdentityOverride(identity: String): FunctionInfo {
            _identOverride = identity;
            return this;
        }

        public function get identityOverride(): String {
            return this._identOverride;
        }
    }
}

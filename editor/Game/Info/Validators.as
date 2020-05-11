package editor.Game.Info {
    public class Validators {
        public static const ARGS: String = 'argument';
        public static const RESS: String = 'result';

        public static function minLength(len: int, required: int, arrType: String): String {
            if (len < required) return 'needs at least ' + required + ' ' + arrType + (required > 1 ? 's' : '');
            return null;
        }

        public static function maxLength(len: int, required: int, arrType: String): String {
            if (len > required) return 'has ' + (len - required) + ' extraneous ' + arrType + (required > 1 ? 's' : '');
            return null;
        }

        /**
         * If arr[idx] exists, compare its type to type
         */
        public static function checkTypeAt(arr: Array, idx: int, type: String, arrType: String): String {
            if (arr.length > idx && typeof arr[idx] !== type) return arrType + ' ' + idx + ' needs to be a ' + type;
            return null;
        }

        /**
         * Args >= 1, Results >= 1, Results <= Args + 1
         */
        public static function checkRange(argsLen: int, resultsLen: int): String {
            var err: String = minLength(argsLen, 1, ARGS);
            if (!err) err = minLength(resultsLen, 1, RESS);
            if (!err) err = maxLength(resultsLen, argsLen + 1, RESS);
            return err;
        }

        public static function range(args: Array, results: int): String {
            return checkRange(args.length, results);
        }
    }
}
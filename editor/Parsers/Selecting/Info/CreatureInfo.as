package editor.Parsers.Selecting.Info {
    import classes.GLOBAL;
    import editor.Parsers.Validators;

    public class CreatureInfo {
        // Lookup
        private function nameToIndex(key: String, name: String): int {
            return GLOBAL[key].indexOf(name.charAt(0).toLocaleUpperCase() + name.slice(1));
        }

        // Validators
        private function nameInGroup(group: String, args: Array): String {
            for (var idx: int = 0; idx < args.length; idx++) {
                if (nameToIndex(group, args[idx]) === -1)
                    return 'cannot accept "' + args[idx] + '" because it does not exist in ' + group;
            }
            return null;
        }

        private function nameToIndexInGroup(key: String, group: String, args: Array): String {
            for (var idx: int = 0; idx < args.length; idx++) {
                if (GLOBAL[group].indexOf(nameToIndex(key, args[idx])) === -1)
                    return 'cannot accept "' + args[idx] + '" because it does not exist in ' + key;
            }
            return null;
        }

        private function hasAtLeastOneStringArgUpToTwoResults(args: Array, results: int): String {
            var err: String = Validators.minLength(args.length, 1, Validators.ARGS);
            if (!err) err = Validators.checkTypeAt(args, 0, 'string', Validators.ARGS);
            if (!err) err = Validators.maxLength(results, 2, Validators.RESS);
            return null;
        }

        private function hasOneIndexArgAtLeastOneOtherArg(args: Array): String {
            var err: String = Validators.minLength(args.length, 2, Validators.ARGS);
            if (!err) err = Validators.checkTypeAt(args, 0, 'number', Validators.ARGS);
            return null;
        }

        // Physical Appearance
        //Femininity
        public const femIs: Function = Validators.range;
        public const femRange: Function = Validators.range;

        // Tallness
        public const tallnessIs: Function = Validators.range;
        public const tallnessRange: Function = Validators.range;

        // Thickness
        public const thicknessIs: Function = Validators.range;
        public const thicknessRange: Function = Validators.range;

        // Tone
        public const toneIs: Function = Validators.range;
        public const toneRange: Function = Validators.range;

        // Hip rating
        public const hipRatingIs: Function = Validators.range;

        // Butt rating
        public const buttRatingIs: Function = Validators.range;

        // Body Parts
        // Skin
        public function skinTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameInGroup('SKIN_TYPE_NAMES', args);
            return err;
        }

        // Eyes
        public function eyeTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_EYE_TYPES', args);
            return err;
        }

        // Hair
        public function hairTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameInGroup('HAIR_TYPE_NAMES', args);
            return err;
        }

        // Beard
        public function beardTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameInGroup('HAIR_TYPE_NAMES', args);
            return err;
        }

        // Face
        public function faceTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_FACE_TYPES', args);
            return err;
        }

        public function hasFaceFlag(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_FACE_FLAGS', args);
            return err;
        }

        public function hasFaceFlags(args: Array, results: int): String {
            var err: String = hasAtLeastOneStringArgUpToTwoResults(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_FACE_FLAGS', args);
            return err;
        }

        // Tongue
        public function tongueTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_TONGUE_TYPES', args);
            return err;
        }

        public function hasTongueFlag(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_TONGUE_FLAGS', args);
            return err;
        }

        public function hasTongueFlags(args: Array, results: int): String {
            var err: String = hasAtLeastOneStringArgUpToTwoResults(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_TONGUE_FLAGS', args);
            return err;
        }

        // Ear
        public function earTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_EAR_TYPES', args);
            return err;
        }

        public function hasEarFlag(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_EAR_FLAGS', args);
            return err;
        }

        public function hasEarFlags(args: Array, results: int): String {
            var err: String = hasAtLeastOneStringArgUpToTwoResults(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_EAR_FLAGS', args);
            return err;
        }

        // Antennae
        public function antennaeTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_ANTENNAE_TYPES', args);
            return err;
        }

        // Horn
        public function hornTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_HORN_TYPES', args);
            return err;
        }

        // Arm
        public function armTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_ARM_TYPES', args);
            return err;
        }

        public function hasArmFlag(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_ARM_FLAGS', args);
            return err;
        }

        public function hasArmFlags(args: Array, results: int): String {
            var err: String = hasAtLeastOneStringArgUpToTwoResults(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_ARM_FLAGS', args);
            return err;
        }

        // Wing
        public function wingTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_WING_TYPES', args);
            return err;
        }

        // Leg
        public function legTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_LEG_TYPES', args);
            return err;
        }

        public function hasLegFlag(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_LEG_FLAGS', args);
            return err;
        }

        public function hasLegFlags(args: Array, results: int): String {
            var err: String = hasAtLeastOneStringArgUpToTwoResults(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_LEG_FLAGS', args);
            return err;
        }

        // Lowerbody

        // Tail
        public function tailTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_TAIL_TYPES', args);
            return err;
        }

        public const tailCountIs: Function = Validators.range;

        public const tailCountRange: Function = Validators.range;

        public function hasTailFlag(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_TAIL_FLAGS', args);
            return err;
        }

        public function hasTailFlags(args: Array, results: int): String {
            var err: String = hasAtLeastOneStringArgUpToTwoResults(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_TAIL_FLAGS', args);
            return err;
        }

        // Cock
        public function hasCockType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_COCK_TYPES', args);
            return err;
        }

        public const cockCountIs: Function = Validators.range;

        public function cockTypeIs(args: Array, results: int): String {
            var err: String = hasOneIndexArgAtLeastOneOtherArg(args);
            if (!err) err = Validators.checkRange(args.length - 1, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_COCK_TYPES', args.slice(1));
            return err;
        }

        public function cockThatFits(args: Array, results: int): String {
            var err: String = Validators.minLength(args.length, 1, Validators.ARGS);
            if (!err) err = Validators.maxLength(args.length, 1, Validators.ARGS);
            if (!err) err = Validators.checkTypeAt(args, 0, 'number', Validators.ARGS);
            if (!err) err = Validators.maxLength(results, 0, Validators.RESS);
            return err;
        }

        // Balls
        public const ballCountIs: Function = Validators.range;

        public const ballSizeIs: Function = Validators.range;
        public const ballSizeRange: Function = Validators.range;

        // Breasts
        public const breastCountIs: Function = Validators.range;

        private const breastCupList: Array = ["0-cup", "A-cup", "B-cup", "C-cup", "D-cup", "DD-cup", "big DD-cup", "E-cup", "big E-cup", "EE-cup", "big EE-cup", "F-cup", "big F-cup", "FF-cup", "big FF-cup", "G-cup", "big G-cup", "GG-cup", "big GG-cup", "H-cup", "big H-cup", "HH-cup", "big HH-cup", "HHH-cup", "I-cup", "big I-cup", "II-cup", "big II-cup", "J-cup", "big J-cup", "JJ-cup", "big JJ-cup", "K-cup", "big K-cup", "KK-cup", "big KK-cup", "L-cup", "big L-cup", "LL-cup", "big LL-cup", "M-cup", "big M-cup", "MM-cup", "big MM-cup", "MMM-cup", "large MMM-cup", "N-cup", "large N-cup", "NN-cup", "large NN-cup", "O-cup", "large O-cup", "OO-cup", "large OO-cup", "P-cup", "large P-cup", "PP-cup", "large PP-cup", "Q-cup", "large Q-cup", "QQ-cup", "large QQ-cup", "R-cup", "large R-cup", "RR-cup", "large RR-cup", "S-cup", "large S-cup", "SS-cup", "large SS-cup", "T-cup", "large T-cup", "TT-cup", "large TT-cup", "U-cup", "large U-cup", "UU-cup", "large UU-cup", "V-cup", "large V-cup", "VV-cup", "large VV-cup", "W-cup", "large W-cup", "WW-cup", "large WW-cup", "X-cup", "large X-cup", "XX-cup", "large XX-cup", "Y-cup", "large Y-cup", "YY-cup", "large YY-cup", "Z-cup", "large Z-cup", "ZZ-cup", "large ZZ-cup", "ZZZ-cup", "large ZZZ-cup", "hyper A-cup", "hyper B-cup", "hyper C-cup", "hyper D-cup", "hyper DD-cup", "hyper big DD-cup", "hyper E-cup", "hyper big E-cup", "hyper EE-cup", "hyper big EE-cup", "hyper F-cup", "hyper big F-cup", "hyper FF-cup", "hyper big FF-cup", "hyper G-cup", "hyper big G-cup", "hyper GG-cup", "hyper big GG-cup", "hyper H-cup", "hyper big H-cup", "hyper HH-cup", "hyper big HH-cup", "hyper HHH-cup", "hyper I-cup", "hyper big I-cup", "hyper II-cup", "hyper big II-cup", "hyper J-cup", "hyper big J-cup", "hyper JJ-cup", "hyper big JJ-cup", "hyper K-cup", "hyper big K-cup", "hyper KK-cup", "hyper big KK-cup", "hyper L-cup", "hyper big L-cup", "hyper LL-cup", "hyper big LL-cup", "hyper M-cup", "hyper big M-cup", "hyper MM-cup", "hyper big MM-cup", "hyper MMM-cup", "hyper large MMM-cup", "hyper N-cup", "hyper large N-cup", "hyper NN-cup", "hyper large NN-cup", "hyper O-cup", "hyper large O-cup", "hyper OO-cup", "hyper large OO-cup", "hyper P-cup", "hyper large P-cup", "hyper PP-cup", "hyper large PP-cup", "hyper Q-cup", "hyper large Q-cup", "hyper QQ-cup", "hyper large QQ-cup", "hyper R-cup", "hyper large R-cup", "hyper RR-cup", "hyper large RR-cup", "hyper S-cup", "hyper large S-cup", "hyper SS-cup", "hyper large SS-cup", "hyper T-cup", "hyper large T-cup", "hyper TT-cup", "hyper large TT-cup", "hyper U-cup", "hyper large U-cup", "hyper UU-cup", "hyper large UU-cup", "hyper V-cup", "hyper large V-cup", "hyper VV-cup", "hyper large VV-cup", "hyper W-cup", "hyper large W-cup", "hyper WW-cup", "hyper large WW-cup", "hyper X-cup", "hyper large X-cup", "hyper XX-cup", "hyper large XX-cup", "hyper Y-cup", "hyper large Y-cup", "hyper YY-cup", "hyper large YY-cup", "hyper Z-cup", "hyper large Z-cup", "hyper ZZ-cup", "hyper large ZZ-cup", "hyper ZZZ-cup", "hyper large ZZZ-cup", "Jacques00-cup"];

        private function inBreastCupList(key: String): Boolean {
            for (var idx:int = 0; idx < this.breastCupList.length; idx++)
                if (this.breastCupList[idx] === key)
                    return true;
            return false;
        }

        public function breastCupSizeIs(args: Array, results: int): String {
            var err: String = Validators.checkTypeAt(args, 0, 'number', Validators.ARGS);
            if (!err)
                for (var idx: int = 1; idx < args.length; idx++)
                    if (!this.inBreastCupList(args[idx])) {
                        err = '"' + args[idx] + '" is not a breast cup';
                        break;
                    }
            if (!err) err = Validators.checkRange(args.length - 1, results);
            return err;
        }

        // Vagina

        // Fluids
        // Milk
        public function milkTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLUID_TYPE_NAMES', 'VALID_MILK_TYPES', args);
            return err;
        }

        public const milkQRange: Function = Validators.range;

        // Cum
        public function cumTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLUID_TYPE_NAMES', 'VALID_CUM_TYPES', args);
            return err;
        }

        public const cumQRange: Function = Validators.range;

        // Girl Cum
        public function girlCumTypeIs(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLUID_TYPE_NAMES', 'VALID_GIRLCUM_TYPES', args);
            return err;
        }

        public const girlCumQRange: Function = Validators.range;

        // Personality

        // Exposure

        // Sex

        // Sex Appearance

        // Stats
        public const lustIs: Function = Validators.range;
        public const lustRange: Function = Validators.range;

        public const physiqueIs: Function = Validators.range;
        public const physiqueRange: Function = Validators.range;

        public const reflexesIs: Function = Validators.range;
        public const reflexesRange: Function = Validators.range;

        public const aimIs: Function = Validators.range;
        public const aimRange: Function = Validators.range;

        public const intelligenceIs: Function = Validators.range;
        public const intelligenceRange: Function = Validators.range;

        public const willpowerIs: Function = Validators.range;
        public const willpowerRange: Function = Validators.range;

        public const libidoIs: Function = Validators.range;
        public const libidoRange: Function = Validators.range;

        public const taintIs: Function = Validators.range;
        public const taintRange: Function = Validators.range;

        // Effects
        // Heat

        // Rut

        // Bimbo

        // Treated

        // Pheromones

        // Perk
        public const hasPerk: Function = Validators.range;

        // StatusEffect
        public const hasStatusEffect: Function = Validators.range;

        // Items
        // Piercing
        private function hasOneOptionalNumberArgUpToTwoResults(args: Array, results: int): String {
            var err: String = Validators.maxLength(args.length, 1, Validators.ARGS);
            if (!err) err = Validators.checkTypeAt(args, 0, 'number', Validators.ARGS);
            if (!err) err = Validators.maxLength(results, 2, Validators.RESS);
            return null;
        }

        public const hasNipplePiercing: Function = hasOneOptionalNumberArgUpToTwoResults;
        public const hasCockPiercing: Function = hasOneOptionalNumberArgUpToTwoResults;
        public const hasPiercedVaginas: Function = hasOneOptionalNumberArgUpToTwoResults;
        public const hasClitPiercing: Function = hasOneOptionalNumberArgUpToTwoResults;
        public const hasCocksock: Function = hasOneOptionalNumberArgUpToTwoResults;

        // Keyitem
        public const hasKeyItem: Function = Validators.range;
    }
}
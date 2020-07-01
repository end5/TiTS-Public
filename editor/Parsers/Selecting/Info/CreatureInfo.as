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

        private function nameInList(list: Array, args: Array): String {
            for (var idx: int = 0; idx < args.length; idx++) {
                for (var listIdx: int = 0; listIdx < list.length; listIdx++)
                    if (list[listIdx] === args[idx].toLocaleLowerCase())
                        break;

                if (listIdx === list.length)
                    return 'cannot accept "' + args[idx] + '" because it does not exist in [' + list.join(', ') + ']';
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
        public const fem: Function = Validators.range;

        // Tallness
        public const tallness: Function = Validators.range;

        // Thickness
        public const thickness: Function = Validators.range;

        // Tone
        public const tone: Function = Validators.range;

        // Hip rating
        public const hipRating: Function = Validators.range;

        // Butt rating
        public const buttRating: Function = Validators.range;

        // Body Parts
        // Skin
        public function skinType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameInGroup('SKIN_TYPE_NAMES', args);
            return err;
        }

        // accentMarkings - Boolean

        // Eyes
        public function eyeType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_EYE_TYPES', args);
            return err;
        }

        // Hair
        public function hairType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameInGroup('HAIR_TYPE_NAMES', args);
            return err;
        }

        // Beard
        public function beardType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameInGroup('HAIR_TYPE_NAMES', args);
            return err;
        }

        // Face
        public function faceType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_FACE_TYPES', args);
            return err;
        }

        public function faceFlag(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_FACE_FLAGS', args);
            return err;
        }

        public function faceFlags(args: Array, results: int): String {
            var err: String = hasAtLeastOneStringArgUpToTwoResults(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_FACE_FLAGS', args);
            return err;
        }

        // Tongue
        public function tongueType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_TONGUE_TYPES', args);
            return err;
        }

        public function tongueFlag(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_TONGUE_FLAGS', args);
            return err;
        }

        public function tongueFlags(args: Array, results: int): String {
            var err: String = hasAtLeastOneStringArgUpToTwoResults(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_TONGUE_FLAGS', args);
            return err;
        }

        // Ear
        public function earType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_EAR_TYPES', args);
            return err;
        }

        public function earFlag(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_EAR_FLAGS', args);
            return err;
        }

        public function earFlags(args: Array, results: int): String {
            var err: String = hasAtLeastOneStringArgUpToTwoResults(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_EAR_FLAGS', args);
            return err;
        }

        // Antennae
        public function antennaeType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_ANTENNAE_TYPES', args);
            return err;
        }

        // Horn
        public function hornType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_HORN_TYPES', args);
            return err;
        }

        // horns - Boolean

        // Arm
        public function armType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_ARM_TYPES', args);
            return err;
        }

        public function armFlag(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_ARM_FLAGS', args);
            return err;
        }

        public function armFlags(args: Array, results: int): String {
            var err: String = hasAtLeastOneStringArgUpToTwoResults(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_ARM_FLAGS', args);
            return err;
        }

        // Wing
        public function wingType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_WING_TYPES', args);
            return err;
        }

        // Leg
        public function legType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_LEG_TYPES', args);
            return err;
        }

        public function legFlag(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_LEG_FLAGS', args);
            return err;
        }

        public function legFlags(args: Array, results: int): String {
            var err: String = hasAtLeastOneStringArgUpToTwoResults(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_LEG_FLAGS', args);
            return err;
        }

        // Lowerbody
        private const lowerBodyList: Array = ['biped', 'naga', 'taur', 'centaur', 'drider', 'goo'];
        public function lowerbody(args: Array, results: int): String {
            var err: String = Validators.minLength(args.length, 1, Validators.ARGS);
            if (!err) err = Validators.maxLength(args.length, this.lowerBodyList.length, Validators.ARGS);
            if (!err) err = Validators.minLength(results, 1, Validators.RESS);
            if (!err) err = Validators.maxLength(results, args.length, Validators.RESS);
            if (!err) err = this.nameInList(this.lowerBodyList, args);
            return err;
        }

        // Tail
        public function tailType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_TAIL_TYPES', args);
            return err;
        }

        public const tails: Function = Validators.range;

        public function tailFlag(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_TAIL_FLAGS', args);
            return err;
        }

        public function tailFlags(args: Array, results: int): String {
            var err: String = hasAtLeastOneStringArgUpToTwoResults(args, results);
            if (!err) err = this.nameToIndexInGroup('FLAG_NAMES', 'VALID_TAIL_FLAGS', args);
            return err;
        }

        // Cock
        public function cocknom(args: Array, results: int): String {
            var err: String = Validators.maxLength(args.length, 0, Validators.ARGS);
            if (!err) err = Validators.maxLength(results, 3, Validators.RESS);
            return err;
        }

        public const cockCount: Function = Validators.range;

        public function cockWType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_COCK_TYPES', args);
            return err;
        }

        public function cockType(args: Array, results: int): String {
            var err: String = hasOneIndexArgAtLeastOneOtherArg(args);
            if (!err) err = Validators.checkRange(args.length - 1, results);
            if (!err) err = this.nameToIndexInGroup('TYPE_NAMES', 'VALID_COCK_TYPES', args.slice(1));
            return err;
        }

        public const cockFits: Function = Validators.range;

        public function cockfks(args: Array, results: int): String {
            var err: String = Validators.maxLength(args.length, 0, Validators.ARGS);
            if (!err) err = Validators.maxLength(results, 4, Validators.RESS);
            return err;
        }

        // Balls
        // balls - Boolean

        public const ballCount: Function = Validators.range;

        public const ballSize: Function = Validators.range;

        // Breasts
        // breasts - Boolean

        public const breastCount: Function = Validators.range;

        private const breastCupList: Array = ["0-cup", "A-cup", "B-cup", "C-cup", "D-cup", "DD-cup", "big DD-cup", "E-cup", "big E-cup", "EE-cup", "big EE-cup", "F-cup", "big F-cup", "FF-cup", "big FF-cup", "G-cup", "big G-cup", "GG-cup", "big GG-cup", "H-cup", "big H-cup", "HH-cup", "big HH-cup", "HHH-cup", "I-cup", "big I-cup", "II-cup", "big II-cup", "J-cup", "big J-cup", "JJ-cup", "big JJ-cup", "K-cup", "big K-cup", "KK-cup", "big KK-cup", "L-cup", "big L-cup", "LL-cup", "big LL-cup", "M-cup", "big M-cup", "MM-cup", "big MM-cup", "MMM-cup", "large MMM-cup", "N-cup", "large N-cup", "NN-cup", "large NN-cup", "O-cup", "large O-cup", "OO-cup", "large OO-cup", "P-cup", "large P-cup", "PP-cup", "large PP-cup", "Q-cup", "large Q-cup", "QQ-cup", "large QQ-cup", "R-cup", "large R-cup", "RR-cup", "large RR-cup", "S-cup", "large S-cup", "SS-cup", "large SS-cup", "T-cup", "large T-cup", "TT-cup", "large TT-cup", "U-cup", "large U-cup", "UU-cup", "large UU-cup", "V-cup", "large V-cup", "VV-cup", "large VV-cup", "W-cup", "large W-cup", "WW-cup", "large WW-cup", "X-cup", "large X-cup", "XX-cup", "large XX-cup", "Y-cup", "large Y-cup", "YY-cup", "large YY-cup", "Z-cup", "large Z-cup", "ZZ-cup", "large ZZ-cup", "ZZZ-cup", "large ZZZ-cup", "hyper A-cup", "hyper B-cup", "hyper C-cup", "hyper D-cup", "hyper DD-cup", "hyper big DD-cup", "hyper E-cup", "hyper big E-cup", "hyper EE-cup", "hyper big EE-cup", "hyper F-cup", "hyper big F-cup", "hyper FF-cup", "hyper big FF-cup", "hyper G-cup", "hyper big G-cup", "hyper GG-cup", "hyper big GG-cup", "hyper H-cup", "hyper big H-cup", "hyper HH-cup", "hyper big HH-cup", "hyper HHH-cup", "hyper I-cup", "hyper big I-cup", "hyper II-cup", "hyper big II-cup", "hyper J-cup", "hyper big J-cup", "hyper JJ-cup", "hyper big JJ-cup", "hyper K-cup", "hyper big K-cup", "hyper KK-cup", "hyper big KK-cup", "hyper L-cup", "hyper big L-cup", "hyper LL-cup", "hyper big LL-cup", "hyper M-cup", "hyper big M-cup", "hyper MM-cup", "hyper big MM-cup", "hyper MMM-cup", "hyper large MMM-cup", "hyper N-cup", "hyper large N-cup", "hyper NN-cup", "hyper large NN-cup", "hyper O-cup", "hyper large O-cup", "hyper OO-cup", "hyper large OO-cup", "hyper P-cup", "hyper large P-cup", "hyper PP-cup", "hyper large PP-cup", "hyper Q-cup", "hyper large Q-cup", "hyper QQ-cup", "hyper large QQ-cup", "hyper R-cup", "hyper large R-cup", "hyper RR-cup", "hyper large RR-cup", "hyper S-cup", "hyper large S-cup", "hyper SS-cup", "hyper large SS-cup", "hyper T-cup", "hyper large T-cup", "hyper TT-cup", "hyper large TT-cup", "hyper U-cup", "hyper large U-cup", "hyper UU-cup", "hyper large UU-cup", "hyper V-cup", "hyper large V-cup", "hyper VV-cup", "hyper large VV-cup", "hyper W-cup", "hyper large W-cup", "hyper WW-cup", "hyper large WW-cup", "hyper X-cup", "hyper large X-cup", "hyper XX-cup", "hyper large XX-cup", "hyper Y-cup", "hyper large Y-cup", "hyper YY-cup", "hyper large YY-cup", "hyper Z-cup", "hyper large Z-cup", "hyper ZZ-cup", "hyper large ZZ-cup", "hyper ZZZ-cup", "hyper large ZZZ-cup", "Jacques00-cup"];

        private function inBreastCupList(key: String): Boolean {
            for (var idx:int = 0; idx < this.breastCupList.length; idx++)
                if (this.breastCupList[idx] === key)
                    return true;
            return false;
        }

        public function breastCupSize(args: Array, results: int): String {
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

        // Cock / Vag
        public function cockVag(args: Array, results: int): String {
            var err: String = Validators.maxLength(args.length, 0, Validators.ARGS);
            if (!err) err = Validators.maxLength(results, 3, Validators.RESS);
            return err;
        }

        // Vagina
        public function vagnom(args: Array, results: int): String {
            var err: String = Validators.maxLength(args.length, 0, Validators.ARGS);
            if (!err) err = Validators.maxLength(results, 3, Validators.RESS);
            return err;
        }

        public const vagLoose: Function = Validators.range;

        public const vagWet: Function = Validators.range;

        public const vagCap: Function = Validators.range;

        // squirt - Boolean

        // Butt
        public const analLoose: Function = Validators.range;

        public const analWet: Function = Validators.range;

        public const analCap: Function = Validators.range;

        // Fluids
        // Milk
        public function milkType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLUID_TYPE_NAMES', 'VALID_MILK_TYPES', args);
            return err;
        }

        public const milkVol: Function = Validators.range;
        public const milkQ: Function = Validators.range;

        // Cum
        public function cumType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLUID_TYPE_NAMES', 'VALID_CUM_TYPES', args);
            return err;
        }

        public const cumVol: Function = Validators.range;
        public const cumQ: Function = Validators.range;

        // Girl Cum
        public function girlCumType(args: Array, results: int): String {
            var err: String = Validators.range(args, results);
            if (!err) err = this.nameToIndexInGroup('FLUID_TYPE_NAMES', 'VALID_GIRLCUM_TYPES', args);
            return err;
        }

        public const girlCumVol: Function = Validators.range;
        public const girlCumQ: Function = Validators.range;

        // Personality
        public function nma(args: Array, results: int): String {
            var err: String = Validators.maxLength(args.length, 0, Validators.ARGS);
            if (!err) err = Validators.maxLength(results, 3, Validators.RESS);
            return err;
        }

        // Exposure
        private const exposedList: Array = ['none', 'all', 'chest', 'crotch', 'ass'];
        public function exposed(args: Array, results: int): String {
            var err: String = Validators.minLength(args.length, 1, Validators.ARGS);
            if (!err) err = Validators.maxLength(args.length, this.exposedList.length, Validators.ARGS);
            if (!err) err = Validators.minLength(results, 1, Validators.RESS);
            if (!err) err = Validators.maxLength(results, args.length, Validators.RESS);
            if (!err) err = this.nameInList(this.exposedList, args);
            return err;
        }

        // Sex Appearance
        public function mfhn(args: Array, results: int): String {
            var err: String = Validators.maxLength(args.length, 0, Validators.ARGS);
            if (!err) err = Validators.maxLength(results, 4, Validators.RESS);
            return err;
        }

        // mf - Boolean

        // Stats
        public const lust: Function = Validators.range;

        public const physique: Function = Validators.range;

        public const reflex: Function = Validators.range;

        public const aim: Function = Validators.range;

        public const inte: Function = Validators.range;

        public const will: Function = Validators.range;

        public const libido: Function = Validators.range;

        public const taint: Function = Validators.range;

        // Effects
        // Heat
        // Rut
        public function heatDeepRut(args: Array, results: int): String {
            var err: String = Validators.maxLength(args.length, 0, Validators.ARGS);
            if (!err) err = Validators.maxLength(results, 4, Validators.RESS);
            return err;
        }

        // Bimbo
        public function bimBro(args: Array, results: int): String {
            var err: String = Validators.maxLength(args.length, 0, Validators.ARGS);
            if (!err) err = Validators.maxLength(results, 3, Validators.RESS);
            return err;
        }

        // Treated
        private const treatedList: Array = ['none', 'any', 'cow', 'bull', 'amazon', 'cumcow', 'cumslut', 'faux'];
        public function treated(args: Array, results: int): String {
            var err: String = Validators.minLength(args.length, 1, Validators.ARGS);
            if (!err) err = Validators.maxLength(args.length, this.treatedList.length, Validators.ARGS);
            if (!err) err = Validators.minLength(results, 1, Validators.RESS);
            if (!err) err = Validators.maxLength(results, args.length, Validators.RESS);
            if (!err) err = this.nameInList(this.treatedList, args);
            return err;
        }

        // Pheromones
        // pheromones - Boolean

        // Perk
        public const perk: Function = Validators.range;

        // StatusEffect
        public const seffect: Function = Validators.range;

        // Items
        // Piercing
        private const piercedList: Array = ['none', 'any', 'ear', 'eyebrow', 'nose', 'lip', 'tongue', 'belly'];
        public function pierced(args: Array, results: int): String {
            var err: String = Validators.minLength(args.length, 1, Validators.ARGS);
            if (!err) err = Validators.maxLength(args.length, this.piercedList.length, Validators.ARGS);
            if (!err) err = Validators.minLength(results, 1, Validators.RESS);
            if (!err) err = Validators.maxLength(results, args.length, Validators.RESS);
            if (!err) err = this.nameInList(this.piercedList, args);
            return err;
        }

        private function hasOneOptionalNumberArgUpToTwoResults(args: Array, results: int): String {
            var err: String = Validators.maxLength(args.length, 1, Validators.ARGS);
            if (!err) err = Validators.checkTypeAt(args, 0, 'number', Validators.ARGS);
            if (!err) err = Validators.maxLength(results, 2, Validators.RESS);
            return null;
        }

        public const nipplePierced: Function = hasOneOptionalNumberArgUpToTwoResults;
        public const cockPierced: Function = hasOneOptionalNumberArgUpToTwoResults;
        public const vaginaPierced: Function = hasOneOptionalNumberArgUpToTwoResults;
        public const clitPierced: Function = hasOneOptionalNumberArgUpToTwoResults;
        public const sockOnCock: Function = hasOneOptionalNumberArgUpToTwoResults;

        // Keyitem
        public const keyItem: Function = Validators.range;
    }
}
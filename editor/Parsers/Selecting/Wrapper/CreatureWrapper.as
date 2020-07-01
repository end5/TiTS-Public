package editor.Parsers.Selecting.Wrapper {
    import classes.Creature;
    import classes.GLOBAL;
    import editor.Parsers.ObjectAccessor;
    import editor.Parsers.Eval;

    /**
     * This is used to limit the interpreter's access
     * Mainly taken from getDesc in Creature
     */
    public class CreatureWrapper {
        private var ownerObj: ObjectAccessor;

        public function CreatureWrapper(ownerObj: ObjectAccessor) {
            this.ownerObj = ownerObj;
        }

        protected function get owner(): Creature { return this.ownerObj.value(); }

        // Lookup
        private function nameToIndex(key: String, name: String): int {
            return GLOBAL[key].indexOf(name.charAt(0).toLocaleUpperCase() + name.slice(1));
        }

        private function mapNameToIndex(key: String): Function {
            return function (name: String, idx: int, arr: Array): int {
                return nameToIndex(key, name);
            }
        }

        // Functionality
        private function hasFlag(flags: Array, args: Array): int {
            for (var idx: int = 0; idx < args.length; idx++) {
                for each (var flag: int in flags)
                    if (args[idx] == flag)
                        return idx;
            }
            return idx;
        }

        private function hasFlags(flags: Array, args: Array): int {
            return hasFlag(flags, args) != args.length ? 0 : 1;
        }


        // Physical Appearance
        // Femininity
        public function fem(... args): int {
            return Eval.range(this.owner.femininity, args);
        }

        // Tallness
        public function tallness(... args): int {
            return Eval.range(this.owner.tallness, args);
        }

        // Thickness
        public function thickness(... args): int {
            return Eval.range(this.owner.thickness, args);
        }

        // Tone
        public function tone(... args): int {
            return Eval.range(this.owner.tone, args);
        }

        // Hip rating
        public function hipRating(... args): int {
            return Eval.equals(this.owner.hipRating(), args);
        }

        // Butt rating
        public function buttRating(... args): int {
            return Eval.equals(this.owner.buttRating(), args);
        }

        // Body Parts
        // Skin
        public function skinType(... args): int {
            return Eval.equals(this.owner.skinType, args.map(mapNameToIndex('SKIN_TYPE_NAMES')));
        }

        public function get accentMarkings(): Boolean {
            return this.owner.hasAccentMarkings();
        }

        // Eyes
        public function eyeType(... args): int {
            return Eval.equals(this.owner.eyeType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        // Hair
        public function hairType(... args): Number {
            return Eval.equals(this.owner.hairType, args.map(mapNameToIndex('HAIR_TYPE_NAMES')));
        }

        // Beard
        public function beardType(... args): int {
            return Eval.equals(this.owner.beardType, args.map(mapNameToIndex('HAIR_TYPE_NAMES')));
        }

        // Face
        public function faceType(... args): int {
            return Eval.equals(this.owner.faceType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        public function faceFlag(... args): int {
            return hasFlag(this.owner.faceFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        public function faceFlags(... args): int {
            return hasFlags(this.owner.faceFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        // Tongue
        public function tongueType(... args): int {
            return Eval.equals(this.owner.tongueType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        public function tongueFlag(... args): int {
            return hasFlag(this.owner.tongueFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        public function tongueFlags(... args): int {
            return hasFlags(this.owner.tongueFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        // Ear
        public function earType(... args): int {
            return Eval.equals(this.owner.earType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        public function earFlag(... args): int {
            return hasFlag(this.owner.earFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        public function earFlags(... args): int {
            return hasFlags(this.owner.earFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        // Antennae
        public function antennaeType(... args): int {
            return Eval.equals(this.owner.antennaeType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        // Horn
        public function hornType(... args): int {
            return Eval.equals(this.owner.hornType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        public function get horns(): Boolean {
            return this.owner.hasHorns();
        }

        // Arm
        public function armType(... args): int {
            return Eval.equals(this.owner.armType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        public function armFlag(... args): int {
            return hasFlag(this.owner.armFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        public function armFlags(... args): int {
            return hasFlags(this.owner.armFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        // Wing
        public function wingType(... args): int {
            return Eval.equals(this.owner.wingType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        // Leg
        public function legType(... args): int {
            return Eval.equals(this.owner.legType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        public function legFlag(... args): int {
            return hasFlag(this.owner.legFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        public function legFlags(... args): int {
            return hasFlags(this.owner.legFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        // Lowerbody
        public function lowerbody(... args): int {
            for (var idx: int = 0; idx < args.length; idx++) {
                // Checks to make sure this exists in Creature
                switch (args[idx]) {
                    case 'biped':
                        if (this.owner.isBiped())
                            return idx;
                    case 'naga':
                        if (this.owner.isNaga())
                            return idx;
                    case 'taur':
                        if (this.owner.isTaur())
                            return idx;
                    case 'centaur':
                        if (this.owner.isCentaur())
                            return idx;
                    case 'drider':
                        if (this.owner.isDrider())
                            return idx;
                    case 'goo':
                        if (this.owner.isGoo())
                            return idx;
                }
            }
            return idx;
        }

        // Tail
        public function tailType(... args): int {
            return Eval.equals(this.owner.tailType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        public function tails(... args): int {
            return Eval.range(this.owner.tailCount, args);
        }

        public function tailFlag(... args): int {
            return hasFlag(this.owner.tailFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        public function tailFlags(... args): int {
            return hasFlags(this.owner.tailFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        // Cock
        public function cocknom(... args): int {
            switch (this.owner.cocks.length) {
                case 0: return 0;
                case 1: return 1;
                default: return 2;
            }
        }

        public function cockCount(... args): int {
            return Eval.equals(this.owner.cocks.length, args);
        }

        public function cockWType(... args): int {
            for (var idx: int = 0; idx < args.length; idx++) {
                if (this.owner.hasCock(nameToIndex('TYPE_NAMES', args[idx])))
                    return idx;
            }
            return args.length;
        }

        public function cockType(cockIdx: int, ... args): int {
            if (cockIdx >= 0 && cockIdx < this.owner.cocks.length)
                for (var idx: int = 0; idx < args.length; idx++) {
                    if (this.owner.cocks[cockIdx].cType === nameToIndex('TYPE_NAMES', args[idx]))
                        return idx;
                }
            return args.length;
        }

        public function cockFits(... args): int {
            for (var idx: int = 0; idx < args.length; idx++) {
                if (this.owner.cockThatFits(args[idx]))
                    return idx;
            }
            return args.length;
        }

        public function get cockfks(): int {
            if (this.owner.hasACockFlag(GLOBAL.FLAG_FLARED)) return 0;
            else if (this.owner.hasACockFlag(GLOBAL.FLAG_KNOTTED)) return 1;
            else if (this.owner.hasACockFlag(GLOBAL.FLAG_SHEATHED)) return 2;
            else return 3;
        }

        // Balls
        public function balls(): Boolean {
            return this.owner.balls > 0;
        }

        public function ballsCount(... args): int {
            return Eval.equals(this.owner.balls, args);
        }

        public function ballSize(... args): int {
            return Eval.range(this.owner.ballSize(), args);
        }

        // Breasts
        public function breasts(): Boolean {
            return this.owner.hasBreasts();
        }

        public function breastCount(... args): int {
            return Eval.equals(this.owner.totalBreasts(), args);
        }

        public function breastCupSize(idx: int, ... args): int {
            return Eval.equals(this.owner.breastCup(idx), args);
        }

        // Cock / Vag
        public function cockVag(... args): int {
            if (this.owner.hasCock()) return 0;
            else if (this.owner.hasVagina()) return 1;
            else return 2;
        }

        // Vagina
        public function vagnom(... args): int {
            switch (this.owner.vaginas.length) {
                case 0: return 0;
                case 1: return 1;
                default: return 2;
            }
        }

        public function vagLoose(... args): int {
            return Eval.range(this.owner.looseness(), args);
        }

        public function vagWet(... args): int {
            return Eval.range(this.owner.wetness(), args);
        }

        public function vagCap(... args): int {
            return Eval.range(this.owner.vaginalCapacity(), args);
        }

        public function get squirt(): Boolean {
            return this.owner.isSquirter();
        }

        // Butt
        public function analLoose(... args): int {
            return Eval.range(this.owner.ass.looseness(), args);
        }

        public function analWet(... args): int {
            return Eval.range(this.owner.ass.wetness(), args);
        }

        public function analCap(... args): int {
            return Eval.range(this.owner.analCapacity(), args);
        }


        // Fluids
        // Milk
        public function milkType(... args): int {
            return Eval.equals(this.owner.milkType, args);
        }

        public function milkVol(... args): int { return this.milkQ(args); }
        public function milkQ(... args): int {
            return Eval.range(this.owner.milkQ(), args);
        }

        // Cum
        public function cumType(... args): int {
            return Eval.equals(this.owner.cumType, args.map(mapNameToIndex('FLUID_TYPE_NAMES')));
        }

        public function cumVol(... args): int { return this.cumQ(args); }
        public function cumQ(... args): int {
            return Eval.range(this.owner.cumQ(), args);
        }

        // Girl Cum
        public function girlCumType(... args): int {
            return Eval.equals(this.owner.girlCumType, args.map(mapNameToIndex('FLUID_TYPE_NAMES')));
        }

        public function girlCumVol(... args): int { return this.girlCumQ(args); }
        public function girlCumQ(... args): int {
            return Eval.range(this.owner.girlCumQ(), args);
        }

        // Personality
        // Nice / Misch / Ass
        public function get nma(): int {
            if (this.owner.isNice()) return 0;
            else if (this.owner.isMisch()) return 1;
            else return 2;
        }

        // Exposure
        // Exposed body parts [all, chest, crotch, ass]
        public function exposed(... args): int {
            for (var idx: int = 0; idx < args.length; idx++) {
                switch (args[idx]) {
                    case 'all':
                        if (this.owner.isExposed())
                            return idx;
                    case 'chest':
                        if (this.owner.isChestExposed())
                            return idx;
                    case 'crotch':
                        if (this.owner.isCrotchExposed())
                            return idx;
                    case 'ass':
                        if (this.owner.isAssExposed())
                            return idx;
                }
            }
            return idx;
        }

        // Sex Appearance
        // Male / Female / Herm / None
        public function mfhn(): int {
            if (this.owner.isMale()) return 0;
            else if (this.owner.isFemale()) return 1;
            else if (this.owner.isHerm()) return 2;
            else return 3;
        }

        // Male / Female With Pref
        public function mf(): Boolean {
            return this.owner.isMasculine();
        }

        // Stats
        public function lust(... args): int {
            return Eval.range(this.owner.lust(), args);
        }

        public function physique(... args): int {
            return Eval.range(this.owner.physique(), args);
        }

        public function reflex(... args): int {
            return Eval.range(this.owner.reflexes(), args);
        }

        public function aim(... args): int {
            return Eval.range(this.owner.aim(), args);
        }

        public function inte(... args): int {
            return Eval.range(this.owner.intelligence(), args);
        }

        public function will(... args): int {
            return Eval.range(this.owner.willpower(), args);
        }

        public function libido(... args): int {
            return Eval.range(this.owner.libido(), args);
        }

        public function taint(... args): int {
            return Eval.range(this.owner.taint(), args);
        }

        // Effects
        // Heat
        // Rut
        public function get heatDeepRut(): int {
            if (this.owner.inHeat()) return 0;
            else if (this.owner.inDeepHeat()) return 1;
            else if (this.owner.inRut()) return 2;
            else return 3;
        }

        // Bimbo
        public function bimBro(): int {
            if (this.owner.isBimbo()) return 0;
            else if (this.owner.isBro()) return 1
            else return 2;
        }

        // Treated
        public function treated(... args): int {
            for (var idx: int = 0; idx < args.length; idx++) {
                switch (args[idx]) {
                    case 'any':
                        if (this.owner.isTreated())
                            return idx;
                    case 'cow':
                        if (this.owner.isTreatedCow())
                            return idx;
                    case 'bull':
                        if (this.owner.isTreatedBull())
                            return idx;
                    case 'amazon':
                        if (this.owner.isAmazon(true))
                            return idx;
                    case 'cumcow':
                        if (this.owner.isCumCow())
                            return idx;
                    case 'cumslut':
                        if (this.owner.isCumSlut())
                            return idx;
                    case 'faux':
                        if (this.owner.isFauxCow())
                            return idx;
                }
            }
            return idx;
        }

        // Pheromones
        public function get pheromones(): Boolean {
            return this.owner.hasPheromones();
        }

        // Perk
        public function perk(... args): int {
            for (var idx: int = 0; idx < args.length; idx++)
                if (this.owner.hasPerk(args[idx]))
                    return idx;
            return args.length;
        }

        // StatusEffect
        public function seffect(... args): int {
            for (var idx: int = 0; idx < args.length; idx++)
                if (this.owner.hasStatusEffect(args[idx]))
                    return idx;
            return args.length;
        }

        // Items
        // Piercing
        public function pierced(... args): int {
            for (var idx: int = 0; idx < args.length; idx++) {
                switch (args[idx]) {
                    case 'any':
                        if (this.owner.hasPiercing())
                            return idx;
                    case 'ear':
                        if (this.owner.hasEarPiercing())
                            return idx;
                    case 'eyebrow':
                        if (this.owner.hasEyebrowPiercing())
                            return idx;
                    case 'nose':
                        if (this.owner.hasNosePiercing())
                            return idx;
                    case 'lip':
                        if (this.owner.hasLipPiercing())
                            return idx;
                    case 'tongue':
                        if (this.owner.hasTonguePiercing())
                            return idx;
                    case 'belly':
                        if (this.owner.hasBellyPiercing())
                            return idx;
                }
            }
            return idx;
        }
        public function nipplePierced(idx: int = -1): Boolean {
            return this.owner.hasPiercedNipples(idx);
        }
        public function cockPierced(idx: int = -1): Boolean {
            return this.owner.hasPiercedCocks(idx);
        }
        public function vaginaPierced(idx: int = -1): Boolean {
            return this.owner.hasPiercedVaginas(idx);
        }
        public function clitPierced(idx: int = -1): Boolean {
            return this.owner.hasPiercedClits(idx);
        }
        public function sockOnCock(idx: int = -1): Boolean {
            return this.owner.hasSockedCocks(idx);
        }

        // Keyitem
        public function keyItem(... args): int {
            for (var idx: int = 0; idx < args.length; idx++)
                if (this.owner.hasKeyItem(args[idx]))
                    return idx;
            return args.length;
        }
    }
}
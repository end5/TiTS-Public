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
        public function femIs(... args): int {
            return Eval.equals(this.owner.femininity, args);
        }

        public function femRange(... args): int {
            return Eval.range(this.owner.femininity, args);
        }

        // Tallness
        public function tallnessIs(... args): int {
            return Eval.equals(this.owner.tallness, args);
        }

        public function tallnessRange(... args): int {
            return Eval.range(this.owner.tallness, args);
        }

        // Thickness
        public function thicknessIs(... args): int {
            return Eval.equals(this.owner.thickness, args);
        }

        public function thicknessRange(... args): int {
            return Eval.range(this.owner.thickness, args);
        }

        // Tone
        public function toneIs(... args): int {
            return Eval.equals(this.owner.tone, args);
        }

        public function toneRange(... args): int {
            return Eval.range(this.owner.tone, args);
        }

        // Hip rating
        public function hipRatingIs(... args): int {
            return Eval.equals(this.owner.hipRating(), args);
        }

        // Butt rating
        public function buttRatingIs(... args): int {
            return Eval.equals(this.owner.buttRating(), args);
        }

        // Body Parts
        // Skin
        public function skinTypeIs(... args): int {
            return Eval.equals(this.owner.skinType, args.map(mapNameToIndex('SKIN_TYPE_NAMES')));
        }

        public function get hasAccentMarkings(): Boolean {
            return this.owner.hasAccentMarkings();
        }

        // Eyes
        public function eyeTypeIs(... args): int {
            return Eval.equals(this.owner.eyeType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        // Hair
        public function hairTypeIs(... args): Number {
            return Eval.equals(this.owner.hairType, args.map(mapNameToIndex('HAIR_TYPE_NAMES')));
        }

        // Beard
        public function beardTypeIs(... args): int {
            return Eval.equals(this.owner.beardType, args.map(mapNameToIndex('HAIR_TYPE_NAMES')));
        }

        // Face
        public function faceTypeIs(... args): int {
            return Eval.equals(this.owner.faceType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        public function hasFaceFlag(... args): int {
            return hasFlag(this.owner.faceFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        public function hasFaceFlags(... args): int {
            return hasFlags(this.owner.faceFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        // Tongue
        public function tongueTypeIs(... args): int {
            return Eval.equals(this.owner.tongueType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        public function hasTongueFlag(... args): int {
            return hasFlag(this.owner.tongueFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        public function hasTongueFlags(... args): int {
            return hasFlags(this.owner.tongueFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        // Ear
        public function earTypeIs(... args): int {
            return Eval.equals(this.owner.earType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        public function hasEarFlag(... args): int {
            return hasFlag(this.owner.earFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        public function hasEarFlags(... args): int {
            return hasFlags(this.owner.earFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        // Antennae
        public function antennaeTypeIs(... args): int {
            return Eval.equals(this.owner.antennaeType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        // Horn
        public function hornTypeIs(... args): int {
            return Eval.equals(this.owner.hornType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        // Arm
        public function armTypeIs(... args): int {
            return Eval.equals(this.owner.armType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        public function hasArmFlag(... args): int {
            return hasFlag(this.owner.armFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        public function hasArmFlags(... args): int {
            return hasFlags(this.owner.armFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        // Wing
        public function wingTypeIs(... args): int {
            return Eval.equals(this.owner.wingType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        // Leg
        public function legTypeIs(... args): int {
            return Eval.equals(this.owner.legType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        public function hasLegFlag(... args): int {
            return hasFlag(this.owner.legFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        public function hasLegFlags(... args): int {
            return hasFlags(this.owner.legFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        // Lowerbody
        public function get isBiped(): Boolean {
            return this.owner.isBiped();
        }

        public function get isNaga(): Boolean {
            return this.owner.isNaga();
        }

        public function get isTaur(): Boolean {
            return this.owner.isTaur();
        }

        public function get isCentaur(): Boolean {
            return this.owner.isCentaur();
        }

        public function get isDrider(): Boolean {
            return this.owner.isDrider();
        }

        public function get isGoo(): Boolean {
            return this.owner.isGoo();
        }

        // Tail
        public function tailTypeIs(... args): int {
            return Eval.equals(this.owner.tailType, args.map(mapNameToIndex('TYPE_NAMES')));
        }

        public function tailCountIs(... args): int {
            return Eval.equals(this.owner.tailCount, args);
        }

        public function tailCountRange(... args): int {
            return Eval.range(this.owner.tailCount, args);
        }

        public function hasTailFlag(... args): int {
            return hasFlag(this.owner.tailFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        public function hasTailFlags(... args): int {
            return hasFlags(this.owner.tailFlags, args.map(mapNameToIndex('FLAG_NAMES')));
        }

        // Cock
        public function get hasCock(): Boolean {
            return this.owner.hasCock();
        }

        public function get hasCocks(): Boolean {
            return this.owner.hasCocks();
        }

        public function hasACockWithType(... args): int {
            for (var idx: int = 0; idx < args.length; idx++) {
                if (this.owner.hasCock(nameToIndex('TYPE_NAMES', args[idx])))
                    return idx;
            }
            return args.length;
        }

        public function cockCountIs(... args): int {
            return Eval.equals(this.owner.cocks.length, args);
        }

        public function cockTypeIs(cockIdx: int, ... args): int {
            if (cockIdx >= 0 && cockIdx < this.owner.cocks.length)
                for (var idx: int = 0; idx < args.length; idx++) {
                    if (this.owner.cocks[cockIdx].cType === nameToIndex('TYPE_NAMES', args[idx]))
                        return idx;
                }
            return args.length;
        }

        public function cockThatFits(fits:Number = 0): int {
            return this.owner.cockThatFits(fits);
        }

        public function biggestCockIndex(): int {
            return this.owner.biggestCockIndex();
        }

        public function smallestCockIndex(): int {
            return this.owner.smallestCockIndex();
        }

        public function thickestCockIndex(): int {
            return this.owner.thinnestCockIndex();
        }

        public function thinnestCockIndex(): int {
            return this.owner.thinnestCockIndex();
        }

        public function longestCockIndex(): int {
            return this.owner.longestCockIndex();
        }

        public function shortestCockIndex(): int {
            return this.owner.shortestCockIndex();
        }

        // Balls
        public function ballCountIs(... args): int {
            return Eval.equals(this.owner.balls, args);
        }

        public function ballSizeIs(... args): int {
            return Eval.equals(this.owner.ballSize(), args);
        }

        // Breasts
        public function hasBreasts(): Boolean {
            return this.owner.hasBreasts();
        }

        public function breastCountIs(... args): int {
            return Eval.equals(this.owner.totalBreasts(), args);
        }

        public function breastCupSizeIs(idx: int, ... args): int {
            return Eval.equals(this.owner.breastCup(idx), args);
        }

        // Vagina
        public function get hasVagina(): Boolean {
            return this.owner.hasVagina();
        }

        // Fluids
        // Milk
        public function milkTypeIs(... args): int {
            return Eval.equals(this.owner.milkType, args);
        }

        public function milkQRange(... args): int {
            return Eval.range(this.owner.milkQ(), args);
        }

        // Cum
        public function cumTypeIs(... args): int {
            return Eval.equals(this.owner.cumType, args.map(mapNameToIndex('FLUID_TYPE_NAMES')));
        }

        public function cumQRange(... args): int {
            return Eval.range(this.owner.cumQ(), args);
        }

        // Girl Cum
        public function girlCumTypeIs(... args): int {
            return Eval.equals(this.owner.girlCumType, args.map(mapNameToIndex('FLUID_TYPE_NAMES')));
        }

        public function girlCumQRange(... args): int {
            return Eval.range(this.owner.girlCumQ(), args);
        }

        // Personality
        public function get isNice(): Boolean {
            return this.owner.isNice();
        }

        public function get isMisch(): Boolean {
            return this.owner.isMisch();
        }

        public function get isAss(): Boolean {
            return this.owner.isAss();
        }

        // Exposure
        public function get isExposed(): Boolean {
            return this.owner.isExposed();
        }

        public function get isChestExposed(): Boolean {
            return this.owner.isChestExposed();
        }

        public function get isCrotchExposed(): Boolean {
            return this.owner.isCrotchExposed();
        }

        public function get isAssExposed(): Boolean {
            return this.owner.isAssExposed();
        }

        // Sex
        public function get isSexless(): Boolean {
            return this.owner.isSexless();
        }

        public function get isMale(): Boolean {
            return this.owner.isMale();
        }

        public function get isFemale(): Boolean {
            return this.owner.isFemale();
        }

        // Sex Appearance
        public function get isMasculine(): Boolean {
            return this.owner.isMasculine();
        }

        public function get isFeminine(): Boolean {
            return this.owner.isFeminine();
        }

        public function get isMan(): Boolean {
            return this.owner.isMan();
        }

        public function get isWoman(): Boolean {
            return this.owner.isWoman();
        }

        public function get isFemboy(): Boolean {
            return this.owner.isFemboy();
        }

        public function get isShemale(): Boolean {
            return this.owner.isShemale();
        }

        public function get isCuntboy(): Boolean {
            return this.owner.isCuntboy();
        }

        public function get isFemmyMale(): Boolean {
            return this.owner.isFemmyMale();
        }

        public function get isManlyFemale(): Boolean {
            return this.owner.isManlyFemale();
        }

        public function isFemHerm(): Boolean {
            return this.owner.isFemHerm();
        }

        public function isManHerm(): Boolean {
            return this.owner.isManHerm();
        }

        // Stats
        public function lustIs(... args): int {
            return Eval.equals(this.owner.lust(), args);
        }

        public function lustRange(... args): int {
            return Eval.range(this.owner.lust(), args);
        }

        public function physiqueIs(... args): int {
            return Eval.equals(this.owner.physique(), args);
        }

        public function physiqueRange(... args): int {
            return Eval.range(this.owner.physique(), args);
        }

        public function reflexesIs(... args): int {
            return Eval.equals(this.owner.reflexes(), args);
        }

        public function reflexesRange(... args): int {
            return Eval.range(this.owner.reflexes(), args);
        }

        public function aimIs(... args): int {
            return Eval.equals(this.owner.aim(), args);
        }

        public function aimRange(... args): int {
            return Eval.range(this.owner.aim(), args);
        }

        public function intelligenceIs(... args): int {
            return Eval.equals(this.owner.intelligence(), args);
        }

        public function intelligenceRange(... args): int {
            return Eval.range(this.owner.intelligence(), args);
        }

        public function willpowerIs(... args): int {
            return Eval.equals(this.owner.willpower(), args);
        }

        public function willpowerRange(... args): int {
            return Eval.range(this.owner.willpower(), args);
        }

        public function libidoIs(... args): int {
            return Eval.equals(this.owner.libido(), args);
        }

        public function libidoRange(... args): int {
            return Eval.range(this.owner.libido(), args);
        }

        public function taintIs(... args): int {
            return Eval.equals(this.owner.taint(), args);
        }

        public function taintRange(... args): int {
            return Eval.range(this.owner.taint(), args);
        }

        // Effects
        // Heat
        public function get inHeat(): Boolean {
            return this.owner.inHeat();
        }

        public function get inDeepHeat(): Boolean {
            return this.owner.inDeepHeat();
        }

        // Rut
        public function get inRut(): Boolean {
            return this.owner.inRut();
        }

        // Bimbo
        public function isBimbo(): Boolean {
            return this.owner.isBimbo();
        }

        public function isBro(): Boolean {
            return this.owner.isBro();
        }

        // Treated
        public function get isTreated(): Boolean {
            return this.owner.isTreated();
        }

        public function get isTreatedFemale(): Boolean {
            return this.owner.isTreatedFemale();
        }

        public function get isTreatedMale(): Boolean {
            return this.owner.isTreatedMale();
        }

        public function get isTreatedCow(): Boolean {
            return this.owner.isTreatedCow();
        }

        public function get isTreatedBull(): Boolean {
            return this.owner.isTreatedBull();
        }

        public function get isAmazon(): Boolean {
            return this.owner.isAmazon();
        }

        public function get isCumCow(): Boolean {
            return this.owner.isCumCow();
        }

        public function get isCumSlut(): Boolean {
            return this.owner.isCumSlut();
        }

        public function get isFauxCow(): Boolean {
            return this.owner.isFauxCow();
        }

        // Pheromones
        public function get hasPheromones(): Boolean {
            return this.owner.hasPheromones();
        }

        // Perk
        public function hasPerk(... args): int {
            for (var idx: int = 0; idx < args.length; idx++)
                if (this.owner.hasPerk(args[idx]))
                    return idx;
            return args.length;
        }

        // StatusEffect
        public function hasStatusEffect(... args): int {
            for (var idx: int = 0; idx < args.length; idx++)
                if (this.owner.hasStatusEffect(args[idx]))
                    return idx;
            return args.length;
        }

        // Items
        // Piercing
        public function get hasPiercing(): Boolean {
            return this.owner.hasPiercing();
        }
        public function get hasEarPiercing(): Boolean {
            return this.owner.hasEarPiercing();
        }
        public function get hasEyebrowPiercing(): Boolean {
            return this.owner.hasEyebrowPiercing();
        }
        public function get hasNosePiercing(): Boolean {
            return this.owner.hasNosePiercing();
        }
        public function get hasLipPiercing(): Boolean {
            return this.owner.hasLipPiercing();
        }
        public function get hasTonguePiercing(): Boolean {
            return this.owner.hasTonguePiercing();
        }
        public function get hasBellyPiercing(): Boolean {
            return this.owner.hasBellyPiercing();
        }
        public function hasNipplePiercing(idx: int = -1): Boolean {
            return this.owner.hasPiercedNipples(idx);
        }
        public function hasCockPiercing(idx: int = -1): Boolean {
            return this.owner.hasPiercedCocks(idx);
        }
        public function hasPiercedVaginas(idx: int = -1): Boolean {
            return this.owner.hasPiercedVaginas(idx);
        }
        public function hasClitPiercing(idx: int = -1): Boolean {
            return this.owner.hasPiercedClits(idx);
        }
        public function hasCocksock(idx: int = -1): Boolean {
            return this.owner.hasSockedCocks(idx);
        }

        // Keyitem
        public function hasKeyItem(... args): int {
            for (var idx: int = 0; idx < args.length; idx++)
                if (this.owner.hasKeyItem(args[idx]))
                    return idx;
            return args.length;
        }
    }
}
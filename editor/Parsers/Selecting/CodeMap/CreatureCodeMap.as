package editor.Parsers.Selecting.CodeMap {
    import editor.Lang.Codify.CodeNode;
    import editor.Parsers.ToCode;

    public class CreatureCodeMap {
        // Lookup
        private function nameToIndex(key: String, name: String): String {
            return 'GLOBAL.' + key.substr(0, key.lastIndexOf('_') + 1) + name.toLocaleUpperCase();
        }

        private function mapNameToIndex(key: String): Function {
            // Each item is surrounded by ""
            return function (node: Array, idx: int, arr: Array): Array {
                return [new CodeNode(CodeNode.Code, nameToIndex(key, node[0].value))];
            }
        }

        // Physical Appearance
        //Femininity
        public function femIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'femininity'), args, results);
        }

        public function femRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'femininity'), args, results);
        }

        // Tallness
        public function tallnessIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'tallness'), args, results);
        }

        public function tallnessRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'tallness'), args, results);
        }

        // Thickness
        public function thicknessIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'thickness'), args, results);
        }

        public function thicknessRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'thickness'), args, results);
        }

        // Tone
        public function toneIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'tone'), args, results);
        }

        public function toneRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'tone'), args, results);
        }

        // Hip rating
        public function hipRatingIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'hipRating()'), args, results);
        }

        // Butt rating
        public function buttRatingIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'buttRating()'), args, results);
        }

        // Body Parts
        // Skin
        public function skinTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'skinType'), args.map(mapNameToIndex('SKIN_TYPE_NAMES')), results);
        }

        public function hasAccentMarkings(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'hasAccentMarkings()'), results);
        }

        // Eyes
        public function eyeTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'eyeType'), args.map(mapNameToIndex('TYPE_NAMES')), results);
        }

        // Hair
        public function hairTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'hairType'), args.map(mapNameToIndex('HAIR_TYPE_NAMES')), results);
        }

        // Beard
        public function beardTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'beardType'), args.map(mapNameToIndex('HAIR_TYPE_NAMES')), results);
        }

        // Face
        public function faceTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'faceType'), args.map(mapNameToIndex('TYPE_NAMES')), results);
        }

        public function hasFaceFlag(identities: Array, args: Array, results: Array): Array {
            return ToCode.callRange(ToCode.replaceIdentity(identities, 1, 'hasFaceFlag'), args.map(mapNameToIndex('FLAG_NAMES')), results);
        }

        public function hasFaceFlags(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.funcCall(ToCode.replaceIdentity(identities, 1, 'hasFaceFlag'), args.map(mapNameToIndex('FLAG_NAMES'))), results);
        }

        // Tongue
        public function tongueTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'tongueType'), args.map(mapNameToIndex('TYPE_NAMES')), results);
        }

        public function hasTongueFlag(identities: Array, args: Array, results: Array): Array {
            return ToCode.callRange(ToCode.replaceIdentity(identities, 1, 'hasTongueFlag'), args.map(mapNameToIndex('FLAG_NAMES')), results);
        }

        public function hasTongueFlags(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.funcCall(ToCode.replaceIdentity(identities, 1, 'hasTongueFlag'), args.map(mapNameToIndex('FLAG_NAMES'))), results);
        }

        // Ear
        public function earTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'earType'), args.map(mapNameToIndex('TYPE_NAMES')), results);
        }

        public function hasEarFlag(identities: Array, args: Array, results: Array): Array {
            return ToCode.callRange(ToCode.replaceIdentity(identities, 1, 'hasEarFlag'), args.map(mapNameToIndex('FLAG_NAMES')), results);
        }

        public function hasEarFlags(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.funcCall(ToCode.replaceIdentity(identities, 1, 'hasEarFlag'), args.map(mapNameToIndex('FLAG_NAMES'))), results);
        }

        // Antennae
        public function antennaeTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'antennaeType'), args.map(mapNameToIndex('TYPE_NAMES')), results);
        }

        // Horn
        public function hornTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'hornType'), args.map(mapNameToIndex('TYPE_NAMES')), results);
        }

        // Arm
        public function armTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'armType'), args.map(mapNameToIndex('TYPE_NAMES')), results);
        }

        public function hasArmFlag(identities: Array, args: Array, results: Array): Array {
            return ToCode.callRange(ToCode.replaceIdentity(identities, 1, 'hasArmFlag'), args.map(mapNameToIndex('FLAG_NAMES')), results);
        }

        public function hasArmFlags(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.funcCall(ToCode.replaceIdentity(identities, 1, 'hasArmFlag'), args.map(mapNameToIndex('FLAG_NAMES'))), results);
        }

        // Wing
        public function wingTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'wingType'), args.map(mapNameToIndex('TYPE_NAMES')), results);
        }

        // Leg
        public function legTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'legType'), args.map(mapNameToIndex('TYPE_NAMES')), results);
        }

        public function hasLegFlag(identities: Array, args: Array, results: Array): Array {
            return ToCode.callRange(ToCode.replaceIdentity(identities, 1, 'hasLegFlag'), args.map(mapNameToIndex('FLAG_NAMES')), results);
        }

        public function hasLegFlags(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.funcCall(ToCode.replaceIdentity(identities, 1, 'hasLegFlag'), args.map(mapNameToIndex('FLAG_NAMES'))), results);
        }

        // Lowerbody
        public function isBiped(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isBiped()'), results);
        }

        public function isNaga(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isNaga()'), results);
        }

        public function isTaur(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isTaur()'), results);
        }

        public function isCentaur(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isCentaur()'), results);
        }

        public function isDrider(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isDrider()'), results);
        }

        public function isGoo(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isGoo()'), results);
        }

        // Tail
        public function tailTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'tailType'), args.map(mapNameToIndex('TYPE_NAMES')), results);
        }

        public function tailCountIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'tailCount'), args, results);
        }

        public function tailCountRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'tailCount'), args, results);
        }

        public function hasTailFlag(identities: Array, args: Array, results: Array): Array {
            return ToCode.callRange(ToCode.replaceIdentity(identities, 1, 'hasTailFlag'), args.map(mapNameToIndex('FLAG_NAMES')), results);
        }

        public function hasTailFlags(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.funcCall(ToCode.replaceIdentity(identities, 1, 'hasTailFlag'), args.map(mapNameToIndex('FLAG_NAMES'))), results);
        }

        // Cock
        public function hasCock(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'hasCock()'), results);
        }

        public function hasCocks(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'hasCocks()'), results);
        }

        public function hasACockWithType(identities: Array, args: Array, results: Array): Array {
            return ToCode.callRange(ToCode.replaceIdentity(identities, 1, 'hasCock'), args.map(mapNameToIndex(('TYPE_NAMES'))), results);
        }

        public function cockCountIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'cocks.length'), args.map(mapNameToIndex(('TYPE_NAMES'))), results);
        }

        public function cockTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'cocks[' + args[0] + '].type'), args.slice(1).map(mapNameToIndex(('TYPE_NAMES'))), results);
        }

        public function cockThatFits(identities: Array, args: Array, results: Array): Array {
            return [new CodeNode(CodeNode.Code, ToCode.funcCall(ToCode.combineIdentities(identities), args))];
        }

        public function biggestCockIndex(identities: Array, args: Array, results: Array): Array {
            return [new CodeNode(CodeNode.Code, ToCode.combineIdentities(identities) + '()')];
        }

        public function smallestCockIndex(identities: Array, args: Array, results: Array): Array {
            return [new CodeNode(CodeNode.Code, ToCode.combineIdentities(identities) + '()')];
        }

        public function thickestCockIndex(identities: Array, args: Array, results: Array): Array {
            return [new CodeNode(CodeNode.Code, ToCode.combineIdentities(identities) + '()')];
        }

        public function thinnestCockIndex(identities: Array, args: Array, results: Array): Array {
            return [new CodeNode(CodeNode.Code, ToCode.combineIdentities(identities) + '()')];
        }

        public function longestCockIndex(identities: Array, args: Array, results: Array): Array {
            return [new CodeNode(CodeNode.Code, ToCode.combineIdentities(identities) + '()')];
        }

        public function shortestCockIndex(identities: Array, args: Array, results: Array): Array {
            return [new CodeNode(CodeNode.Code, ToCode.combineIdentities(identities) + '()')];
        }

        // Balls
        public function ballCountIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'balls'), args, results);
        }

        public function ballSizeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'ballSize()'), args, results);
        }

        // Breasts
        public function hasBreasts(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(identities + '()', results);
        }

        public function breastCountIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'totalBreasts()'), args, results);
        }

        public function breastCupSizeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'breastCup(' + args[0] + ')'), args.slice(1), results);
        }

        // Vagina
        public function hasVagina(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(identities + '()', results);
        }

        // Fluids
        // Milk
        public function milkTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'milkType'), args, results);
        }

        public function milkQRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'milkQ()'), args, results);
        }

        // Cum
        public function cumTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'cumType'), args.map(mapNameToIndex('FLUID_TYPE_NAMES')), results);
        }

        public function cumQIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'cumQ()'), args, results);
        }

        public function cumQRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'cumQ()'), args, results);
        }

        // Girl Cum
        public function girlCumTypeIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'girlCumType'), args.map(mapNameToIndex('FLUID_TYPE_NAMES')), results);
        }

        public function girlCumQIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'girlCumQ()'), args, results);
        }

        public function girlCumQRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'girlCumQ()'), args, results);
        }

        // Personality
        public function isNice(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isNice()'), results);
        }

        public function isMisch(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isMisch()'), results);
        }

        public function isAss(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isAss()'), results);
        }

        // Exposure
        public function isExposed(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isExposed()'), results);
        }

        public function isChestExposed(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isChestExposed()'), results);
        }

        public function isCrotchExposed(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isCrotchExposed()'), results);
        }

        public function isAssExposed(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isAssExposed()'), results);
        }

        // Sex
        public function isSexless(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isSexless()'), results);
        }

        public function isMale(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isMale()'), results);
        }

        public function isFemale(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isFemale()'), results);
        }

        // Sex Appearance
        public function isMasculine(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isMasculine()'), results);
        }

        public function isFeminine(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isFeminine()'), results);
        }

        public function isMan(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isMan()'), results);
        }

        public function isWoman(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isWoman()'), results);
        }

        public function isFemboy(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isFemboy()'), results);
        }

        public function isShemale(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isShemale()'), results);
        }

        public function isCuntboy(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isCuntboy()'), results);
        }

        public function isFemmyMale(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isFemmyMale()'), results);
        }

        public function isManlyFemale(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isManlyFemale()'), results);
        }

        public function isFemHerm(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isFemHerm()'), results);
        }

        public function isManHerm(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'isManHerm()'), results);
        }

        // Stats
        public function lustIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'lust()'), args, results);
        }

        public function lustRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'lust()'), args, results);
        }

        public function physiqueIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'physique()'), args, results);
        }

        public function physiqueRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'physique()'), args, results);
        }

        public function reflexesIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'reflexes()'), args, results);
        }

        public function reflexesRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'reflexes()'), args, results);
        }

        public function aimIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'aim()'), args, results);
        }

        public function aimRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'aim()'), args, results);
        }

        public function intelligenceIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'intelligence()'), args, results);
        }

        public function intelligenceRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'intelligence()'), args, results);
        }

        public function willpowerIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'willpower()'), args, results);
        }

        public function willpowerRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'willpower()'), args, results);
        }

        public function libidoIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'libido()'), args, results);
        }

        public function libidoRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'libido()'), args, results);
        }

        public function taintIs(identities: Array, args: Array, results: Array): Array {
            return ToCode.equals(ToCode.replaceIdentity(identities, 1, 'taint()'), args, results);
        }

        public function taintRange(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'taint()'), args, results);
        }

        // Effects
        // Heat
        public function inHeat(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'inHeat()'), args, results);
        }

        public function inDeepHeat(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'inDeepHeat()'), args, results);
        }

        // Rut
        public function inRut(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'inRut()'), args, results);
        }

        // Bimbo
        public function isBimbo(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'isBimbo()'), args, results);
        }

        public function isBro(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'isBro()'), args, results);
        }

        // Treated
        public function isTreated(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'isTreated()'), args, results);
        }

        public function isTreatedFemale(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'isTreatedFemale()'), args, results);
        }

        public function isTreatedMale(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'isTreatedMale()'), args, results);
        }

        public function isTreatedCow(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'isTreatedCow()'), args, results);
        }

        public function isTreatedBull(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'isTreatedBull()'), args, results);
        }

        public function isAmazon(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'isAmazon()'), args, results);
        }

        public function isCumCow(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'isCumCow()'), args, results);
        }

        public function isCumSlut(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'isCumSlut()'), args, results);
        }

        public function isFauxCow(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'isFauxCow()'), args, results);
        }

        // Pheromones
        public function hasPheromones(identities: Array, args: Array, results: Array): Array {
            return ToCode.range(ToCode.replaceIdentity(identities, 1, 'hasPheromones()'), args, results);
        }

        // Perk
        public function hasPerk(identities: Array, args: Array, results: Array): Array {
            return ToCode.callRange(ToCode.replaceIdentity(identities, 1, 'hasPerk'), args, results);
        }

        // StatusEffect
        public function hasStatusEffect(identities: Array, args: Array, results: Array): Array {
            return ToCode.callRange(ToCode.replaceIdentity(identities, 1, 'hasStatusEffect'), args, results);
        }

        // Items
        // Piercing
        public function hasPiercing(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'hasPiercing()'), results);;
        }

        public function hasEarPiercing(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'hasEarPiercing()'), results);;
        }

        public function hasEyebrowPiercing(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'hasEyebrowPiercing()'), results);;
        }

        public function hasNosePiercing(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'hasNosePiercing()'), results);;
        }

        public function hasLipPiercing(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'hasLipPiercing()'), results);;
        }

        public function hasTonguePiercing(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'hasTonguePiercing()'), results);;
        }

        public function hasBellyPiercing(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.replaceIdentity(identities, 1, 'hasBellyPiercing()'), results);;
        }

        public function hasNipplePiercing(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.funcCall(ToCode.replaceIdentity(identities, 1, 'hasPiercedNipples'), args), results);
        }

        public function hasCockPiercing(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.funcCall(ToCode.replaceIdentity(identities, 1, 'hasPiercedCocks'), args), results);
        }

        public function hasPiercedVaginas(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.funcCall(ToCode.replaceIdentity(identities, 1, 'hasPiercedVaginas'), args), results);
        }

        public function hasClitPiercing(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.funcCall(ToCode.replaceIdentity(identities, 1, 'hasPiercedClits'), args), results);
        }

        public function hasCocksock(identities: Array, args: Array, results: Array): Array {
            return ToCode.boolean(ToCode.funcCall(ToCode.replaceIdentity(identities, 1, 'hasSockedCocks'), args), results);
        }

        // Keyitem
        public function hasKeyItem(identities: Array, args: Array, results: Array): Array {
            return ToCode.callRange(ToCode.replaceIdentity(identities, 1, 'hasKeyItem'), args, results);
        }
    }
}
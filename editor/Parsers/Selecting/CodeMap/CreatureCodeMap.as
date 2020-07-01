package editor.Parsers.Selecting.CodeMap {
    import editor.Lang.Codify.CodeNode;
    import editor.Parsers.ToCode;

    public class CreatureCodeMap {
        // Lookup
        private function nameToIndex(key: String, name: String): String {
            return 'GLOBAL.' + key.substr(0, key.lastIndexOf('_') + 1) + name.toLocaleUpperCase();
        }

        private function mapNameToIndex(key: String): Function {
            return function (value: *, idx: int, arr: Array): Array {
                return [new CodeNode(CodeNode.Code, nameToIndex(key, value))];
            }
        }

        // Physical Appearance
        // Femininity
        public function fem(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.femininity', ToCode.getArgValues(args)), results);
        }

        // Tallness
        public function tallness(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.tallness', ToCode.getArgValues(args)), results);
        }

        // Thickness
        public function thickness(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.thickness', ToCode.getArgValues(args)), results);
        }

        // Tone
        public function tone(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.tone', ToCode.getArgValues(args)), results);
        }

        // Hip rating
        public function hipRating(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.hipRating()', ToCode.getArgValues(args)), results);
        }

        // Butt rating
        public function buttRating(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.buttRating()', ToCode.getArgValues(args)), results);
        }

        // Body Parts
        // Skin
        public function skinType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.skinType', ToCode.getArgValues(args).map(mapNameToIndex('SKIN_TYPE_NAMES'))), results);
        }

        public function accentMarkings(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.getAccessPath(identities) + '.hasAccentMarkings()'
            ], results);
        }

        // Eyes
        public function eyeType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.eyeType', ToCode.getArgValues(args).map(mapNameToIndex('TYPE_NAMES'))), results);
        }

        // Hair
        public function hairType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.hairType', ToCode.getArgValues(args).map(mapNameToIndex('HAIR_TYPE_NAMES'))), results);
        }

        // Beard
        public function beardType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.beardType', ToCode.getArgValues(args).map(mapNameToIndex('HAIR_TYPE_NAMES'))), results);
        }

        // Face
        public function faceType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.faceType', ToCode.getArgValues(args).map(mapNameToIndex('TYPE_NAMES'))), results);
        }

        public function faceFlag(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.callConditions(ToCode.getAccessPath(identities) + '.hasFaceFlag', ToCode.getArgValues(args).map(mapNameToIndex('FLAG_NAMES'))), results);
        }

        public function faceFlags(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.funcCall(ToCode.getAccessPath(identities) + '.hasFaceFlag', ToCode.getArgValues(args).map(mapNameToIndex('FLAG_NAMES')))
            ], results);
        }

        // Tongue
        public function tongueType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.tongueType', ToCode.getArgValues(args).map(mapNameToIndex('TYPE_NAMES'))), results);
        }

        public function tongueFlag(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.callConditions(ToCode.getAccessPath(identities) + '.hasTongueFlag', ToCode.getArgValues(args).map(mapNameToIndex('FLAG_NAMES'))), results);
        }

        public function tongueFlags(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.funcCall(ToCode.getAccessPath(identities) + '.hasTongueFlag', ToCode.getArgValues(args).map(mapNameToIndex('FLAG_NAMES')))
            ], results);
        }

        // Ear
        public function earType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.earType', ToCode.getArgValues(args).map(mapNameToIndex('TYPE_NAMES'))), results);
        }

        public function earFlag(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.callConditions(ToCode.getAccessPath(identities) + '.hasEarFlag', ToCode.getArgValues(args).map(mapNameToIndex('FLAG_NAMES'))), results);
        }

        public function earFlags(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.funcCall(ToCode.getAccessPath(identities) + '.hasEarFlag', ToCode.getArgValues(args).map(mapNameToIndex('FLAG_NAMES')))
            ], results);
        }

        // Antennae
        public function antennaeType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.antennaeType', ToCode.getArgValues(args).map(mapNameToIndex('TYPE_NAMES'))), results);
        }

        // Horn
        public function hornType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.hornType', ToCode.getArgValues(args).map(mapNameToIndex('TYPE_NAMES'))), results);
        }

        public function horns(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.getAccessPath(identities) + '.hasHorns()'
            ], results);
        }

        // Arm
        public function armType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.armType', ToCode.getArgValues(args).map(mapNameToIndex('TYPE_NAMES'))), results);
        }

        public function armFlag(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.callConditions(ToCode.getAccessPath(identities) + '.hasArmFlag', ToCode.getArgValues(args).map(mapNameToIndex('FLAG_NAMES'))), results);
        }

        public function armFlags(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.funcCall(ToCode.getAccessPath(identities) + '.hasArmFlag', ToCode.getArgValues(args).map(mapNameToIndex('FLAG_NAMES')))
            ], results);
        }

        // Wing
        public function wingType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.wingType', ToCode.getArgValues(args).map(mapNameToIndex('TYPE_NAMES'))), results);
        }

        // Leg
        public function legType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.legType', ToCode.getArgValues(args).map(mapNameToIndex('TYPE_NAMES'))), results);
        }

        public function legFlag(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.callConditions(ToCode.getAccessPath(identities) + '.hasLegFlag', ToCode.getArgValues(args).map(mapNameToIndex('FLAG_NAMES'))), results);
        }

        public function legFlags(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.funcCall(ToCode.getAccessPath(identities) + '.hasLegFlag', ToCode.getArgValues(args).map(mapNameToIndex('FLAG_NAMES')))
            ], results);
        }

        // Lowerbody
        public function lowerbody(identities: Array, args: Array, results: Array): Array {
            const conds: Array = [];
            const identifier: String = ToCode.getAccessPath(identities);
            const argValues: Array = ToCode.getArgValues(args);
            for (var idx: int = 0; idx < argValues.length; idx++) {
                switch (argValues[idx]) {
                    case 'biped': conds.push(identifier + '.isBiped()'); break;
                    case 'naga': conds.push(identifier + '.isNaga()'); break;
                    case 'taur': conds.push(identifier + '.isTaur()'); break;
                    case 'centaur': conds.push(identifier + '.isCentaur()'); break;
                    case 'drider': conds.push(identifier + '.isDrider()'); break;
                    case 'goo': conds.push(identifier + '.isGoo()'); break;
                }
            }

            return ToCode.ifElseChain(conds, results);
        }

        // Tail
        public function tailType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.tailType', ToCode.getArgValues(args).map(mapNameToIndex('TYPE_NAMES'))), results);
        }

        public function tails(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.tailCount', ToCode.getArgValues(args)), results);
        }

        public function tailFlag(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.callConditions(ToCode.getAccessPath(identities) + '.hasTailFlag', ToCode.getArgValues(args).map(mapNameToIndex('FLAG_NAMES'))), results);
        }

        public function tailFlags(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.funcCall(ToCode.getAccessPath(identities) + '.hasTailFlag', ToCode.getArgValues(args).map(mapNameToIndex('FLAG_NAMES')))
            ], results);
        }

        // Cock
        public function cocknom(identities: Array, args: Array, results: Array): Array {
            return ToCode.skippingIfElseChain([
                ToCode.getAccessPath(identities) + '.cocks.length === 0',
                ToCode.getAccessPath(identities) + '.cocks.length === 1',
                ToCode.getAccessPath(identities) + '.cocks.length > 1'
            ], results);
        }

        public function cockWType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.callConditions(ToCode.getAccessPath(identities) + '.hasCock', ToCode.getArgValues(args).map(mapNameToIndex(('TYPE_NAMES')))), results);
        }

        public function cockCount(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.cocks.length', ToCode.getArgValues(args).map(mapNameToIndex(('TYPE_NAMES')))), results);
        }

        public function cockType(identities: Array, args: Array, results: Array): Array {
            const argValues: Array = ToCode.getArgValues(args);
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.cocks[' + argValues[0] + '].type', argValues.slice(1).map(mapNameToIndex(('TYPE_NAMES')))), results);
        }

        public function cockFits(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.callConditions(ToCode.getAccessPath(identities) + '.cockThatFits', ToCode.getArgValues(args)), results);
        }

        public function cockfks(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.getAccessPath(identities) + '.hasACockFlag(GLOBAL.FLAG_FLARED)',
                ToCode.getAccessPath(identities) + '.hasACockFlag(GLOBAL.FLAG_KNOTTED)',
                ToCode.getAccessPath(identities) + '.hasACockFlag(GLOBAL.FLAG_SHEATHED)'
            ], results);
        }

        // Balls
        public function balls(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.getAccessPath(identities) + '.hasBalls()'
            ], results);
        }

        public function ballsCount(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.balls', ToCode.getArgValues(args)), results);
        }

        public function ballSize(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.ballSize()', ToCode.getArgValues(args)), results);
        }

        // Breasts
        public function breasts(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.getAccessPath(identities) + '.breasts()'
            ], results);
        }

        public function breastCount(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.totalBreasts()', ToCode.getArgValues(args)), results);
        }

        public function breastCupSize(identities: Array, args: Array, results: Array): Array {
            const argValues: Array = ToCode.getArgValues(args);
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.breastCup(' + argValues[0] + ')', argValues.slice(1)), results);
        }

        // Cock / Vag
        public function cockVag(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.getAccessPath(identities) + '.hasCock()',
                ToCode.getAccessPath(identities) + '.hasVagina()'
            ], results);
        }

        // Vagina
        public function vagnom(identities: Array, args: Array, results: Array): Array {
            return ToCode.skippingIfElseChain([
                ToCode.getAccessPath(identities) + '.vaginas.length === 0',
                ToCode.getAccessPath(identities) + '.vaginas.length === 1',
                ToCode.getAccessPath(identities) + '.vaginas.length > 1'
            ], results);
        }

        public function vagLoose(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.looseness()', ToCode.getArgValues(args)), results);
        }

        public function vagWet(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.wetness()', ToCode.getArgValues(args)), results);
        }

        public function vagCap(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.vaginalCapacity()', ToCode.getArgValues(args)), results);
        }

        public function squirt(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.getAccessPath(identities) + '.isSquirter()'
            ], results);
        }

        // Butt

        public function analLoose(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.ass.looseness()', ToCode.getArgValues(args)), results);
        }

        public function analWet(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.ass.wetness()', ToCode.getArgValues(args)), results);
        }

        public function analCap(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.analCapacity()', ToCode.getArgValues(args)), results);
        }

        // Fluids
        // Milk
        public function milkType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.milkType', ToCode.getArgValues(args)), results);
        }

        public function milkVol(identities: Array, args: Array, results: Array): Array {
            return milkQ(identities, args, results);
        }
        public function milkQ(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.milkQ()', ToCode.getArgValues(args)), results);
        }

        // Cum
        public function cumType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.cumType', ToCode.getArgValues(args).map(mapNameToIndex('FLUID_TYPE_NAMES'))), results);
        }

        public function cumVol(identities: Array, args: Array, results: Array): Array {
            return cumQ(identities, args, results);
        }
        public function cumQ(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.cumQ()', ToCode.getArgValues(args)), results);
        }

        // Girl Cum
        public function girlCumType(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.equalsConditions(ToCode.getAccessPath(identities) + '.girlCumType', ToCode.getArgValues(args).map(mapNameToIndex('FLUID_TYPE_NAMES'))), results);
        }

        public function girlCumVol(identities: Array, args: Array, results: Array): Array {
            return girlCumQ(identities, args, results);
        }
        public function girlCumQ(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.girlCumQ()', ToCode.getArgValues(args)), results);
        }

        // Personality
        // Nice / Misch / Ass
        public function nma(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.getAccessPath(identities) + '.isNice()',
                ToCode.getAccessPath(identities) + '.isMisch()',
            ], results);
        }

        // Exposure
        // Exposed body parts [all, chest, crotch, ass]
        public function exposed(identities: Array, args: Array, results: Array): Array {
            const conds: Array = [];
            const identifier: String = ToCode.getAccessPath(identities);
            const argValues: Array = ToCode.getArgValues(args);
            for (var idx: int = 0; idx < argValues.length; idx++) {
                switch (argValues[idx]) {
                    case 'none': conds.push('!' + identifier + '.isExposed()'); break;
                    case 'all': conds.push(identifier + '.isExposed()'); break;
                    case 'chest': conds.push(identifier + '.isChestExposed()'); break;
                    case 'crotch': conds.push(identifier + '.isCrotchExposed()'); break;
                    case 'ass': conds.push(identifier + '.isAssExposed()'); break;
                }
            }

            return ToCode.skippingIfElseChain(conds, results);
        }

        // Sex Appearance
        // Male / Female / Herm / None
        public function mfhn(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.getAccessPath(identities) + '.isMale()',
                ToCode.getAccessPath(identities) + '.isFemale()',
                ToCode.getAccessPath(identities) + '.isHerm()'
            ], results);
        }

        // Male / Female With Pref
        public function mf(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.getAccessPath(identities) + '.isMasculine()'
            ], results);
        }

        // Stats
        public function lust(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.lust()', ToCode.getArgValues(args)), results);
        }

        public function physique(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.physique()', ToCode.getArgValues(args)), results);
        }

        public function reflex(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.reflexes()', ToCode.getArgValues(args)), results);
        }

        public function aim(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.aim()', ToCode.getArgValues(args)), results);
        }

        public function inte(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.intelligence()', ToCode.getArgValues(args)), results);
        }

        public function will(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.willpower()', ToCode.getArgValues(args)), results);
        }

        public function libido(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.libido()', ToCode.getArgValues(args)), results);
        }

        public function taint(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.rangeConditions(ToCode.getAccessPath(identities) + '.taint()', ToCode.getArgValues(args)), results);
        }

        // Effects
        // Heat / Deep Heat / Rut
        public function heatDeepRut(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.getAccessPath(identities) + '.inHeat()',
                ToCode.getAccessPath(identities) + '.inDeepHeat()',
                ToCode.getAccessPath(identities) + '.inRut()'
            ], results);
        }

        // Bimbo / Bro
        public function bimBro(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.getAccessPath(identities) + '.isBimbo()',
                ToCode.getAccessPath(identities) + '.isBro()'
            ], results);
        }

        // Treated
        public function treated(identities: Array, args: Array, results: Array): Array {
            const conds: Array = [];
            const ident: String = ToCode.getAccessPath(identities);
            const argValues: Array = ToCode.getArgValues(args);
            for each (var arg: * in argValues) {
                switch (arg) {
                    case 'none': conds.push('!' + ident + '.isTreated()'); break;
                    case 'any': conds.push(ident + '.isTreated()'); break;
                    case 'cow': conds.push(ident + '.isTreatedCow()'); break;
                    case 'bull': conds.push(ident + '.isTreatedBull()'); break;
                    case 'amazon': conds.push(ident + '.isAmazon(true)'); break;
                    case 'cumcow': conds.push(ident + '.isCumCow()'); break;
                    case 'cumslut': conds.push(ident + '.isCumSlut()'); break;
                    case 'faux': conds.push(ident + '.isFauxCow()'); break;
                }
            }
            return ToCode.skippingIfElseChain(conds, results);
        }

        // Pheromones
        public function pheromones(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.getAccessPath(identities) + '.hasPheromones()'
            ], results);
        }

        // Perk
        public function perk(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.callConditions(ToCode.getAccessPath(identities) + '.hasPerk', ToCode.getArgValues(args)), results);
        }

        // StatusEffect
        public function seffect(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.callConditions(ToCode.getAccessPath(identities) + '.hasStatusEffect', ToCode.getArgValues(args)), results);
        }

        // Items
        // Piercing
        public function pierced(identities: Array, args: Array, results: Array): Array {
            const conds: Array = [];
            const identifier: String = ToCode.getAccessPath(identities);
            const argValues: Array = ToCode.getArgValues(args);
            for each (var arg: * in argValues) {
                switch (arg) {
                    case 'none': conds.push('!' + identifier + '.hasPiercing()'); break;
                    case 'any': conds.push(identifier + '.hasPiercing()'); break;
                    case 'ear': conds.push(identifier + '.hasEarPiercing()'); break;
                    case 'eyebrow': conds.push(identifier + '.hasEyebrowPiercing()'); break;
                    case 'nose': conds.push(identifier + '.hasNosePiercing()'); break;
                    case 'lip': conds.push(identifier + '.hasLipPiercing()'); break;
                    case 'tongue': conds.push(identifier + '.hasTonguePiercing()'); break;
                    case 'belly': conds.push(identifier + '.hasBellyPiercing()'); break;
                }
            }

            return ToCode.skippingIfElseChain(conds, results);
        }

        public function nipplePierced(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.funcCall(ToCode.getAccessPath(identities) + '.hasPiercedNipples', ToCode.getArgValues(args))
            ], results);
        }

        public function cockPierced(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.funcCall(ToCode.getAccessPath(identities) + '.hasPiercedCocks', ToCode.getArgValues(args))
            ], results);
        }

        public function vaginaPierced(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.funcCall(ToCode.getAccessPath(identities) + '.hasPiercedVaginas', ToCode.getArgValues(args))
            ], results);
        }

        public function clitPierced(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.funcCall(ToCode.getAccessPath(identities) + '.hasPiercedClits', ToCode.getArgValues(args))
            ], results);
        }

        public function sockOnCock(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain([
                ToCode.funcCall(ToCode.getAccessPath(identities) + '.hasSockedCocks', ToCode.getArgValues(args))
            ], results);
        }

        // Keyitem
        public function keyItem(identities: Array, args: Array, results: Array): Array {
            return ToCode.ifElseChain(ToCode.callConditions(ToCode.getAccessPath(identities) + '.hasKeyItem', ToCode.getArgValues(args)), results);
        }
    }
}
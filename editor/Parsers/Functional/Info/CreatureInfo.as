package editor.Parsers.Functional.Info {
    import editor.Game.Info.Validators;

    public class CreatureInfo {
        // Old parsers
        private function hasOneOptionalNumberArgNoResults(args: Array, results: int): String {
            var err: String = Validators.maxLength(args.length, 1, Validators.ARGS);
            if (!err) err = Validators.checkTypeAt(args, 0, 'number', Validators.ARGS);
            if (!err) err = Validators.maxLength(results, 0, Validators.RESS);
            return err;
        }

        public const base: Function = hasOneOptionalNumberArgNoResults;
        public const cockBase: Function = hasOneOptionalNumberArgNoResults;
        public const sheath: Function = hasOneOptionalNumberArgNoResults;
        public const sheathDescript: Function = hasOneOptionalNumberArgNoResults;
        public const sheathOrBase: Function = hasOneOptionalNumberArgNoResults;
        public const knot: Function = hasOneOptionalNumberArgNoResults;
        public const knotOrBase: Function = hasOneOptionalNumberArgNoResults;
        public const knots: Function = hasOneOptionalNumberArgNoResults;
        public const sheathOrKnot: Function = hasOneOptionalNumberArgNoResults;
        public const knotOrSheath: Function = hasOneOptionalNumberArgNoResults;
        public const knotBallsHilt: Function = hasOneOptionalNumberArgNoResults;
        public const cockLength: Function = hasOneOptionalNumberArgNoResults;
        public const cocklength: Function = hasOneOptionalNumberArgNoResults;
        public const cocksIsAre: Function = hasOneOptionalNumberArgNoResults;
        public const dicksIsAre: Function = hasOneOptionalNumberArgNoResults;
        public const cocksLightIsAre: Function = hasOneOptionalNumberArgNoResults;
        public const dicksLightIsAre: Function = hasOneOptionalNumberArgNoResults;
        public const cockComplex: Function = hasOneOptionalNumberArgNoResults;
        public const cockNounComplex: Function = hasOneOptionalNumberArgNoResults;
        public const cockLight: Function = hasOneOptionalNumberArgNoResults;
        public const cockSimple: Function = hasOneOptionalNumberArgNoResults;
        public const cockNounSimple: Function = hasOneOptionalNumberArgNoResults;
        public const cockShort: Function = hasOneOptionalNumberArgNoResults;
        public const cockNoun: Function = hasOneOptionalNumberArgNoResults;
        public const dicksNounIsAre: Function = hasOneOptionalNumberArgNoResults;
        public const cocksNounIsAre: Function = hasOneOptionalNumberArgNoResults;
        public const cockSkin: Function = hasOneOptionalNumberArgNoResults;
        public const dickSkin: Function = hasOneOptionalNumberArgNoResults;
        public const cockColor: Function = hasOneOptionalNumberArgNoResults;
        public const dickColor: Function = hasOneOptionalNumberArgNoResults;
        public const vaginaColor: Function = hasOneOptionalNumberArgNoResults;
        public const cuntColor: Function = hasOneOptionalNumberArgNoResults;
        public const pussyColor: Function = hasOneOptionalNumberArgNoResults;
        public const cockHead: Function = hasOneOptionalNumberArgNoResults;
        public const cockhead: Function = hasOneOptionalNumberArgNoResults;
        public const cockHeadNoun: Function = hasOneOptionalNumberArgNoResults;
        public const cockHeads: Function = hasOneOptionalNumberArgNoResults;
        public const cockheads: Function = hasOneOptionalNumberArgNoResults;
        public const cockDescript: Function = hasOneOptionalNumberArgNoResults;
        public const cock: Function = hasOneOptionalNumberArgNoResults;
        public const cockOrStrapon: Function = hasOneOptionalNumberArgNoResults;
        public const cockOrHardlight: Function = hasOneOptionalNumberArgNoResults;
        public const cockOrStraponNoun: Function = hasOneOptionalNumberArgNoResults;
        public const cockOrHardlightNoun: Function = hasOneOptionalNumberArgNoResults;
        public const cockOrStraponFull: Function = hasOneOptionalNumberArgNoResults;
        public const cockOrHardlightFull: Function = hasOneOptionalNumberArgNoResults;
        public const cockOrStraponHead: Function = hasOneOptionalNumberArgNoResults;
        public const nippleNoun: Function = hasOneOptionalNumberArgNoResults;
        public const nipplesNoun: Function = hasOneOptionalNumberArgNoResults;
        public const nippleNounSimple: Function = hasOneOptionalNumberArgNoResults;
        public const nipplesNounSimple: Function = hasOneOptionalNumberArgNoResults;
        public const nipple: Function = hasOneOptionalNumberArgNoResults;
        public const nippleDescript: Function = hasOneOptionalNumberArgNoResults;
        public const lipple: Function = hasOneOptionalNumberArgNoResults;
        public const nipples: Function = hasOneOptionalNumberArgNoResults;
        public const nipplesDescript: Function = hasOneOptionalNumberArgNoResults;
        public const lipples: Function = hasOneOptionalNumberArgNoResults;
        public const milkyNipple: Function = hasOneOptionalNumberArgNoResults;
        public const milkyNipples: Function = hasOneOptionalNumberArgNoResults;
        public const nippleHarden: Function = hasOneOptionalNumberArgNoResults;
        public const nipplesHarden: Function = hasOneOptionalNumberArgNoResults;
        public const nippleHardening: Function = hasOneOptionalNumberArgNoResults;
        public const nipplesHardening: Function = hasOneOptionalNumberArgNoResults;
        public const areola: Function = hasOneOptionalNumberArgNoResults;
        public const areolaDescript: Function = hasOneOptionalNumberArgNoResults;
        public const areolae: Function = hasOneOptionalNumberArgNoResults;
        public const areolaeDescript: Function = hasOneOptionalNumberArgNoResults;
        public const erectCock: Function = hasOneOptionalNumberArgNoResults;
        public const flaccidCock: Function = hasOneOptionalNumberArgNoResults;
        public const chestSimple: Function = hasOneOptionalNumberArgNoResults;
        public const chestNoun: Function = hasOneOptionalNumberArgNoResults;
        public const breastsNoun: Function = hasOneOptionalNumberArgNoResults;
        public const breastNoun: Function = hasOneOptionalNumberArgNoResults;
        public const breast: Function = hasOneOptionalNumberArgNoResults;
        public const breastNounChaste: Function = hasOneOptionalNumberArgNoResults;
        public const breastChaste: Function = hasOneOptionalNumberArgNoResults;
        public const breastNounDry: Function = hasOneOptionalNumberArgNoResults;
        public const breastDry: Function = hasOneOptionalNumberArgNoResults;
        public const cupSize: Function = hasOneOptionalNumberArgNoResults;
        public const breastCup: Function = hasOneOptionalNumberArgNoResults;
        public const breastCupSize: Function = hasOneOptionalNumberArgNoResults;
        public const breastDescript: Function = hasOneOptionalNumberArgNoResults;
        public const breasts: Function = hasOneOptionalNumberArgNoResults;
        public const boobs: Function = hasOneOptionalNumberArgNoResults;
        public const tits: Function = hasOneOptionalNumberArgNoResults;
        public const cockClit: Function = hasOneOptionalNumberArgNoResults;
        public const vagina: Function = hasOneOptionalNumberArgNoResults;
        public const pussy: Function = hasOneOptionalNumberArgNoResults;
        public const cunt: Function = hasOneOptionalNumberArgNoResults;
        public const vaginaNounComplex: Function = hasOneOptionalNumberArgNoResults;
        public const pussyNounComplex: Function = hasOneOptionalNumberArgNoResults;
        public const vaginaSimple: Function = hasOneOptionalNumberArgNoResults;
        public const pussySimple: Function = hasOneOptionalNumberArgNoResults;
        public const cuntSimple: Function = hasOneOptionalNumberArgNoResults;
        public const vaginaNounSimple: Function = hasOneOptionalNumberArgNoResults;
        public const vaginaNoun: Function = hasOneOptionalNumberArgNoResults;
        public const pussyNoun: Function = hasOneOptionalNumberArgNoResults;
        public const cuntNoun: Function = hasOneOptionalNumberArgNoResults;
        public const vagOrAss: Function = hasOneOptionalNumberArgNoResults;
        public const vagOrAsshole: Function = hasOneOptionalNumberArgNoResults;
        public const vaginaOrAss: Function = hasOneOptionalNumberArgNoResults;
        public const vaginaOrAsshole: Function = hasOneOptionalNumberArgNoResults;
        public const pussyOrAss: Function = hasOneOptionalNumberArgNoResults;
        public const pussyOrAsshole: Function = hasOneOptionalNumberArgNoResults;
        public const vagOrAssNoun: Function = hasOneOptionalNumberArgNoResults;
        public const vagOrAssSimple: Function = hasOneOptionalNumberArgNoResults;
        public const womb: Function = hasOneOptionalNumberArgNoResults;
        public const uterus: Function = hasOneOptionalNumberArgNoResults;
        public const clit: Function = hasOneOptionalNumberArgNoResults;
        public const clitoris: Function = hasOneOptionalNumberArgNoResults;
        public const clitNoun: Function = hasOneOptionalNumberArgNoResults;
        public const clitorisNoun: Function = hasOneOptionalNumberArgNoResults;
        public const oneClitPerVagina: Function = hasOneOptionalNumberArgNoResults;
        public const clits: Function = hasOneOptionalNumberArgNoResults;
        public const clitsNoun: Function = hasOneOptionalNumberArgNoResults;
        public const clitsIsAre: Function = hasOneOptionalNumberArgNoResults;
        public const cockShape: Function = hasOneOptionalNumberArgNoResults;
        public const cockshape: Function = hasOneOptionalNumberArgNoResults;
        public const cockType: Function = hasOneOptionalNumberArgNoResults;
        public const cocktype: Function = hasOneOptionalNumberArgNoResults;
        public const accurateCockName: Function = hasOneOptionalNumberArgNoResults;

    }
}
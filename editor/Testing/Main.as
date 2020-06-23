package editor.Testing {
    import classes.TiTS;
    import classes.GameData.*;
    import classes.ShittyShips.Casstech;
    import flash.display.Sprite;
    import editor.Display.Components.StaticField;
    
    public class Main extends Sprite {
        private var tits: TiTS;
        private var outputBox: StaticField;
        
        public function Main() {
            tits = new TiTS();
            addChild(tits); // Game doesn't load until added to stage
            tits.visible = false;
            visible = true;

            // Things not initialized by default
            tits.initializeNPCs();
            tits.shits["SHIP"] = new Casstech();
            MailManager.resetMails();
            ChildManager.resetChildren();
            tits.userInterface.mailsDisplayButton.Deactivate();
            CombatManager.TerminateCombat();
            tits.userInterface.hideNPCStats();
            tits.userInterface.leftBarDefaults();
            tits.userInterface.resetPCStats();
            tits.shipDb.NewGame();

            outputBox = new StaticField();
            outputBox.x = 0;
            outputBox.y = 0;
            outputBox.nsWidth = stage.stageWidth;
            outputBox.nsHeight = stage.stageHeight;

            addChild(outputBox);

            runTests();
        }

        private function runTests(): void {
            var text: String = '';

            text += new TokenizerTests().run();
            text += new ParserTests().run();
            text += new InterpreterTests().run();
            text += new CodeTranslatorTests().run();
            text += new CodePrinterTests().run();

            outputBox.text = text;
        }
    }
}
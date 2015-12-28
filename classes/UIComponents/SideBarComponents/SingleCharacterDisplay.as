package classes.UIComponents.SideBarComponents 
{
	import classes.Creature;
	import classes.StorageClass;
	import classes.UIComponents.StatusEffectComponents.StatusEffectsDisplay;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import classes.UIComponents.UIStyleSettings;
	import flash.text.AntiAliasType;
	import classes.Resources.NPCBustImages;
	/**
	 * ...
	 * @author Gedan
	 */
	public class SingleCharacterDisplay extends Sprite
	{
		private var _leftAlign:Boolean = true;
		
		private var _debug:Boolean = false;
		private var _debugBackground:Sprite;
		
		private var _nameHeader:TextField;
		private var _nameUnderline:Sprite;
		
		private var _bustImage:Sprite;
		private var _loadedBustIdx:String;
		private var _statBars:CompressedStatBars;
		private var _statusEffects:StatusEffectsDisplay;
		
		private var _bustVisible:Boolean = true;
		
		public function set bustVisible(v:Boolean):void
		{
			if (v != _bustVisible)
			{
				_bustImage.visible = _statBars.bustVisible = v;
				if (_leftAlign)
				{
					_bustImage.x = 0;
					_statBars.x = _bustImage.x + _bustImage.width + 1;
				}
				else
				{
					_statBars.x = 5;
					_bustImage.x = _statBars.x + _statBars.width + 1;
				}
			}
		}
		
		/**
		 * Update animates value changes from the current.
		 * @param	char
		 */
		public function UpdateFromCharacter(char:Creature):void
		{
			_nameHeader.text = (char.uniqueName && char.uniqueName.length > 0 ? char.uniqueName : char.short);
			
			_statBars.shield.setValue(char.shields(), char.shieldsMax());
			_statBars.hp.setValue(char.HP(), char.HPMax());
			_statBars.lust.setValue(char.lust(), char.lustMax());
			_statBars.energy.setValue(char.energy(), char.energyMax());
			_statusEffects.updateDisplay(char.statusEffects);
			
			setBust(char.bustDisplay);
		}
		
		/**
		 * Set sets initial values and then forcibly skips animations.
		 * @param	char
		 */
		public function SetFromCharacter(char:Creature):void
		{
			UpdateFromCharacter(char);
			_statBars.shield.EndAnimation();
			_statBars.hp.EndAnimation();
			_statBars.lust.EndAnimation();
			_statBars.energy.EndAnimation();
		}
		
		public function setBust(bustIdx:String):void
		{
			if (_loadedBustIdx && _loadedBustIdx == bustIdx) return; // already set, abort to avoid heavy pixel copies
			_loadedBustIdx = bustIdx;
			
			// See if we can even get the bust
			var bustT:Class = NPCBustImages.getBust(bustIdx);
			
			// No bust? Hide the element entirely and resize everything to fit
			if (bustT == null)
			{
				bustVisible = false;
				return;
			}
			
			// We've got a bust, make sure the containing element is available
			bustVisible = true;
			
			// Check to see if there IS an available configured bounds for this bust
			var bounds:Rectangle = NPCBustImages.getBounds(bustIdx);
			
			// Clamp the bounds so that it'll jive with the area we're gonna display this thing at
			
			var bustObj:Bitmap = new bustT();
			bustObj.smoothing = true;
			
			// If bounds IS available, we need to display a subportion of the bust image within the target
			if (bounds != null)
			{
				var region:Shape = new Shape();
				region.graphics.beginBitmapFill(bustObj.bitmapData, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y), false, true);
				region.graphics.drawRect(0, 0, bounds.width, bounds.height);
				region.graphics.endFill();
				_bustImage.removeChildren();
				_bustImage.addChild(region);
				region.x = region.y = 1;
			}
			// If bounds is null, display the whole image scaled to fit our target.
			else
			{
				bustObj.width = 68;
				bustObj.height = 63;
				_bustImage.removeChildren();
				_bustImage.addChild(bustObj);
				bustObj.x = bustObj.y = 1;
			}
		}
		
		public function SingleCharacterDisplay(alignment:String = "left") 
		{
			_leftAlign = (alignment == "left" ? true : false);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Build();
			
			if (_debug)
			{
				_debugBackground = new Sprite();
				_debugBackground.graphics.beginFill(0xFF0000);
				_debugBackground.graphics.drawRect(0, 0, this.width, this.height);
				_debugBackground.graphics.endFill();
				addChildAt(_debugBackground, 0);
			}
		}
		
		private function Build():void
		{
			_nameUnderline = new Sprite();
			(_leftAlign) ? _nameUnderline.x = 0 : _nameUnderline.x = 10;
			_nameUnderline.y = 17;
			_nameUnderline.graphics.beginFill(UIStyleSettings.gHighlightColour, 1);
			_nameUnderline.graphics.drawRect(0, 0, 190, 1);
			_nameUnderline.graphics.endFill();			
			addChild(_nameUnderline);
			
			_nameHeader = new TextField();
			_nameHeader.x = 10;
			_nameHeader.y = 0;
			_nameHeader.width = 190;
			_nameHeader.defaultTextFormat = UIStyleSettings.gStatBlockHeaderFormatter;
			_nameHeader.embedFonts = true;
			_nameHeader.antiAliasType = AntiAliasType.ADVANCED;
			_nameHeader.text = "PLACEHOLDER";
			_nameHeader.mouseEnabled = false;
			_nameHeader.mouseWheelEnabled = false
			addChild(_nameHeader);
			
			_bustImage = new Sprite();
			
			_bustImage.graphics.beginFill(UIStyleSettings.gHighlightColour);
			_bustImage.graphics.drawRect(0, 0, 70, 65);
			_bustImage.graphics.endFill();
			
			_bustImage.graphics.beginFill(UIStyleSettings.gBackgroundColour);
			_bustImage.graphics.drawRect(1, 1, 68, 63);
			_bustImage.graphics.endFill();
			
			_bustImage.y = _nameUnderline.y;
			addChild(_bustImage);
			
			_statBars = new CompressedStatBars();
			_statBars.x = _bustImage.x + _bustImage.width + 1;
			_statBars.y = _nameUnderline.y + _nameUnderline.height + 1;
			addChild(_statBars);
			
			if (!_leftAlign)
			{
				_statBars.x = 5;
				_bustImage.x = _statBars.x + _statBars.width + 1;
			}
			
			_statusEffects = new StatusEffectsDisplay(!_leftAlign);
			_statusEffects.targetY = _bustImage.y + _bustImage.height + 1;
			_statusEffects.targetX = (_leftAlign ? 2 : 5);
			_statusEffects.maxDisplayed = 7;
			_statusEffects.childSizeX = 25;
			_statusEffects.childSizeY = 25;
			_statusEffects.childSpacing = 3;
			_statusEffects.targetWidth = 200;
			addChild(_statusEffects);
		}
	}

}
package;
import robotic.RoboPerk;
import robotic.knockout.GameOverSubstateCuphead;
import robotic.RoboCoin;
import robotic.RoboticFunctions;
import flixel.addons.display.FlxBackdrop;
import robotic.knockout.ShotGreenRose;
import robotic.knockout.ShotGreenSelever;
import robotic.knockout.ShotGreenYuri;
import robotic.knockout.ShotGreenWell;
import robotic.knockout.ShotSunk;
import robotic.knockout.ShotGreenSunk;
import robotic.knockout.ShotGreenSusan;
import robotic.knockout.ShotSusan;
import robotic.knockout.ShotRecolored;
import robotic.knockout.ShotAnkha;
import robotic.knockout.ShotGreenAnkha;
import robotic.knockout.ShotGreen;
import robotic.knockout.Shot;
import flixel.util.FlxDestroyUtil;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUINumericStepper;
import lime.system.Clipboard;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUITabMenu;
import flixel.graphics.FlxGraphic;
#if desktop
import Discord.DiscordClient;
#end
import openfl.filters.ShaderFilter;
import Shaders;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import Note.EventNote;
import openfl.events.KeyboardEvent;
import flixel.util.FlxSave;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;
import robotic.TextBox;
import lime.media.AudioBuffer;
import haxe.io.Bytes;
#if sys
import sys.FileSystem;
#end
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
import flash.media.Sound;
#end

using StringTools;
typedef Jdialogue =
{
	var dialogues:Array<robotic.TextBox.DialogueLine>;
}

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;

	public static var ratingStuff:Array<Dynamic> = [
		['You Suck!', 0.2], //From 0% to 19%
		['Shit', 0.4], //From 20% to 39%
		['Bad', 0.5], //From 40% to 49%
		['Bruh', 0.6], //From 50% to 59%
		['Meh', 0.69], //From 60% to 68%
		['Nice', 0.7], //69%
		['Good', 0.8], //From 70% to 79%
		['Great', 0.9], //From 80% to 89%
		['Sick!', 1], //From 90% to 99%
		['Perfect!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, ModchartText> = new Map<String, ModchartText>();
	public var modchartSaves:Map<String, FlxSave> = new Map<String, FlxSave>();
	//event variables
	private var isCameraOnForcedPos:Bool = false;
	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var boyfriendMapAgain:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var dadMapAgain1:Map<String, Character> = new Map();
	public var dadMapAgain2:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	public var gfMapAgain:Map<String, Character> = new Map();
	#else
	public var boyfriendMap:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var boyfriendMapAgain:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var dadMapAgain1:Map<String, Character> = new Map<String, Character>();
	public var dadMapAgain2:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	public var gfMapAgain:Map<String, Character> = new Map<String, Character>();
	#end

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;

	public var songSpeedTween:FlxTween;
	public var songSpeed(default, set):Float = 1;
	public var songSpeedType:String = "multiplicative";
	public var noteKillOffset:Float = 350;
	
	public var boyfriendGroup:FlxSpriteGroup;
	public var boyfriendGroupAgain:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var dadGroupAgain1:FlxSpriteGroup;
	public var dadGroupAgain2:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;
	public var gfGroupAgain:FlxSpriteGroup;
	public static var curStage:String = '';
	public static var isPixelStage:Bool = false;
	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	public var vocals:FlxSound;
	public var songusic:AudioThing;
	public var dialogueMusic:FlxSound;

	public var dad:Character = null;
	public var gf:Character = null;
	public var boyfriend:Boyfriend = null;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<EventNote> = [];

	private var strumLine:FlxSprite;

	//Handles the new epic mega sexy cam code that i've done
	public var camFollow:FlxPoint;
	public var camFollow2:FlxPoint;
	private var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public var camZooming:Bool = false;
	private var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;

	private var healthBarBG:AttachedSprite;
	var healthBarBGKnock:AttachedSprite;
	public var healthBar:FlxBar;
	var songPercent:Float = 0;

	private var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;
	
	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;
	
	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	public var startingSong:Bool = false;
	private var updateTime:Bool = true;
	public static var changedDifficulty:Bool = false;
	public static var chartingMode:Bool = false;

	//Gameplay settings
	public var healthGain:Float = 1;
	public var healthLoss:Float = 1;
	public var instakillOnMiss:Bool = false;
	public var cpuControlled:Bool = false;
	public var practiceMode:Bool = false;

	public var botplaySine:Float = 0;
	public var botplayTxt:FlxText;

	public var iconP1:HealthIcon;
	public var iconP1Again:HealthIcon;
	public var iconP2:HealthIcon;
	public var iconP2Again1:HealthIcon;
	public var iconP2Again2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camHUDier:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	public var cameraSpeed:Float = 1;

	public var shaderUpdates:Array<Float->Void> = [];
	public var camGameShaders:Array<ShaderEffect> = [];
	public var camHUDShaders:Array<ShaderEffect> = [];
	public var camOtherShaders:Array<ShaderEffect> = [];
	public var chromaticShader:Shaders.ChromaticAberrationEffect;
	public var bawShader:Shaders.BlackAndWhiteEffect;
	public var bawShader2:Shaders.BlackAndWhiteEffect;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialogueJson:DialogueFile = null;

	var halloweenBG:BGSprite;
	var halloweenWhite:BGSprite;

	var phillyCityLights:FlxTypedGroup<BGSprite>;
	var phillyTrain:BGSprite;
	var blammedLightsBlack:ModchartSprite;
	var blammedLightsBlackTween:FlxTween;
	var phillyCityLightsEvent:FlxTypedGroup<BGSprite>;
	var phillyCityLightsEventTween:FlxTween;
	var trainSound:FlxSound;

	var limoKillingState:Int = 0;
	var limo:BGSprite;
	var limoMetalPole:BGSprite;
	var limoLight:BGSprite;
	var limoCorpse:BGSprite;
	var limoCorpseTwo:BGSprite;
	var bgLimo:BGSprite;
	var grpLimoParticles:FlxTypedGroup<BGSprite>;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:BGSprite;

	var upperBoppers:BGSprite;
	var bottomBoppers:BGSprite;
	var santa:BGSprite;
	var heyTimer:Float;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	var bgGhouls:BGSprite;

	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;
	public var funniVariable:Array<Float> = [];
	public var randomfunni:Array<Float> = [];
	public var funniRects:Array<FlxSprite> = [];
	public var moreRects:Array<FlxSprite> = [];
	public var scoreTxt:FlxText;
	var timeTxt:FlxText;
	var scoreTxtTween:FlxTween;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;

	public var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;
	private var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var inCutscene:Bool = false;
	public var skipCountdown:Bool = false;
	var songLength:Float = 0;

	public var boyfriendCameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var opponentAgainCameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	//Achievement shit
	var keysPressed:Array<Bool> = [];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	// Lua shit
	public static var instance:PlayState;
	public var luaArray:Array<FunkinLua> = [];
	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	public var introSoundsSuffix:String = '';

	// Debug buttons
	private var debugKeysChart:Array<FlxKey>;
	private var debugKeysCharacter:Array<FlxKey>;
	
	// Less laggy controls
	private var keysArray:Array<Dynamic>;

	///ROBOTIC'S CODE///
		var fUNNINUMBERLOL:Int = 0;
		var aaaaaaaaclose:Float = 0;
		var aaaaaaaaclose2:Float = 0;
		var aaaaaaaaclose3:Float = 0;
		var aaaaaaaaclose4:Float = 0;
		var camXAddition = 0;
		var camYAddition = 0;
		var theAddition = 50;
		var songBackSprite:FlxSprite;
		var ccsongBackSprite:FlxSprite;
		var RobosongBackSprite:FlxSprite;
		var originFunni:FlxSprite;
		var songBackSpriteWidth:Int = 1;
		var ccsongBackSpriteWidth:Int = 1;
		var RobosongBackSpriteWidth:Int = 1;
		var ccBackSpriteWidth:Int = 1;
		var RoboBackSpriteWidth:Int = 1;
		var songNameDistance:Float = 0;
		var ccsongNameDistance:Float = 0;
		var RobosongNameDistance:Float = 0;
		var displaySongName:FlxText;
		var displayArtistName:FlxText;
		var ccdisplaySongName:FlxText;
		var ccdisplayArtistName:FlxText;
		var RobodisplaySongName:FlxText;
		var RobodisplayArtistName:FlxText;
		var iconSongName:FlxSprite;
		var cciconSongName:FlxSprite;
		var RoboiconSongName:FlxSprite;
		var iconSongNameAgain:FlxSprite;
		var cciconSongNameAgain:FlxSprite;
		var RoboiconSongNameAgain:FlxSprite;
		var textBox:TextBox;
		public var betadciuMoment:Bool = false;
		var coolnumber = 0.0;
		var iconDistance:Float = 50;
		var iconDistance2:Float = 300;
		public var gfAgain:Character = null;
		public var constantThingy:Float = (120/ClientPrefs.framerate);
		public var loopanim:Bool = false;
		public var dedbutnot:Bool = false;
		public var maxHealth:Float = 2;
		var perks:FlxTypedSpriteGroup<RoboPerk>;
		public var roboRoboPerkActivated:Bool = false;
		public var roboRoboPerkActivatedBefore:Bool = false;
			//Dialogue Editting
				public static var dialogueEditing:Bool = false;
				var Dialogue_box:FlxUITabMenu;
				var senteneceInputText:FlxUIInputText;
				var characterInputText:FlxUIInputText;
				var valueInputText1:FlxUIInputText;
				var valueInputText2:FlxUIInputText;
				var valueInputText3:FlxUIInputText;
				var indexStepper:FlxUINumericStepper;
				var effectDropDown:FlxUIDropDownMenuCustom;
				var theOptionsText:FlxText;
				var theIndexText:FlxText;
				var theEffect:String = 'Wave';
				var pageStepper:FlxUINumericStepper;
				var thePageNumber:FlxText;
				var eventStepper:FlxUINumericStepper;
				var event1:FlxText;
				var event2:FlxText;
				var event3:FlxText;
				var event4:FlxText;
				var event5:FlxText;
				var event6:FlxText;
				var event7:FlxText;
				var event8:FlxText;
				var event9:FlxText;
				var pageStepperLine:FlxUINumericStepper;
				var thePageNumberLine:FlxText;
				var lineStepper:FlxUINumericStepper;
				var line1:FlxText;
				var line2:FlxText;
				var line3:FlxText;
				var roboticDialogues:Array<DialogueLine> = [];
				var pageStepperSwitchLine1:FlxUINumericStepper;
				var pageStepperSwitchLine2:FlxUINumericStepper;

				var _file:FileReference;
				var didIstartDialogue:Bool = false;

			//GOSPEL
				var circ1:FlxSprite;
				var circ2:FlxSprite;
				var dumbasstext:FlxText;
				var rotBeat = 32;
				var rotUpBeat = 36 * 4;
				var rotEndBeat = 100 * 4;
				var rotTime = 0;
				var rotSpd:Float = 1;
				var rotLen = 0.3;
				var rotXLen:Float = 0;


			//Expurgation
				var cloneOne:FlxSprite;
				var cloneTwo:FlxSprite;
				var exSpikes:FlxSprite;
				var hatSpikes:FlxSprite;
				var gremlinTimer = new FlxTimer();
				var tikturn:Bool = false;
				var hatturn:Bool = false;
				var tstatic:FlxSprite;
				var tStaticSound:FlxSound;
				public var ExTrickyLinesSing:Array<String> = [
					"YOU AREN'T HANK",
					"WHERE IS HANK",
					"HANK???",
					"WHO ARE YOU",
					"WHERE AM I",
					"THIS ISN'T RIGHT",
					"MIDGET",
					"SYSTEM UNRESPONSIVE",
					"WHY CAN'T I KILL?????"
				];
				public var HatKidLinesSing:Array<String> = [
					"YOU AREN'T MUSTACHE GIRL",
					"WHERE IS MUSTACHE GIRL",
					"MUSTACHE GIRL???",
					"BOOP",
					"CAT CRIME",
					"WHICH CHAPTER IS THIS",
					"IS THIS DEATHWISH???",
					"PECK",
					"I NEED TIMEPIECES",
					"WHY CAN'T I MYERDER?????"
				];
				var cover:FlxSprite;
				var hole:FlxSprite;
				var converHole:FlxSprite;
				public var dadAgain1:Character = null;
				public var dadAgain2:Character = null;
				public var dadAgain1Singing:Bool = false;
				public var dadAgain2Singing:Bool = false;
				public var dadSinging:Bool = true;
				public var dadBETADCIU:Character;
				public var boyfriendAgain:Boyfriend;
				public var boyfriendAgainSinging:Bool = false;
				public var gfAgainSinging:Bool = false;
				public var boyfriendBETADCIU:Boyfriend;
				public var lol86:Character;
				var grabbed = false;
				var interupt = false;
				var totalDamageTaken:Float = 0;
				var shouldBeDead:Bool = false;
				var beatOfFuck:Int = 0;
				var spookyText:FlxText;
				var spookySteps:Int = 0;
				var spookyRendered:Bool = false;
				var dumbasstext2:FlxText;
				var dumbasstext3:FlxText;

			//knockout
				var bg1:FlxSprite;
				var bg2:FlxSprite;
				var bg3:FlxSprite;
				var bg4:FlxSprite;
				var bg5:FlxSprite;
				var bg6:FlxSprite;
				var rain1:BGSprite;
				var rain2:BGSprite;
				var cupheadShid:BGSprite;
				var cupheadGrain:BGSprite;
				var warning:FlxSprite;
				var bfDodgin:Bool = false;
				var hurtSound:FlxSound;
				var dodgeSound:FlxSound;
				var superCard:FlxSprite;
				var superCardCharge:Float = 0;
				var superCardTween:FlxTween;
															//var mugman:FlxSprite;
				var superType:String;
				public var taeyaiConsole:FlxSprite;
				var jomGlasses:FlxSprite;
				var superCuphead:FlxSprite;
				var superCupheadTiky:FlxSprite;
				var superCircleCuphead:FlxSprite;
				var sunkLoop:FlxSprite;
				var sansBone:FlxSprite;
				var circSelever:FlxSprite;
				var blackSelever:FlxSprite;
				var BACKGROUNDMOMENTYOOOO:FlxSprite;
				var superMove:Bool;
				public var cupheadShooting:Bool;
				public var wasShooting:Bool;
				var funniNumberForChrome = 0.03;
				var defaultChromNumber = 0.0025;
				var tordMissile:FlxSprite;
				var redLaser:FlxSprite;
				var blueLaser:FlxSprite;
				var lylaceDead:FlxSprite;
				var space:FlxBackdrop;
				var BG2:FlxSprite;
				var BG3:FlxSprite;
				var BG4:FlxSprite;
				var firstPersonMode:Bool = false;
				var betadciucamera:Bool = false;
				var bluelasercheckimfuckingtiredmanletsgetthisdoneoverwith:Bool = false;
				var BETADCIUAlphaCrazy:Bool = false;
				var BETADCIUYCrazy:Bool = false;
				var monikaHit:Bool = false;
				public var JUSTMONIKA:FlxSprite;
				public var firstPersonMic:FlxSprite;
				var crossArray:Array<FlxSprite> = [];
				var crossed:Array<Bool> = [];
				var picoShoot:Bool = false;
				//var blasterRect:FlxSprite;
				var dodge:FlxSprite = new FlxSprite(50,350);
				var attack:FlxSprite = new FlxSprite(50,300);
				var circleTween:FlxTween;
				var chromaticTween:FlxTween;
				var superHitBox:FlxSprite;
				var superCircleHitBox:FlxSprite;
				public var bfHitBox:FlxSprite;

			//ATROCITY
				var retroShake = false;

			//MALEDICTION
				var currentWindowLocation = [0, 0];

			//MILK
				var blackFuck:FlxSprite;
				var startCircle:FlxSprite;

			//stuff for later
				public static var roseturn:Bool = false;
				public static var roboturn:Bool = false;
				var roboasbf = false;

	override public function create()
	{
		Paths.clearStoredMemory();
		if (FlxG.save.data.equipped == null)
			FlxG.save.data.equipped = [];
		blackFuck = new FlxSprite().makeGraphic(1280,720, FlxColor.BLACK);
		startCircle = new FlxSprite();
		if (ClientPrefs.downScroll)
			iconDistance2 = -300;
		didIstartDialogue = false;
		roboturn = false;
		roboasbf = false;
		roseturn = false;
		betadciuMoment = false;
		iconDistance = 50;
		maxHealth = 2;

		//Expurgation
			tikturn = false;
			hatturn = false;
			cover = new FlxSprite(-180, 755).loadGraphic(Paths.image('expurgation/cover', 'shared'));
			hole = new FlxSprite(50, 530).loadGraphic(Paths.image('expurgation/Spawnhole_Ground_BACK', 'shared'));
			converHole = new FlxSprite(7, 578).loadGraphic(Paths.image('expurgation/Spawnhole_Ground_COVER', 'shared'));
			tstatic = new FlxSprite(0, 0).loadGraphic(Paths.image('expurgation/TrickyStatic', 'shared'), true, 320, 180);
			tStaticSound = new FlxSound().loadEmbedded(Paths.sound("expurgation/staticSound", "shared"));
			grabbed = false;
		//Knockout
			new FlxTimer().start(0.2, function(tmr:FlxTimer) {
				if (chromaticTween != null && !chromaticTween.active)
				{
					chromaticTween = FlxTween.tween(this, {funniNumberForChrome: defaultChromNumber}, 0.2, {
						ease: FlxEase.quadInOut,
						onUpdate: function(twn:FlxTween) {
							if (!ClientPrefs.shaders)
								chromaticShader.setChrome(funniNumberForChrome);
						}
					});
				}
				if (cupheadShooting && shotType == 'blue')
				{
					if (dad.alpha > 0)
					{
						if (!dadBETADCIU.animation.curAnim.name.startsWith('sing'))
						{
							cupheadShootAShot(true);
						}
						if (!dad.animation.curAnim.name.startsWith('sing'))
						if (dad.alpha > 0)
						{
							switch (dad.curCharacter)
							{
								case 'ankha':
									cupheadShootAShotAnkha(true);
								case 'furscorns':
									cupheadShootAShotFur(true);
								case 'extiky':
									cupheadShootAShotTiky(true);
								case 'ChampionKnightEX':
									cupheadShootAShotSamantha(true);
								case 'sunky':
									cupheadShootAShotSunky(true);
								case 'eduardo':
									cupheadShootAShotWell(true);
								case 'agressive-yuri':
									cupheadShootAShotYuri(true);
								case 'selever':
									cupheadShootAShotSelever(true);
								case 'rose-opponent':
									cupheadShootAShotRose(true);
							}
							if (!gfAgain.animation.curAnim.name.startsWith('sing') && gfAgainSinging)
								cupheadShootAShotSusan(true);
						}
					}
				}
			}, 0);
			hurtSound = new FlxSound().loadEmbedded(Paths.sound('knockout/shootfunni/hurt'));
			dodgeSound = new FlxSound().loadEmbedded(Paths.sound('knockout/dodge'));
			dodgeSound.volume = 0.8;
			superCard = new FlxSprite(1050, 550 + 147);
			superCard.frames = Paths.getSparrowAtlas('knockout/shootstuff/superCard');
			superCard.animation.addByPrefix('filled', 'Card Filled instance 1', 24, false);
			superCard.animation.addByPrefix('parry', 'PARRY Card Pop out  instance 1', 24, false);
			superCard.animation.addByPrefix('normal', 'Card Normal Pop out instance 1', 24, false);
			superCard.animation.addByPrefix('used', 'Card Used instance 1', 24, false);
			superCard.animation.addByPrefix('flipped', 'Card but flipped instance 1', 24, false);
			superCard.animation.play('flipped');
			if (ClientPrefs.downScroll)
			{
				superCard.x = 525;
			}
			BACKGROUNDMOMENTYOOOO = new FlxSprite(-800, 200).makeGraphic(1600 * 2, 1000 * 2, FlxColor.WHITE);

		// for lua
		instance = this;

		debugKeysChart = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		debugKeysCharacter = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));
		PauseSubState.songName = null; //Reset to default

		keysArray = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
		];

		// For the "Just the Two of Us" achievement
		for (i in 0...keysArray.length)
		{
			keysPressed.push(false);
		}

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// Gameplay settings
		healthGain = ClientPrefs.getGameplaySetting('healthgain', 1);
		healthLoss = ClientPrefs.getGameplaySetting('healthloss', 1);
		instakillOnMiss = ClientPrefs.getGameplaySetting('instakill', false);
		practiceMode = ClientPrefs.getGameplaySetting('practice', false);
		cpuControlled = ClientPrefs.getGameplaySetting('botplay', false);

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUDier = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camHUDier.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camHUDier);
		FlxG.cameras.add(camOther);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		FlxCamera.defaultCameras = [camGame];
		CustomFadeTransition.nextCamera = camOther;
		//FlxG.cameras.setDefaultDrawTarget(camGame, true);

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		#if desktop
		storyDifficultyText = CoolUtil.difficulties[storyDifficulty];

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: " + WeekData.getCurrentWeek().weekName;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		#end

		GameOverSubstate.resetVariables();
		var songName:String = Paths.formatToSongPath(SONG.song);

		curStage = PlayState.SONG.stage;
		//trace('stage is: ' + curStage);
		if (curStage == 'knockout')
			add(superCard);


		songBackSprite = new FlxSprite(0, 400).makeGraphic(0, 125, FlxColor.WHITE);
		songBackSprite.alpha = 0.8;
		add(songBackSprite);
		songBackSprite.cameras = [camHUD];

		ccsongBackSprite = new FlxSprite(0, 300).makeGraphic(0, 125, FlxColor.WHITE);
		ccsongBackSprite.alpha = 0.8;
		add(ccsongBackSprite);
		ccsongBackSprite.cameras = [camHUD];

		RobosongBackSprite = new FlxSprite(0, 425).makeGraphic(0, 125, FlxColor.WHITE);
		RobosongBackSprite.alpha = 0.8;
		add(RobosongBackSprite);
		RobosongBackSprite.cameras = [camHUD];
		if (curStage != 'jelly')
		{
			RobosongBackSprite.visible = false;
			ccsongBackSprite.visible = false;
		}
		
		displaySongName = new FlxText(0, songBackSprite.y - 40, 0, SONG.song.toUpperCase(), 40);
		ccdisplaySongName = new FlxText(0, ccsongBackSprite.y - 40, 0, 'SNOW THE FOX', 40);
		RobodisplaySongName = new FlxText(0, RobosongBackSprite.y - 40, 0, 'ROBOTIC PRESS', 40);
		switch (curStage)
		{
			case 'jelly':
				ccdisplaySongName.setFormat(Paths.font("Schluber.ttf"), 50, 0xD1149B, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
				RobodisplaySongName.setFormat(Paths.font("Schluber.ttf"), 50, 0xD1149B, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
				displaySongName.setFormat(Paths.font("Schluber.ttf"), 50, 0xD1149B, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
			default:
				ccdisplaySongName.setFormat(Paths.font("Friday Night Funkin Font.ttf"), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				RobodisplaySongName.setFormat(Paths.font("Friday Night Funkin Font.ttf"), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				displaySongName.setFormat(Paths.font("Friday Night Funkin Font.ttf"), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		}
		displaySongName.alignment = "center";
		displaySongName.alpha = 0;
		add(displaySongName);
		displaySongName.cameras = [camHUD];

		displaySongName.screenCenter(X);
		displaySongName.x -= songNameDistance;
		ccdisplaySongName.alignment = "center";
		ccdisplaySongName.alpha = 0;
		add(ccdisplaySongName);
		ccdisplaySongName.cameras = [camHUD];

		ccdisplaySongName.screenCenter(X);
		ccdisplaySongName.x -= ccsongNameDistance;
		RobodisplaySongName.alignment = "center";
		RobodisplaySongName.alpha = 0;
		add(RobodisplaySongName);
		RobodisplaySongName.cameras = [camHUD];

		RobodisplaySongName.screenCenter(X);
		RobodisplaySongName.x -= RobosongNameDistance;
		
		iconSongName = new FlxSprite(0,0);
		iconSongName.y = songBackSprite.y;
		iconSongName.alpha = 0;
		add(iconSongName);
		iconSongName.cameras = [camHUD];
		cciconSongName = new FlxSprite(0,0);
		cciconSongName.y = ccsongBackSprite.y;
		cciconSongName.alpha = 0;
		add(cciconSongName);
		cciconSongName.cameras = [camHUD];
		RoboiconSongName = new FlxSprite(0,0);
		RoboiconSongName.y = RobosongBackSprite.y;
		RoboiconSongName.alpha = 0;
		add(RoboiconSongName);
		RoboiconSongName.cameras = [camHUD];
		iconSongNameAgain = new FlxSprite(0,0);
		iconSongNameAgain.y = songBackSprite.y;
		iconSongNameAgain.alpha = 0;
		add(iconSongNameAgain);
		iconSongNameAgain.cameras = [camHUD];

		cciconSongNameAgain = new FlxSprite(0,0);
		cciconSongNameAgain.y = songBackSprite.y;
		cciconSongNameAgain.alpha = 0;
		add(cciconSongNameAgain);
		cciconSongNameAgain.cameras = [camHUD];

		RoboiconSongNameAgain = new FlxSprite(0,0);
		RoboiconSongNameAgain.y = songBackSprite.y;
		RoboiconSongNameAgain.alpha = 0;
		add(RoboiconSongNameAgain);
		RoboiconSongNameAgain.cameras = [camHUD];

		var dumb = CoolUtil.coolTextFile(Paths.txt(SONG.song.toLowerCase().replace(' ', '-') + '/artist'));
		displayArtistName = new FlxText(0, songBackSprite.y + 20, 0, dumb[0], 40);
		ccdisplayArtistName = new FlxText(0, songBackSprite.y + 20, 0, dumb[1], 40);
		RobodisplayArtistName = new FlxText(0, songBackSprite.y + 20, 0, dumb[2], 40);
		
		switch (curStage)
		{
			case 'jelly':
				displayArtistName.setFormat(Paths.font("Schluber.ttf"), 20, FlxColor.PURPLE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
				ccdisplayArtistName.setFormat(Paths.font("Schluber.ttf"), 20, FlxColor.PURPLE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
				RobodisplayArtistName.setFormat(Paths.font("Schluber.ttf"), 20, FlxColor.PURPLE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
			default:
				displayArtistName.setFormat(Paths.font("Friday Night Funkin Font.ttf"), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				ccdisplayArtistName.setFormat(Paths.font("Friday Night Funkin Font.ttf"), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				RobodisplayArtistName.setFormat(Paths.font("Friday Night Funkin Font.ttf"), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);

		}
		displayArtistName.alignment = "center";
		displayArtistName.alpha = 0;
		add(displayArtistName);
		displayArtistName.cameras = [camHUD];

		displayArtistName.screenCenter(X);
		ccdisplayArtistName.alignment = "center";
		ccdisplayArtistName.alpha = 0;
		add(ccdisplayArtistName);
		ccdisplayArtistName.cameras = [camHUD];

		ccdisplayArtistName.screenCenter(X);
		RobodisplayArtistName.alignment = "center";
		RobodisplayArtistName.alpha = 0;
		add(RobodisplayArtistName);
		RobodisplayArtistName.cameras = [camHUD];

		RobodisplayArtistName.screenCenter(X);


		
		if(PlayState.SONG.stage == null || PlayState.SONG.stage.length < 1) {
			switch (songName)
			{
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly' | 'philly-nice':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'limo';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				default:
					curStage = 'stage';
			}
		}

		var stageData:StageFile = StageData.getStageFile(curStage);
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,
			
				boyfriend: [770, 100],
				girlfriend: [400, 130],
				opponent: [100, 100],
				hide_girlfriend: false,
			
				camera_boyfriend: [0, 0],
				camera_opponent: [0, 0],
				camera_girlfriend: [0, 0],
				camera_speed: 1
			};
		}

		defaultCamZoom = stageData.defaultZoom;
		isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		if(stageData.camera_speed != null)
			cameraSpeed = stageData.camera_speed;

		boyfriendCameraOffset = stageData.camera_boyfriend;
		if(boyfriendCameraOffset == null) //Fucks sake should have done it since the start :rolling_eyes:
			boyfriendCameraOffset = [0, 0];

		opponentCameraOffset = stageData.camera_opponent;
		if(opponentCameraOffset == null)
			opponentCameraOffset = [0, 0];

		opponentAgainCameraOffset = stageData.camera_opponent;
		if(opponentAgainCameraOffset == null)
			opponentAgainCameraOffset = [0, 0];
		
		girlfriendCameraOffset = stageData.camera_girlfriend;
		if(girlfriendCameraOffset == null)
			girlfriendCameraOffset = [0, 0];

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		boyfriendGroupAgain = new FlxSpriteGroup(BF_X + 250, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		dadGroupAgain1 = new FlxSpriteGroup(DAD_X - 250, DAD_Y);
		dadGroupAgain2 = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);
		gfGroupAgain = new FlxSpriteGroup(GF_X - 600, GF_Y);


		dad = new Character(0, 0, SONG.player2);
		dadAgain1 = new Character(0, 0, SONG.player2);
		dadBETADCIU = new Character(0, 0, SONG.player2);
		dadAgain2 = new Character(0, 0, SONG.player2);
		startCharacterPos(dad, true);
		startCharacterPos(dadAgain1, true);
		startCharacterPos(dadAgain2, true);
		dadGroup.add(dad);
		dadGroupAgain1.add(dadAgain1);
		dadGroupAgain2.add(dadAgain2);
		
		
		startCharacterLua(dad.curCharacter);
		startCharacterLua(dadAgain1.curCharacter);
		
		boyfriend = new Boyfriend(0, 0, SONG.player1);
		boyfriendAgain = new Boyfriend(0, 0, SONG.player1);
		boyfriendBETADCIU = new Boyfriend(0, 0, SONG.player1);
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);
		startCharacterPos(boyfriendAgain);
		boyfriendGroupAgain.add(boyfriendAgain);
		startCharacterLua(boyfriend.curCharacter);
		startCharacterLua(boyfriendAgain.curCharacter);
		lol86 = new Character(100, 100, 'rose');

		var gfVersion:String = SONG.gfVersion;
		if(gfVersion == null || gfVersion.length < 1) {
			switch (curStage)
			{
				case 'limo':
					gfVersion = 'gf-car';
				case 'mall' | 'mallEvil':
					gfVersion = 'gf-christmas';
				case 'school' | 'schoolEvil':
					gfVersion = 'gf-pixel';
				default:
					gfVersion = 'gf';
			}
			SONG.gfVersion = gfVersion; //Fix for the Chart Editor
		}
		{
			gf = new Character(0, 0, gfVersion);
			startCharacterPos(gf);
			gf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(gf);
			startCharacterLua(gf.curCharacter);
			
			gfAgain = new Character(0, 0, 'susan');
			startCharacterPos(gfAgain);
			gfAgain.scrollFactor.set(0.95, 0.95);
			gfGroupAgain.add(gfAgain);
			startCharacterLua(gfAgain.curCharacter);
		}
		if (stageData.hide_girlfriend)
			gf.visible = false;

		switch (curStage)
		{
			case 'stage': //Week 1
				var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
				add(bg);
				for (i in 0...23)
				{
					var rectanglemf:BGSprite;
					if (i == 0)
						rectanglemf = new BGSprite('pillar', -300, 0, 0.9, 0.9);
					else
						rectanglemf = new BGSprite('pillar', funniRects[i-1].x + funniRects[i-1].width, 0, 0.9, 0.9);
					rectanglemf.setGraphicSize(Std.int(rectanglemf.width * 5));
					rectanglemf.updateHitbox();
					rectanglemf.antialiasing = false;
					rectanglemf.visible = ClientPrefs.visualizers;
					add(rectanglemf);
					funniVariable[funniRects.length] = FlxG.random.int(100, 200);
					funniRects.push(rectanglemf);
				}
				for (i in 0...23)
				{
					var rectanglemf:BGSprite;
					if (i == 0)
						rectanglemf = new BGSprite('pillar', -300, 0, 0.9, 0.9);
					else
						rectanglemf = new BGSprite('pillar', moreRects[i-1].x + moreRects[i-1].width, 0, 0.9, 0.9);
					rectanglemf.setGraphicSize(Std.int(rectanglemf.width * 5));
					rectanglemf.flipY = true;
					rectanglemf.updateHitbox();
					rectanglemf.antialiasing = false;
					rectanglemf.visible = ClientPrefs.visualizers;
					add(rectanglemf);
					funniVariable[moreRects.length] = FlxG.random.int(100, 200);
					moreRects.push(rectanglemf);
				}
				aaaaaaaaclose = funniRects[funniRects.length-1].x+funniRects[funniRects.length-1].width;
				
				var stageFront:BGSprite = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				add(stageFront);
				if(!ClientPrefs.lowQuality) {
					var stageLight:BGSprite = new BGSprite('stage_light', -125, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					add(stageLight);
					var stageLight:BGSprite = new BGSprite('stage_light', 1225, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					stageLight.flipX = true;
					add(stageLight);

					var stageCurtains:BGSprite = new BGSprite('stagecurtains', -500, -300, 1.3, 1.3);
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					add(stageCurtains);
				}

			case 'spooky': //Week 2
				if(!ClientPrefs.lowQuality) {
					halloweenBG = new BGSprite('halloween_bg', -200, -100, ['halloweem bg0', 'halloweem bg lightning strike']);
				} else {
					halloweenBG = new BGSprite('halloween_bg_low', -200, -100);
				}
				add(halloweenBG);

				halloweenWhite = new BGSprite(null, -FlxG.width, -FlxG.height, 0, 0);
				halloweenWhite.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.WHITE);
				halloweenWhite.alpha = 0;
				halloweenWhite.blend = ADD;

				//PRECACHE SOUNDS
				CoolUtil.precacheSound('thunder_1');
				CoolUtil.precacheSound('thunder_2');

			case 'philly': //Week 3
				if(!ClientPrefs.lowQuality) {
					var bg:BGSprite = new BGSprite('philly/sky', -100, 0, 0.1, 0.1);
					add(bg);
				}
				
				var city:BGSprite = new BGSprite('philly/city', -10, 0, 0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<BGSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:BGSprite = new BGSprite('philly/win' + i, city.x, city.y, 0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					phillyCityLights.add(light);
				}

				if(!ClientPrefs.lowQuality) {
					var streetBehind:BGSprite = new BGSprite('philly/behindTrain', -40, 50);
					add(streetBehind);
				}

				phillyTrain = new BGSprite('philly/train', 2000, 360);
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				CoolUtil.precacheSound('train_passes');
				FlxG.sound.list.add(trainSound);

				var street:BGSprite = new BGSprite('philly/street', -40, 50);
				add(street);

			case 'limo': //Week 4
				var skyBG:BGSprite = new BGSprite('limo/limoSunset', -120, -50, 0.1, 0.1);
				add(skyBG);
				for (i in 0...23)
				{
					var rectanglemf:BGSprite;
					if (i == 0)
						rectanglemf = new BGSprite('pillar', -300, 0, 0.9, 0.9);
					else
						rectanglemf = new BGSprite('pillar', funniRects[i-1].x + funniRects[i-1].width, 0, 0.9, 0.9);
					rectanglemf.color = FlxColor.GREEN;
					rectanglemf.setGraphicSize(Std.int(rectanglemf.width * 5));
					rectanglemf.updateHitbox();
					rectanglemf.antialiasing = false;
					rectanglemf.visible = ClientPrefs.visualizers;
					add(rectanglemf);
					funniVariable[funniRects.length] = FlxG.random.int(100, 200);
					funniRects.push(rectanglemf);
				}
				for (i in 0...23)
				{
					var rectanglemf:BGSprite;
					if (i == 0)
						rectanglemf = new BGSprite('pillar', -300, 0, 0.9, 0.9);
					else
						rectanglemf = new BGSprite('pillar', moreRects[i-1].x + moreRects[i-1].width, 0, 0.9, 0.9);
					rectanglemf.color = FlxColor.PINK;
					rectanglemf.setGraphicSize(Std.int(rectanglemf.width * 5));
					//rectanglemf.flipY = true;
					rectanglemf.updateHitbox();
					rectanglemf.antialiasing = false;
					rectanglemf.visible = ClientPrefs.visualizers;
					add(rectanglemf);
					funniVariable[moreRects.length] = FlxG.random.int(100, 200);
					moreRects.push(rectanglemf);
				}
				aaaaaaaaclose = funniRects[funniRects.length-1].x+funniRects[funniRects.length-1].width;
				aaaaaaaaclose2 = funniRects[0].x;

				if(!ClientPrefs.lowQuality) {
					limoMetalPole = new BGSprite('gore/metalPole', -500, 220, 0.4, 0.4);
					add(limoMetalPole);

					bgLimo = new BGSprite('limo/bgLimo', -150, 480, 0.4, 0.4, ['background limo pink'], true);
					add(bgLimo);

					limoCorpse = new BGSprite('gore/noooooo', -500, limoMetalPole.y - 130, 0.4, 0.4, ['Henchmen on rail'], true);
					add(limoCorpse);

					limoCorpseTwo = new BGSprite('gore/noooooo', -500, limoMetalPole.y, 0.4, 0.4, ['henchmen death'], true);
					add(limoCorpseTwo);

					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}

					limoLight = new BGSprite('gore/coldHeartKiller', limoMetalPole.x - 180, limoMetalPole.y - 80, 0.4, 0.4);
					add(limoLight);

					grpLimoParticles = new FlxTypedGroup<BGSprite>();
					add(grpLimoParticles);

					//PRECACHE BLOOD
					var particle:BGSprite = new BGSprite('gore/stupidBlood', -400, -400, 0.4, 0.4, ['blood'], false);
					particle.alpha = 0.01;
					grpLimoParticles.add(particle);
					resetLimoKill();

					//PRECACHE SOUND
					CoolUtil.precacheSound('dancerdeath');
				}

				limo = new BGSprite('limo/limoDrive', -120, 550, 1, 1, ['Limo stage'], true);

				fastCar = new BGSprite('limo/fastCarLol', -300, 160);
				fastCar.active = true;
				limoKillingState = 0;

			case 'mall': //Week 5 - Cocoa, Eggnog
				var bg:BGSprite = new BGSprite('christmas/bgWalls', -1000, -500, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				if(!ClientPrefs.lowQuality) {
					upperBoppers = new BGSprite('christmas/upperBop', -240, -90, 0.33, 0.33, ['Upper Crowd Bob']);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);

					var bgEscalator:BGSprite = new BGSprite('christmas/bgEscalator', -1100, -600, 0.3, 0.3);
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);
				}

				var tree:BGSprite = new BGSprite('christmas/christmasTree', 370, -250, 0.40, 0.40);
				add(tree);

				bottomBoppers = new BGSprite('christmas/bottomBop', -300, 140, 0.9, 0.9, ['Bottom Level Boppers Idle']);
				bottomBoppers.animation.addByPrefix('hey', 'Bottom Level Boppers HEY', 24, false);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:BGSprite = new BGSprite('christmas/fgSnow', -600, 700);
				add(fgSnow);

				santa = new BGSprite('christmas/santa', -840, 150, 1, 1, ['santa idle in fear']);
				add(santa);
				CoolUtil.precacheSound('Lights_Shut_off');

			case 'mallEvil': //Week 5 - Winter Horrorland
				var bg:BGSprite = new BGSprite('christmas/evilBG', -400, -500, 0.2, 0.2);
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:BGSprite = new BGSprite('christmas/evilTree', 300, -300, 0.2, 0.2);
				add(evilTree);

				var evilSnow:BGSprite = new BGSprite('christmas/evilSnow', -200, 700);
				add(evilSnow);

			case 'school': //Week 6 - Senpai, Roses
				GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
				GameOverSubstate.loopSoundName = 'gameOver-pixel';
				GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
				GameOverSubstate.characterName = 'bf-pixel-dead';

				var bgSky:BGSprite = new BGSprite('weeb/weebSky', 0, 0, 0.1, 0.1);
				add(bgSky);
				bgSky.antialiasing = false;

				var repositionShit = -200;

				var bgSchool:BGSprite = new BGSprite('weeb/weebSchool', repositionShit, 0, 0.6, 0.90);
				add(bgSchool);
				bgSchool.antialiasing = false;

				var bgStreet:BGSprite = new BGSprite('weeb/weebStreet', repositionShit, 0, 0.95, 0.95);
				add(bgStreet);
				bgStreet.antialiasing = false;

				var widShit = Std.int(bgSky.width * 6);
				if(!ClientPrefs.lowQuality) {
					var fgTrees:BGSprite = new BGSprite('weeb/weebTreesBack', repositionShit + 170, 130, 0.9, 0.9);
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					fgTrees.updateHitbox();
					add(fgTrees);
					fgTrees.antialiasing = false;
				}

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				bgTrees.frames = Paths.getPackerAtlas('weeb/weebTrees');
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);
				bgTrees.antialiasing = false;

				if(!ClientPrefs.lowQuality) {
					var treeLeaves:BGSprite = new BGSprite('weeb/petals', repositionShit, -40, 0.85, 0.85, ['PETALS ALL'], true);
					treeLeaves.setGraphicSize(widShit);
					treeLeaves.updateHitbox();
					add(treeLeaves);
					treeLeaves.antialiasing = false;
				}

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));

				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();

				if(!ClientPrefs.lowQuality) {
					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
				}

			case 'schoolEvil': //Week 6 - Thorns
				GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
				GameOverSubstate.loopSoundName = 'gameOver-pixel';
				GameOverSubstate.endSoundName = 'gameOverEnd-pixel';
				GameOverSubstate.characterName = 'bf-pixel-dead';

				/*if(!ClientPrefs.lowQuality) { //Does this even do something?
					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);
				}*/
				var posX = 400;
				var posY = 200;
				if(!ClientPrefs.lowQuality) {
					var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool', posX, posY, 0.8, 0.9, ['background 2'], true);
					bg.scale.set(6, 6);
					bg.antialiasing = false;
					add(bg);

					bgGhouls = new BGSprite('weeb/bgGhouls', -100, 190, 0.9, 0.9, ['BG freaks glitch instance'], false);
					bgGhouls.setGraphicSize(Std.int(bgGhouls.width * daPixelZoom));
					bgGhouls.updateHitbox();
					bgGhouls.visible = false;
					bgGhouls.antialiasing = false;
					add(bgGhouls);
				} else {
					var bg:BGSprite = new BGSprite('weeb/animatedEvilSchool_low', posX, posY, 0.8, 0.9);
					bg.scale.set(6, 6);
					bg.antialiasing = false;
					add(bg);
				}

			case 'sunkStage':
			{
				defaultCamZoom = 0.9;
				curStage = 'sunkStage';



				bg1 = new FlxSprite().loadGraphic(Paths.image('milk/SunkBG2', 'shared'));
				bg1.setGraphicSize(Std.int(bg1.width * 0.8));
				bg1.antialiasing = true;
				bg1.scrollFactor.set(.91, .91);
				bg1.x -= 670;
				bg1.y -= 260;

				bg1.active = false;
				bg3 = new FlxSprite(bg1.x, bg1.y + 550).makeGraphic(Std.int(bg1.width), 800, FlxColor.RED);
				bg3.antialiasing = true;
				bg3.scrollFactor.set(.91, .91);
				bg3.alpha = 1/3;
				bg4 = new FlxSprite(bg1.x, bg1.y + 700).makeGraphic(Std.int(bg1.width), 700, FlxColor.RED);
				bg4.antialiasing = true;
				bg4.scrollFactor.set(.91, .91);
				bg4.alpha = 1/3;
				bg5 = new FlxSprite(bg1.x, bg1.y + 850).makeGraphic(Std.int(bg1.width), 600, FlxColor.RED);
				bg5.antialiasing = true;
				bg5.scrollFactor.set(.91, .91);
				bg5.alpha = 1/3;
				add(bg3);
				add(bg4);
				add(bg5);
				add(bg1);

				bg2 = new FlxSprite().loadGraphic(Paths.image('milk/SunkBG', 'shared'));
				bg2.setGraphicSize(Std.int(bg2.width * 0.8));
				bg2.antialiasing = true;
				bg2.scrollFactor.set(.91, .91);
				bg2.x -= 670;
				bg2.y -= 260;
				bg2.active = false;
				add(bg2);
			}
			case 'pegmeplease':
				defaultCamZoom = 0.9;
				curStage = 'pegmeplease';

				var stageFront:FlxSprite = new FlxSprite(-400, 0).loadGraphic(Paths.image('church/floor'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(1, 1);
				stageFront.active = false;
				add(stageFront);

				var bgback:FlxSprite = new FlxSprite(-400, -200).loadGraphic(Paths.image('church/bgback'));
				bgback.setGraphicSize(Std.int(stageFront.width * 1.2));
				bgback.updateHitbox();
				bgback.antialiasing = true;
				bgback.scrollFactor.set(0.9, 1);
				bgback.active = false;
				add(bgback);
				
				for (i in 0...17)
				{
					var rectanglemf:BGSprite;
					if (i == 0)
						rectanglemf = new BGSprite('pillar', 150, 1200, 0.9, 0.9);
					else
						rectanglemf = new BGSprite('pillar', funniRects[i-1].x + funniRects[i-1].width, 1200, 0.9, 0.9);
					rectanglemf.color = FlxColor.YELLOW;
					rectanglemf.setGraphicSize(Std.int(rectanglemf.width * 5));
					rectanglemf.updateHitbox();
					rectanglemf.antialiasing = false;
					rectanglemf.visible = ClientPrefs.visualizers;
					add(rectanglemf);
					rectanglemf.alpha = 0.8;
					funniVariable[funniRects.length] = FlxG.random.int(100, 200);
					funniRects.push(rectanglemf);
				}
				for (i in 0...17)
				{
					var rectanglemf:BGSprite;
					if (i == 0)
						rectanglemf = new BGSprite('pillar', 150, -1200, 0.9, 0.9);
					else
						rectanglemf = new BGSprite('pillar', moreRects[i-1].x + moreRects[i-1].width, -1200, 0.9, 0.9);
					rectanglemf.color = FlxColor.PINK;
					rectanglemf.setGraphicSize(Std.int(rectanglemf.width * 5));
					//rectanglemf.flipY = true;
					rectanglemf.updateHitbox();
					rectanglemf.antialiasing = false;
					rectanglemf.visible = ClientPrefs.visualizers;
					add(rectanglemf);
					funniVariable[moreRects.length] = FlxG.random.int(100, 200);
					moreRects.push(rectanglemf);
				}
				aaaaaaaaclose = funniRects[funniRects.length-1].x+funniRects[funniRects.length-1].width;
				aaaaaaaaclose2 = moreRects[0].x;
				aaaaaaaaclose3 = funniRects[0].x;
				aaaaaaaaclose4 = moreRects[moreRects.length-1].x+moreRects[moreRects.length-1].width;
				var bgback2:FlxSprite = new FlxSprite(-400, -200).loadGraphic(Paths.image('church/bgback2'));
				bgback2.setGraphicSize(Std.int(stageFront.width * 1.2));
				bgback2.updateHitbox();
				bgback2.antialiasing = true;
				bgback2.scrollFactor.set(0.9, 1);
				bgback2.active = false;
				add(bgback2);
				var bg:FlxSprite = new FlxSprite(-400, -200).loadGraphic(Paths.image('church/bg'));
				bg.setGraphicSize(Std.int(stageFront.width * 1.2));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 1);
				bg.active = false;
				add(bg);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('church/pillars'));
				stageCurtains.setGraphicSize(Std.int(stageFront.width * 1.2));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(0.9, 1);
				stageCurtains.active = false;
				add(stageCurtains);

				var circ0:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('church/circ0'));
				circ0.setGraphicSize(Std.int(stageFront.width * 1.2));
				circ0.updateHitbox();
				circ0.antialiasing = true;
				circ0.scrollFactor.set(0.9, 1);
				circ0.active = false;
				add(circ0);

				circ2 = new FlxSprite(-500, -375).loadGraphic(Paths.image('church/circ1'));
				circ2.setGraphicSize(Std.int(stageFront.width * 1.2));
				circ2.updateHitbox();
				circ2.origin.set(989,659);
				circ2.antialiasing = true;
				circ2.scrollFactor.set(0.9, 1);
				circ2.active = false;
				add(circ2);

				circ1 = new FlxSprite(-500, -375).loadGraphic(Paths.image('church/circ2'));
				circ1.setGraphicSize(Std.int(stageFront.width * 1.2));
				circ1.updateHitbox();
				circ1.origin.set(989,659);
				circ1.antialiasing = true;
				circ1.scrollFactor.set(0.9, 1);
				circ1.active = false;
				add(circ1);
			case 'auditorHell':
			{
				defaultCamZoom = 0.55;
				curStage = 'auditorHell';
	
				tstatic.scrollFactor.set(0, 0);
				tstatic.setGraphicSize(Std.int(tstatic.width * 8.3));
				tstatic.animation.add('static', [0, 1, 2], 24, true);
				tstatic.animation.play('static');
	
				tstatic.alpha = 0;
	
				var bg:FlxSprite = new FlxSprite(-10, -10).loadGraphic(Paths.image('expurgation/bg', 'shared'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox();
				bg.setGraphicSize(Std.int(bg.width * 4));
				bg.graphic.dump();
				add(bg);
				for (i in 0...17)
				{
					var rectanglemf:BGSprite;
					if (i == 0)
						rectanglemf = new BGSprite('pillar', 0, 1200, 0.9, 0.9);
					else
						rectanglemf = new BGSprite('pillar', funniRects[i-1].x + funniRects[i-1].width, 1200, 0.9, 0.9);
					rectanglemf.color = FlxColor.RED;
					rectanglemf.setGraphicSize(Std.int(rectanglemf.width * 5));
					rectanglemf.updateHitbox();
					rectanglemf.antialiasing = false;
					rectanglemf.visible = ClientPrefs.visualizers;
					add(rectanglemf);
					rectanglemf.alpha = 0.8;
					funniVariable[funniRects.length] = FlxG.random.int(100, 200);
					funniRects.push(rectanglemf);
				}
				for (i in 0...17)
				{
					var rectanglemf:BGSprite;
					if (i == 0)
						rectanglemf = new BGSprite('pillar', 0, -1200, 0.9, 0.9);
					else
						rectanglemf = new BGSprite('pillar', moreRects[i-1].x + moreRects[i-1].width, -1200, 0.9, 0.9);
					rectanglemf.color = FlxColor.BLACK;
					rectanglemf.setGraphicSize(Std.int(rectanglemf.width * 5));
					//rectanglemf.flipY = true;
					rectanglemf.updateHitbox();
					rectanglemf.antialiasing = false;
					rectanglemf.visible = ClientPrefs.visualizers;
					add(rectanglemf);
					funniVariable[moreRects.length] = FlxG.random.int(100, 200);
					moreRects.push(rectanglemf);
				}
				aaaaaaaaclose = funniRects[funniRects.length-1].x+funniRects[funniRects.length-1].width;
				aaaaaaaaclose2 = moreRects[0].x;
				aaaaaaaaclose3 = funniRects[0].x;
	
				hole.scrollFactor.set(0.9, 0.9);
				hole.setGraphicSize(Std.int(hole.width * 2));
				hole.updateHitbox();
				hole.graphic.dump();
	
				converHole.scrollFactor.set(0.9, 0.9);
				converHole.setGraphicSize(Std.int(converHole.width * 2));
				converHole.updateHitbox();
				converHole.setGraphicSize(Std.int(converHole.width * 1.3));
				hole.setGraphicSize(Std.int(hole.width * 1.55));
				converHole.graphic.dump();
	
				cover.scrollFactor.set(0.9, 0.9);
				cover.setGraphicSize(Std.int(cover.width * 2));
				cover.updateHitbox();
				cover.setGraphicSize(Std.int(cover.width * 1.55));
				cover.graphic.dump();
	
				var energyWall:FlxSprite = new FlxSprite(1350, -690).loadGraphic(Paths.image("expurgation/Energywall", "shared"));
				energyWall.setGraphicSize(Std.int(energyWall.width * 2));
				energyWall.updateHitbox();
				energyWall.scrollFactor.set(0.9, 0.9);
				energyWall.graphic.dump();
				add(energyWall);
	
				var stageFront:FlxSprite = new FlxSprite(-350, -355).loadGraphic(Paths.image('expurgation/daBackground', 'shared'));
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 2));
				stageFront.updateHitbox();
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.55));
				stageFront.graphic.dump();
				add(stageFront);
				add(hole);
				// Clown init
				addCharacterToList('hat kid tiky', 3);

				var wasGf:Bool = dad.curCharacter.startsWith('gf');
				var lastAlpha:Float = dadAgain1.alpha;
				dadAgain1.alpha = 0.00001;
				dadAgain1 = dadMapAgain1.get('hat kid tiky');
				dadAgain1.alpha = lastAlpha;
				dadAgain1.visible = true;
				//add(dadAgain1);
				add(gf);
				add(lol86);
				add(dad);
				cloneOne = new FlxSprite(0, 0);
				cloneTwo = new FlxSprite(0, 0);
				var cloneframes = Paths.getSparrowAtlas('expurgation/Clone', 'shared');
				cloneOne.frames = cloneframes;
				cloneTwo.frames = cloneframes;
				cloneOne.setGraphicSize(Std.int(cloneOne.width * 2));
				cloneOne.updateHitbox();
				cloneTwo.setGraphicSize(Std.int(cloneTwo.width * 2));
				cloneTwo.updateHitbox();
				cloneOne.alpha = 0;
				cloneTwo.alpha = 0;
				cloneOne.animation.addByPrefix('clone', 'Clone', 24, false);
				cloneTwo.animation.addByPrefix('clone', 'Clone', 24, false);
				boyfriend.scrollFactor.set(0.9, 0.9);
				gf.scrollFactor.set(0.9, 0.9);
				lol86.scrollFactor.set(0.9, 0.9);
				dadAgain1.scrollFactor.set(0.9, 0.9);
				dad.scrollFactor.set(0.9, 0.9);
				dadAgain1.y = dad.y;
				dadAgain1.x = dad.x + 600;
				// cover crap
				hatSpikes = new FlxSprite(dadAgain1.x - 130, dadAgain1.y - 60);
				hatSpikes.frames = Paths.getSparrowAtlas('expurgation/Floor','shared');
				hatSpikes.visible = false;
				hatSpikes.updateHitbox();
				hatSpikes.scrollFactor.set(0.9, 0.9);

				hatSpikes.animation.addByPrefix('spike','Floor Spikes', 24, false);
				
				exSpikes = new FlxSprite(dad.x - 350,dad.y - 130);
				exSpikes.frames = Paths.getSparrowAtlas('expurgation/FloorSpikes','shared');
				exSpikes.visible = false;
				exSpikes.setGraphicSize(Std.int(exSpikes.width * 2));
				exSpikes.updateHitbox();

				exSpikes.animation.addByPrefix('spike','Floor Spikes', 24, false);
				exSpikes.scrollFactor.set(0.9, 0.9);
				tstatic.alpha = 0.1;
				tstatic.setGraphicSize(Std.int(tstatic.width * 12));
				tstatic.x += 600;
			}
			case 'garAlley':
			{
				curStage = 'garAlley';

				//var images = ['Zardy', 'HATKID_HATTED', 'HEX', 'tord_assets', 'RON', 'sunday_assets', 'monsterAnnie', 'TANKMAN', 'tricky', 'LavPhase1', 'spooky_kids_assets', 'KAPI', 'rebecca_asset4', 'Pico_FNF_assetss', 'cass', 'TABI', 'AGOTI', 'HD_SENPAI', 'HD_MONIKA', 'bob_asset', 'OPHEEBOP', 'sarvente_sheet', 'ruv_sheet', 'qt-kbV2', 'WHITTY', 'CAROL'];
		
				//trace("caching images...");
		
				//for (i in images)
				//{
					//FlxG.bitmap.add(Paths.image("characters/" + i,"shared"));
					//trace("cached " + i);
				//}

				var bg:FlxSprite = new FlxSprite(-500, -170).loadGraphic(Paths.image('headache/garStagebg'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.7, 0.7);
				bg.active = false;
				add(bg);
				for (i in 0...9)
				{
					var rectanglemf:BGSprite;
					if (i == 0)
						rectanglemf = new BGSprite('pillar', -400, 600, 0.9, 0.9);
					else
						rectanglemf = new BGSprite('pillar', moreRects[i-1].x + moreRects[i-1].width, 600, 0.9, 0.9);
					rectanglemf.color = 0xFF66FFFF;
					rectanglemf.setGraphicSize(Std.int(rectanglemf.width * 5));
					//rectanglemf.flipY = true;
					rectanglemf.updateHitbox();
					rectanglemf.antialiasing = false;
					rectanglemf.visible = ClientPrefs.visualizers;
					add(rectanglemf);
					funniVariable[moreRects.length] = FlxG.random.int(100, 200);
					moreRects.push(rectanglemf);
				}
				for (i in 0...9)
				{
					var rectanglemf:BGSprite;
					if (i == 0)
						rectanglemf = new BGSprite('pillar', -400, 600, 0.9, 0.9);
					else
						rectanglemf = new BGSprite('pillar', funniRects[i-1].x + funniRects[i-1].width, 600, 0.9, 0.9);
					rectanglemf.color = 0xFF00FF90;
					rectanglemf.setGraphicSize(Std.int(rectanglemf.width * 5));
					rectanglemf.updateHitbox();
					rectanglemf.antialiasing = false;
					rectanglemf.visible = ClientPrefs.visualizers;
					add(rectanglemf);
					rectanglemf.alpha = 0.8;
					funniVariable[funniRects.length] = FlxG.random.int(100, 200);
					funniRects.push(rectanglemf);
				}
				aaaaaaaaclose = funniRects[funniRects.length-1].x+funniRects[funniRects.length-1].width;
				aaaaaaaaclose2 = moreRects[0].x;
				aaaaaaaaclose3 = funniRects[0].x;

				var bgAlley:FlxSprite = new FlxSprite(-500, -200).loadGraphic(Paths.image('headache/garStage'));
				bgAlley.antialiasing = true;
				bgAlley.scrollFactor.set(0.9, 0.9);
				bgAlley.active = false;
				add(bgAlley);

				/*var dadarray = ['zardy', 'hat-kid-hatted', 'hex', 'tord', 'ron', 'sky-mad', 'monster-annie', 'tankman', 'tricky', 'lav', 'spooky', 'kapi', 'rebecca4', 'pico', 'cass', 'tabi', 'agoti', 'HD_senpai', 'HD_monika', 'bob', 'opheebop', 'sarv', 'ruv', 'qt-kb', 'whitty', 'carol'];
				for (i in dadarray)
				{
					var dadder = new Character(100, 100, i);
					add(dadder);
					trace("added " + i);
				}*/
			}
			case 'knockout':
			{

				var images1 = [
					'knockout/shootstuff/Cupheadshoot',
					'knockout/shootstuff/downscroll',
					'knockout/shootstuff/GreenShit',
					'knockout/shootstuff/roundabout',
					'knockout/shootstuff/super',
					'knockout/shootstuff/superCard',
					'knockout/shootstuff/upscroll',
					'knockout/shootstuff/tord/DS Rocket Note',
					'knockout/shootstuff/tord/Explosion',
					'knockout/shootstuff/yuri projectiles/word 0',
					'knockout/shootstuff/yuri projectiles/word 1',
					'knockout/shootstuff/yuri projectiles/word 2',
					'knockout/shootstuff/yuri projectiles/word 3',
					'knockout/shootstuff/yuri projectiles/word 4',
					'knockout/shootstuff/yuri projectiles/word 5',
					'knockout/shootstuff/yuri projectiles/word 6',
					'knockout/shootstuff/sunk/loop 1',
					'knockout/shootstuff/sunk/loop 2',
					'knockout/shootstuff/sunk/loop 3',
					'knockout/shootstuff/sunk/loop 4',
					'knockout/shootstuff/sunk/loop 5',
					'knockout/shootstuff/sunk/loop 6',
					'knockout/shootstuff/sunk/spoon',
					'knockout/shootstuff/one projectile/circ',
					'knockout/shootstuff/one projectile/SusanShootFunni',
					'knockout/shootstuff/one projectile/tiky',
					'knockout/shootstuff/one projectile/wELL',
					'knockout/shootstuff/one projectile/cross',
					'knockout/shootstuff/ankha projectiles/B',
					'knockout/shootstuff/ankha projectiles/A',
					'knockout/shootstuff/ankha projectiles/L',
					'knockout/shootstuff/ankha projectiles/S',
					'knockout/shootstuff/ankha projectiles/8',
					'knockout/shootstuff/ankha projectiles/6',
					'knockout/shootstuff/jom/Fleetway_Lazer',
					'knockout/shootstuff/jom/Fleetway_Lazer2',
					'knockout/shootstuff/jom/the what',
					'knockout/burned to a crisp',
					'bigmonika/Sky',
					'bigmonika/BG',
					'bigmonika/FG',
					'bigmonika/bigika_delete',
					'sonicsez/sky',
				];
				var images2 = [
					'knockout/burned to a crisp',
					'bigmonika/Sky',
					'bigmonika/BG',
					'bigmonika/FG',
				];
		
				trace("caching images...");
				for (i in images2)
				{
					FlxG.bitmap.add(Paths.image(i,"shared"));
					trace('cached ' + i);
				}
				
				attack.frames = Paths.getSparrowAtlas('knockout/IC_Buttons');
				attack.animation.addByPrefix('idle','Attack instance 1', 24, false);
				attack.animation.addByPrefix('active','Attack Click instance 1', 24, false);
				attack.animation.play('idle');
				attack.cameras = [camHUD];
				attack.scale.set(0.5,0.5);
				attack.updateHitbox();
				attack.alpha = 0.5;
				dodge.frames = Paths.getSparrowAtlas('knockout/IC_Buttons');
				dodge.animation.addByPrefix('idle','Dodge instance 1', 24, false);
				dodge.animation.addByPrefix('active','Dodge click instance 1', 24, false);
				dodge.animation.play('idle');
				dodge.cameras = [camHUD];
				dodge.scale.set(0.5,0.5);
				dodge.updateHitbox();
				dodge.alpha = 0.5;

				add(attack);
				add(dodge);

				redLaser = new FlxSprite(dad.x - 800,dad.y - 1200);
				redLaser.frames = Paths.getSparrowAtlas('knockout/shootstuff/jom/Fleetway_Lazer');
				redLaser.animation.addByPrefix('shoot','laser instance 1', 24, false);
				redLaser.angle = -10;
				blueLaser = new FlxSprite(dad.x - 1300,dad.y - 1000);
				blueLaser.frames = Paths.getSparrowAtlas('knockout/shootstuff/jom/Fleetway_Lazer2');
				blueLaser.animation.addByPrefix('shoot','laser instance 1', 24, false);
				blueLaser.angle = -10;
				/*
				var dumb = CoolUtil.coolTextFile(Paths.txt('dumb'));
				var xfunni = Std.parseFloat(dumb[0]);
				var yfunni = Std.parseFloat(dumb[1]);
				trace(xfunni);
				trace(yfunni);
				curStage = 'knockout';

				var bg:FlxSprite = new FlxSprite(-800 + 1500, -400 + 800).loadGraphic(Paths.image('knockout/Cup-CH-RN-00'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.scale.set(3,3);

				var bg2:FlxSprite = new FlxSprite(-850 + 1500, -500 + 800).loadGraphic(Paths.image('knockout/Cup-CH-RN-01'));
				bg2.antialiasing = true;
				bg2.scrollFactor.set(0.2, 0.2);
				bg2.scale.set(3,3);

				var bg3:FlxSprite = new FlxSprite(-600 + 1500, -100 + 800).loadGraphic(Paths.image('knockout/Cup-CH-RN-02'));
				bg3.antialiasing = true;
				bg3.scale.set(4,4);
				add(bg);
				add(bg2);
				add(bg3);*/
				var dumb = CoolUtil.coolTextFile(Paths.txt('dumb'));
				var xfunni = Std.parseFloat(dumb[0]);
				var yfunni = Std.parseFloat(dumb[1]);
				curStage = 'knockout';

				bg1 = new FlxSprite(-650 + 1500, -50 + 800).loadGraphic(Paths.image('knockout/Cup-CH-RN-00'));
				blackSelever = new FlxSprite(-3000, -3000).makeGraphic(8000, 5000, FlxColor.BLACK);
				bg1.antialiasing = true;
				bg1.scrollFactor.set(0.5, 0.5);
				bg1.scale.set(3,3);

				bg2 = new FlxSprite(-850 + 1500, -150 + 800).loadGraphic(Paths.image('knockout/Cup-CH-RN-01'));
				bg2.antialiasing = true;
				bg2.scrollFactor.set(0.7, 0.7);
				bg2.scale.set(3,3);

				bg3 = new FlxSprite(-600 + 1500, -100 + 800).loadGraphic(Paths.image('knockout/Cup-CH-RN-02'));
				bg3.antialiasing = true;
				bg3.scale.set(4,4);
				add(bg1);
				add(bg2);
				for (i in 0...36)
				{
					var rectanglemf:BGSprite;
					if (i == 0)
						rectanglemf = new BGSprite('pillar', -300, 1400, 0.9, 0.9);
					else
						rectanglemf = new BGSprite('pillar', moreRects[i-1].x + moreRects[i-1].width, 1400, 0.9, 0.9);
					rectanglemf.color = 0xFF6670FF;
					rectanglemf.setGraphicSize(Std.int(rectanglemf.width * 5));
					//rectanglemf.flipY = true;
					rectanglemf.updateHitbox();
					rectanglemf.antialiasing = false;
					rectanglemf.visible = ClientPrefs.visualizers;
					add(rectanglemf);
					funniVariable[moreRects.length] = FlxG.random.int(100, 200);
					moreRects.push(rectanglemf);
				}
				for (i in 0...36)
				{
					var rectanglemf:BGSprite;
					if (i == 0)
						rectanglemf = new BGSprite('pillar', -300, 1400, 0.9, 0.9);
					else
						rectanglemf = new BGSprite('pillar', funniRects[i-1].x + funniRects[i-1].width, 1400, 0.9, 0.9);
					rectanglemf.color = 0xFFFF7373;
					rectanglemf.setGraphicSize(Std.int(rectanglemf.width * 5));
					rectanglemf.updateHitbox();
					rectanglemf.antialiasing = false;
					rectanglemf.visible = ClientPrefs.visualizers;
					add(rectanglemf);
					rectanglemf.alpha = 0.8;
					funniVariable[funniRects.length] = FlxG.random.int(100, 200);
					funniRects.push(rectanglemf);
				}
				aaaaaaaaclose = funniRects[funniRects.length-1].x+funniRects[funniRects.length-1].width;
				aaaaaaaaclose2 = moreRects[0].x;
				aaaaaaaaclose3 = funniRects[0].x;
				add(bg3);
				ExTrickyLinesSing = [
					"WHO IS THIS TRANSPARENT CUP",
					"WHAT'S A CUPHEAD",
					"IS THAT A POTATO???",
					"WHO ARE YOU",
					"WHERE AM I",
					"THIS ISN'T RIGHT",
					"POTATO",
					"SYSTEM UNRESPONSIVE",
					"WHY CAN'T I KILL?????",
					"HOW IS THIS CUP CONTROLLING ME"
				];
				lylaceDead = new FlxSprite(boyfriend.x + 650, boyfriend.y - 230);
				lylaceDead.flipX = true;
				lylaceDead.loadGraphic(Paths.image('knockout/burned to a crisp'));
			}
			case 'jelly':
			{
				curStage = 'jelly';

				bg1 = new FlxSprite(0, 0).loadGraphic(Paths.image('atrocity/bg'));
				bg1.antialiasing = true;
				bg1.scrollFactor.set(0.9, 0.9);

				bg2 = new FlxSprite(0, 0).loadGraphic(Paths.image('atrocity/bgjelly'));
				bg2.antialiasing = true;
				bg2.scrollFactor.set(0.9, 0.9);

				bg6 = new FlxSprite(-881, 0).loadGraphic(Paths.image('atrocity/moreBGs/bg14'));
				bg6.antialiasing = true;
				bg6.scrollFactor.set(0.9, 0.9);
				bg6.visible = false;

				
				rain1 = new BGSprite('atrocity/bg_skele', 100, 700, 0.9, 0.9, ['bg skele boppin'], true);

				bg3 = new FlxSprite(0, 0).loadGraphic(Paths.image('atrocity/border'));
				bg3.antialiasing = true;
				bg3.scrollFactor.set(0.9, 0.9);
				add(bg1);
				add(rain1);
				add(bg2);
				add(bg6);
			}
		}

		if(isPixelStage) {
			introSoundsSuffix = '-pixel';
		}

		add(BACKGROUNDMOMENTYOOOO);
		BACKGROUNDMOMENTYOOOO.alpha = 0.00001;
		add(gfGroup); //Needed for blammed lights
		if (curStage == 'knockout')
			add(gfGroupAgain); //Needed for blammed lights

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		switch (curStage)
		{
			case 'auditorHell':
				add(dadGroupAgain1);
				add(dadGroup);
				add(boyfriendGroup);
				add(boyfriendGroupAgain);
				add(hatSpikes);
				add(cloneOne);
				cloneOne.graphic.dump();
				add(cloneTwo);
				cloneTwo.graphic.dump();
				add(exSpikes);
				add(cover);
				add(converHole);
				add(boyfriend);
			case 'knockout':
				addCharacterToList('lordX', 1);
				addCharacterToList('ski', 1);
				addCharacterToList('gold', 1);
				addCharacterToList('sonic', 1);
				addCharacterToList('p2doll', 1);
				addCharacterToList('TC-attacc', 0);
				circSelever = new FlxSprite(-400, -375).loadGraphic(Paths.image('knockout/shootstuff/one projectile/circ'));
				add(blackSelever);
				add(circSelever);
				blackSelever.alpha = 0;
				circSelever.alpha = 0;
				add(dadGroup);
				add(dadGroupAgain1);
				add(boyfriendGroup);
				add(boyfriendGroupAgain);
				add(dadGroupAgain2);
				
				add(redLaser);
				add(blueLaser);
				redLaser.alpha = 0.00001;
				blueLaser.alpha = 0.00001;

				if (!ClientPrefs.lowQuality)
				{
					rain1 = new BGSprite('knockout/Cup-NewRAINLayer01', -350, -191, 0, 0, ['RainFirstlayer instance 1'], true);
					rain1.scale.set(1.2,1.2);
					add(rain1);
		
					rain2 = new BGSprite('knockout/Cup-NewRainLayer02', -350, -191, 0, 0, ['RainFirstlayer instance 1'], true);
					rain2.scale.set(1.2,1.2);
					add(rain2);
				
					cupheadShid = new BGSprite('knockout/CUpheqdshid', -350, -193, 0, 0, ['Cupheadshit_gif instance 1'], true);
					cupheadShid.scale.set(1.6,1.6);
					add(cupheadShid);
		
					cupheadGrain = new BGSprite('knockout/Grainshit', -350, -193, 0, 0, ['Geain instance 1'], true);
					cupheadGrain.scale.set(1.6,1.6);
					add(cupheadGrain);
				}
					//mugman = new FlxSprite(2000, 1300);
					//mugman.frames = Paths.getSparrowAtlas('knockout/mugman dies');
					//mugman.animation.addByPrefix('walk','Mugman instance 1', 24, false);
					//mugman.animation.addByPrefix('dead','MUGMANDEAD YES instance 1', 24, true);
					superCuphead = new FlxSprite(dad.x + 2500,dad.y - 125);
					superCuphead.frames = Paths.getSparrowAtlas('knockout/shootstuff/super');
					superCuphead.animation.addByPrefix('Burst','BurstFX instance 1', 24, false);
					superCuphead.animation.addByPrefix('Hadolen','Hadolen instance 1', 24, true);
					superCuphead.animation.play('Hadolen');
					superCuphead.blend = ADD;

					tordMissile = new FlxSprite(dad.x - 130,dad.y - 1250);
					tordMissile.frames = Paths.getSparrowAtlas('knockout/shootstuff/tord/DS Rocket Note');
					tordMissile.animation.addByPrefix('shoot','DS Rocket', 24, true);
					tordMissile.animation.play('shoot');
					//BigShotYOffset = -50
					superCircleCuphead = new FlxSprite(dad.x + 2500,dad.y - 125);
					superCircleCuphead.frames = Paths.getSparrowAtlas('knockout/shootstuff/roundabout');
					superCircleCuphead.animation.addByPrefix('spinnnnnn','Roundabout instance 1', 24, true);
					superCircleCuphead.animation.play('spinnnnnn');
					superCircleCuphead.blend = ADD;
					add(superCircleCuphead);
					sunkLoop = new FlxSprite(superCircleCuphead.x,superCircleCuphead.y);
					sunkLoop.loadGraphic(Paths.image('knockout/shootstuff/sunk/loop ' + FlxG.random.int(1,6)));
					add(sunkLoop);
					sunkLoop.visible = false;
					sansBone = new FlxSprite(superCircleCuphead.x,superCircleCuphead.y);
					sansBone.loadGraphic(Paths.image('knockout/shootstuff/one projectile/bone'));
					add(sansBone);
					sansBone.visible = false;


					//BETADCIU
					superCupheadTiky = new FlxSprite(dad.x + 3000,dad.y - 125);
					superCupheadTiky.loadGraphic(Paths.image('knockout/shootstuff/one projectile/tiky'));
					superCupheadTiky.setGraphicSize(Std.int(superCupheadTiky.width * 4), Std.int(superCupheadTiky.height * 4));
			case 'jelly':
				addCharacterToList('spooky-playable', 4);
				addCharacterToList('retrospectre', 1);
				add(dadGroupAgain1);
				add(dadGroup);
				add(dadGroupAgain2);
				add(boyfriendGroup);
				add(boyfriendGroupAgain);
				boyfriendGroupAgain.x -= 250;
				add(bg3);
				bg4 = new FlxSprite(0,0).makeGraphic(Std.int(bg3.width), 800, FlxColor.BLACK);
				bg4.scrollFactor.set(0.9, 0.9);
				bg4.y = bg3.y - bg4.height;
				add(bg4);
				bg5 = new FlxSprite(0,0).makeGraphic(Std.int(bg3.width), Std.int(bg3.height), FlxColor.BLACK);
				bg5.scrollFactor.set(0.9, 0.9);
				bg5.y = bg3.y;
				bg5.x = bg3.x + bg3.width;
				add(bg5);
			default:
				add(dadGroup);
				add(dadGroupAgain1);
				add(boyfriendGroup);
				add(boyfriendGroupAgain);
				
			//Milk
				if (curStage == 'sunkStage')
				{
					boyfriend.visible = false;
					dad.visible = false;
				}
		}
		
		if(curStage == 'spooky') {
			add(halloweenWhite);
		}

		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

		if(curStage == 'philly') {
			phillyCityLightsEvent = new FlxTypedGroup<BGSprite>();
			for (i in 0...5)
			{
				var light:BGSprite = new BGSprite('philly/win' + i, -10, 0, 0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				phillyCityLightsEvent.add(light);
			}
		}


		// "GLOBAL" SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('scripts/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('scripts/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/scripts/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end
		

		// STAGE SCRIPTS
		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'stages/' + curStage + '.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}

		if(doPush) 
			luaArray.push(new FunkinLua(luaFile));
		#end

		if(!modchartSprites.exists('blammedLightsBlack')) { //Creates blammed light black fade in case you didn't make your own
			blammedLightsBlack = new ModchartSprite(FlxG.width * -0.5, FlxG.height * -0.5);
			blammedLightsBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
			var position:Int = members.indexOf(gfGroup);
			if(members.indexOf(boyfriendGroup) < position) {
				position = members.indexOf(boyfriendGroup);
			} else if(members.indexOf(dadGroup) < position) {
				position = members.indexOf(dadGroup);
			}
			insert(position, blammedLightsBlack);

			blammedLightsBlack.wasAdded = true;
			modchartSprites.set('blammedLightsBlack', blammedLightsBlack);
		}
		if(curStage == 'philly') insert(members.indexOf(blammedLightsBlack) + 1, phillyCityLightsEvent);
		blammedLightsBlack = modchartSprites.get('blammedLightsBlack');
		blammedLightsBlack.alpha = 0.0;

		if (curStage == 'jelly')
		{
			{
				ccsongBackSprite.color = FlxColor.fromRGB(247,163,149);
				ccdisplaySongName.color = FlxColor.fromRGB(255, 255, 255);
				if (curStage == 'jelly')
				{
					displaySongName.color = 0xD1149B;
					ccdisplaySongName.color = 0xD1149B;
					RobodisplaySongName.color = 0xD1149B;
				}
				var name:String = 'icons/atrocity/SnowTheFox';
				if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + dad.healthIcon; //Older versions of psych engine's support
				if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
				var file:Dynamic = Paths.image(name);
	
				cciconSongName.loadGraphic(file); //Load stupidly first for getting the file size
				cciconSongName.loadGraphic(file, true, Math.floor(cciconSongName.width / 2), Math.floor(cciconSongName.height)); //Then load it fr
				cciconSongName.offset.x = (cciconSongName.width - 150) / 2;
				cciconSongName.offset.y = (cciconSongName.width - 150) / 2;
				cciconSongName.setGraphicSize(Std.int(cciconSongName.width * 0.8));
				cciconSongName.updateHitbox();
	
				cciconSongName.animation.add('SnowTheFox', [0, 1], 0, false, false);
				cciconSongName.animation.play('SnowTheFox');
	
				cciconSongName.antialiasing = ClientPrefs.globalAntialiasing;
			}
			{
				if (curStage == 'jelly')
				{
					displaySongName.color = 0xD1149B;
					ccdisplaySongName.color = 0xD1149B;
					RobodisplaySongName.color = 0xD1149B;
				}
				var name:String = 'icons/' + dadAgain1.healthIcon;
				if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + dadAgain1.healthIcon; //Older versions of psych engine's support
				if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
				var file:Dynamic = Paths.image(name);
	
				cciconSongNameAgain.loadGraphic(file); //Load stupidly first for getting the file size
				cciconSongNameAgain.loadGraphic(file, true, Math.floor(cciconSongNameAgain.width / 2), Math.floor(cciconSongNameAgain.height)); //Then load it fr
				cciconSongNameAgain.offset.x = (cciconSongNameAgain.width - 150) / 2;
				cciconSongNameAgain.offset.y = (cciconSongNameAgain.width - 150) / 2;
				cciconSongNameAgain.setGraphicSize(Std.int(cciconSongNameAgain.width * 0.8));
				cciconSongNameAgain.updateHitbox();
	
				cciconSongNameAgain.animation.add(dadAgain1.healthIcon, [0, 1], 0, false, false);
				cciconSongNameAgain.animation.play(dadAgain1.healthIcon);
	
				iconSongNameAgain.antialiasing = ClientPrefs.globalAntialiasing;
			}
			{
				RobosongBackSprite.color = FlxColor.fromRGB(78,225,198);
				RobodisplaySongName.color = FlxColor.fromRGB(255, 255, 255);
				if (curStage == 'jelly')
				{
					displaySongName.color = 0xD1149B;
					ccdisplaySongName.color = 0xD1149B;
					RobodisplaySongName.color = 0xD1149B;
				}
				var name:String = 'icons/RoboVerse/robo-gf';
				if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + dad.healthIcon; //Older versions of psych engine's support
				if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
				var file:Dynamic = Paths.image(name);
	
				RoboiconSongName.loadGraphic(file); //Load stupidly first for getting the file size
				RoboiconSongName.loadGraphic(file, true, Math.floor(RoboiconSongName.width / 2), Math.floor(RoboiconSongName.height)); //Then load it fr
				RoboiconSongName.offset.x = (RoboiconSongName.width - 150) / 2;
				RoboiconSongName.offset.y = (RoboiconSongName.width - 150) / 2;
				RoboiconSongName.setGraphicSize(Std.int(RoboiconSongName.width * 0.8));
				RoboiconSongName.updateHitbox();
	
				RoboiconSongName.animation.add('robo-gf', [0, 1], 0, false, false);
				RoboiconSongName.animation.play('robo-gf');
	
				RoboiconSongName.antialiasing = ClientPrefs.globalAntialiasing;
			}
			{
				if (curStage == 'jelly')
				{
					displaySongName.color = 0xD1149B;
					ccdisplaySongName.color = 0xD1149B;
					RobodisplaySongName.color = 0xD1149B;
				}
				var name:String = 'icons/' + dadAgain1.healthIcon;
				if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + dadAgain1.healthIcon; //Older versions of psych engine's support
				if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
				var file:Dynamic = Paths.image(name);
	
				cciconSongNameAgain.loadGraphic(file); //Load stupidly first for getting the file size
				cciconSongNameAgain.loadGraphic(file, true, Math.floor(cciconSongNameAgain.width / 2), Math.floor(cciconSongNameAgain.height)); //Then load it fr
				cciconSongNameAgain.offset.x = (cciconSongNameAgain.width - 150) / 2;
				cciconSongNameAgain.offset.y = (cciconSongNameAgain.width - 150) / 2;
				cciconSongNameAgain.setGraphicSize(Std.int(cciconSongNameAgain.width * 0.8));
				cciconSongNameAgain.updateHitbox();
	
				cciconSongNameAgain.animation.add(dadAgain1.healthIcon, [0, 1], 0, false, false);
				cciconSongNameAgain.animation.play(dadAgain1.healthIcon);
	
				iconSongNameAgain.antialiasing = ClientPrefs.globalAntialiasing;
			}
		}		
		{
			songBackSprite.color = FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]);
			displaySongName.color = FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]);
			if (curStage == 'jelly')
			{
				displaySongName.color = 0xD1149B;
				ccdisplaySongName.color = 0xD1149B;
				RobodisplaySongName.color = 0xD1149B;
			}
			var name:String = 'icons/' + dad.healthIcon;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + dad.healthIcon; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			iconSongName.loadGraphic(file); //Load stupidly first for getting the file size
			iconSongName.loadGraphic(file, true, Math.floor(iconSongName.width / 2), Math.floor(iconSongName.height)); //Then load it fr
			iconSongName.offset.x = (iconSongName.width - 150) / 2;
			iconSongName.offset.y = (iconSongName.width - 150) / 2;
			iconSongName.setGraphicSize(Std.int(iconSongName.width * 0.8));
			iconSongName.updateHitbox();

			iconSongName.animation.add(dad.healthIcon, [0, 1], 0, false, false);
			iconSongName.animation.play(dad.healthIcon);

			iconSongName.antialiasing = ClientPrefs.globalAntialiasing;
		}
		{
			songBackSprite.color = FlxColor.fromRGB(dadAgain1.healthColorArray[0], dadAgain1.healthColorArray[1], dadAgain1.healthColorArray[2]);
			displaySongName.color = FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]);
			if (curStage == 'jelly')
			{
				displaySongName.color = 0xD1149B;
				ccdisplaySongName.color = 0xD1149B;
				RobodisplaySongName.color = 0xD1149B;
			}
			var name:String = 'icons/' + dadAgain1.healthIcon;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + dadAgain1.healthIcon; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			iconSongNameAgain.loadGraphic(file); //Load stupidly first for getting the file size
			iconSongNameAgain.loadGraphic(file, true, Math.floor(iconSongNameAgain.width / 2), Math.floor(iconSongNameAgain.height)); //Then load it fr
			iconSongNameAgain.offset.x = (iconSongNameAgain.width - 150) / 2;
			iconSongNameAgain.offset.y = (iconSongNameAgain.width - 150) / 2;
			iconSongNameAgain.setGraphicSize(Std.int(iconSongNameAgain.width * 0.8));
			iconSongNameAgain.updateHitbox();

			iconSongNameAgain.animation.add(dadAgain1.healthIcon, [0, 1], 0, false, false);
			iconSongNameAgain.animation.play(dadAgain1.healthIcon);

			iconSongNameAgain.antialiasing = ClientPrefs.globalAntialiasing;
		}
		iconSongNameAgain.visible = false;
		cciconSongNameAgain.visible = false;
		RoboiconSongNameAgain.visible = false;
		
		var camPos:FlxPoint = new FlxPoint(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
		if(gf != null)
		{
			camPos.x += gf.getGraphicMidpoint().x + gf.cameraPosition[0];
			camPos.y += gf.getGraphicMidpoint().y + gf.cameraPosition[1];
		}

		if(dad.curCharacter.startsWith('gf')) {
			dad.setPosition(GF_X, GF_Y);
			if(gf != null)
				gf.visible = false;
		}

		switch(curStage)
		{
			case 'limo':
				resetFastCar();
				insert(members.indexOf(gfGroup) - 1, fastCar);
			
			case 'schoolEvil':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069); //nice
				insert(members.indexOf(dadGroup) - 1, evilTrail);
		}

		var file:String = Paths.json(songName + '/dialogue'); //Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file)) {
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
		}

		var file:String = Paths.txt(songName + '/' + songName + 'Dialogue'); //Checks for vanilla/Senpai dialogue
		if (OpenFlAssets.exists(file)) {
			dialogue = CoolUtil.coolTextFile(file);
		}
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = startNextDialogue;
		doof.skipDialogueThing = skipDialogue;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();
		var thefontj = Paths.font("vcr.ttf");
		if (curStage == 'knockout')
			thefontj = Paths.font("CupheadICFont.ttf");

		var showTime:Bool = (ClientPrefs.timeBarType != 'Disabled');
		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(thefontj, 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = showTime;
		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 44;

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.text = SONG.song;
		}
		updateTime = showTime;

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = showTime;
		timeBarBG.color = FlxColor.BLACK;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;
		add(timeBarBG);

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		timeBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
		timeBar.alpha = 0;
		timeBar.visible = showTime;
		add(timeBar);
		add(timeTxt);
		timeBarBG.sprTracker = timeBar;

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.size = 24;
			timeTxt.y += 3;
		}

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();

		// startCountdown();

		generateSong(SONG.song);
		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys())
		{
			var luaToLoad:String = Paths.modFolders('custom_notetypes/' + notetype + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
		}
		for (event in eventPushedMap.keys())
		{
			var luaToLoad:String = Paths.modFolders('custom_events/' + event + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_events/' + event + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
		}
		#end
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		// After all characters being loaded, it makes then invisible 0.01s later so that the player won't freeze when you change characters
		// add(strumLine);

		camFollow = new FlxPoint();
		camFollow2 = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		moveCameraSection(0);

		if (curStage == 'knockout')
		{
			warning = new FlxSprite(500,340);
			add(warning);
		}
		healthBarBG = new AttachedSprite('healthBar');
		healthBarBG.y = FlxG.height * 0.89;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = !ClientPrefs.hideHud;
		healthBarBG.xAdd = -4;
		healthBarBG.yAdd = -4;
		add(healthBarBG);
		if(ClientPrefs.downScroll) healthBarBG.y = 0.11 * FlxG.height;

		if (!FlxG.save.data.equipped.contains('extra health'))
		{
			healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
				'health', 0, maxHealth);
		}
		else
		{
			maxHealth = 3;
			health = 1.5;
			healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width * 1.5 - 12), Std.int(healthBarBG.height - 8), this,
				'health', 0, maxHealth);
			healthBarBG.scale.set(1.5, 1);
			healthBarBG.updateHitbox();
		}
		healthBar.scrollFactor.set();
		healthBar.screenCenter(X);
		healthBarBG.screenCenter(X);
		// healthBar
		healthBar.visible = !ClientPrefs.hideHud;
		healthBar.alpha = ClientPrefs.healthBarAlpha;
		add(healthBar);
		if (curStage == 'knockout')
			add(healthBarBG);
		healthBarBG.sprTracker = healthBar;
		healthBarBGKnock = new AttachedSprite('knockout/cuphealthbar');
		if (curStage == 'knockout')
		{
			healthBarBGKnock.y = FlxG.height * 0.89;
			healthBarBGKnock.screenCenter(X);
			healthBarBGKnock.scrollFactor.set();
			healthBarBGKnock.visible = !ClientPrefs.hideHud;
			healthBarBGKnock.xAdd = -14;
			healthBarBGKnock.yAdd = -21;
			add(healthBarBGKnock);
			healthBarBGKnock.sprTracker = healthBar;
			if (FlxG.save.data.equipped.contains('extra health'))
				healthBarBGKnock.scale.set(1.5,1);
			healthBarBGKnock.updateHitbox();
			healthBarBGKnock.screenCenter(X);
		}

		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - 75;
		iconP1.visible = !ClientPrefs.hideHud;
		iconP1.alpha = ClientPrefs.healthBarAlpha;
		add(iconP1);
		iconP1Again = new HealthIcon(boyfriend.healthIcon, true);
		iconP1Again.y = healthBar.y - 75;
		iconP1Again.visible = !ClientPrefs.hideHud;
		iconP1Again.alpha = ClientPrefs.healthBarAlpha;
		add(iconP1Again);
		iconP1Again.visible = false;


		iconP2 = new HealthIcon(dad.healthIcon, false);
		iconP2.y = healthBar.y - 75;
		iconP2.visible = !ClientPrefs.hideHud;
		iconP2.alpha = ClientPrefs.healthBarAlpha;
		add(iconP2);
		iconP2Again1 = new HealthIcon(dadAgain1.healthIcon, false);
		iconP2Again1.y = healthBar.y - 75;
		iconP2Again1.visible = !ClientPrefs.hideHud;
		iconP2Again1.alpha = ClientPrefs.healthBarAlpha;
		add(iconP2Again1);
		iconP2Again1.visible = false;
		iconP2Again2 = new HealthIcon(dadAgain2.healthIcon, false);
		iconP2Again2.y = healthBar.y - 75;
		iconP2Again2.visible = !ClientPrefs.hideHud;
		iconP2Again2.alpha = ClientPrefs.healthBarAlpha;
		add(iconP2Again2);
		iconP2Again2.visible = false;
		reloadHealthBarColors();
		
		dumbasstext = new FlxText(0, 0, 0, "Yo I love this", 40);
		dumbasstext.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		dumbasstext.alignment = "center";
		dumbasstext2 = new FlxText(-1600, 1000, 0, "THANKS THE86THPLAYER FOR FIXING THE COVER BEING OFFKEY", 160);
		dumbasstext2.setFormat(Paths.font("vcr.ttf"), 160, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		dumbasstext2.alignment = "center";
		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(thefontj, 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		add(scoreTxt);
		add(dumbasstext);
		if (curStage == 'auditorHell')
			add(dumbasstext2);

		botplayTxt = new FlxText(400, timeBarBG.y + 55, FlxG.width - 800, "BOTPLAY", 32);
		botplayTxt.setFormat(thefontj, 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.25;
		botplayTxt.visible = cpuControlled;
		add(botplayTxt);
		if(ClientPrefs.downScroll) {
			botplayTxt.y = timeBarBG.y - 78;
		}

		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		healthBarBGKnock.cameras = [camHUD];
		superCard.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP1Again.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		iconP2Again1.cameras = [camHUD];
		iconP2Again2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		botplayTxt.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		startCircle.cameras = [camHUD];
		blackFuck.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		// SONG SPECIFIC SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('data/' + Paths.formatToSongPath(SONG.song) + '/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('data/' + Paths.formatToSongPath(SONG.song) + '/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/data/' + Paths.formatToSongPath(SONG.song) + '/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end
		boyfriendAgain.visible = false;
		dadAgain1.visible = false;
		dadAgain2.visible = false;
		boyfriendBETADCIU.visible = false;
		dadBETADCIU.visible = false;
		switch (curStage)
		{
			case 'auditorHell':
				//boyfriend.y -= 380;
				//boyfriend.x += 500;
				//gf.y -= 700;
				//gf.x -= 300;
				lol86.x = gf.x - 80;
				lol86.y = gf.y - 385;
				add(tstatic);
				dadAgain1.visible = true;
				iconP2Again1.visible = true;
				iconSongNameAgain.visible = true;
				iconDistance = 100;
			case 'garAlley':
				iconDistance = 100;
				boyfriendBETADCIU.x = boyfriend.x;
				boyfriendBETADCIU.y = boyfriend.y;
				//dadAgain1.x = dad.x + 100;
				dadBETADCIU.x = dad.x;
				dadBETADCIU.y = dad.y;
				add(boyfriendBETADCIU);
				add(dadBETADCIU);
				boyfriend.alpha = 0.00001;
				dad.alpha = 0.00001;
				betadciuMoment = true;
				boyfriendBETADCIU.visible = true;
				dadBETADCIU.visible = true;
			case 'knockout':
				iconDistance = 100;
				boyfriendBETADCIU.x = boyfriend.x;
				boyfriendBETADCIU.y = boyfriend.y;
				//dadAgain1.x = dad.x + 100;
				dadBETADCIU.x = dad.x;
				dadBETADCIU.y = dad.y;
				insert(this.members.indexOf(rain1) -1 , boyfriendBETADCIU);
				insert(this.members.indexOf(boyfriendBETADCIU) -1 , dadBETADCIU);
				add(superCuphead);
				insert(this.members.indexOf(dadGroup) + 1, tordMissile);
				add(superCupheadTiky);
				boyfriend.alpha = 0;
				dad.alpha = 0;
				betadciuMoment = true;
				boyfriendBETADCIU.visible = true;
				dadBETADCIU.visible = true;
			case 'curse':
				boyfriendBETADCIU.x = boyfriend.x;
				boyfriendBETADCIU.y = boyfriend.y;
				//dadAgain1.x = dad.x + 100;
				dadBETADCIU.x = dad.x;
				dadBETADCIU.y = dad.y;
				add(boyfriendBETADCIU);
				add(dadBETADCIU);
				boyfriend.alpha = 0;
				dad.alpha = 0;
				betadciuMoment = true;
				boyfriendBETADCIU.visible = true;
				dadBETADCIU.visible = true;
		}
		
		var daSong:String = Paths.formatToSongPath(curSong);
		if (isStoryMode && !seenCutscene)
		{
			switch (daSong)
			{
				case "monster":
					var whiteScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
					add(whiteScreen);
					whiteScreen.scrollFactor.set();
					whiteScreen.blend = ADD;
					camHUD.visible = false;
					snapCamFollowToPos(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					inCutscene = true;

					FlxTween.tween(whiteScreen, {alpha: 0}, 1, {
						startDelay: 0.1,
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							camHUD.visible = true;
							remove(whiteScreen);
							startCountdown();
						}
					});
					FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
					if(gf != null) gf.playAnim('scared', true);
					boyfriend.playAnim('scared', true);

				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;
					inCutscene = true;

					FlxTween.tween(blackScreen, {alpha: 0}, 0.7, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween) {
							remove(blackScreen);
						}
					});
					FlxG.sound.play(Paths.sound('Lights_Turn_On'));
					snapCamFollowToPos(400, -2050);
					FlxG.camera.focusOn(camFollow);
					FlxG.camera.zoom = 1.5;

					new FlxTimer().start(0.8, function(tmr:FlxTimer)
					{
						camHUD.visible = true;
						remove(blackScreen);
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
							ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								startCountdown();
							}
						});
					});
				case 'senpai' | 'roses' | 'thorns':
					if(daSong == 'roses') FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);

				default:
					startCountdown();
			}
			seenCutscene = true;
		}
		else
		{
			startCountdown();
		}
		RecalculateRating();

		//PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND FUCK THEM UP IDK HOW HAXE WORKS
		if(ClientPrefs.hitsoundVolume > 0) CoolUtil.precacheSound('hitsound');
		CoolUtil.precacheSound('missnote1');
		CoolUtil.precacheSound('missnote2');
		CoolUtil.precacheSound('missnote3');
		CoolUtil.precacheSound('OUCH');
		CoolUtil.precacheSound('sfk shiz');
		CoolUtil.precacheSound('sfk shiz 2');
		if (curStage == 'knockout')
		{
			CoolUtil.precacheSound('knockout/shootfunni/parry');
			CoolUtil.precacheSound('knockout/shootfunni/ankhahurt');
			CoolUtil.precacheSound('knockout/shootfunni/Powyouaredead');
			CoolUtil.precacheSound('knockout/shootfunni/byebye');
			CoolUtil.precacheSound('knockout/shootfunni/tc');
			CoolUtil.precacheSound('knockout/shootfunni/tord ready');
			CoolUtil.precacheSound('knockout/shootfunni/tord bang your mom');
			CoolUtil.precacheSound('knockout/dodge');
			CoolUtil.precacheSound('knockout/knockout');
			CoolUtil.precacheSound('knockout/Pre_shoot');
		}
		if (curStage == 'jelly')
			CoolUtil.precacheSound('atrocity/bam');


		if (PauseSubState.songName != null) {
			CoolUtil.precacheMusic(PauseSubState.songName);
		} else if(ClientPrefs.pauseMusic != 'None') {
			CoolUtil.precacheMusic(Paths.formatToSongPath(ClientPrefs.pauseMusic));
		}

		#if desktop
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		#end

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}

		Conductor.safeZoneOffset = (ClientPrefs.safeFrames / 60) * 1000;
		callOnLuas('onCreatePost', []);
		
		super.create();
		

		Paths.clearUnusedMemory();
		CustomFadeTransition.nextCamera = camOther;
		loadAudioBuffer();

		if (dialogueEditing)
		{
			var randomTextThing = ['hi', 'nooo', 'sans serif', 'sans', 'Subscribe to the best FNF youtuber ever,\nRobotic Press', 'drowning drowning sinking sinking', 'My pants have exploded in the dishwasher.', '"in the notepad"'];
			var theRandom = randomTextThing[FlxG.random.int(0, randomTextThing.length-1)];
			textBox = new TextBox(0, 500, 125, FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]), 0.2, theRandom, dad.healthIcon);

			var theEvent:TextBoxEvent = {
				index: 40,
				event: 'Wave On',
				value1: '5',
				value2: '5',
				value3: ''
			};
			if (theRandom == 'Subscribe to the best FNF youtuber ever,\nRobotic Press')
				textBox.events.push(theEvent);
			add(textBox);
			textBox.cameras = [camHUD];
			textBox.appear();
			camHUD.zoom = 1;
			FlxG.mouse.visible = true;
			var tabs = [
				//{name: 'Offsets', label: 'Offsets'},
				{name: 'Add Event', label: 'Add Event'},
				{name: 'Events', label: 'Events'},
				{name: 'DialogueNot', label: 'DialogueNot'},
			];
			Dialogue_box = new FlxUITabMenu(null, tabs, true);

			Dialogue_box.cameras = [camHUD];
	
			Dialogue_box.resize(1200, 120);
			Dialogue_box.x = 0;
			Dialogue_box.y = 25;
			Dialogue_box.scrollFactor.set();

			var tab_group = new FlxUI(null, Dialogue_box);

			var saveDialogueButton:FlxButton = new FlxButton(1000, 5, "Save ig", function()
			{
				saveDialogue();
			});
			var loadDialogueButton:FlxButton = new FlxButton(1100, 5, "Load ig", function()
			{
				var songName:String = Paths.formatToSongPath(SONG.song);
				var file:String = Paths.json(songName + '/DialogueThing');
				#if sys
				if (#if MODS_ALLOWED FileSystem.exists(Paths.modsJson(songName + '/DialogueThing')) || #end FileSystem.exists(file))
				#else
				if (OpenFlAssets.exists(file))
				#end
				{
					//clearEvents();
					var events = parseDialogue(file);
					roboticDialogues = events.dialogues.copy();
				}
			});

			var addLine:FlxButton = new FlxButton(200, 5, "Add Line", function()
			{
				var theLine:DialogueLine = {
					characterName: characterInputText.text,
					line: textBox.typeThis,
					events: textBox.events.copy()
				};
				roboticDialogues.push(theLine);
				for (thedialogue in roboticDialogues)
					trace(thedialogue.events);
			});


			pageStepperLine = new FlxUINumericStepper(400, 10, 1, 0, 0, 999, 0);
			lineStepper = new FlxUINumericStepper(pageStepperLine.x + 120, 10, 1, 0, 0, 999, 0);
			pageStepperSwitchLine1 = new FlxUINumericStepper(pageStepperLine.x + 390, 10, 1, 0, 0, 999, 0);
			pageStepperSwitchLine2 = new FlxUINumericStepper(pageStepperLine.x + 460, 10, 1, 0, 0, 999, 0);
			
			var textSize:Int = 16;

			line1 = new FlxText(0, 0, 0, '', textSize);
			line1.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			line1.alignment = "center";

			tab_group.add(line1);

			line2 = new FlxText(0, 0, 0, '', textSize);
			line2.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			line2.alignment = "center";

			tab_group.add(line2);

			line3 = new FlxText(0, 0, 0, '', textSize);
			line3.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			line3.alignment = "center";

			tab_group.add(line3);
	
			var deleteLine:FlxButton = new FlxButton(pageStepperLine.x + 210, pageStepperLine.y - 5, "Delete Line", function()
			{
				if (lineStepper.value >= roboticDialogues.length)
					return;
				roboticDialogues.splice(Std.int(lineStepper.value), 1);
			});
			var reloadPageLine:FlxButton = new FlxButton(pageStepperLine.x + 300, pageStepperLine.y - 5, "Reload Page", function()
			{
				var eventTextArray = [line1, line2, line3];
				for (eventText in eventTextArray)
				{
					eventText.text = '';
				}
				thePageNumberLine.text = 'Page Number: ' + pageStepperLine.value;
				var i:Int = Std.int(0 + 3 * pageStepperLine.value);
				while (i < roboticDialogues.length)
				{
					if (i > 2 + 3 * pageStepperLine.value)
						break;

					var event = roboticDialogues[i];

					var theText:FlxText = line1;
					switch (i%3)
					{
						case 0:
							theText = line1;
						case 1:
							theText = line2;
						case 2:
							theText = line3;
					}
					
					theText.text = (i) + '."' + roboticDialogues[i].line + '" with ' + roboticDialogues[i].events.length + ' events.';
					i++;
				}
			});
			var switchLines:FlxButton = new FlxButton(pageStepperLine.x + 520, pageStepperLine.y - 5, "Switch Lines", function()
			{
				if (pageStepperSwitchLine1.value >= roboticDialogues.length)
					return;
				if (pageStepperSwitchLine2.value >= roboticDialogues.length)
					return;
				var dialoguething = roboticDialogues[Std.int(pageStepperSwitchLine1.value)];
				roboticDialogues[Std.int(pageStepperSwitchLine1.value)] = roboticDialogues[Std.int(pageStepperSwitchLine2.value)];
				roboticDialogues[Std.int(pageStepperSwitchLine2.value)] = dialoguething;
			});
			line1.x = 0;
			line1.y = 20;
			line2.x = 0;
			line2.y = 40;
			line3.x = 0;
			line3.y = 60;

			thePageNumberLine = new FlxText(0, 0, 0, 'Page Number: load a page', 24);
			thePageNumberLine.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			thePageNumberLine.alignment = "center";

			tab_group.name = "DialogueNot";
			tab_group.add(pageStepperLine);
			tab_group.add(new FlxText(pageStepperLine.x - 75, pageStepperLine.y, 0, 'Page Number:'));
			tab_group.add(lineStepper);
			tab_group.add(new FlxText(pageStepperLine.x + 80, pageStepperLine.y, 0, 'Event:'));
			tab_group.add(reloadPageLine);
			tab_group.add(deleteLine);
			tab_group.add(switchLines);
			tab_group.add(pageStepperSwitchLine1);
			tab_group.add(pageStepperSwitchLine2);

			tab_group.add(thePageNumberLine);
			tab_group.add(saveDialogueButton);
			tab_group.add(loadDialogueButton);
			tab_group.add(addLine);
			Dialogue_box.addGroup(tab_group);



			var tab_groupAddEvent = new FlxUI(null, Dialogue_box);


			senteneceInputText = new FlxUIInputText(15, 45, 800, 'PRESS A LITTLE BELOW FOR FOCUS', 8);
			senteneceInputText.updateHitbox();
			senteneceInputText.scrollFactor.set();
			characterInputText = new FlxUIInputText(15, 85, 800, 'robo', 8);
			characterInputText.updateHitbox();
			characterInputText.scrollFactor.set();
			valueInputText1 = new FlxUIInputText(1000, 25, 100, 'value1', 8);
			valueInputText1.updateHitbox();
			valueInputText1.scrollFactor.set();
			valueInputText2 = new FlxUIInputText(valueInputText1.x, 50, 100, 'value2', 8);
			valueInputText2.updateHitbox();
			valueInputText2.scrollFactor.set();
			valueInputText3 = new FlxUIInputText(valueInputText1.x, 75, 100, 'value3', 8);
			valueInputText3.updateHitbox();
			valueInputText3.scrollFactor.set();

			indexStepper = new FlxUINumericStepper(500, 10, 1, 0, 0, 999, 0);
			var effectArray:Array<String> = ['Wave On', 'Wave Off', 'Shake On', 'Shake Off', 'Camera Follow', 'Box Color', 'Text Color', 'Camera Skake', 'Change Box Size', 'Change Letter Size', 'Change Character Animation', 'Set if Character singing', 'Change Icon', 'Change Sound', 'Change Font', 'Skip', 'Do Hardcoded Event'];

			effectDropDown = new FlxUIDropDownMenuCustom(indexStepper.x + 120, indexStepper.y - 5, FlxUIDropDownMenuCustom.makeStrIdLabelArray(effectArray, true), function(effect:String)
			{
				theEffect = effectArray[Std.parseInt(effect)];
			});
			effectDropDown.selectedLabel = 'Wave On';

			var addEffect:FlxButton = new FlxButton(indexStepper.x + 240, indexStepper.y - 5, "Add Event", function()
			{
				trace(Std.int(indexStepper.value));
				trace((effectDropDown.selectedLabel));
				var theEvent:TextBoxEvent = {
					index: Std.int(indexStepper.value),
					event: effectDropDown.selectedLabel,
					value1: valueInputText1.text,
					value2: valueInputText2.text,
					value3: valueInputText3.text,
				};
				textBox.events.push(theEvent);
			});
			var quickAddEffect:FlxButton = new FlxButton(indexStepper.x + 330, indexStepper.y - 5, "Quick Character Switch Events", function()
			{
				var extraValue1 = '';
				var extraValue2 = '';
				var extraValue3 = '';
				switch (valueInputText1.text.toLowerCase())
				{
					case 'dad':
						extraValue1 = 'dad';
						extraValue2 = 'bf';
						extraValue3 = 'gf';
					case 'gf':
						extraValue1 = 'gf';
						extraValue2 = 'bf';
						extraValue3 = 'dad';
					default:
						extraValue1 = 'bf';
						extraValue2 = 'gf';
						extraValue3 = 'dad';
				}
				var theEvent:TextBoxEvent = {
					index: Std.int(indexStepper.value),
					event: 'Set if Character singing',
					value1: extraValue1,
					value2: 'true',
					value3: valueInputText3.text,
				};
				textBox.events.push(theEvent);
				var theEvent:TextBoxEvent = {
					index: Std.int(indexStepper.value),
					event: 'Set if Character singing',
					value1: extraValue2,
					value2: 'false',
					value3: valueInputText3.text,
				};
				textBox.events.push(theEvent);
				var theEvent:TextBoxEvent = {
					index: Std.int(indexStepper.value),
					event: 'Set if Character singing',
					value1: extraValue3,
					value2: 'false',
					value3: valueInputText3.text,
				};
				textBox.events.push(theEvent);
				var theEvent:TextBoxEvent = {
					index: Std.int(indexStepper.value),
					event: 'Camera Follow',
					value1: extraValue1,
					value2: valueInputText2.text,
					value3: valueInputText3.text,
				};
				textBox.events.push(theEvent);
				var theEvent:TextBoxEvent = {
					index: Std.int(indexStepper.value),
					event: 'Change Sound',
					value1: 'characters/' + characterInputText.text,
					value2: valueInputText2.text,
					value3: valueInputText3.text,
				};
				textBox.events.push(theEvent);
			});
			var addLine:FlxButton = new FlxButton(indexStepper.x + 240, indexStepper.y + 15, "Add Line", function()
			{
				senteneceInputText.text = senteneceInputText.text + '\\n';
			});
			//blockPressWhileScrolling.push(effectDropDown);
			
			tab_groupAddEvent.name = "Add Event";
			tab_groupAddEvent.add(new FlxText(15, senteneceInputText.y - 18, 0, 'Dialogue text:'));
			tab_groupAddEvent.add(senteneceInputText);
			tab_groupAddEvent.add(new FlxText(15, characterInputText.y - 18, 0, 'Character text:'));
			tab_groupAddEvent.add(characterInputText);
			tab_groupAddEvent.add(new FlxText(valueInputText1.x - 80, valueInputText1.y, 0, 'Value 1:'));
			tab_groupAddEvent.add(valueInputText1);
			tab_groupAddEvent.add(new FlxText(valueInputText2.x - 80, valueInputText2.y, 0, 'Value 2:'));
			tab_groupAddEvent.add(valueInputText2);
			tab_groupAddEvent.add(new FlxText(valueInputText3.x - 80, valueInputText3.y, 0, 'Value 3:'));
			tab_groupAddEvent.add(valueInputText3);
			tab_groupAddEvent.add(new FlxText(indexStepper.x - 70, indexStepper.y, 0, 'Event Index'));
			tab_groupAddEvent.add(indexStepper);
			tab_groupAddEvent.add(new FlxText(indexStepper.x + 80, indexStepper.y, 0, 'Event:'));
			tab_groupAddEvent.add(effectDropDown);
			tab_groupAddEvent.add(addEffect);
			tab_groupAddEvent.add(quickAddEffect);
			tab_groupAddEvent.add(addLine);

			theIndexText = new FlxText(0, 0, 0, 'Current Index: ' + (senteneceInputText.text.length), 24);
			theIndexText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			theIndexText.alignment = "center";
			tab_groupAddEvent.add(theIndexText);
			theOptionsText = new FlxText(0, 300, 0, 'The Options Text: value1 is wave Intensity, value2 is wave Distance', 12);
			theOptionsText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			theOptionsText.alignment = "center";
			tab_groupAddEvent.add(theOptionsText);

	
			Dialogue_box.addGroup(tab_groupAddEvent);




			var tab_groupEvents = new FlxUI(null, Dialogue_box);
			tab_groupEvents.name = "Events";

			pageStepper = new FlxUINumericStepper(500, 10, 1, 0, 0, 999, 0);
			eventStepper = new FlxUINumericStepper(pageStepper.x + 120, 10, 1, 0, 0, 999, 0);

			var deleteEvent:FlxButton = new FlxButton(pageStepper.x + 210, pageStepper.y - 5, "Delete Event", function()
			{
				if (eventStepper.value >= textBox.events.length)
					return;
				//textBox.events[Std.int(eventStepper.value)].destroy();
				//var l = 0;//because I took the L
				//var newVariable = [];
				//while (l < textBox.events.length)
				//{
				//	if (l != Std.int(eventStepper.value))
				//		newVariable.push(textBox.events[l]);
				//	l++;
				//}
				//textBox.events = newVariable;
				//textBox.events[Std.int(eventStepper.value)].destroy;
				textBox.events.splice(Std.int(eventStepper.value), 1);
				//textBox.events[Std.int(eventStepper.value)].kill();
			});
			//var texts:Array<FlxText> = [];

			event1 = new FlxText(0, 0, 0, '', textSize);
			event1.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			event1.alignment = "center";

			tab_groupEvents.add(event1);

			event2 = new FlxText(0, 0, 0, '', textSize);
			event2.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			event2.alignment = "center";

			tab_groupEvents.add(event2);

			event3 = new FlxText(0, 0, 0, '', textSize);
			event3.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			event3.alignment = "center";

			tab_groupEvents.add(event3);

			event4 = new FlxText(0, 0, 0, '', textSize);
			event4.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			event4.alignment = "center";

			tab_groupEvents.add(event4);

			event5 = new FlxText(0, 0, 0, '', textSize);
			event5.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			event5.alignment = "center";

			tab_groupEvents.add(event5);

			event6 = new FlxText(0, 0, 0, '', textSize);
			event6.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			event6.alignment = "center";

			tab_groupEvents.add(event6);

			event7 = new FlxText(0, 0, 0, '', textSize);
			event7.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			event7.alignment = "center";

			tab_groupEvents.add(event7);

			event8 = new FlxText(0, 0, 0, '', textSize);
			event8.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			event8.alignment = "center";

			tab_groupEvents.add(event8);

			event9 = new FlxText(0, 0, 0, '', textSize);
			event9.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			event9.alignment = "center";

			tab_groupEvents.add(event9);
			var eventTextArray = [event1, event2, event3, event4, event5, event6, event7, event8, event9];
			for (eventText in eventTextArray)
			{
				eventText.text = '';
			}
			var textK = new FlxText(200, 0, 0, 'THE EVENTS:', 14);
			tab_groupEvents.add(textK);
			var reloadPage:FlxButton = new FlxButton(pageStepper.x + 300, pageStepper.y - 5, "Reload Page", function()
			{
				var eventTextArray = [event1, event2, event3, event4, event5, event6, event7, event8, event9];
				for (eventText in eventTextArray)
				{
					eventText.text = '';
				}
				thePageNumber.text = 'Page Number: ' + pageStepper.value;
				var i:Int = Std.int(0 + 9 * pageStepper.value);
				//for (text in texts)
				//{
				//	text.destroy();
				//	texts = [];
				//}
				//texts.push(textK);
				while (i < textBox.events.length)
				{
					var theX = 0;
					if (i > 2 + 9 * pageStepper.value && i < 6 + 9 * pageStepper.value)
						theX = 1;
					else if (i > 5 + 9 * pageStepper.value)
						theX = 2;
					if (i > 8 + 9 * pageStepper.value)
						break;

					var event = textBox.events[i];
					//var textJ = new FlxText(0 + 400 * theX, 30 + (i%3) * 20, 0, (i) + '.' + event.event + ' at index ' + event.index, 14);
					//tab_groupEvents.add(textJ);
					//texts.push(textJ);
					//trace(i + '. ${textJ.x},${textJ.y}');

					var theText:FlxText = event1;
					switch (i%9)
					{
						case 0:
							theText = event1;
						case 1:
							theText = event2;
						case 2:
							theText = event3;
						case 3:
							theText = event4;
						case 4:
							theText = event5;
						case 5:
							theText = event6;
						case 6:
							theText = event7;
						case 7:
							theText = event8;
						case 8:
							theText = event9;
					}
					
					theText.text = (i) + '.' + event.event + ' at index ' + event.index;
					i++;
				}
			});
	
			tab_groupEvents.name = "Events";
			tab_groupEvents.add(new FlxText(pageStepper.x - 75, pageStepper.y, 0, 'Page Number:'));
			tab_groupEvents.add(pageStepper);
			tab_groupEvents.add(eventStepper);
			tab_groupEvents.add(new FlxText(pageStepper.x + 80, pageStepper.y, 0, 'Event:'));
			tab_groupEvents.add(reloadPage);
			tab_groupEvents.add(deleteEvent);
			event1.x = 0;
			event1.y = 20;
			event2.x = 0;
			event2.y = 40;
			event3.x = 0;
			event3.y = 60;
			event4.x = 400;
			event4.y = 20;
			event5.x = 400;
			event5.y = 40;
			event6.x = 400;
			event6.y = 60;
			event7.x = 800;
			event7.y = 20;
			event8.x = 800;
			event8.y = 40;
			event9.x = 800;
			event9.y = 60;
			thePageNumber = new FlxText(0, 0, 0, 'Page Number: load a page', 24);
			thePageNumber.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			thePageNumber.alignment = "center";

			tab_groupEvents.add(thePageNumber);
	
			Dialogue_box.addGroup(tab_groupEvents);

			add(Dialogue_box);
		}
		originFunni = new FlxSprite(-4000, -4000).makeGraphic(20, 20, FlxColor.RED);
		superHitBox = new FlxSprite(-4000, -4000).makeGraphic(20, 20, FlxColor.RED);
		superCircleHitBox = new FlxSprite(-4000, -4000).makeGraphic(20, 20, FlxColor.RED);
		bfHitBox = new FlxSprite(-4000, -4000).makeGraphic(20, 20, FlxColor.RED);
		taeyaiConsole = new FlxSprite(0, 0).makeGraphic(600, 300, FlxColor.BLACK);
		//blasterRect = new FlxSprite(1800, 300);
		//blasterRect.frames = Paths.getSparrowAtlas('knockout/shootstuff/one projectile/Gaster_blasterss');
		//blasterRect.animation.addByPrefix('shoot','fefe instance ', 24, true);
		JUSTMONIKA = new FlxSprite(0, camHUD.height + 200).loadGraphic(Paths.image('knockout/shootstuff/one projectile/the funki monika'));
		
		add(superHitBox);
		add(superCircleHitBox);
		add(bfHitBox);
		add(taeyaiConsole);
		//add(blasterRect);
		taeyaiConsole.cameras = [camHUD];
		taeyaiConsole.alpha = 0.5;
		add(JUSTMONIKA);
		JUSTMONIKA.setGraphicSize(Std.int(JUSTMONIKA.width * 2), Std.int(JUSTMONIKA.height * 2));
		JUSTMONIKA.updateHitbox();
		JUSTMONIKA.cameras = [camHUD];
		//add(originFunni);
		//ChromaticAberrationEffect(0)
		dumbasstext3 = new FlxText(0, 280, 0, "> Starting countdown...\n\n> Song Started\n\n> DAD BETADCIU Mode intitiated\n\n> Changed dad to sky-mad\n\n> BOYFRIEND BETADCIU Mode intitiated\n\n> Changed boyfriend to taeyai-playable\n\n> Changed dad to majin\n\n", 16);
		dumbasstext3.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		dumbasstext3.alignment = "LEFT";
		dumbasstext3.cameras = [camHUD];
		add(dumbasstext3);
		dumbasstext3.visible = false;
		taeyaiConsole.visible = false;
		if (SONG.song.toLowerCase() == 'knockout')
		{
			if (!ClientPrefs.shaders)
			{
				chromaticShader = new ChromaticAberrationEffect(defaultChromNumber);
				addShaderToCamera('camGame', chromaticShader);
				addShaderToCamera('camHUD', chromaticShader);
				addShaderToCamera('camHUDier', chromaticShader);
			}
			FlxG.sound.list.add(hurtSound);
			FlxG.sound.list.add(dodgeSound);
			//USE FOR ENDLESS
			//dad.color = FlxColor.fromRGB(0, 38, 255, 122);
			//COOL RED
			//dad.color = FlxColor.fromHSB(0, 32, 150);
			
			gfAgain.color = 0xFFAEB8CF;

			
			var thefunkicuphead:FlxSprite = new FlxSprite();
			thefunkicuphead.frames = Paths.getSparrowAtlas('knockout/the_thing2.0', 'shared');
			thefunkicuphead.animation.addByPrefix('boo', 'BOO instance 1', 24, false);
			thefunkicuphead.animation.play('boo');
			add(thefunkicuphead);
			thefunkicuphead.scale.set(1.1, 1.1);
			thefunkicuphead.cameras = [camHUD];
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				remove(thefunkicuphead);
			});
		}
		if (FlxG.save.data.equipped == null)
			FlxG.save.data.equipped = [];
		perks = new FlxTypedSpriteGroup();
		for (i in 0...FlxG.save.data.equipped.length)
		{
			perks.add (new RoboPerk(FlxG.save.data.equipped[i], 950,  100 + i * 100)).scale.set(0.3,0.3);
		}
		while (perks.length < 3)
		{
			perks.add (new RoboPerk('disabled', 950,  100 + perks.length * 100)).scale.set(0.3,0.3);
		}
		add(perks);
		perks.cameras = [camHUD];
		//placeholderSprite = new FlxSprite(0, 0).loadGraphic();
	}

	function set_songSpeed(value:Float):Float
	{
		if(generatedMusic)
		{
			var ratio:Float = value / songSpeed; //funny word huh
			for (note in notes)
			{
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
				{
					note.scale.y *= ratio;
					note.updateHitbox();
				}
			}
			for (note in unspawnNotes)
			{
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
				{
					note.scale.y *= ratio;
					note.updateHitbox();
				}
			}
		}
		songSpeed = value;
		noteKillOffset = 350 / songSpeed;
		return value;
	}

	public function addTextToDebug(text:String) {
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText) {
			spr.y += 20;
		});

		if(luaDebugGroup.members.length > 34) {
			var blah = luaDebugGroup.members[34];
			blah.destroy();
			luaDebugGroup.remove(blah);
		}
		luaDebugGroup.insert(0, new DebugLuaText(text, luaDebugGroup));
		#end
	}

	public function reloadHealthBarColors() {
		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
			
		healthBar.updateBar();
	}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Boyfriend = new Boyfriend(0, 0, newCharacter);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					
					if (newBoyfriend.curCharacter != 'hat kid rain' && curStage == 'knockout')
						newBoyfriend.color = 0xFFAEB8CF;
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					startCharacterLua(newBoyfriend.curCharacter);
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					if (newDad.curCharacter != 'big-monika'
					&& newDad.curCharacter != 'lordX'
					&& newDad.curCharacter != 'ski'
					&& newDad.curCharacter != 'gold'
					&& newDad.curCharacter != 'sonic'
					&& newDad.curCharacter != 'p2doll'
					&& newDad.curCharacter != 'fleetway'
					&& newDad.curCharacter != 'fleetway3' && curStage == 'knockout')
						newDad.color = 0xFFAEB8CF;
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					startCharacterLua(newDad.curCharacter);
				}

			case 2:
				if(gf != null && !gfMap.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					if (newGf.curCharacter != 'big-monika'
					&& newGf.curCharacter != 'lordX'
					&& newGf.curCharacter != 'ski'
					&& newGf.curCharacter != 'gold'
					&& newGf.curCharacter != 'sonic'
					&& newGf.curCharacter != 'p2doll' && curStage == 'knockout')
						newGf.color = 0xFFAEB8CF;
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					startCharacterLua(newGf.curCharacter);
				}
			case 3:
				if(!dadMapAgain1.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					if (newDad.curCharacter != 'big-monika'
					&& newDad.curCharacter != 'lordX'
					&& newDad.curCharacter != 'ski'
					&& newDad.curCharacter != 'gold'
					&& newDad.curCharacter != 'sonic'
					&& newDad.curCharacter != 'p2doll'
					&& newDad.curCharacter != 'fleetway'
					&& newDad.curCharacter != 'fleetway3' && curStage == 'knockout')
						newDad.color = 0xFFAEB8CF;
					dadMapAgain1.set(newCharacter, newDad);
					dadGroupAgain1.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					startCharacterLua(newDad.curCharacter);
				}
				//var olddadx = dadAgain1.x;
				//var olddady = dadAgain1.y;
				//var olddadoffsettingX = dadAgain1.positionArray[0];
				//var olddadoffsettingY = dadAgain1.positionArray[1];
				//trace(dadAgain1.y);
				//remove(dadAgain1);
				//dadAgain1 = new Character(olddadx - olddadoffsettingX, olddady - olddadoffsettingY, newCharacter);
				//trace(olddady - olddadoffsettingY);
				//add(dadAgain1);
				//dadAgain1.x += dadAgain1.positionArray[0];
				//dadAgain1.y += dadAgain1.positionArray[1];
				//trace(dadAgain1.y);
				//if (curStage == 'LordXStage')
				//	dadAgain1.scrollFactor.set(1.53, 1);
				//startCharacterPos(dadAgain1);
				//dadAgain1.alpha = 0.00001;
			case 4:
				if(!boyfriendMapAgain.exists(newCharacter)) {
					var newBoyfriend:Boyfriend = new Boyfriend(0, 0, newCharacter);
					if (newBoyfriend.curCharacter != 'hat kid rain' && curStage == 'knockout')
						newBoyfriend.color = 0xFFAEB8CF;
					boyfriendMapAgain.set(newCharacter, newBoyfriend);
					boyfriendGroupAgain.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					startCharacterLua(newBoyfriend.curCharacter);
				}
			case 5:
				if(!dadMapAgain2.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					if (newDad.curCharacter != 'big-monika'
					&& newDad.curCharacter != 'lordX'
					&& newDad.curCharacter != 'ski'
					&& newDad.curCharacter != 'gold'
					&& newDad.curCharacter != 'sonic'
					&& newDad.curCharacter != 'p2doll'
					&& newDad.curCharacter != 'fleetway'
					&& newDad.curCharacter != 'fleetway3' && curStage == 'knockout')
						newDad.color = 0xFFAEB8CF;
					dadMapAgain2.set(newCharacter, newDad);
					dadGroupAgain2.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					startCharacterLua(newDad.curCharacter);
				}
			case 6:
				if(gfAgain != null && !gfMapAgain.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					if (newGf.curCharacter != 'hat kid rain' && curStage == 'knockout')
						newGf.color = 0xFFAEB8CF;
					newGf.scrollFactor.set(0.95, 0.95);
					gfMapAgain.set(newCharacter, newGf);
					gfGroupAgain.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					startCharacterLua(newGf.curCharacter);
				}
		}
	}

	function startCharacterLua(name:String)
	{
		#if LUA_ALLOWED
		var doPush:Bool = false;
		var luaFile:String = 'characters/' + name + '.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}
		
		if(doPush)
		{
			for (lua in luaArray)
			{
				if(lua.scriptName == luaFile) return;
			}
			luaArray.push(new FunkinLua(luaFile));
		}
		#end
	}
	
	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
			char.danceEveryNumBeats = 2;
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public function startVideo(name:String):Void {
		#if VIDEOS_ALLOWED
		var foundFile:Bool = false;
		var fileName:String = #if MODS_ALLOWED Paths.modFolders('videos/' + name + '.' + Paths.VIDEO_EXT); #else ''; #end
		#if sys
		if(FileSystem.exists(fileName)) {
			foundFile = true;
		}
		#end

		if(!foundFile) {
			fileName = Paths.video(name);
			#if sys
			if(FileSystem.exists(fileName)) {
			#else
			if(OpenFlAssets.exists(fileName)) {
			#end
				foundFile = true;
			}
		}

		if(foundFile) {
			inCutscene = true;
			var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			bg.scrollFactor.set();
			bg.cameras = [camHUD];
			add(bg);

			(new FlxVideo(fileName)).finishCallback = function() {
				remove(bg);
				startAndEnd();
			}
			return;
		}
		else
		{
			FlxG.log.warn('Couldnt find video file: ' + fileName);
			startAndEnd();
		}
		#end
		startAndEnd();
	}

	function startAndEnd()
	{
		if(endingSong)
			endSong();
		else
			startCountdown();
	}

	var dialogueCount:Int = 0;
	public var psychDialogue:DialogueBoxPsych;
	//You don't have to add a song, just saying. You can just do "startDialogue(dialogueJson);" and it should work
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{
		// TO DO: Make this more flexible, maybe?
		if(psychDialogue != null) return;

		if(dialogueFile.dialogue.length > 0) {
			inCutscene = true;
			CoolUtil.precacheSound('dialogue');
			CoolUtil.precacheSound('dialogueClose');
			psychDialogue = new DialogueBoxPsych(dialogueFile, song);
			psychDialogue.scrollFactor.set();
			if(endingSong) {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					endSong();
				}
			} else {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					startCountdown();
				}
			}
			psychDialogue.nextDialogueThing = startNextDialogue;
			psychDialogue.skipDialogueThing = skipDialogue;
			psychDialogue.cameras = [camHUD];
			add(psychDialogue);
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			if(endingSong) {
				endSong();
			} else {
				startCountdown();
			}
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += 300;

		var songName:String = Paths.formatToSongPath(SONG.song);
		if (songName == 'roses' || songName == 'thorns')
		{
			remove(black);

			if (songName == 'thorns')
			{
				add(red);
				camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (Paths.formatToSongPath(SONG.song) == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var countdownReady:FlxSprite;
	public var countdownSet:FlxSprite;
	public var countdownGo:FlxSprite;
	public static var startOnTime:Float = 0;

	public function startCountdown():Void
	{
		var songName:String = Paths.formatToSongPath(SONG.song);
		var doIstartDialogue:Bool = false;
		var file:String = Paths.json(songName + '/DialogueThing');
		#if sys
		if (#if MODS_ALLOWED FileSystem.exists(Paths.modsJson(songName + '/DialogueThing')) || #end FileSystem.exists(file))
		#else
		if (OpenFlAssets.exists(file))
		#end
		{
			//clearEvents();
			var events = parseDialogue(file);
			roboticDialogues = events.dialogues.copy();
			doIstartDialogue = true;
		}
		if (dialogueEditing)
			return;
		if(doIstartDialogue && !didIstartDialogue) {
			var iconName:String = '';
			{
				var songName:String = Paths.formatToSongPath('robo');
				var file:String = Paths.json(songName + '/characters/' + roboticDialogues[0].characterName);
				#if sys
				if (#if MODS_ALLOWED FileSystem.exists(Paths.modsJson(songName + '/characters/' + roboticDialogues[0].characterName)) || #end FileSystem.exists(file))
				#else
				if (OpenFlAssets.exists(file))
				#end
				{
					var charProperties = TextBox.parseCharacter(file);
					
					iconName = charProperties.iconName;
				}
			}
			textBox = new TextBox(0, 500, 125, FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]), 0.2, roboticDialogues[0].line, iconName);
			textBox.allDialogues = roboticDialogues;
			add(textBox);
			textBox.cameras = [camHUDier];
			textBox.appear();
			textBox.goToNextDialogue();
			textBox.onComplete = startCountdown;
			didIstartDialogue = true;
			camHUD.alpha = 0;
			dialogueMusic = new FlxSound();
			if (curStage == 'knockout')
				dialogueMusic.loadEmbedded(Paths.music('UnnessecaryIntenseStory'), true, true);
			else
				dialogueMusic.loadEmbedded(Paths.music('UnnessecaryStory'), true, true);
			dialogueMusic.play(false);
			dialogueMusic.fadeIn(1, 0, 0.4);
			dialogueMusic.volume = 0;
	
			FlxG.sound.list.add(dialogueMusic);
			return;
		}
		if (dialogueMusic != null)
		dialogueMusic.fadeOut(1);

		if (SONG.song.toLowerCase() == 'milk')
		{
			add(blackFuck);
			startCircle.loadGraphic(Paths.image('milk/Sunky', 'shared'));
			startCircle.scale.x = 0;
			startCircle.x += 50;
			add(startCircle);
			new FlxTimer().start(0.6, function(tmr:FlxTimer)
			{
				FlxTween.tween(startCircle.scale, {x: 1}, 0.2, {ease: FlxEase.elasticOut});
				FlxG.sound.play(Paths.sound('milk/flatBONK', 'shared'));
			});

			new FlxTimer().start(1.9, function(tmr:FlxTimer)
			{
				FlxTween.tween(blackFuck, {alpha: 0}, 1);
				FlxTween.tween(startCircle, {alpha: 0}, 1);
				dad.visible = true;
				boyfriend.visible = true;
				triggerEventNote("Change Character", "gf", "no-gf");
				gf.x -= 150;
			});
		}
		if (SONG.song.toLowerCase() == 'expurgation') // start the grem time
		{
			gremlinTimer.start(25, function(tmr:FlxTimer)
			{
				if (curStep < 2400)
				{
					if (canPause && !paused && health >= 1.5 && !grabbed)
						doGremlin(40, 3);
					trace('checka ' + health);
					tmr.reset(25);
				}
			});
		}
		if(startedCountdown) {
			callOnLuas('onStartCountdown', []);
			return;
		}
		FlxTween.tween(camHUD, {alpha: 1}, 0.5, {
			ease: FlxEase.quadInOut
		});
		

		inCutscene = false;
		var ret:Dynamic = callOnLuas('onStartCountdown', []);
		if(ret != FunkinLua.Function_Stop) {
			if (skipCountdown || startOnTime > 0) skipArrowStartTween = true;

			generateStaticArrows(0);
			generateStaticArrows(1);
			for (i in 0...playerStrums.length) {
				setOnLuas('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defaultPlayerStrumY' + i, playerStrums.members[i].y);
			}
			for (i in 0...opponentStrums.length) {
				setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				//if(ClientPrefs.middleScroll) opponentStrums.members[i].visible = false;
			}

			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;
			setOnLuas('startedCountdown', true);
			callOnLuas('onCountdownStarted', []);

			var swagCounter:Int = 0;

			if (skipCountdown || startOnTime > 0) {
				clearNotesBefore(startOnTime);
				setSongTime(startOnTime - 500);
				return;
			}

			startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				if (gf != null && tmr.loopsLeft % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && !gf.stunned && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
				{
					gf.dance();
					if (curStage == 'auditorHell' || (SONG.song.toLowerCase() == 'ejected' && !roseturn))
						lol86.dance();
				}
				if (gfAgain != null && tmr.loopsLeft % Math.round(gfSpeed * gfAgain.danceEveryNumBeats) == 0 && !gfAgain.stunned && gfAgain.animation.curAnim.name != null && !gfAgain.animation.curAnim.name.startsWith("sing") && !gfAgain.stunned)
				{
					gfAgain.dance();
				}
				if (tmr.loopsLeft % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
				{
					boyfriend.dance();
				}
				if (tmr.loopsLeft % boyfriendAgain.danceEveryNumBeats == 0 && boyfriendAgain.animation.curAnim != null && !boyfriendAgain.animation.curAnim.name.startsWith('sing') && !boyfriendAgain.stunned)
				{
					boyfriendAgain.dance();
				}
				if (tmr.loopsLeft % boyfriendBETADCIU.danceEveryNumBeats == 0 && boyfriendBETADCIU.animation.curAnim != null && !boyfriendBETADCIU.animation.curAnim.name.startsWith('sing') && !boyfriendBETADCIU.stunned)
				{
					boyfriendBETADCIU.dance();
				}
				if (tmr.loopsLeft % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
				{
					dad.dance();
				}
				if (tmr.loopsLeft % dadAgain1.danceEveryNumBeats == 0 && dadAgain1.animation.curAnim != null && !dadAgain1.animation.curAnim.name.startsWith('sing') && !dadAgain1.stunned)
				{
					dadAgain1.dance();
				}
				if (tmr.loopsLeft % dadAgain2.danceEveryNumBeats == 0 && dadAgain2.animation.curAnim != null && !dadAgain2.animation.curAnim.name.startsWith('sing') && !dadAgain2.stunned)
				{
					dadAgain2.dance();
				}
				if (tmr.loopsLeft % dadBETADCIU.danceEveryNumBeats == 0 && dadBETADCIU.animation.curAnim != null && !dadBETADCIU.animation.curAnim.name.startsWith('sing') && !dadBETADCIU.stunned)
				{
					trace('I am here');
					dadBETADCIU.idleSuffix = '';
					if (dad.alpha > 0 && dadBETADCIU.animation.curAnim.name != 'oops')
					{
						trace('at 1');
						dadBETADCIU.dance();
					}
				}

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', 'set', 'go']);
				introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

				var introAlts:Array<String> = introAssets.get('default');
				var antialias:Bool = ClientPrefs.globalAntialiasing;
				if(isPixelStage) {
					introAlts = introAssets.get('pixel');
					antialias = false;
				}

				// head bopping for bg characters on Mall
				if(curStage == 'mall') {
					if(!ClientPrefs.lowQuality)
						upperBoppers.dance(true);
	
					bottomBoppers.dance(true);
					santa.dance(true);
				}
				if(curStage == 'knockout') {
					if(!ClientPrefs.lowQuality)
					{

					}
				}

				switch (curStage)
				{
					case 'jelly':
						switch (swagCounter)
						{
							case 0:
								FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
							case 1:
								countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
								countdownReady.scrollFactor.set();
								countdownReady.updateHitbox();
		
								if (PlayState.isPixelStage)
									countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));
		
								countdownReady.screenCenter();
								countdownReady.antialiasing = antialias;
								add(countdownReady);
								FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownReady);
										countdownReady.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
							case 2:
								countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
								countdownSet.scrollFactor.set();
		
								if (PlayState.isPixelStage)
									countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));
		
								countdownSet.screenCenter();
								countdownSet.antialiasing = antialias;
								add(countdownSet);
								FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownSet);
										countdownSet.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
							case 3:
								countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
								countdownGo.scrollFactor.set();
		
								if (PlayState.isPixelStage)
									countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));
		
								countdownGo.updateHitbox();
		
								countdownGo.screenCenter();
								countdownGo.antialiasing = antialias;
								add(countdownGo);
								FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownGo);
										countdownGo.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
							case 4:
						}

					case 'knockout':
						switch (swagCounter)
						{
							case 0:
								FlxG.sound.play(Paths.sound('knockout/' + FlxG.random.int(0,1)), 1);
								var ready:FlxSprite = new FlxSprite();
								ready.frames = Paths.getSparrowAtlas('knockout/ready_wallop');
								ready.animation.addByPrefix('start','Ready? WALLOP!', 24, false);
								ready.animation.play('start');
								ready.scrollFactor.set();
								ready.updateHitbox();
		
								ready.screenCenter();
								ready.antialiasing = antialias;
								add(ready);
								ready.animation.finishCallback = function(funki:String) {
									remove(ready);
									FlxTween.tween(this, {songBackSpriteWidth: FlxG.width}, 0.625,
									{
										onComplete: function(twn:FlxTween)
										{
											FlxTween.tween(displaySongName, {y: songBackSprite.y + 30, alpha: 1}, 0.80, {
												ease: FlxEase.elasticInOut,
												onComplete: function(twn:FlxTween)
												{
													trace (displaySongName.x + displaySongName.width - iconSongName.x);
													FlxTween.tween(this, {songNameDistance: 70}, 0.5, {
														ease: FlxEase.elasticInOut
													});
													FlxTween.tween(iconSongName, {alpha: 1}, 0.5, {
														ease: FlxEase.elasticInOut
													});
													FlxTween.tween(iconSongNameAgain, {alpha: 1}, 0.5, {
														ease: FlxEase.elasticInOut
													});
													FlxTween.tween(displayArtistName, {y: displaySongName.y + 50, alpha: 1}, 0.5, {
														ease: FlxEase.elasticInOut
													});
													
													new FlxTimer().start(4, function(tmr:FlxTimer)
													{
														FlxTween.tween(songBackSprite, {y: songBackSprite.y - 100, alpha: 0}, 0.5, {
															ease: FlxEase.elasticInOut
														});
														FlxTween.tween(displayArtistName, {y: displayArtistName.y - 100, alpha: 0}, 0.5, {
															ease: FlxEase.elasticInOut
														});
														FlxTween.tween(displaySongName, {y: displaySongName.y - 100, alpha: 0}, 0.5, {
															ease: FlxEase.elasticInOut
														});
														FlxTween.tween(iconSongName, {y: iconSongName.y - 100, alpha: 0}, 0.5, {
															ease: FlxEase.elasticInOut
														});
														FlxTween.tween(iconSongNameAgain, {alpha: 0}, 0.5, {
															ease: FlxEase.elasticInOut
														});
													});
												}
											});
										}
									});
								}
						}
					default:
						switch (swagCounter)
						{
							case 0:
								FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
							case 1:
								countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
								countdownReady.scrollFactor.set();
								countdownReady.updateHitbox();
		
								if (PlayState.isPixelStage)
									countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));
		
								countdownReady.screenCenter();
								countdownReady.antialiasing = antialias;
								add(countdownReady);
								FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownReady);
										countdownReady.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
							case 2:
								countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
								countdownSet.scrollFactor.set();
		
								if (PlayState.isPixelStage)
									countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));
		
								countdownSet.screenCenter();
								countdownSet.antialiasing = antialias;
								add(countdownSet);
								FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownSet);
										countdownSet.destroy();
									}
								});
								FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
							case 3:
								countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
								countdownGo.scrollFactor.set();
		
								if (PlayState.isPixelStage)
									countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));
		
								countdownGo.updateHitbox();
		
								countdownGo.screenCenter();
								countdownGo.antialiasing = antialias;
								add(countdownGo);
								FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
									ease: FlxEase.cubeInOut,
									onComplete: function(twn:FlxTween)
									{
										remove(countdownGo);
										countdownGo.destroy();
										FlxTween.tween(this, {songBackSpriteWidth: FlxG.width}, 1.25,
										{
											onComplete: function(twn:FlxTween)
											{
												FlxTween.tween(displaySongName, {y: songBackSprite.y + 30, alpha: 1}, 0.80, {
													ease: FlxEase.elasticInOut,
													onComplete: function(twn:FlxTween)
													{
														trace (displaySongName.x + displaySongName.width - iconSongName.x);
														FlxTween.tween(this, {songNameDistance: 70}, 0.5, {
															ease: FlxEase.elasticInOut
														});
														FlxTween.tween(iconSongName, {alpha: 1}, 0.5, {
															ease: FlxEase.elasticInOut
														});
														FlxTween.tween(iconSongNameAgain, {alpha: 1}, 0.5, {
															ease: FlxEase.elasticInOut
														});
														FlxTween.tween(displayArtistName, {y: displaySongName.y + 50, alpha: 1}, 0.5, {
															ease: FlxEase.elasticInOut
														});
														
														new FlxTimer().start(4, function(tmr:FlxTimer)
														{
															FlxTween.tween(songBackSprite, {y: songBackSprite.y - 100, alpha: 0}, 0.5, {
																ease: FlxEase.elasticInOut
															});
															FlxTween.tween(displayArtistName, {y: displayArtistName.y - 100, alpha: 0}, 0.5, {
																ease: FlxEase.elasticInOut
															});
															FlxTween.tween(displaySongName, {y: displaySongName.y - 100, alpha: 0}, 0.5, {
																ease: FlxEase.elasticInOut
															});
															FlxTween.tween(iconSongName, {y: iconSongName.y - 100, alpha: 0}, 0.5, {
																ease: FlxEase.elasticInOut
															});
															FlxTween.tween(iconSongNameAgain, {alpha: 0}, 0.5, {
																ease: FlxEase.elasticInOut
															});
														});
													}
												});
											}
										});
									}
								});
								FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
							case 4:
						}
				}

				notes.forEachAlive(function(note:Note) {
					note.copyAlpha = false;
					note.alpha = note.multAlpha;
					if(ClientPrefs.middleScroll && !note.mustPress) {
						note.alpha *= 0.5;
					}
				});
				callOnLuas('onCountdownTick', [swagCounter]);

				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	}

	public function clearNotesBefore(time:Float)
	{
		var i:Int = unspawnNotes.length - 1;
		while (i >= 0) {
			var daNote:Note = unspawnNotes[i];
			if(daNote.strumTime - 500 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				unspawnNotes.remove(daNote);
				daNote.destroy();
			}
			--i;
		}

		i = notes.length - 1;
		while (i >= 0) {
			var daNote:Note = notes.members[i];
			if(daNote.strumTime - 500 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			--i;
		}
	}

	public function setSongTime(time:Float)
	{
		if(time < 0) time = 0;

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.time = time;
		FlxG.sound.music.play();

		vocals.time = time;
		vocals.play();
		Conductor.songPosition = time;
	}

	function startNextDialogue() {
		dialogueCount++;
		callOnLuas('onNextDialogue', [dialogueCount]);
	}

	function skipDialogue() {
		callOnLuas('onSkipDialogue', [dialogueCount]);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = onSongComplete;
		vocals.play();

		if(startOnTime > 0)
		{
			setSongTime(startOnTime - 500);
		}
		startOnTime = 0;

		if(paused) {
			//trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			vocals.pause();
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		
		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength);
		#end
		setOnLuas('songLength', songLength);
		callOnLuas('onSongStart', []);
	}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();
	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());
		songSpeedType = ClientPrefs.getGameplaySetting('scrolltype','multiplicative');

		switch(songSpeedType)
		{
			case "multiplicative":
				songSpeed = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1);
			case "constant":
				songSpeed = ClientPrefs.getGameplaySetting('scrollspeed', 1);
		}
		
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);
		
		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var songName:String = Paths.formatToSongPath(SONG.song);
		var file:String = Paths.json(songName + '/events');
		#if sys
		if (FileSystem.exists(Paths.modsJson(songName + '/events')) || FileSystem.exists(file)) {
		#else
		if (OpenFlAssets.exists(file)) {
		#end
			var eventsData:Array<Dynamic> = Song.loadFromJson('events', songName).events;
			for (event in eventsData) //Event Notes
			{
				for (i in 0...event[1].length)
				{
					var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
					var subEvent:EventNote = {
						strumTime: newEventNote[0] + ClientPrefs.noteOffset,
						event: newEventNote[1],
						value1: newEventNote[2],
						value2: newEventNote[3]
					};
					subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
					eventNotes.push(subEvent);
					eventPushed(subEvent);
				}
			}
		}

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.mustPress = gottaHitNote;
				swagNote.sustainLength = songNotes[2];
				swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
				swagNote.noteType = songNotes[3];
				if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts
				
				swagNote.scrollFactor.set();

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				var floorSus:Int = Math.floor(susLength);
				if(floorSus > 0) {
					for (susNote in 0...floorSus+1)
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2)), daNoteData, oldNote, true);
						sustainNote.mustPress = gottaHitNote;
						sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
						sustainNote.noteType = swagNote.noteType;
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);

						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
						else if(ClientPrefs.middleScroll)
						{
							sustainNote.x += 310;
							if(daNoteData > 1) //Up and Right
							{
								sustainNote.x += FlxG.width / 2 + 25;
							}
						}
					}
				}

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else if(ClientPrefs.middleScroll)
				{
					swagNote.x += 310;
					if(daNoteData > 1) //Up and Right
					{
						swagNote.x += FlxG.width / 2 + 25;
					}
				}

				if(!noteTypeMap.exists(swagNote.noteType)) {
					noteTypeMap.set(swagNote.noteType, true);
				}
			}
			daBeats += 1;
		}
		for (event in songData.events) //Event Notes
		{
			for (i in 0...event[1].length)
			{
				var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
				var subEvent:EventNote = {
					strumTime: newEventNote[0] + ClientPrefs.noteOffset,
					event: newEventNote[1],
					value1: newEventNote[2],
					value2: newEventNote[3]
				};
				subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
				eventNotes.push(subEvent);
				eventPushed(subEvent);
			}
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		if(eventNotes.length > 1) { //No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}
		checkEventNote();
		generatedMusic = true;
	}

	function eventPushed(event:EventNote) {
		switch(event.event) {
			case 'Change Character':
				var charType:Int = 0;
				switch(event.value1.toLowerCase()) {
					case 'dadagain2' | 'opponentagain2' | '4':
						charType = 5;
					case 'bfagain' | 'boyfriendagain' | '3':
						charType = 4;
					case 'dadagain1' | 'opponentagain' | '2':
						charType = 3;
					case 'gf' | 'girlfriend' | '1':
						charType = 2;
					case 'dad' | 'opponent' | '0':
						charType = 1;
					default:
						charType = Std.parseInt(event.value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event.value2;
				addCharacterToList(newCharacter, charType);
		}

		if(!eventPushedMap.exists(event.event)) {
			eventPushedMap.set(event.event, true);
		}
	}

	function eventNoteEarlyTrigger(event:EventNote):Float {
		var returnedValue:Float = callOnLuas('eventEarlyTrigger', [event.event]);
		if(returnedValue != 0) {
			return returnedValue;
		}

		switch(event.event) {
			case 'Kill Henchmen': //Better timing so that the kill sound matches the beat intended
				return 280; //Plays 280ms before the actual position
		}
		return 0;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByTime(Obj1:EventNote, Obj2:EventNote):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public var skipArrowStartTween:Bool = false; //for lua
	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var targetAlpha:Float = 1;
			if (player < 1 && ClientPrefs.middleScroll) targetAlpha = 0.35;

			var babyArrow:StrumNote = new StrumNote(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i, player);
			babyArrow.downScroll = ClientPrefs.downScroll;
			if (!isStoryMode && !skipArrowStartTween)
			{
				//babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {/*y: babyArrow.y + 10,*/ alpha: targetAlpha}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			else
			{
				babyArrow.alpha = targetAlpha;
			}

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				if(ClientPrefs.middleScroll)
				{
					babyArrow.x += 310;
					if(i > 1) { //Up and Right
						babyArrow.x += FlxG.width / 2 + 25;
					}
				}
				opponentStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);
			babyArrow.postAddedToGroup();
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = false;
			if (songSpeedTween != null)
				songSpeedTween.active = false;

			if(blammedLightsBlackTween != null)
				blammedLightsBlackTween.active = false;
			if(phillyCityLightsEventTween != null)
				phillyCityLightsEventTween.active = false;

			if(carTimer != null) carTimer.active = false;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = false;
				}
			}

			for (tween in modchartTweens) {
				tween.active = false;
			}
			for (timer in modchartTimers) {
				timer.active = false;
			}
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = true;
			if (songSpeedTween != null)
				songSpeedTween.active = true;

			if(blammedLightsBlackTween != null)
				blammedLightsBlackTween.active = true;
			if(phillyCityLightsEventTween != null)
				phillyCityLightsEventTween.active = true;
			if(roborobotimer != null)
				roborobotimer.active = true;
			if(chromaticTween != null)
				chromaticTween.active = true;
			if(circleTween != null)
				circleTween.active = true;
			
			if(carTimer != null) carTimer.active = true;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = true;
				}
			}
			
			for (tween in modchartTweens) {
				tween.active = true;
			}
			for (timer in modchartTimers) {
				timer.active = true;
			}
			paused = false;
			callOnLuas('onResume', []);

			#if desktop
			if (startTimer != null && startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if(finishTimer != null) return;

		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	public var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var limoSpeed:Float = 0;
	var cointhing:Float = 0;
	var floatyFloat:Float = 0;
	var numberThatIncreasesByOne:Int = 0;
	var attackingOpponent:Bool = false;
	var placeholderSprite:FlxSprite;
	var roborobotimer:FlxTimer;

	override public function update(elapsed:Float)
	{
		if (curStage == 'sunkStage')
		{
			bg3.y = bg1.y + 1000 + (Math.abs(Math.sin(floatyFloat/10)) * (550 - 1000));
			bg4.y = bg1.y + 1000 + (Math.abs(Math.sin(floatyFloat/10)) * (700 - 1000));
			bg5.y = bg1.y + 1000 + (Math.abs(Math.sin(floatyFloat/10)) * (850 - 1000));
		}
		if (curStage == 'curse')
		{
				for (i in 0...strumLineNotes.length)
				{
					var strum = strumLineNotes.members[i];
					if (stepCheck(144, 176) || stepCheck(207, 239))
					{
						strum.y = strumLine.y + Math.sin ((i * 2) + floatyFloat) * 10;
					}
					else if (stepCheck(176, 207) || stepCheck(239, 270))
					{
						strum.y = strumLine.y - Math.sin ((i * 2) + floatyFloat) * 10;
					}
					else if (stepCheck(720, 752) || stepCheck(784, 816)
						||   stepCheck(848, 880) || stepCheck(912, 944))
					{
						strum.y = strumLine.y + Math.sin ((i * 2) + floatyFloat) * 10;
						
						if (i > 3)
							strum.x = STRUM_X + FlxG.width / 4 + Note.swagWidth * i - 50 + Math.sin ((i * 2) + floatyFloat) * 10;
						else
							strum.x = STRUM_X + Note.swagWidth * i + Math.sin ((i * 2) + floatyFloat) * 10;
					}
					else if (stepCheck(752, 784) || stepCheck(816, 848)
						||   stepCheck(880, 912) || stepCheck(944, 976))
					{
						strum.y = strumLine.y - Math.sin ((i * 2) + floatyFloat) * 10;
						
						if (i > 3)
							strum.x = STRUM_X + FlxG.width / 4 + Note.swagWidth * i - 50 - Math.sin ((i * 2) + floatyFloat) * 10;
						else
							strum.x = STRUM_X + Note.swagWidth * i - Math.sin ((i * 2) + floatyFloat) * 10 + 50;
					}
					else if (stepCheck(976, 1040))
					{
						strum.y = strumLine.y + Math.sin ((i * 2) + floatyFloat * 2) * 1.5 * 10;
						if (i > 3)
							strum.x = STRUM_X + FlxG.width / 4 + Note.swagWidth * i - 50 + Math.sin ((i * 2) + floatyFloat) * 1.5 * 10;
						else
							strum.x = STRUM_X + Note.swagWidth * i + Math.sin ((i * 2) + floatyFloat) * 1.5 * 10 + 50;
					}
					else if (stepCheck(1040, 1104))
					{
						strum.y = strumLine.y - Math.sin ((i * 2) + floatyFloat * 2) * 1.5 * 10;
						
						if (i > 3)
							strum.x = STRUM_X + FlxG.width / 4 + Note.swagWidth * i - 50 + Math.sin ((i * 2) + floatyFloat) * 1.5 * 10;
						else
							strum.x = STRUM_X + Note.swagWidth * i + Math.sin ((i * 2) + floatyFloat) * 1.5 * 10 + 50;
					}
					else
					{
						strum.y = strumLine.y;
						if (i > 3)
							strum.x = STRUM_X + FlxG.width / 4 + Note.swagWidth * i - 50;
						else
							strum.x = STRUM_X + Note.swagWidth * i + 50;
					}
				}
		}
		if (curStage == 'jelly')
			bg3.angle = bg3.velocity.y / 20;
		if (boyfriend.curCharacter.startsWith('mx'))
			boyfriend.clipRect = new FlxRect(0, 50, 1000, 1000);
		if (dad.curCharacter.startsWith('wbshaggy')||dad.curCharacter.startsWith('fleetway') || dad.flying)
			dad.y += Math.sin(floatyFloat/3);
		if (dadAgain1.curCharacter.startsWith('wbshaggy')||dadAgain1.curCharacter.startsWith('fleetway') || dadAgain1.flying)
			dadAgain1.y += Math.sin(floatyFloat/3);
		if (dadAgain2.curCharacter.startsWith('wbshaggy')||dadAgain2.curCharacter.startsWith('fleetway') || dadAgain2.flying)
			dadAgain2.y += Math.sin(floatyFloat/3);
		if (boyfriend.curCharacter.startsWith('wbshaggy')||boyfriend.curCharacter.startsWith('fleetway') || boyfriend.flying)
			boyfriend.y += Math.sin(floatyFloat/3);
		if (boyfriendAgain.curCharacter.startsWith('wbshaggy')||boyfriendAgain.curCharacter.startsWith('fleetway') || boyfriendAgain.flying)
			boyfriendAgain.y += Math.sin(floatyFloat/3);
		if (retroShake)
		{
			var theRandom = FlxG.random.float(-40, 40);
			bg1.x = theRandom;
			dadAgain1.x = -90 + theRandom;
			dadAgain1.clipRect = new FlxRect(0, 0, 775 - theRandom, 400);
		}
		if (FlxG.keys.justPressed.THREE && FlxG.save.data.equipped.contains('botplay') && !roboRoboPerkActivatedBefore)
		{
			roboRoboPerkActivatedBefore = true;
			roboRoboPerkActivated = true;
			FlxG.sound.play(Paths.sound('sfx shiz'), 0.7);
			
			var perk:RoboPerk = new RoboPerk('disabled',0, 0);
			for (i in 0...FlxG.save.data.equipped.length)
			{
				if (perks.members[i].type == 'botplay')
					perk = perks.members[i];
			}
			perk.color = FlxColor.CYAN;
			roborobotimer = new FlxTimer().start(8.6, function(tmr:FlxTimer) {
				roboRoboPerkActivated = false;
				FlxG.sound.play(Paths.sound('sfx shiz 2'), 0.7);
				perk.color = FlxColor.GRAY;
			});
		}
		//if (dedbutnot)
			//camHUD.shake(0.01, 0.1);
		//trace(health);
		//trace(healthBar.percent);
		var dumb = CoolUtil.coolTextFile(Paths.txt('dumb'));
		//blasterRect.x = Std.parseFloat(dumb[0]);
		//blasterRect.y = Std.parseFloat(dumb[1]);
		if (loopanim)
		{
			var dumb = CoolUtil.coolTextFile(Paths.txt('dumb'));
			dadBETADCIU.playAnim(dumb[0], true);
		}
		numberThatIncreasesByOne++;
		dumbasstext3.y = 300 - dumbasstext3.height + 30;
		floatyFloat += 0.1 * (120/ClientPrefs.framerate);
		
		if (curStage == 'jelly')
		{

			switch (dad.curCharacter)
			{
				case 'Sans_IC':
					if (dad.animation.curAnim.name.startsWith('idle'))
						dad.clipRect = new FlxRect(0, 0, 420, 400);
				case 'sans':
					if (dad.animation.curAnim.name.startsWith('idle'))
						dad.clipRect = new FlxRect(0, 0, 420, 400);
				case 'zardy':
					if (dad.animation.curAnim.name.startsWith('idle'))
						dad.clipRect = new FlxRect(0, 0, 650, 800);
				case 'derg':
					if (dad.animation.curAnim.name.startsWith('idle'))
						dad.clipRect = new FlxRect(0, 0, 450, 565);
				case 'retrospectre':
					if (dad.animation.curAnim.name.startsWith('idle') && coolnumber == 0)
						dad.clipRect = new FlxRect(0, 0, 800, 1200);
				case 'carey':
					if (dad.animation.curAnim.name.startsWith('idle'))
						dad.clipRect = new FlxRect(0, 0, 450, 565);
			}
			switch (dadAgain1.curCharacter)
			{
				case 'Papyrus_IC':
					if (dadAgain1.animation.curAnim.name.startsWith('idle'))
						dadAgain1.clipRect = new FlxRect(0, 0, 800, 400);
				//case 'carey':
				//	if (dadAgain1.animation.curAnim.name.startsWith('idle'))
				//		dadAgain1.clipRect = new FlxRect(0, 0, 450, 565);
			}
			switch (boyfriend.curCharacter)
			{
				case 'spooky-playable':
					if (boyfriend.animation.curAnim.name.startsWith('danceRight') || boyfriend.animation.curAnim.name.startsWith('danceLeft'))
						boyfriend.clipRect = new FlxRect(0, 0, 600, 400);
				case 'ace-playable':
					if (boyfriend.animation.curAnim.name.startsWith('idle'))
						boyfriend.clipRect = new FlxRect(110, 0, 500, 800);
				case '8owser':
					if (boyfriend.animation.curAnim.name.startsWith('idle'))
						boyfriend.clipRect = new FlxRect(0, 0, 200, 800);
				//case 'edd-playable':
				//	if (boyfriend.animation.curAnim.name.startsWith('idle'))
				//		boyfriend.clipRect = new FlxRect(0, 0, 400, 500);
			}
		}
		//knockout
			if (curStage == 'knockout')
			{
				if (cupheadShooting && dad.curCharacter == 'big-monika' && !monikaHit)
					{
						JUSTMONIKA.y -= (JUSTMONIKA.y) / 200 * constantThingy;
					}
					else
						JUSTMONIKA.y -= (JUSTMONIKA.y - (camHUD.height + 200)) / 10 * constantThingy;
				if (BETADCIUAlphaCrazy)
				{
					dadBETADCIU.alpha = ((Math.sin(floatyFloat/3) + 1) / 4) + 0.25;
					boyfriendBETADCIU.alpha = ((Math.sin(-floatyFloat/3) + 1) / 4) + 0.25;
				}
				if (BETADCIUYCrazy)
				{
					dadBETADCIU.y += ((Math.sin(floatyFloat/3))) * 2;
					boyfriendBETADCIU.y += ((Math.sin(floatyFloat/3))) * 2;
					gfAgain.y += ((Math.sin(floatyFloat/3))) * 2;
					gf.y += ((Math.sin(floatyFloat/3))) * 2;
				}
				if (tordMissile.animation.curAnim.name == 'boom' && tordMissile.animation.curAnim.finished)
				{
					remove(tordMissile);
				}
				if (bluelasercheckimfuckingtiredmanletsgetthisdoneoverwith)
				{
					if (redLaser.animation.curAnim != null && redLaser.animation.curAnim.name == 'shoot' && redLaser.animation.curAnim.finished)
					{
						remove(redLaser);
					}
					if (blueLaser.animation.curAnim != null && blueLaser.animation.curAnim.name == 'shoot' && blueLaser.animation.curAnim.finished)
					{
						remove(blueLaser);
					}
				}
				if (boyfriend.curCharacter == 'TC-attacc' && boyfriend.animation.curAnim.name == 'idle' && boyfriend.animation.curAnim.finished)
				{
					triggerEventNote("Change Character", "bf", "TC");
				}
				switch (dad.curCharacter) {
					case 'selever':
						circSelever.y = dad.y;
						circSelever.x = dad.x - 150;
					case 'selever-playable':
						circSelever.y = dad.y;
						circSelever.x = dad.x - 150;
				}
				switch (dadAgain1.curCharacter) {
					case 'selever':
						circSelever.y = dadAgain1.y;
						circSelever.x = dadAgain1.x - 150;
					case 'selever-playable':
						circSelever.y = dadAgain1.y;
						circSelever.x = dadAgain1.x - 150;
				}
				if (!superMove)
				{
					if (dadBETADCIU.animation.curAnim.name == 'Hadoken!!' && dadBETADCIU.animation.curAnim.curFrame == 7 && superType == 'normal')
					{
						FlxG.sound.play(Paths.sound('knockout/Pre_shoot.ogg'), 0.7);
						cupheadShoot();
					}
					if (dadBETADCIU.animation.curAnim.name == 'Hadoken!!' && dadBETADCIU.animation.curAnim.curFrame == 7 && superType == 'round')
					{
						cupheadShootCircle();
						if (dad.curCharacter == 'sunky')
							sunkLoop.visible = true;
						if (dad.curCharacter == 'Sans_IC')
							sansBone.visible = true;
					}
				}
				if ((dadBETADCIU.animation.curAnim.name == 'Hadoken!!' || dadBETADCIU.animation.curAnim.name == 'hurt') && dadBETADCIU.animation.curAnim.finished)
				{
					dadBETADCIU.specialAnim = false;
					if (dad.alpha > 0 && dadBETADCIU.animation.curAnim.name != 'oops')
					{
						dadBETADCIU.dance();
					}
					dad.specialAnim = false;
					dad.dance();
					dadAgain1.specialAnim = true;
					dadAgain1.dance();
				}
				if (boyfriendBETADCIU.animation.curAnim.name == 'attack' && boyfriendBETADCIU.animation.curAnim.finished)
				{
					boyfriendBETADCIU.specialAnim = false;
					boyfriendBETADCIU.dance();
					boyfriend.specialAnim = false;
					boyfriend.dance();
					dumbasstext3.visible = false;
					taeyaiConsole.visible = false;
					boyfriendAgain.specialAnim = false;
					boyfriendAgain.dance();
					attack.animation.play('idle');
				}


				if (boyfriendBETADCIU.animation.curAnim.name == 'attack' && boyfriendBETADCIU.animation.curAnim.curFrame == 11 && attackingOpponent)
				{
					attackingOpponent = false;
					attackOpponent();
					
					switch (boyfriend.curCharacter)
					{
						case 'TC':
							triggerEventNote("Change Character", "bf", "TC-attacc");
							boyfriend.playAnim('idle', true);
							vocals.volume = 0;
							flashScreen(FlxColor.CYAN, 0.4);
							dadBETADCIU.playAnim('oops',true);
							dad.color = 0xFF00EEFF;
							dad.animation.stop();
							FlxG.sound.play(Paths.sound('knockout/shootfunni/tc'), 0.4);
						case 'hank-playable':
							boyfriend.playAnim('singLEFT-alt', true);
							boyfriend.specialAnim = true;
							FlxG.sound.play(Paths.sound('knockout/shootfunni/Powyouaredead'), 1);
						case 'taeyai-playable':
							dumbasstext3.text += '> attackOpponent()\n\n';
							new FlxTimer().start(3, function(tmr:FlxTimer) {
								dumbasstext3.visible = false;
								taeyaiConsole.visible = false;
							});
					}
				}
				if (FlxG.keys.justPressed.SPACE)
				{
					trace('BF DO BE DODGIN\'');
					bfDodgin = true;
					dodge.animation.play('active');
				}
				if (superMove)
				{
					bfHitBox.x = boyfriendBETADCIU.x + 100;
					bfHitBox.y = boyfriendBETADCIU.y + 80;
					bfHitBox.makeGraphic(250, 250, FlxColor.RED);
					bfHitBox.updateHitbox();
					superCuphead.x += 10 * (120/ClientPrefs.framerate);
					switch (dad.curCharacter)
					{
						case 'extiky':
							superCupheadTiky.x += 24 * (120/ClientPrefs.framerate);
							superCupheadTiky.angle += 4 * (120/ClientPrefs.framerate);
					}
					//superCircleCuphead.x += 10 * (120/ClientPrefs.framerate);
					superCircleCuphead.y = dadBETADCIU.y - 25 + Math.sin(floatyFloat) * 30;
					sunkLoop.y = dadBETADCIU.y - 25 - Math.sin(floatyFloat) * 30;
					sansBone.y = dadBETADCIU.y - 25 - Math.sin(floatyFloat) * 30;
					superHitBox.x = superCuphead.x + 520;
					superHitBox.y = superCuphead.y + 100;
					superHitBox.makeGraphic(660, 300, FlxColor.RED);
					superHitBox.updateHitbox();
					sunkLoop.x = superCircleHitBox.x - 10;
					sunkLoop.angle += 1 * constantThingy;
					if(circleTween != null && circleTween.active)
					{
						sansBone.x = superCircleHitBox.x - 10;
						sansBone.angle += 1 * constantThingy;
					}
					else
					{
						sansBone.x = superCuphead.x + 500;
						sansBone.angle = 90;
					}
					superCircleHitBox.x = superCircleCuphead.x;
					superCircleHitBox.y = superCircleCuphead.y;
					superCircleHitBox.makeGraphic(300, 300, FlxColor.RED);
					superCircleHitBox.updateHitbox();
					if (boyfriendBETADCIU.animation.curAnim.name == 'attack')
					{
						switch (boyfriend.curCharacter)
						{
							case 'taeyai-playable':
								boyfriend.playAnim(singAnimations[numberThatIncreasesByOne % 4], true);
								boyfriend.specialAnim = true;
						}
					}
					if ((superCuphead.x > FlxG.width * 3 && superType == 'normal') || (superCircleCuphead.x > FlxG.width * 3 && superType == 'round'))
						superMove = false;
	
					if (!bfDodgin)
					{
						if ((superCircleHitBox.x + superCircleHitBox.width > bfHitBox.x) && !(superCircleHitBox.x > bfHitBox.x + bfHitBox.width))
						{
							health = -86; //awesome number
							bfDodgin = true;
						}
						if ((superHitBox.x + superHitBox.width > bfHitBox.x) && !(superHitBox.x > bfHitBox.x + bfHitBox.width))
						{
							health = -11.8; //also awesome number
							superCuphead.y -= 375;
							superCuphead.animation.play('Burst');
							superMove = false;
							superCupheadTiky.visible = false;
							bfDodgin = true;
						}
					}
					else
					{
						if ((superHitBox.x + superHitBox.width > bfHitBox.x) && !(superHitBox.x > bfHitBox.x + bfHitBox.width))
						{
							switch (boyfriend.curCharacter)
							{
								case 'chara-playable':
									if (boyfriend.animation.curAnim.name != 'singLEFT-alt')
									{
										if (boyfriendBETADCIU.animation.curAnim.name != 'attack')
										{
											boyfriend.specialAnim = true;
											boyfriend.playAnim('save');
										}
									}
								case 'hank-playable':
									if (boyfriend.animation.curAnim.name != 'singLEFT-alt')
									{
										if (boyfriendBETADCIU.animation.curAnim.name != 'attack')
										{
											boyfriend.specialAnim = true;
											boyfriend.playAnim('ready');
										}
									}
								case 'tord-playable':
									if (boyfriend.animation.curAnim.name != 'hey')
									{
										if (boyfriendBETADCIU.animation.curAnim.name != 'attack')
										{
											boyfriend.specialAnim = true;
											boyfriend.playAnim('hey');
										}
									}
								default:
									if (boyfriendBETADCIU.animation.curAnim.name != 'attack')
									{
										boyfriend.specialAnim = true;
										boyfriend.playAnim('dodge');
										if (dad.curCharacter == 'pico' && !picoShoot)
										{
											picoShoot = true;
											dad.playAnim('singDOWN', true);
											FlxG.sound.play(Paths.sound('knockout/shootfunni/Powyouaredead'), 1);
										}
									}
							}
							if (boyfriendBETADCIU.animation.curAnim.name != 'attack')
							{
								boyfriendBETADCIU.specialAnim = true;
								if (!dodgeSound.playing)
								{
									dodgeSound.play(true);
								}
								boyfriendBETADCIU.playAnim('dodge');
							}
							if (boyfriend.curCharacter == 'taeyai-playable' && (superHitBox.x + superHitBox.width > bfHitBox.x + 400))
							{
								superCuphead.y -= 375;
								superCuphead.animation.play('Burst');
								superMove = false;
							}
						}
						else if ((superCircleHitBox.x + superCircleHitBox.width > bfHitBox.x) && !(superCircleHitBox.x > bfHitBox.x + bfHitBox.width) )
						{
							switch (boyfriend.curCharacter)
							{
								case 'chara-playable':
									if (boyfriend.animation.curAnim.name != 'save')
									{
										if (boyfriendBETADCIU.animation.curAnim.name != 'attack')
										{
											boyfriend.specialAnim = true;
											boyfriend.playAnim('save');
										}
									}
								case 'hank-playable':
									if (boyfriend.animation.curAnim.name != 'singLEFT-alt')
									{
										if (boyfriendBETADCIU.animation.curAnim.name != 'attack')
										{
											boyfriend.specialAnim = true;
											boyfriend.playAnim('ready');
										}
									}
								case 'tord-playable':
									if (boyfriend.animation.curAnim.name != 'hey')
									{
										if (boyfriendBETADCIU.animation.curAnim.name != 'attack')
										{
											boyfriend.specialAnim = true;
											boyfriend.playAnim('hey');
										}
									}
								default:
									if (boyfriendBETADCIU.animation.curAnim.name != 'attack')
									{
										boyfriend.specialAnim = true;
										boyfriend.playAnim('dodge');
										if (dad.curCharacter == 'pico' && !picoShoot)
										{
											picoShoot = true;
											dad.playAnim('singDOWN', true);
											FlxG.sound.play(Paths.sound('knockout/shootfunni/Powyouaredead'), 1);
										}
									}
							}
							if (boyfriendBETADCIU.animation.curAnim.name != 'attack')
							{
								boyfriendBETADCIU.specialAnim = true;
								if (!dodgeSound.playing)
								{
									dodgeSound.play(true);
								}
								boyfriendBETADCIU.playAnim('dodge');
							}
						}
						else
						{
							if (boyfriend.animation.curAnim.name != 'attack')
							{
								boyfriend.specialAnim = false;
								boyfriendBETADCIU.specialAnim = false;
							}
						}
					}
				}
				if (superCuphead.animation.curAnim.name == 'Burst' && superCuphead.animation.curAnim.finished)
				{
					superCuphead.y = dadBETADCIU.y + 125;
					superCuphead.x = dadBETADCIU.x + 3000;
					superCuphead.animation.play('Hadolen');
				}
				if (warning.animation.curAnim != null && warning.animation.curAnim.finished)
					warning.visible = false;

				if (FlxG.keys.justPressed.SHIFT && (superCard.animation.curAnim.name == 'normal' || superCard.animation.curAnim.name == 'parry') && ((superCardTween != null && !superCardTween.active) || (superCardTween == null)) && superCardCharge == 147 && !(!firstPersonMode && (boyfriend.curCharacter == 'robo' && (dad.curCharacter == 'jom' || dad.curCharacter == 'selever'))))
				{
					attackingOpponent = true;
					switch (boyfriend.curCharacter)
					{
						case 'neonight-playable':
							boyfriendAgain.playAnim('attack');
							boyfriendAgain.specialAnim = true;
						case 'taeyai-playable':
							dumbasstext3.visible = true;
							taeyaiConsole.visible = true;
						case 'hank-playable':
							//hehehehaw
						case 'chara-playable':
							boyfriend.playAnim('YOU');
							boyfriend.specialAnim = true;
						case 'blantados-playable':
							FlxG.sound.play(Paths.sound('knockout/shootfunni/byebye'), 1);
							vocals.volume = 0;
							flashScreen(FlxColor.WHITE, 0.4);
							dad.alpha = 0;
							dadBETADCIU.playAnim('oops',true);
						
						case 'tord-playable':
							FlxG.sound.play(Paths.sound('knockout/shootfunni/tord ready'), 1);
							FlxTween.tween(tordMissile, {y: dad.y + 50}, 0.4, {
								ease: FlxEase.quadIn,
								onComplete: function(twn:FlxTween) {
									remove(tordMissile);
									tordMissile.frames = Paths.getSparrowAtlas('knockout/shootstuff/tord/Explosion');
									tordMissile.animation.addByPrefix('boom','Explosion', 24, false);
									tordMissile.animation.play('boom');
									tordMissile.scale.set(3,3);
									tordMissile.x -= 100;
									tordMissile.y -= 100;
									insert(this.members.indexOf(dadGroup) + 1, tordMissile);
									FlxTween.tween(dad, {x: dad.x - 250, angle: -720}, 0.6);
									//FlxTween.tween(dad, {x: dad.x - 750, y: dad.y - 350, angle: -720}, 0.6);
									FlxG.sound.play(Paths.sound('knockout/shootfunni/tord bang your mom'), 1);
								}
							});

						default:
							if (!firstPersonMode)
							{
								boyfriend.playAnim('attack');
								boyfriend.specialAnim = true;
							}
							else
							{
								firstPersonMic = new FlxSprite(1200, dad.y + dad.height + 200).loadGraphic(Paths.image('knockout/shootstuff/mic'));

								add(firstPersonMic);
								firstPersonMic.setGraphicSize(Std.int(firstPersonMic.width * 4), Std.int(firstPersonMic.height * 4));
								firstPersonMic.updateHitbox();
								if (dad.curCharacter != 'lordX')
								{
									FlxTween.tween(firstPersonMic, {x: dad.getGraphicMidpoint().x,y: -200, angle: 480}, 0.5, {
										ease: FlxEase.quadInOut,
										onComplete: function(twn:FlxTween) {
											firstPersonMic.setGraphicSize(Std.int(firstPersonMic.width / 3), Std.int(firstPersonMic.height / 3));
											firstPersonMic.updateHitbox();
											FlxTween.tween(firstPersonMic, {x: dad.getGraphicMidpoint().x - 12, y: dad.getGraphicMidpoint().y, angle: 480 * 2 + 90}, 0.3, {
												ease: FlxEase.quadIn,
												onComplete: function(twn:FlxTween) {
													remove(firstPersonMic);
													dad.playAnim('singDOWN');
												}
											});
										},
									});
								}
								else
								{
									FlxTween.tween(firstPersonMic, {x: dad.getGraphicMidpoint().x + 100,y: -200, angle: 480}, 0.5, {
										ease: FlxEase.quadInOut,
										onComplete: function(twn:FlxTween) {
											firstPersonMic.setGraphicSize(Std.int(firstPersonMic.width / 3), Std.int(firstPersonMic.height / 3));
											firstPersonMic.updateHitbox();
											FlxTween.tween(firstPersonMic, {x: dad.getGraphicMidpoint().x + 88, y: dad.getGraphicMidpoint().y, angle: 480 * 2 + 90}, 0.3, {
												ease: FlxEase.quadIn,
												onComplete: function(twn:FlxTween) {
													remove(firstPersonMic);
													dad.playAnim('singDOWN');
												}
											});
										},
									});
								}
							}
					}
					attack.animation.play('active');
					boyfriendBETADCIU.playAnim('attack');
					boyfriendBETADCIU.specialAnim = true;
					
					if(superCardTween != null) {
						superCardTween.cancel();
					}
					superCardTween = FlxTween.tween(this, {superCardCharge: 0}, 1, {
						ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween) {
							superCardTween = null;
							superCard.animation.play('flipped');
						}
					});
				}
				if (superCardCharge > 147)
					superCardCharge = 147;
				if (superCardCharge == 147 && superCard.animation.curAnim.name == 'flipped')
					superCard.animation.play('normal');
				
				if (!ClientPrefs.downScroll)
				{
					if (!ClientPrefs.middleScroll)
					{
						switch (superCard.animation.curAnim.name)
						{
							case 'flipped':
								superCard.y = 550 + 147 - superCardCharge;
								superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge);
							case 'normal':
								superCard.y = 550 + 147 - superCardCharge - 33;
								superCard.x = 1050 - 6;
								superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge + 30);
							case 'parry':
								if (!superCard.animation.curAnim.finished)
								{
									superCard.y = 550 + 147 - superCardCharge - 33;
									superCard.x = 1050 - 6;
									superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge + 70);
								}
								else
								{
									superCard.y = 550 + 147 - superCardCharge - 33;
									superCard.x = 1050 - 6;
									superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge + 30);
								}

						}
					}
					else
					{
						switch (superCard.animation.curAnim.name)
						{
							case 'flipped':
								superCard.x = 585;
								superCard.y = 550 + 70 - superCardCharge;
								superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge);
							case 'normal':
								superCard.y = 550 + 70 - superCardCharge - 33;
								superCard.x = 585 - 6;
								superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge + 30);
							case 'parry':
								if (!superCard.animation.curAnim.finished)
								{
									superCard.y = 550 + 70 - superCardCharge - 33;
									superCard.x = 585 - 6;
									superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge + 70);
								}
								else
								{
									superCard.y = 550 + 70 - superCardCharge - 33;
									superCard.x = 585 - 6;
									superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge + 30);
								}

						}
					}
				}
				else
				{
					if (!ClientPrefs.middleScroll)
					{
						switch (superCard.animation.curAnim.name)
						{
							case 'flipped':
								superCard.x = 585;
								superCard.y = 550 + 147 - superCardCharge;
								superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge);
							case 'normal':
								superCard.y = 550 + 147 - superCardCharge - 33;
								superCard.x = 585 - 6;
								superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge + 30);
							case 'parry':
								if (!superCard.animation.curAnim.finished)
								{
									superCard.y = 550 + 147 - superCardCharge - 33;
									superCard.x = 585 - 6;
									superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge + 70);
								}
								else
								{
									superCard.y = 550 + 147 - superCardCharge - 33;
									superCard.x = 585 - 6;
									superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge + 30);
								}

						}
					}
					else
					{
						switch (superCard.animation.curAnim.name)
						{
							case 'flipped':
								superCard.x = 585;
								superCard.y = 300 - superCardCharge;
								superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge);
							case 'normal':
								superCard.y = 300 - superCardCharge - 33;
								superCard.x = 585 - 6;
								superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge + 30);
							case 'parry':
								if (!superCard.animation.curAnim.finished)
								{
									superCard.y = 300 - superCardCharge - 33;
									superCard.x = 585 - 6;
									superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge + 70);
								}
								else
								{
									superCard.y = 300 - superCardCharge - 33;
									superCard.x = 585 - 6;
									superCard.clipRect = new FlxRect(0, 0, superCard.width, superCardCharge + 30);
								}

						}
					}
				}
			}
		originFunni.x = boyfriend.x + boyfriend.origin.x - originFunni.width/2;
		originFunni.y = boyfriend.y + boyfriend.origin.y - originFunni.height/2;
		cointhing += 0.01;
		#if debug
		if ((dialogueEditing && !(senteneceInputText.hasFocus || characterInputText.hasFocus || valueInputText1.hasFocus || valueInputText2.hasFocus || valueInputText3.hasFocus)) || !dialogueEditing)
		{
			if (dialogueEditing)
			{
				defaultCamZoom = 1;
				FlxG.camera.zoom = 1;
				if (FlxG.keys.justPressed.T) {
					LoadingState.loadAndSwitchState(new PlayState());
					dialogueEditing = false;
				}
			}
			if (FlxG.keys.justPressed.L) {

				//cupheadShooting = true;
				//shotType = 'green';

				//add(mugman);
				//mugman.animation.play('walk');

				superType = 'round';
				dad.playAnim('Hadoken!!');
				dad.specialAnim = true;
				cupheadAlert();
				bfDodgin = false;
				dodge.animation.play('idle');
			}
			
			if (FlxG.keys.justPressed.M) {
				bg1.x = Std.parseInt(dumb[0]);
				bg1.y = Std.parseInt(dumb[1]);
				bg2.x = Std.parseInt(dumb[2]);
				bg2.y = Std.parseInt(dumb[3]);
				bg6.x = Std.parseInt(dumb[4]);
				bg6.y = Std.parseInt(dumb[5]);
				//boyfriendAgain.playAnim('singUP');
			}
			if (FlxG.keys.justPressed.M) {
				//boyfriendAgain.x = Std.parseInt(dumb[0]);
				//boyfriendAgain.y = Std.parseInt(dumb[1]);
			}
			if (FlxG.keys.justPressed.F) {
				var thingything = -1;
				dad.scale.set(thingything,1);
				dad.updateHitbox();
		
				for (anim in dad.animOffsets.keys())
				{
					dad.animOffsets[anim] = [dad.animOffsets[anim][0]*thingything,dad.animOffsets[anim][1]];
				}
				textBox.changeHeight(50, 5);
			}
			if (FlxG.keys.justPressed.G) {
				var thingything = 1;
				dad.scale.set(thingything,1);
				dad.updateHitbox();
		
				for (anim in dad.animOffsets.keys())
				{
					dad.animOffsets[anim] = [dad.animOffsets[anim][0]*thingything,dad.animOffsets[anim][1]];
				}
			}
			if (FlxG.keys.justPressed.Z) {
			
				cupheadShooting = true;
				shotType = 'blue';
			}
			if (FlxG.keys.justPressed.X && !FlxG.keys.pressed.SHIFT) {
				cupheadShooting = true;
				shotType = 'green';
			}
			if (FlxG.keys.justPressed.X && FlxG.keys.pressed.SHIFT) {
				chartingMode = false;
			}
			
			if (FlxG.keys.justPressed.U) {
				FlxG.sound.music.time -= 10000;
			}
			if (FlxG.keys.justPressed.I) {
				FlxG.sound.music.time -= 1000;
			}
			if (FlxG.keys.justPressed.O) {
				FlxG.sound.music.time += 1000;
			}
			if (FlxG.keys.justPressed.P) {
				FlxG.sound.music.time += 10000;
			}
			if (FlxG.keys.justPressed.C && !FlxG.keys.pressed.SHIFT) {
				superType = 'normal';
				dadBETADCIU.playAnim('Hadoken!!');
				dadBETADCIU.specialAnim = true;
				cupheadAlert();
				bfDodgin = false;
				dodge.animation.play('idle');
			}
			if (FlxG.keys.justPressed.C && FlxG.keys.pressed.SHIFT) {
				chartingMode = true;
			}
			if (FlxG.keys.justPressed.Q) {
				//blasterRect.angle += 90;
				//blasterRect.animation.play('shoot');
			}
			if (FlxG.keys.justPressed.B) {
				superType = 'round';
				dadBETADCIU.playAnim('Hadoken!!');
				dadBETADCIU.specialAnim = true;
				cupheadAlert();
				bfDodgin = false;
				dodge.animation.play('idle');
			}
			/*if (FlxG.keys.justPressed.C) {
				var dad2 = new Character(0, 0, SONG.player2);
				var thingything = -1;
				dad.scale.set(Math.sin(cointhing),1);
				dad.updateHitbox();
		
				for (anim in dad.animOffsets.keys())
				{
					dad.animOffsets[anim] = [dad2.animOffsets[anim][0]*Math.sin(cointhing),dad2.animOffsets[anim][1]];
				}
			}*/
			if (FlxG.keys.justPressed.J) {
				textBox = new TextBox(0, 500, 125, FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]), 0.2, dad.healthIcon);
				add(textBox);
				textBox.cameras = [camHUDier];
				textBox.appear();
			}
			if (FlxG.keys.justPressed.K) {
				textBox.startText(senteneceInputText.text);
			}
			if (FlxG.keys.justPressed.H) {
				loopanim = true;
			}
		}
		#end
		
		if (dialogueEditing)
		{
			theIndexText.text = 'Current Index: ' + (senteneceInputText.text.length);
			switch (effectDropDown.selectedLabel)
			{
				case 'Wave On':
					theOptionsText.text = 'The Options Text: value1 is wave Intensity, value2 is wave Distance';
				case 'Wave Off':
					theOptionsText.text = 'The Options Text: Nothing';
				case 'Shake On':
					theOptionsText.text = 'The Options Text: value1 is shake Intensity';
				case 'Shake Off':
					theOptionsText.text = 'The Options Text: Nothing';
				case 'Camera Follow':
					theOptionsText.text = 'The Options Text: value1 is character (dad, bf, gf)';
				case 'Box Color':
					theOptionsText.text = 'The Options Text: value1 is color in HEX';
				case 'Text Color':
					theOptionsText.text = 'The Options Text: value1 is color in HEX';
				case 'Camera Skake':
					theOptionsText.text = 'The Options Text: value1 is intensity, value2 is duration';
				case 'Change Box Size':
					theOptionsText.text = 'The Options Text: value1 is size in pixels';
				case 'Change Letter Size':
					theOptionsText.text = 'The Options Text: value1 is the scale';
				case 'Change Character Animation':
					theOptionsText.text = 'The Options Text: value1 is character (dad, bf, gf), value2 is the animation';
				case 'Set if Character singing':
					theOptionsText.text = 'The Options Text: value1 is character (dad, bf, gf), value2 is the Bool (true or false)';
				case 'Change Icon':
					theOptionsText.text = 'The Options Text: value1 is icon file name';
				case 'Change Sound':
					theOptionsText.text = 'The Options Text: value1 is sound file directory';
				case 'Change Font':
					theOptionsText.text = 'The Options Text: value1 is font folder directory in shared/robo';
				case 'Skip':
					theOptionsText.text = 'The Options Text: Nothing';
				case 'Do Hardcoded Event':
					theOptionsText.text = 'The Options Text: all values are codes';
			}
		}
		songBackSprite.makeGraphic(songBackSpriteWidth, 125, FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]));
		ccsongBackSprite.makeGraphic(ccsongBackSpriteWidth, 125, FlxColor.fromRGB(255,255,255));
		RobosongBackSprite.makeGraphic(RobosongBackSpriteWidth, 125, FlxColor.fromRGB(255,255,255));
		displaySongName.screenCenter(X);

		displaySongName.x -= songNameDistance;
		iconSongName.x = songNameDistance * 2 + 20 + displaySongName.x + displaySongName.width - 131;
		ccdisplaySongName.screenCenter(X);

		ccdisplaySongName.x -= ccsongNameDistance;
		cciconSongName.x = ccsongNameDistance * 2 + 20 + ccdisplaySongName.x + ccdisplaySongName.width - 131;
		RobodisplaySongName.screenCenter(X);

		RobodisplaySongName.x -= RobosongNameDistance;
		RoboiconSongName.x = RobosongNameDistance * 2 + 20 + RobodisplaySongName.x + RobodisplaySongName.width - 131;
		iconSongNameAgain.x = iconSongName.x - 50;
		iconSongNameAgain.y = iconSongName.y;
		cciconSongNameAgain.x = cciconSongName.x - 50;
		cciconSongNameAgain.y = cciconSongName.y;
		RoboiconSongNameAgain.x = RoboiconSongName.x - 50;
		RoboiconSongNameAgain.y = RoboiconSongName.y;

		camXAddition = 0;
		camYAddition = 0;
		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !endingSong && !isCameraOnForcedPos && !firstPersonMode)
		{
			if (PlayState.SONG.notes[Std.int(curStep / 16)].gfSection)
			{
				if (!gfAgainSinging)
				{
					if (gf.animation.curAnim.name.startsWith('singLEFT'))
						camXAddition -= theAddition;
					if (gf.animation.curAnim.name.startsWith('singRIGHT'))
						camXAddition += theAddition;
					if (gf.animation.curAnim.name.startsWith('singUP'))
						camYAddition -= theAddition;
					if (gf.animation.curAnim.name.startsWith('singDOWN'))
						camYAddition += theAddition;
					camFollow.set(gf.getMidpoint().x + camXAddition, gf.getMidpoint().y + camYAddition);
					camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
					camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
				}
				else
				{
					if (gfAgain.animation.curAnim.name.startsWith('singLEFT'))
						camXAddition -= theAddition;
					if (gfAgain.animation.curAnim.name.startsWith('singRIGHT'))
						camXAddition += theAddition;
					if (gfAgain.animation.curAnim.name.startsWith('singUP'))
						camYAddition -= theAddition;
					if (gfAgain.animation.curAnim.name.startsWith('singDOWN'))
						camYAddition += theAddition;
					camFollow.set(gfAgain.getMidpoint().x + camXAddition, gfAgain.getMidpoint().y + camYAddition);
					camFollow.x += gfAgain.cameraPosition[0] + girlfriendCameraOffset[0];
					camFollow.y += gfAgain.cameraPosition[1] + girlfriendCameraOffset[1];
				}
			}
			else
			{
				switch(curStage)
				{
					case 'auditorHell':
						if (tikturn)
						{
							if (dad.animation.curAnim.name.startsWith('singLEFT'))
								camXAddition -= theAddition;
							if (dad.animation.curAnim.name.startsWith('singRIGHT'))
								camXAddition += theAddition;
							if (dad.animation.curAnim.name.startsWith('singUP'))
								camYAddition -= theAddition;
							if (dad.animation.curAnim.name.startsWith('singDOWN'))
								camYAddition += theAddition;
							camFollow.set(dad.getMidpoint().x + 150 + camXAddition, dad.getMidpoint().y - 100 + camYAddition);
							camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
							camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
						}
						if (hatturn)
						{
							if (dadAgain1.animation.curAnim.name.startsWith('singLEFT'))
								camXAddition -= theAddition;
							if (dadAgain1.animation.curAnim.name.startsWith('singRIGHT'))
								camXAddition += theAddition;
							if (dadAgain1.animation.curAnim.name.startsWith('singUP'))
								camYAddition -= theAddition;
							if (dadAgain1.animation.curAnim.name.startsWith('singDOWN'))
								camYAddition += theAddition;
							camFollow.set(dadAgain1.getMidpoint().x + 150 + camXAddition, dadAgain1.getMidpoint().y - 100 + camYAddition);
							camFollow.x += dadAgain1.cameraPosition[0] + opponentAgainCameraOffset[0];
							camFollow.y += dadAgain1.cameraPosition[1] + opponentAgainCameraOffset[1];
						}
					default:
						switch (betadciuMoment)
						{
							case false:
								if (dad.animation.curAnim.name.startsWith('singLEFT'))
									camXAddition -= theAddition;
								if (dad.animation.curAnim.name.startsWith('singRIGHT'))
									camXAddition += theAddition;
								if (dad.animation.curAnim.name.startsWith('singUP'))
									camYAddition -= theAddition;
								if (dad.animation.curAnim.name.startsWith('singDOWN'))
									camYAddition += theAddition;
							default:
								if (dadBETADCIU.animation.curAnim.name.startsWith('singLEFT'))
									camXAddition -= theAddition;
								if (dadBETADCIU.animation.curAnim.name.startsWith('singRIGHT'))
									camXAddition += theAddition;
								if (dadBETADCIU.animation.curAnim.name.startsWith('singUP'))
									camYAddition -= theAddition;
								if (dadBETADCIU.animation.curAnim.name.startsWith('singDOWN'))
									camYAddition += theAddition;
						}
						if (!betadciucamera)
						{
							camFollow.set(dad.getMidpoint().x + 150 + camXAddition, dad.getMidpoint().y - 100 + camYAddition);
							camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
							camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
						}
						else
						{
							camFollow.set(dadBETADCIU.getMidpoint().x - 100 + camXAddition, dadBETADCIU.getMidpoint().y - 100 + camYAddition);
							camFollow.x -= dadBETADCIU.cameraPosition[0] - opponentCameraOffset[0];
							camFollow.y += dadBETADCIU.cameraPosition[1] + opponentCameraOffset[1];
						}
				}
			}
		}
		else if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !endingSong && !isCameraOnForcedPos && !firstPersonMode)
		{
			switch (betadciuMoment)
			{
				case false:
					if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
						camXAddition -= theAddition;
					if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
						camXAddition += theAddition;
					if (boyfriend.animation.curAnim.name.startsWith('singUP'))
						camYAddition -= theAddition;
					if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
						camYAddition += theAddition;
				default:
					if (boyfriendBETADCIU.animation.curAnim.name.startsWith('singLEFT'))
						camXAddition -= theAddition;
					if (boyfriendBETADCIU.animation.curAnim.name.startsWith('singRIGHT'))
						camXAddition += theAddition;
					if (boyfriendBETADCIU.animation.curAnim.name.startsWith('singUP'))
						camYAddition -= theAddition;
					if (boyfriendBETADCIU.animation.curAnim.name.startsWith('singDOWN'))
						camYAddition += theAddition;
			}
			if (!betadciucamera)
			{
				camFollow.set(boyfriend.getMidpoint().x - 100 + camXAddition, boyfriend.getMidpoint().y - 100 + camYAddition);
				camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
				camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];
			}
			else
			{
				camFollow.set(boyfriendBETADCIU.getMidpoint().x - 100 + camXAddition, boyfriendBETADCIU.getMidpoint().y - 100 + camYAddition);
				camFollow.x -= boyfriendBETADCIU.cameraPosition[0] - boyfriendCameraOffset[0];
				camFollow.y += boyfriendBETADCIU.cameraPosition[1] + boyfriendCameraOffset[1];
			}
		}
		else if (firstPersonMode)
		{
			if (dadBETADCIU.animation.curAnim.name.startsWith('singLEFT'))
				camXAddition -= theAddition;
			if (dadBETADCIU.animation.curAnim.name.startsWith('singRIGHT'))
				camXAddition += theAddition;
			if (dadBETADCIU.animation.curAnim.name.startsWith('singUP'))
				camYAddition -= theAddition;
			if (dadBETADCIU.animation.curAnim.name.startsWith('singDOWN'))
				camYAddition += theAddition;
			if (boyfriendBETADCIU.animation.curAnim.name.startsWith('singLEFT'))
				camXAddition -= theAddition;
			if (boyfriendBETADCIU.animation.curAnim.name.startsWith('singRIGHT'))
				camXAddition += theAddition;
			if (boyfriendBETADCIU.animation.curAnim.name.startsWith('singUP'))
				camYAddition -= theAddition;
			if (boyfriendBETADCIU.animation.curAnim.name.startsWith('singDOWN'))
				camYAddition += theAddition;
			camFollow.set(dad.getMidpoint().x + camXAddition, dad.getMidpoint().y + camYAddition);
			camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
			camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
		}

		switch (curStage)
		{
			case 'pegmeplease':
				if (curStep > 0)
					pillarsThing(funniRects, 0, 1, 600, false, 2, true, 25);
				if (curStep > 119)
					pillarsThing(moreRects, 1, 1, 600, false, 2, true, 25);
				if (curStep >= 1184 && curStep < 1193)
				{
					movePillars(moreRects, ((1192-curStep)/8)*15 + 5, aaaaaaaaclose);
					movePillars(funniRects, ((1192-curStep)/8)*-15 - 5 * 1/2, aaaaaaaaclose2);
				}
				else if (curStep >= 1312 && curStep < 1321)
				{
					movePillars(moreRects, ((1321-curStep)/8)*15 + 5, aaaaaaaaclose);
					movePillars(funniRects, ((1321-curStep)/8)*-15 - 5 * 1/2, aaaaaaaaclose2);
				}
				else
				{
					movePillars(moreRects, 5, aaaaaaaaclose);
					movePillars(funniRects, -5 * 1/2, aaaaaaaaclose2);
				}
		
			case 'auditorHell':
				pillarsThing(funniRects, 0, 1, 200, false, 4, true, 25);
				pillarsThing(moreRects, 1, 1, 200, false, 4, true, 25);
				if ((curStep >= 320 && curStep < 1632) || (curStep >= 2144 && curStep < 2656))
				{
					movePillars(moreRects, 10, aaaaaaaaclose);
					movePillars(funniRects, -10 * 1/2, aaaaaaaaclose2);
				}
				else if (curStep >= 1632 && curStep < 2128)
				{
					movePillars(moreRects, 30/((2127-curStep)/8), aaaaaaaaclose);
					movePillars(funniRects, -30/(((2127-curStep)/8)) * 1/2, aaaaaaaaclose2);
				}
				else if (curStep >= 2128 && curStep < 2144)
				{
					movePillars(moreRects, 30, aaaaaaaaclose);
					movePillars(funniRects, -30 * 1/2, aaaaaaaaclose2);
				}
				else
				{
					movePillars(moreRects, 5, aaaaaaaaclose);
					movePillars(funniRects, -5 * 1/2, aaaaaaaaclose2);
				}
				if (curBeat == 532 && curSong.toLowerCase() == "expurgation")
					dad.playAnim('Hank', true);

			case 'garAlley':
				pillarsThing(funniRects, 0, 1, 600, false, 3, true, 25);
				pillarsThing(moreRects, 1, 1, 600, false, 3, true, 25);
				movePillars(moreRects, 5, aaaaaaaaclose);
				movePillars(funniRects, -5 * 1/2, aaaaaaaaclose2);
			case 'knockout':
				if (stepCheck(1104, 1120) || stepCheck(1136, 1152) || stepCheck(1160, 1167))
					snapCamFollowToPos(dad.getMidpoint().x,dad.getMidpoint().y);
				if (stepCheck(1120, 1136) || stepCheck(1152, 1160))
					snapCamFollowToPos(boyfriend.getMidpoint().x,boyfriend.getMidpoint().y);
				pillarsThing(funniRects, 0, 1, 1400, false, 1, true, 25, true, 4);
				pillarsThing(moreRects, 1, 1, 1400, false, 1, true, 25, true, 4);
				movePillars(moreRects, 15, aaaaaaaaclose);
				movePillars(funniRects, -15 * 1/2, aaaaaaaaclose2);
			case 'jelly':
				if (stepCheck(-200, 1792))
				{
					camXAddition = 0;
					camYAddition = 0;
					if (dadAgain1Singing && dadAgain1.animation.curAnim.name.startsWith('singLEFT'))
						camXAddition -= theAddition;
					if (dadAgain1Singing && dadAgain1.animation.curAnim.name.startsWith('singRIGHT'))
						camXAddition += theAddition;
					if (dadAgain1Singing && dadAgain1.animation.curAnim.name.startsWith('singUP'))
						camYAddition -= theAddition;
					if (dadAgain1Singing && dadAgain1.animation.curAnim.name.startsWith('singDOWN'))
						camYAddition += theAddition;
					if (dadAgain1Singing && dadAgain1.animation.curAnim.name.startsWith('singLEFT'))
						camXAddition -= theAddition;
					if (dad.animation.curAnim.name.startsWith('singRIGHT'))
						camXAddition += theAddition;
					if (dad.animation.curAnim.name.startsWith('singUP'))
						camYAddition -= theAddition;
					if (dad.animation.curAnim.name.startsWith('singDOWN'))
						camYAddition += theAddition;
					if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
						camXAddition -= theAddition;
					if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
						camXAddition += theAddition;
					if (boyfriend.animation.curAnim.name.startsWith('singUP'))
						camYAddition -= theAddition;
					if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
						camYAddition += theAddition;
					if (camXAddition > 30)
						camXAddition = 30;
					if (camXAddition < -30)
						camXAddition = -30;
					if (camYAddition > 30)
						camYAddition = 30;
					if (camYAddition < -30)
						camYAddition = -30;
					camFollow.set(1035 + camXAddition, 541.5 + camYAddition);
				}
				else if (stepCheck(2030, 2105))
					{
						camXAddition = 0;
						camYAddition = 0;
						if (dadAgain1Singing && dadAgain1.animation.curAnim.name.startsWith('singLEFT'))
							camXAddition -= theAddition;
						if (dadAgain1Singing && dadAgain1.animation.curAnim.name.startsWith('singRIGHT'))
							camXAddition += theAddition;
						if (dadAgain1Singing && dadAgain1.animation.curAnim.name.startsWith('singUP'))
							camYAddition -= theAddition;
						if (dadAgain1Singing && dadAgain1.animation.curAnim.name.startsWith('singDOWN'))
							camYAddition += theAddition;
						if (dadAgain1Singing && dadAgain1.animation.curAnim.name.startsWith('singLEFT'))
							camXAddition -= theAddition;
						if (dad.animation.curAnim.name.startsWith('singRIGHT'))
							camXAddition += theAddition;
						if (dad.animation.curAnim.name.startsWith('singUP'))
							camYAddition -= theAddition;
						if (dad.animation.curAnim.name.startsWith('singDOWN'))
							camYAddition += theAddition;
						if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
							camXAddition -= theAddition;
						if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
							camXAddition += theAddition;
						if (boyfriend.animation.curAnim.name.startsWith('singUP'))
							camYAddition -= theAddition;
						if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
							camYAddition += theAddition;
						if (camXAddition > 30)
							camXAddition = 30;
						if (camXAddition < -30)
							camXAddition = -30;
						if (camYAddition > 30)
							camYAddition = 30;
						if (camYAddition < -30)
							camYAddition = -30;
						camFollow.set(1200 + camXAddition, 500 + camYAddition);
					}

				
		}
		/*if (FlxG.keys.justPressed.NINE)
		{
			iconP1.swapOldIcon();
		}*/
		//spinPillars(moreRects, 1000, 0.01, 1, gf.x);
		//pillarsThing(moreRects, 1, 0, -1200, false);

		callOnLuas('onUpdate', [elapsed]);

		switch (curStage)
		{
			case 'schoolEvil':
				if(!ClientPrefs.lowQuality && bgGhouls.animation.curAnim.finished) {
					bgGhouls.visible = false;
				}
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed * 1.5;
			case 'limo':
				if(!ClientPrefs.lowQuality) {
					grpLimoParticles.forEach(function(spr:BGSprite) {
						if(spr.animation.curAnim.finished) {
							spr.kill();
							grpLimoParticles.remove(spr, true);
							spr.destroy();
						}
					});

					switch(limoKillingState) {
						case 1:
							limoMetalPole.x += 5000 * elapsed;
							limoLight.x = limoMetalPole.x - 180;
							limoCorpse.x = limoLight.x - 50;
							limoCorpseTwo.x = limoLight.x + 35;

							var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
							for (i in 0...dancers.length) {
								if(dancers[i].x < FlxG.width * 1.5 && limoLight.x > (370 * i) + 130) {
									switch(i) {
										case 0 | 3:
											if(i == 0) FlxG.sound.play(Paths.sound('dancerdeath'), 0.5);

											var diffStr:String = i == 3 ? ' 2 ' : ' ';
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 200, dancers[i].y, 0.4, 0.4, ['hench leg spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 160, dancers[i].y + 200, 0.4, 0.4, ['hench arm spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x, dancers[i].y + 50, 0.4, 0.4, ['hench head spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);

											var particle:BGSprite = new BGSprite('gore/stupidBlood', dancers[i].x - 110, dancers[i].y + 20, 0.4, 0.4, ['blood'], false);
											particle.flipX = true;
											particle.angle = -57.5;
											grpLimoParticles.add(particle);
										case 1:
											limoCorpse.visible = true;
										case 2:
											limoCorpseTwo.visible = true;
									} //Note: Nobody cares about the fifth dancer because he is mostly hidden offscreen :(
									dancers[i].x += FlxG.width * 2;
								}
							}

							if(limoMetalPole.x > FlxG.width * 2) {
								resetLimoKill();
								limoSpeed = 800;
								limoKillingState = 2;
							}

						case 2:
							limoSpeed -= 4000 * elapsed;
							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x > FlxG.width * 1.5) {
								limoSpeed = 3000;
								limoKillingState = 3;
							}

						case 3:
							limoSpeed -= 2000 * elapsed;
							if(limoSpeed < 1000) limoSpeed = 1000;

							bgLimo.x -= limoSpeed * elapsed;
							if(bgLimo.x < -275) {
								limoKillingState = 4;
								limoSpeed = 800;
							}

						case 4:
							bgLimo.x = FlxMath.lerp(bgLimo.x, -150, CoolUtil.boundTo(elapsed * 9, 0, 1));
							if(Math.round(bgLimo.x) == -150) {
								bgLimo.x = -150;
								limoKillingState = 0;
							}
					}

					if(limoKillingState > 2) {
						var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
						for (i in 0...dancers.length) {
							dancers[i].x = (370 * i) + bgLimo.x + 280;
						}
					}
				}
			case 'mall':
				if(heyTimer > 0) {
					heyTimer -= elapsed;
					if(heyTimer <= 0) {
						bottomBoppers.dance(true);
						heyTimer = 0;
					}
				}
			case 'auditorHell':
				if (curBeat % 8 == 4 && beatOfFuck != curBeat)
				{
					beatOfFuck = curBeat;
					doClone(FlxG.random.int(0, 1));
				}
		}

		switch (curStage)
		{
			case 'knockout':
				//trace(camXAddition);
				if (camFollow.x < 710 && !firstPersonMode)
					camFollow.x = 710 + camXAddition;
				//if (camFollow.x > 1100)
					//camFollow.x = 1100;
				//if (camFollow.y > 1400)
					//camFollow.y = 1400;
		}

		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			if(!startingSong && !endingSong && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
		}

		super.update(elapsed);
		if (dialogueEditing)
		{
			var theNOOOOOOOO = false;
			var inputTexts:Array<FlxUIInputText> = [senteneceInputText, characterInputText, valueInputText1, valueInputText2, valueInputText3];
			for (i in 0...inputTexts.length) {
				if(inputTexts[i].hasFocus) {
					theNOOOOOOOO = true;
					FlxG.debugger.toggleKeys = [F2];
					if(FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.V && Clipboard.text != null) { //Copy paste
						inputTexts[i].text = ClipboardAdd(inputTexts[i].text);
						inputTexts[i].caretIndex = inputTexts[i].text.length;
						getEvent(FlxUIInputText.CHANGE_EVENT, inputTexts[i], null, []);
					}
					if(FlxG.keys.justPressed.ENTER) {
						inputTexts[i].hasFocus = false;
					}
					FlxG.sound.muteKeys = [];
					FlxG.sound.volumeDownKeys = [];
					FlxG.sound.volumeUpKeys = [];
					super.update(elapsed);
					return;
				}
			}
			if (!theNOOOOOOOO)
				FlxG.debugger.toggleKeys = [F2, GRAVEACCENT, BACKSLASH];

		}

		if(ratingName == '?') {
			scoreTxt.text = 'Score: ' + songScore + ' | Misses: ' + songMisses + ' | Rating: ' + ratingName;
		} else {
			scoreTxt.text = 'Score: ' + songScore + ' | Misses: ' + songMisses + ' | Rating: ' + ratingName + ' (' + Highscore.floorDecimal(ratingPercent * 100, 2) + '%)' + ' - ' + ratingFC;//peeps wanted no integer rating
		}

		if(botplayTxt.visible) {
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}

		if (controls.PAUSE && startedCountdown && canPause)
		{
			var ret:Dynamic = callOnLuas('onPause', []);
			if(ret != FunkinLua.Function_Stop) {
				if (cupheadShooting)
					wasShooting = true;
				cupheadShooting = false;
				if(roborobotimer != null)
					roborobotimer.active = false;
				if(circleTween != null)
					circleTween.active = false;
				if(chromaticTween != null)
					chromaticTween.active = false;
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

				// 1 / 1000 chance for Gitaroo Man easter egg
				/*if (FlxG.random.bool(0.1))
				{
					// gitaroo man easter egg
					cancelMusicFadeTween();
					MusicBeatState.switchState(new GitarooPause());
				}
				else {*/
				if(FlxG.sound.music != null) {
					FlxG.sound.music.pause();
					vocals.pause();
				}
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				//}
		
				#if desktop
				DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
			}
		}

		if (FlxG.keys.anyJustPressed(debugKeysChart) && !endingSong && !inCutscene && !dialogueEditing)
		{
			openChartEditor();
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP1.scale.set(mult, mult);
		iconP1.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP1Again.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP1Again.scale.set(mult, mult);
		iconP1Again.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP2.scale.set(mult, mult);
		iconP2.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2Again1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP2Again1.scale.set(mult, mult);
		iconP2Again1.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2Again2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP2Again2.scale.set(mult, mult);
		iconP2Again2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * iconP2.scale.x) / 2 - iconOffset * 2;

		iconP2Again1.x = iconP2.x - iconDistance;
		iconP2Again2.x = iconP2.x - iconDistance/2;
		iconP2Again2.y = iconP2.y - iconP2Again2.height/2 + iconDistance2;
		iconP1Again.x = iconP1.x + iconDistance;

		if (health > maxHealth)
			health = maxHealth;


		if (healthBar.percent < 20)
		{
			iconP1.animation.curAnim.curFrame = 1;
			iconP1Again.animation.curAnim.curFrame = 1;
		}
		else
		{
			iconP1.animation.curAnim.curFrame = 0;
			iconP1Again.animation.curAnim.curFrame = 0;
		}
		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;
		if (healthBar.percent > 80)
		{
			iconP2.animation.curAnim.curFrame = 1;
			iconP2Again1.animation.curAnim.curFrame = 1;
			iconP2Again2.animation.curAnim.curFrame = 1;
		}
		else
		{
			iconP2.animation.curAnim.curFrame = 0;
			iconP2Again1.animation.curAnim.curFrame = 0;
			iconP2Again2.animation.curAnim.curFrame = 0;
		}

		if (FlxG.keys.anyJustPressed(debugKeysCharacter) && !endingSong && !inCutscene) {
			persistentUpdate = false;
			paused = true;
			cancelMusicFadeTween();
			MusicBeatState.switchState(new CharacterEditorState(SONG.player2));
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if(updateTime) {
					var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var songCalc:Float = (songLength - curTime);
					if(ClientPrefs.timeBarType == 'Time Elapsed') songCalc = curTime;

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					if(ClientPrefs.timeBarType != 'Song Name')
						timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		FlxG.watch.addQuick("camfollowX", camFollow.x);
		FlxG.watch.addQuick("camfollowY", camFollow.y);

		// RESET = Quick Game Over Screen
		if (!ClientPrefs.noReset && controls.RESET && !inCutscene && !endingSong)
		{
			health = 0;
			trace("RESET = True");
		}
		doDeathCheck();

		if (unspawnNotes[0] != null)
		{
			var time:Float = 3000;//shit be werid on 4:3
			if(songSpeed < 1) time /= songSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}
		if (spookyRendered) // move shit around all spooky like
		{
			spookyText.angle = FlxG.random.int(-5, 5); // change its angle between -5 and 5 so it starts shaking violently.
			// tstatic.x = tstatic.x + FlxG.random.int(-2,2); // move it back and fourth to repersent shaking.
			if (tstatic.alpha != 0)
				tstatic.alpha = FlxG.random.float(0.1, 0.5); // change le alpha too :)
		}

		if (generatedMusic)
		{
			if (!inCutscene) {
				if(!cpuControlled && !roboRoboPerkActivated) {
					keyShit();
				} else
				{
					if(boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.dance();
					if(boyfriendAgain.holdTimer > Conductor.stepCrochet * 0.001 * boyfriendAgain.singDuration && boyfriendAgain.animation.curAnim.name.startsWith('sing') && !boyfriendAgain.animation.curAnim.name.endsWith('miss'))
						boyfriendAgain.dance();
					if(boyfriendBETADCIU.holdTimer > Conductor.stepCrochet * 0.001 * boyfriendBETADCIU.singDuration && boyfriendBETADCIU.animation.curAnim.name.startsWith('sing') && !boyfriendBETADCIU.animation.curAnim.name.endsWith('miss'))
						boyfriendBETADCIU.dance();
					//boyfriend.animation.curAnim.finish();
				}
			}
			if (spookyRendered) // move shit around all spooky like
			{
				spookyText.angle = FlxG.random.int(-5, 5); // change its angle between -5 and 5 so it starts shaking violently.
				// tstatic.x = tstatic.x + FlxG.random.int(-2,2); // move it back and fourth to repersent shaking.
				if (tstatic.alpha != 0)
					tstatic.alpha = FlxG.random.float(0.1, 0.5); // change le alpha too :)
			}

			var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
				if(!daNote.mustPress) strumGroup = opponentStrums;

				var strumX:Float = strumGroup.members[daNote.noteData].x;
				var strumY:Float = strumGroup.members[daNote.noteData].y;
				var strumAngle:Float = strumGroup.members[daNote.noteData].angle;
				var strumDirection:Float = strumGroup.members[daNote.noteData].direction;
				var strumAlpha:Float = strumGroup.members[daNote.noteData].alpha;
				var strumScroll:Bool = strumGroup.members[daNote.noteData].downScroll;

				strumX += daNote.offsetX;
				strumY += daNote.offsetY;
				strumAngle += daNote.offsetAngle;
				strumAlpha *= daNote.multAlpha;

				if (strumScroll) //Downscroll
				{
					//daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
					daNote.distance = (0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
				}
				else //Upscroll
				{
					//daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
					daNote.distance = (-0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
				}

				var angleDir = strumDirection * Math.PI / 180;
				if (daNote.copyAngle)
					daNote.angle = strumDirection - 90 + strumAngle;

				if(daNote.copyAlpha)
					daNote.alpha = strumAlpha;
				
				if(daNote.copyX)
					daNote.x = strumX + Math.cos(angleDir) * daNote.distance + daNote.xOffsetFunni;

				if(daNote.copyY)
				{
					daNote.y = strumY + Math.sin(angleDir) * daNote.distance;

					//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
					if(strumScroll && daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith('end')) {
							daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * songSpeed + (46 * (songSpeed - 1));
							daNote.y -= 46 * (1 - (fakeCrochet / 600)) * songSpeed;
							if(PlayState.isPixelStage) {
								daNote.y += 8 + (6 - daNote.originalHeightForCalcs) * PlayState.daPixelZoom;
							} else {
								daNote.y -= 19;
							}
						} 
						daNote.y += (Note.swagWidth / 2) - (60.5 * (songSpeed - 1));
						daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (songSpeed - 1);
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
				{
					opponentNoteHit(daNote);
				}

				if(daNote.mustPress && (cpuControlled || roboRoboPerkActivated)) {
					if(daNote.isSustainNote) {
						if(daNote.canBeHit) {
							if (!crossed[daNote.noteData])
								goodNoteHit(daNote);
						}
					} else if(daNote.strumTime <= Conductor.songPosition || (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress)) {
						if (!crossed[daNote.noteData])
							goodNoteHit(daNote);
					}
				}
				
				var center:Float = strumY + Note.swagWidth / 2;
				if(strumGroup.members[daNote.noteData].sustainReduce && daNote.isSustainNote && (daNote.mustPress || !daNote.ignoreNote) &&
					(!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					if (strumScroll)
					{
						if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
							swagRect.height = (center - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;

							daNote.clipRect = swagRect;
						}
					}
					else
					{
						if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
							swagRect.y = (center - daNote.y) / daNote.scale.y;
							swagRect.height -= swagRect.y;

							daNote.clipRect = swagRect;
						}
					}
				}

				// Kill extremely late notes and cause misses
				if (Conductor.songPosition > noteKillOffset + daNote.strumTime)
				{
					if (daNote.mustPress && !cpuControlled && !roboRoboPerkActivated &&!daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit)) {
						noteMiss(daNote);
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
		checkEventNote();
		
		#if debug
		if(!endingSong && !startingSong) {
			if (FlxG.keys.justPressed.ONE) {
				KillNotes();
				FlxG.sound.music.onComplete();
			}
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				setSongTime(Conductor.songPosition + 10000);
				clearNotesBefore(Conductor.songPosition);
			}
		}
		#end

		dumbasstext.visible = false;
		switch(curStage)
		{
			case 'pegmeplease':
				dad.x = 200 + Math.cos(rotTime / 50 * rotSpd) * 80 * rotXLen;
				dad.y = 200 + Math.sin(rotTime / 40 * rotSpd) * 80 * rotLen;
				rotTime ++;
				if (curBeat < rotBeat)
				{
					defaultCamZoom = 0.8;
				}
				else if (curBeat < rotUpBeat)
				{
					rotLen += (1 - rotLen) / 12;
					defaultCamZoom = 0.75;
					rotSpd = 1.2;
				}
				else if (curBeat < rotEndBeat)
				{
					rotSpd = 1.7;
					rotLen += (0.75 - rotLen) / 12;
					rotXLen += (0.6 - rotXLen) / 12;
					defaultCamZoom = 0.7;
				}
				else
				{
					rotLen += (0.2 - rotLen) / 12;
					rotXLen += (0 - rotXLen) / 12;
					rotSpd = 0.8;
					defaultCamZoom = 0.8;
				}

				boyfriend.x = 1500 - Math.cos(rotTime / 50 * rotSpd) * 80 * rotXLen;
				boyfriend.y = 0 + Math.sin(rotTime / 40 * rotSpd) * 80 * rotLen;
		
				if ((curBeat < rotEndBeat) && !(curBeat < rotBeat) && !(curBeat < rotUpBeat))
					dumbasstext.visible = true;
				gf.x = 650 - Math.sin(rotTime / 40 * rotSpd) * 80 * rotLen;
				gf.y = 350 + Math.cos(rotTime / 50 * rotSpd) * 80 * rotXLen;
				dumbasstext.x = gf.x + 351.5 - dumbasstext.width/2;
				dumbasstext.y = gf.y - 20;
			case 'auditorHell':
				if (exSpikes.animation.frameIndex >= 3 && dad.animation.curAnim.name == 'singUP')
				{
					//trace('paused');
					exSpikes.animation.pause();
				}
				if (hatSpikes.animation.frameIndex >= 4 && dadAgain1.animation.curAnim.name == 'singUP')
				{
					//trace('paused');
					hatSpikes.animation.pause();
				}
		}
		setOnLuas('cameraX', camFollowPos.x);
		setOnLuas('cameraY', camFollowPos.y);
		setOnLuas('botPlay', cpuControlled);
		callOnLuas('onUpdatePost', [elapsed]);
		camHUDier.zoom = camHUD.zoom;

		for (i in shaderUpdates)
		{
			i(elapsed);
		}
		if (dadAgain2.flying)
			dadAgain2.y += Math.sin(floatyFloat);
	}

	function openChartEditor()
	{
		persistentUpdate = false;
		paused = true;
		cancelMusicFadeTween();
		MusicBeatState.switchState(new ChartingState());
		chartingMode = true;

		#if desktop
		DiscordClient.changePresence("Chart Editor", null, null, true);
		#end
	}
	var thej:FlxSprite;
	public function cardJ() {
		var dumb = CoolUtil.coolTextFile(Paths.txt('dumb'));
		remove(thej);
		thej = new FlxSprite(1050, 550 + 147);
		thej.frames = Paths.getSparrowAtlas('knockout/shootstuff/superCard');
		thej.animation.addByPrefix('filled', 'Card Filled instance 1', 24, false);
		thej.animation.addByPrefix('parry', 'PARRY Card Pop out  instance 1', 24, false);
		thej.animation.addByPrefix('normal', 'Card Normal Pop out instance 1', 24, false);
		thej.animation.addByPrefix('used', 'Card Used instance 1', 24, false);
		thej.animation.addByPrefix('flipped', 'Card but flipped instance 1', 24, false);
		thej.animation.play('flipped');
		add(thej);
		thej.cameras = [camHUD];
		thej.animation.play(dumb[0]);
		thej.y = superCard.y - Std.parseFloat(dumb[1]);
		thej.x = superCard.x - Std.parseFloat(dumb[2]);
	}

	var shotType:String = '';
	public function cupheadShootAShot(isBlue:Bool = true)
	{
		if (isBlue)
		{
			var shot = new Shot(dadBETADCIU.x  + 400, dadBETADCIU.y - 220 + FlxG.random.float(-30, 30));
			add(shot);
			dadBETADCIU.playAnim('DIE');
			dadBETADCIU.specialAnim = true;
			cupheadShooting = true;
		}
		else
		{
			var shot = new ShotGreen(dadBETADCIU.x  + 400, dadBETADCIU.y - 70);
			add(shot);
		}
	}

	var ankhaLetter:Int = 0;
	public function cupheadShootAShotAnkha(isBlue:Bool = true)
	{
		if (isBlue)
		{
			var shot = new ShotAnkha(dad.x + 400, dad.y + 330 + FlxG.random.float(-30, 30), ankhaLetter);
			add(shot);
			dad.playAnim('DIE');
			dad.specialAnim = true;
		}
		else
		{
			var shot = new ShotGreenAnkha(dad.x  + 400, dad.y + 330, ankhaLetter);
			add(shot);
		}
		ankhaLetter--;
		if (ankhaLetter <= 0)
			ankhaLetter = 5;
	}
	public function cupheadShootAShotFur(isBlue:Bool = true)
	{
		if (isBlue)
		{
			var shot = new ShotRecolored(dad.x + 400, dad.y + 100 + FlxG.random.float(-30, 30));
			add(shot);
			dad.playAnim('singRIGHT', true);
			dad.specialAnim = true;
		}
		else
		{
			var shot = new ShotGreenAnkha(dad.x  + 400, dad.y + 330, ankhaLetter);
			add(shot);
		}
	}
	public function cupheadShootAShotTiky(isBlue:Bool = true)
	{
		if (isBlue)
		{
			var shot = new ShotRecolored(dad.x + 500, dad.y + 100 + FlxG.random.float(-30, 30), FlxColor.RED);
			add(shot);
			dad.playAnim('Hank', true);
			dad.specialAnim = true;
		}
		else
		{
			var shot = new ShotGreenAnkha(dad.x  + 400, dad.y + 330, ankhaLetter);
			add(shot);
		}
	}
	public function cupheadShootAShotSusan(isBlue:Bool = true)
	{
		if (isBlue)
		{
			var shot = new ShotSusan(gfAgain.x  + 200 + FlxG.random.float(-10, 10), gfAgain.y - 360 + FlxG.random.float(-10, 10), FlxColor.CYAN);
			add(shot);
			gfAgain.playAnim('DIE', true);
			gfAgain.specialAnim = true;
		}
		else
		{
			var shot = new ShotGreenSusan(gfAgain.x  + 200, gfAgain.y + 20, FlxColor.LIME);
			add(shot);
		}
		ankhaLetter++;
	}
	public function cupheadShootAShotSamantha(isBlue:Bool = true)
	{
		var dumb = CoolUtil.coolTextFile(Paths.txt('dumb'));
		if (isBlue)
		{
			var shot = new Shot(dad.x  + 400, dad.y - 420 + FlxG.random.float(-30, 30));
			shot.angle = 0;
			shot.color = FlxColor.BLACK;
			shot.doNot = true;
			add(shot);
			dad.playAnim('singUP', true);
			dad.specialAnim = true;
		}
		else
		{
			var shot = new ShotGreen(dad.x + 100, dad.y - 180);
			shot.color = FlxColor.RED;
			shot.setGraphicSize(Std.int(shot.width * 2), Std.int(shot.height));
			shot.angle = 4;
			shot.doNot = true;
			add(shot);
		}
	}
	public function cupheadShootAShotSunky(isBlue:Bool = true)
	{
		if (isBlue)
		{
			var shot = new ShotSunk(dad.x + 500, dad.y + FlxG.random.float(-30, 30));
			add(shot);
			dad.specialAnim = true;
		}
		else
		{
			var shot = new ShotGreenSunk(dad.x  + 400, dad.y + 150);
			add(shot);
		}
	}
	public function cupheadShootAShotWell(isBlue:Bool = true)
	{
		if (isBlue)
		{
			var shot = new ShotSusan(gfAgain.x  + 200 + FlxG.random.float(-10, 10), gfAgain.y - 360 + FlxG.random.float(-10, 10), FlxColor.CYAN);
			add(shot);
			gfAgain.playAnim('DIE', true);
			gfAgain.specialAnim = true;
		}
		else
		{
			var shot = new ShotGreenWell(dad.x  + 200, dad.y + 320);
			add(shot);
		}
	}
	public function cupheadShootAShotYuri(isBlue:Bool = true)
	{
		if (isBlue)
		{
			var shot = new ShotSusan(gfAgain.x  + 200 + FlxG.random.float(-10, 10), gfAgain.y - 360 + FlxG.random.float(-10, 10), FlxColor.CYAN);
			add(shot);
			gfAgain.playAnim('DIE', true);
			gfAgain.specialAnim = true;
		}
		else
		{
			var shot = new ShotGreenYuri(dad.x  + 200, dad.y + 320);
			add(shot);
		}
	}
	public function cupheadShootAShotSelever(isBlue:Bool = true)
	{
		if (isBlue)
		{
			var shot = new ShotSusan(gfAgain.x  + 200 + FlxG.random.float(-10, 10), gfAgain.y - 360 + FlxG.random.float(-10, 10), FlxColor.CYAN);
			add(shot);
			gfAgain.playAnim('DIE', true);
			gfAgain.specialAnim = true;
		}
		else
		{
			var shot = new ShotGreenSelever(dad.x  + 200, dad.y + 190);
			add(shot);
		}
	}
	public function cupheadShootAShotRose(isBlue:Bool = true)
	{
		if (isBlue)
		{
			var shot = new ShotSusan(gfAgain.x  + 200 + FlxG.random.float(-10, 10), gfAgain.y - 360 + FlxG.random.float(-10, 10), FlxColor.CYAN);
			add(shot);
			gfAgain.playAnim('DIE', true);
			gfAgain.specialAnim = true;
		}
		else
		{
			var shot = new ShotGreenRose(dad.x  + 200, dad.y + 190);
			add(shot);
		}
	}

	public function cupheadAlert()
	{
		FlxG.sound.play(Paths.sound('knockout/shootfunni/himoro'));
		warning.visible = true;
		if (!ClientPrefs.downScroll)
		{
			remove(warning);
			warning.frames = Paths.getSparrowAtlas('knockout/shootstuff/upscroll');
			warning.animation.addByPrefix('WARNING', 'YTJT instance 1', 24, false);
			warning.cameras = [camHUD];
			warning.animation.play('WARNING');
			add(warning);
		}
		else
		{
			remove(warning);
			warning.y = 110;
			warning.frames = Paths.getSparrowAtlas('knockout/shootstuff/downscroll');
			warning.animation.addByPrefix('WARNING', 'YTJT instance 1', 24, false);
			warning.cameras = [camHUD];
			warning.animation.play('WARNING');
			add(warning);
		}
	}
	public function cupheadShoot()
	{




		chromaticTween = FlxTween.tween(this, {funniNumberForChrome: 0.09}, 0.2, {
			ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween) {

				chromaticTween = FlxTween.tween(this, {funniNumberForChrome: defaultChromNumber}, 0.2, {
					ease: FlxEase.quadInOut,
					onUpdate: function(twn:FlxTween) {
						if (!ClientPrefs.shaders)
							chromaticShader.setChrome(funniNumberForChrome);
					}
				});

			},
			onUpdate: function(twn:FlxTween) {
				if (!ClientPrefs.shaders)
					chromaticShader.setChrome(funniNumberForChrome);
			}
		});


		superMove = true;
		superCuphead.x = dadBETADCIU.x - 500;
		superCuphead.y = dadBETADCIU.y - 125;
		switch (dad.curCharacter)
		{
			case 'extiky':
				superCupheadTiky.x = dadBETADCIU.x - 2100;
				superCupheadTiky.y = dadBETADCIU.y - 125;
				superCupheadTiky.angle = 0;
		}
		FlxG.sound.play(Paths.sound('knockout/shootfunni/super'));
		var dumb = CoolUtil.coolTextFile(Paths.txt('dumb'));
		superHitBox.alpha = 0;
		bfHitBox.alpha = 0;
		/* hitbox for super
		x + 520
		y + 100
		width 660
		height 300
		*/
	}

	public function cupheadShootCircle()
	{


		remove(superCircleCuphead);
		remove(sunkLoop);
		remove(sansBone);
		insert(this.members.indexOf(boyfriendGroup) - 1, superCircleCuphead);
		insert(this.members.indexOf(boyfriendGroup) - 1, sunkLoop);
		insert(this.members.indexOf(boyfriendGroup) - 1, sansBone);

		circleTween = FlxTween.tween(superCircleCuphead, {x: boyfriend.x + 600}, 2, {
			ease: FlxEase.quadOut,
			onComplete: function(twn:FlxTween) {
				
				picoShoot = false;
				bfDodgin = false;
				dodge.animation.play('idle');
				remove(superCircleCuphead);
				remove(sunkLoop	);
				remove( sansBone);
				insert(this.members.indexOf(boyfriendBETADCIU) + 1, superCircleCuphead);
				insert(this.members.indexOf(boyfriendBETADCIU) + 1, sunkLoop);
				insert(this.members.indexOf(boyfriendBETADCIU) + 1, sansBone);

				circleTween = FlxTween.tween(superCircleCuphead, {x: -700}, 2.5, {
					ease: FlxEase.quadIn,
					onComplete: function(twn:FlxTween) {
						superMove = false;
						sunkLoop.visible = false;
						sansBone.visible = false;
					}
				});

			},
			onUpdate: function(twn:FlxTween) {
				if (!ClientPrefs.shaders)
					chromaticShader.setChrome(funniNumberForChrome);
			}
		});
		chromaticTween = FlxTween.tween(this, {funniNumberForChrome: 0.09}, 0.2, {
			ease: FlxEase.quadInOut,
			onComplete: function(twn:FlxTween) {

				chromaticTween = FlxTween.tween(this, {funniNumberForChrome: defaultChromNumber}, 0.2, {
					ease: FlxEase.quadInOut,
					onUpdate: function(twn:FlxTween) {
						if (!ClientPrefs.shaders)
							chromaticShader.setChrome(funniNumberForChrome);
					}
				});

			},
			onUpdate: function(twn:FlxTween) {
				if (!ClientPrefs.shaders)
					chromaticShader.setChrome(funniNumberForChrome);
			}
		});


		superMove = true;
		superCircleCuphead.x = dadBETADCIU.x + 50;
		superCircleCuphead.y = dadBETADCIU.y - 25;
		FlxG.sound.play(Paths.sound('knockout/shootfunni/super'));
		var dumb = CoolUtil.coolTextFile(Paths.txt('dumb'));
		superCircleHitBox.alpha = 0;
		bfHitBox.alpha = 0;
		trace(Std.parseFloat(dumb[0]));
		trace(Std.parseFloat(dumb[1]));
		trace(Std.parseFloat(dumb[2]));
		trace(Std.parseFloat(dumb[3]));
		/* hitbox for super
		x + 520
		y + 100
		width 660
		height 300
		*/
	}

	public function flashScreen(color:FlxColor, time:Float) {
		var flashSprite:FlxSprite = new FlxSprite(0, 0).makeGraphic(1280, 720, color);
		flashSprite.cameras = [camHUDier];
		add(flashSprite);
		FlxTween.tween(flashSprite, {alpha: 0}, time, {
			onComplete: function(twn:FlxTween)
			{
				remove(flashSprite);
			}
		});
	}

	public var isDead:Bool = false; //Don't mess with this on Lua!!!
	function doDeathCheck(?skipHealthCheck:Bool = false) {
		if (boyfriend.curCharacter.startsWith('rose')) return false;
		if (((skipHealthCheck && instakillOnMiss) || health <= 0) && !practiceMode && !isDead)
		{
			if (!dedbutnot && FlxG.save.data.equipped.contains('extra life'))
			{
				var oldmaxHealth = maxHealth;
				maxHealth /= 2;
				health = maxHealth;
				healthBarBG.scale.set(healthBarBG.scale.x * 0.5, 1);
				healthBarBGKnock.scale.set(healthBarBGKnock.scale.x * 0.5, 1);
				healthBarBG.screenCenter(X);
				remove(healthBar);
				healthBar = new FlxBar((healthBarBG.x + healthBarBG.width)/2  + 22, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int((healthBarBG.width)/2 - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, maxHealth);
				reloadHealthBarColors();
				healthBar.cameras = [camHUD];
				healthBar.scrollFactor.set();
				add(healthBar);
				healthBar.screenCenter(X);
				healthBar.x += 3;
				for (i in 0...FlxG.save.data.equipped.length)
				{
					if (perks.members[i].type == 'extra life')
						perks.members[i].fly();
				}
				FlxG.sound.play(Paths.sound('OUCH'), 1);
				FlxG.camera.shake(0.01,0.1);
				camHUD.shake(0.1,0.1);
				camHUDier.shake(0.1,0.1);
				camHUD.color = 0xffc5c5;
				camHUDier.color = 0xffc5c5;
				return dedbutnot = true;
			}
			cupheadShooting = false;
			var ret:Dynamic = callOnLuas('onGameOver', []);
			if(ret != FunkinLua.Function_Stop) {
				boyfriend.stunned = true;
				deathCounter++;

				paused = true;

				vocals.stop();

				persistentUpdate = false;
				for (tween in modchartTweens) {
					tween.active = true;
				}
				for (timer in modchartTimers) {
					timer.active = true;
				}

				if (curStage == 'auditorHell')
				{
					openSubState(new GameOverSubstateTiky());
					persistentDraw = false;
					FlxG.sound.music.stop();
				}
				else
				{
					if (!betadciuMoment)
					{
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x - boyfriend.positionArray[0], boyfriend.getScreenPosition().y - boyfriend.positionArray[1], camFollowPos.x, camFollowPos.y));
						persistentDraw = false;
						FlxG.sound.music.stop();
					}
					else
					{
						switch (curStage)
						{
							case 'knockout':
								var quote = "We haven't even started,\nyet you smell like you farded.";
								var image = "2";
								FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.quartInOut});
								FlxTween.tween(camHUDier, {alpha: 0}, 1, {ease: FlxEase.quadIn});
								
								persistentDraw = true;
								boyfriendBETADCIU.visible = false;
								boyfriend.visible = false;
								switch (dad.curCharacter)
								{
									case 'sky-mad':
										quote = "I'll kill your girlfriend like the rest,\ntime to join the manifest.";
										image = "_sky";
									case 'majin':
										if (dadAgain2.visible)
										{
											if (dadAgain1.visible)
											{
												quote = "The ultimate trio shines with energy,\ntwo hedgehogs and a robot\nwith high levels of synergy.";
												image = "_fleetmajinhex";
											}
											else
											{
												quote = "Richard Elson has visited,\nHe told us your fun was limited!";
												image = "_fleetmajin";
											}
										}
										else
										{
											quote = "We aren't even done!\nLet's enjoy the rest of our infinite fun.";
											image = "_majin";
										}
									case 'ankha':
										quote = "I won't bore you with the specifics\njust read the hieroglyphics.";
										image = "_ankha";
									case 'furscorns':
										quote = "You’re dead? How shocking.\nIn this battle I’m Toppin’.";
										image = "_furscorns";
									case 'extiky':
										quote = "WHY IS EVERYTHING SO HARD??\nWHY AM I TRAPPED IN FLOATING CARD??";
										image = "_tiky";
									case 'Sans_IC':
										quote = "Looks like you had a really bad time,\nyeah I am lazy to think of a rhyme.";
										image = "_sans";
									case 'ChampionKnightEX':
										quote = "You can’t run,\nnow you’re done!";
										image = "_sam";
									case 'eduardo':
										quote = "I am the numero uno meme as you can tell,\nif you ever doubt me then well well well.";
										image = "_eduardo";
									case 'sunky':
										quote = "You couldn't handle sunky.mpeg,\nyour head is egg.";
										image = "_sunky";
									case 'agressive-yuri':
										quote = "Obsess over me, why is your head closed shut?\nYour brain is so dense it's harder than a nut.";
										image = "_ayuri";
									case 'rose-opponent':
										quote = "You should get cozy,\nbeing beaten by Rosie!! >:3";
										image = "_rose";
									case 'jom':
										quote = "HA! Expect lore?\nToo bad you won't be getting anything more.";
										image = "_jom";
									case 'big-monika':
										quote = "Wherever you are, Asia, Astrulia or Antartica,\nyou're not getting any more girls, Just Monika.";
										image = "_bigika";
									case 'lordX':
										quote = "No matter where you hide, closet, cave or fort,\nyou can never hide from the PC port!";
										image = "_X";
									case 'ski':
										quote = "A song for you, and a fren for me :D";
										image = "_ski";
									case 'gold':
										quote = "I may be dead,\nbut your last minutes were filled with dread.";
										image = "_gold";
									case 'sonic':
										quote = "If you don't hit the notes as you should,\nthen THAT'S no good.";
										image = "_sonic";
									case 'p2doll':
										quote = "Can you feel the sunshine?\nDoes it brighten up your day?\nDon't you feel that sometimes\nYou just need to run away?";
										image = "_p2doll";
								}
								if (gfAgainSinging)
								{
									quote = "These thoughts got into your head,\nI exist to only make your life full of dread.";
									image = "_susan";
								}
								if (betadciucamera)
								{
									quote = "I am not rhyming anything how did\nyou lose at the last turn like that???";
									image = "_robo-gf";
								}
								openSubState(new GameOverSubstateCuphead(boyfriendBETADCIU.getScreenPosition().x - boyfriendBETADCIU.positionArray[0], boyfriendBETADCIU.getScreenPosition().y - boyfriendBETADCIU.positionArray[1], camFollowPos.x, camFollowPos.y, quote, image));
							default:
								persistentDraw = false;
								FlxG.sound.music.stop();
								openSubState(new GameOverSubstate(boyfriendBETADCIU.getScreenPosition().x - boyfriendBETADCIU.positionArray[0], boyfriendBETADCIU.getScreenPosition().y - boyfriendBETADCIU.positionArray[1], camFollowPos.x, camFollowPos.y));
						}
					}
				}

				// MusicBeatState.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				
				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
				isDead = true;
				return true;
			}
		}
		return false;
	}

	public function checkEventNote() {
		while(eventNotes.length > 0) {
			var leStrumTime:Float = eventNotes[0].strumTime;
			if(Conductor.songPosition < leStrumTime) {
				break;
			}

			var value1:String = '';
			if(eventNotes[0].value1 != null)
				value1 = eventNotes[0].value1;

			var value2:String = '';
			if(eventNotes[0].value2 != null)
				value2 = eventNotes[0].value2;

			triggerEventNote(eventNotes[0].event, value1, value2);
			eventNotes.shift();
		}
	}

	public function getControl(key:String) {
		var pressed:Bool = Reflect.getProperty(controls, key);
		//trace('Control result: ' + pressed);
		return pressed;
	}

	public function triggerEventNote(eventName:String, value1:String, value2:String) {
		switch(eventName) {
			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				var time:Float = Std.parseFloat(value2);
				if(Math.isNaN(time) || time <= 0) time = 0.6;

				if(value != 0) {
					if(dad.curCharacter.startsWith('gf')) { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					} else if (gf != null) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = time;
					}

					if(curStage == 'mall') {
						bottomBoppers.animation.play('hey', true);
						heyTimer = time;
					}
				}
				if(value != 1) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = time;
				}

			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if(Math.isNaN(value) || value < 1) value = 1;
				gfSpeed = value;

			case 'Blammed Lights':
				var lightId:Int = Std.parseInt(value1);
				if(Math.isNaN(lightId)) lightId = 0;

				var chars:Array<Character> = [boyfriend, gf, dad];
				if(lightId > 0 && curLightEvent != lightId) {
					if(lightId > 5) lightId = FlxG.random.int(1, 5, [curLightEvent]);

					var color:Int = 0xffffffff;
					switch(lightId) {
						case 1: //Blue
							color = 0xff31a2fd;
						case 2: //Green
							color = 0xff31fd8c;
						case 3: //Pink
							color = 0xfff794f7;
						case 4: //Red
							color = 0xfff96d63;
						case 5: //Orange
							color = 0xfffba633;
					}
					curLightEvent = lightId;

					if(blammedLightsBlack.alpha == 0) {
						if(blammedLightsBlackTween != null) {
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = FlxTween.tween(blammedLightsBlack, {alpha: 1}, 1, {ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween) {
								blammedLightsBlackTween = null;
							}
						});

						for (char in chars) {
							if(char.colorTween != null) {
								char.colorTween.cancel();
							}
							char.colorTween = FlxTween.color(char, 1, FlxColor.WHITE, color, {onComplete: function(twn:FlxTween) {
								char.colorTween = null;
							}, ease: FlxEase.quadInOut});
						}
					} else {
						if(blammedLightsBlackTween != null) {
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = null;
						blammedLightsBlack.alpha = 1;

						for (char in chars) {
							if(char.colorTween != null) {
								char.colorTween.cancel();
							}
							char.colorTween = null;
						}
						dad.color = color;
						boyfriend.color = color;
						if (gf != null)
							gf.color = color;
					}
					
					if(curStage == 'philly') {
						if(phillyCityLightsEvent != null) {
							phillyCityLightsEvent.forEach(function(spr:BGSprite) {
								spr.visible = false;
							});
							phillyCityLightsEvent.members[lightId - 1].visible = true;
							phillyCityLightsEvent.members[lightId - 1].alpha = 1;
						}
					}
				} else {
					if(blammedLightsBlack.alpha != 0) {
						if(blammedLightsBlackTween != null) {
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = FlxTween.tween(blammedLightsBlack, {alpha: 0}, 1, {ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween) {
								blammedLightsBlackTween = null;
							}
						});
					}

					if(curStage == 'philly') {
						phillyCityLights.forEach(function(spr:BGSprite) {
							spr.visible = false;
						});
						phillyCityLightsEvent.forEach(function(spr:BGSprite) {
							spr.visible = false;
						});

						var memb:FlxSprite = phillyCityLightsEvent.members[curLightEvent - 1];
						if(memb != null) {
							memb.visible = true;
							memb.alpha = 1;
							if(phillyCityLightsEventTween != null)
								phillyCityLightsEventTween.cancel();

							phillyCityLightsEventTween = FlxTween.tween(memb, {alpha: 0}, 1, {onComplete: function(twn:FlxTween) {
								phillyCityLightsEventTween = null;
							}, ease: FlxEase.quadInOut});
						}
					}

					for (char in chars) {
						if(char.colorTween != null) {
							char.colorTween.cancel();
						}
						char.colorTween = FlxTween.color(char, 1, char.color, FlxColor.WHITE, {onComplete: function(twn:FlxTween) {
							char.colorTween = null;
						}, ease: FlxEase.quadInOut});
					}

					curLight = 0;
					curLightEvent = 0;
				}

			case 'Kill Henchmen':
				killHenchmen();

			case 'Add Camera Zoom':
				if(ClientPrefs.camZooms && FlxG.camera.zoom < 1.35) {
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(camZoom)) camZoom = 0.015;
					if(Math.isNaN(hudZoom)) hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;
				}

			case 'Trigger BG Ghouls':
				if(curStage == 'schoolEvil' && !ClientPrefs.lowQuality) {
					bgGhouls.dance(true);
					bgGhouls.visible = true;
				}

			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'boyfriendbetadciu' | 'bfbetadciu':
						char = boyfriendBETADCIU;
					case 'dadbetadciu' | 'opponentbetadciu':
						char = dadBETADCIU;
					case 'dadagain2' | 'opponentagain2':
						char = dadAgain2;
					case 'dadagain1' | 'opponentagain1':
						char = dadAgain1;
					case 'bfagain' | 'boyfriendagain':
						char = boyfriendAgain;
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;
		
						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.playAnim(value1, true);
					char.specialAnim = true;
				}

			case 'Camera Follow Pos':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 0;
				if(Math.isNaN(val2)) val2 = 0;

				isCameraOnForcedPos = false;
				if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
					camFollow.x = val1;
					camFollow.y = val2;
					isCameraOnForcedPos = true;
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					case 'boyfriendagain' | 'bfagain':
						char = boyfriendAgain;
					case 'opponentagain' | 'dadagain' | 'opponentagain1' | 'dadagain1':
						char = dadAgain1;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
				}

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = 0;
					var intensity:Float = 0;
					if(split[0] != null) duration = Std.parseFloat(split[0].trim());
					if(split[1] != null) intensity = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}


			case 'Change Character':
				var charType:Int = 0;
				switch(value1) {
					case 'dadagain2' | 'opponentagain2':
						charType = 5;
					case 'bfagain' | 'boyfriendagain' | 'bfagain1' | 'boyfriendagain1':
						charType = 4;
					case 'dadagain1' | 'opponentagain1' | 'dadagain' | 'opponentagain':
						charType = 3;
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend.alpha = 0.00001;
							boyfriend = boyfriendMap.get(value2);
							boyfriend.alpha = lastAlpha;
							iconP1.changeIcon(boyfriend.healthIcon);
							/*if (boyfriend.playable == false)
							{
								boyfriend.flipX = false;
								boyfriend.scale.set(boyfriend.scale.x*-1,boyfriend.scale.y);
								
								var largesetDoof:Float = 0;
								for (anim in boyfriend.animOffsets.keys())
								{
									boyfriend.animOffsets[anim] = [boyfriend.animOffsets[anim][0]*-1,boyfriend.animOffsets[anim][1]];
									if (boyfriend.animOffsets[anim][0] < largesetDoof)
										largesetDoof = boyfriend.animOffsets[anim][0];
								}
								/*for (anim in boyfriend.animOffsets.keys())
								{
									boyfriend.animOffsets[anim] = [boyfriend.animOffsets[anim][0] - (-(largesetDoof) + boyfriend.width),boyfriend.animOffsets[anim][1]];
								}
								boyfriend.x -= (-(largesetDoof) + boyfriend.width);
								trace(boyfriend.x);
								boyfriend.updateHitbox();
								//boyfriend.origin.set(boyfriend.origin.x * 0, boyfriend.origin.y);
								//boyfriend.x *= 2;
								trace(boyfriend.x);
								//boyfriend.x = boyfriend.origin.x;
							}*/
						}
						setOnLuas('boyfriendName', boyfriend.curCharacter);

					case 1:
						if(dad.curCharacter != value2) {
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							var lastAlpha:Float = dad.alpha;
							dad.alpha = 0.00001;
							dad = dadMap.get(value2);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf && gf != null) {
									gf.visible = true;
								}
							} else if(gf != null) {
								gf.visible = false;
							}
							
							switch (value2)
							{
								case 'selever':
									circSelever.angle = 0;
									FlxTween.tween(circSelever, {angle: 360}, 1.9, {ease: FlxEase.cubeInOut});
									FlxTween.tween(circSelever, {alpha: 1}, 0.7);
									FlxTween.tween(blackSelever, {alpha: 0.8}, 0.7, {
										onComplete: function(twn:FlxTween)
										{
											new FlxTimer().start(0.5, function(tmr:FlxTimer)
											{
												FlxTween.tween(circSelever, {alpha: 0}, 0.7);
												FlxTween.tween(blackSelever, {alpha: 0}, 0.7);
											});
										}
									});
							}
							if ((boyfriend.curCharacter == 'blantados-playable' || boyfriend.curCharacter == 'tord-playable') && curStage == 'knockout')
								dad.alpha = 1;
							else
								dad.alpha = lastAlpha;
							iconP2.changeIcon(dad.healthIcon);
							if (value2 == 'qt-kb')
							{
								iconP2Again1.changeIcon('headache/kb');
								iconP2Again1.visible = true;
							}
						}
						setOnLuas('dadName', dad.curCharacter);

					case 2:
						if(gf != null)
						{
							if(gf.curCharacter != value2)
							{
								if(!gfMap.exists(value2))
								{
									addCharacterToList(value2, charType);
								}

								var lastAlpha:Float = gf.alpha;
								gf.alpha = 0.00001;
								gf = gfMap.get(value2);
								gf.alpha = lastAlpha;
							}
							setOnLuas('gfName', gf.curCharacter);
						}
					case 3:
						addCharacterToList(value2, charType);

						var wasGf:Bool = dad.curCharacter.startsWith('gf');
						var lastAlpha:Float = dadAgain1.alpha;
						dadAgain1.alpha = 0.00001;
						dadAgain1 = dadMapAgain1.get(value2);
						dadAgain1.alpha = lastAlpha;
						dadAgain1.visible = true;
						iconP2Again1.visible = true;
						iconP2Again1.changeIcon(dadAgain1.healthIcon);
						dumbasstext3.text += '> Changed dadAgain1 to hex\n\n';
					case 4:
						addCharacterToList(value2, charType);
						if(!boyfriendMapAgain.exists(value2)) {
							addCharacterToList(value2, charType);
						}

						var lastAlpha:Float = boyfriendAgain.alpha;
						boyfriendAgain.alpha = 0.00001;
						boyfriendAgain = boyfriendMapAgain.get(value2);
						boyfriendAgain.alpha = lastAlpha;
						boyfriendAgain.visible = true;
						/*if (boyfriendAgain.playable == false)
						{
							boyfriendAgain.flipX = false;
							boyfriendAgain.scale.set(boyfriendAgain.scale.x*-1,boyfriendAgain.scale.y);
					
							var largesetDoof:Float = 0;
							for (anim in boyfriendAgain.animOffsets.keys())
							{
								if (boyfriendAgain.animOffsets[anim][0] < largesetDoof)
									largesetDoof = boyfriendAgain.animOffsets[anim][0];
								boyfriendAgain.animOffsets[anim] = [boyfriendAgain.animOffsets[anim][0]*-1,boyfriendAgain.animOffsets[anim][1]];
							}
							for (anim in boyfriendAgain.animOffsets.keys())
							{
								boyfriendAgain.animOffsets[anim] = [boyfriendAgain.animOffsets[anim][0] - (largesetDoof + boyfriendAgain.width),boyfriendAgain.animOffsets[anim][1]];
							}
							boyfriendAgain.x += (largesetDoof + boyfriendAgain.width);
							boyfriendAgain.updateHitbox();
						}*/
						iconP1Again.visible = true;
						iconP1Again.changeIcon(boyfriendAgain.healthIcon);
				case 5:
					addCharacterToList(value2, charType);

					var wasGf:Bool = dad.curCharacter.startsWith('gf');
					var lastAlpha:Float = dadAgain2.alpha;
					dadAgain2.alpha = 0.00001;
					dadAgain2 = dadMapAgain2.get(value2);
					dadAgain2.alpha = lastAlpha;
					dadAgain2.visible = true;
					iconP2Again2.visible = true;
					iconP2Again2.changeIcon(dadAgain2.healthIcon);
					dumbasstext3.text += '> Changed dadAgain2 to ${value2}\n\n';
					if (value2 == 'fleetway3' && curStage == 'knockout')
					{
						dadAgain2.y += 1000;
						FlxTween.tween(dadAgain2, {y: dadAgain2.y - 1000}, 0.3, {
							ease: FlxEase.elasticInOut
						});
					}

				case 6:
					if(gfAgain != null)
					{
						if(gfAgain.curCharacter != value2)
						{
							if(!gfMapAgain.exists(value2))
							{
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = gfAgain.alpha;
							gfAgain.alpha = 0.00001;
							gfAgain = gfMapAgain.get(value2);
							gfAgain.alpha = lastAlpha;
						}
						setOnLuas('gfName', gfAgain.curCharacter);
					}
			}
			reloadHealthBarColors();
			
			case 'BG Freaks Expression':
				if(bgGirls != null) bgGirls.swapDanceType();
			case 'Change Dad Icon GF':
				iconP2.changeIcon(gf.healthIcon);
				healthBar.createFilledBar(FlxColor.fromRGB(gf.healthColorArray[0], gf.healthColorArray[1], gf.healthColorArray[2]),
					FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
					
				healthBar.updateBar();
			case 'Change Dad Icon GFAgain':
				iconP2.changeIcon(gfAgain.healthIcon);
				healthBar.createFilledBar(FlxColor.fromRGB(gfAgain.healthColorArray[0], gfAgain.healthColorArray[1], gfAgain.healthColorArray[2]),
					FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
					
				healthBar.updateBar();
			case 'Change Zoom':
				defaultCamZoom = Std.parseFloat(value1);
			case 'betadciuBF':
				betadciuMomentBF();
			case 'betadciuDAD':
				betadciuMomentDAD();
			case 'hide dadAgain1':
				dadAgain1.visible = false;
				iconP2Again1.visible = false;
				dadAgain1Singing = false;
			case 'hide dadAgain2':
				dadAgain2.visible = false;
				iconP2Again2.visible = false;
				dadAgain2Singing = false;
			case 'hide BoyfriendAgain':
				boyfriendAgain.visible = false;
				iconP1Again.visible = false;
				boyfriendAgainSinging = false;
			case 'boyfriendAgain Singing':
				if (value1 == 'true')
					boyfriendAgainSinging = true;
				else
					boyfriendAgainSinging = false;
			case 'dadAgain1 Singing':
				if (value1 == 'true')
					dadAgain1Singing = true;
				else
					dadAgain1Singing = false;
			case 'dadAgain2 Singing':
				if (value1 == 'true')
					dadAgain2Singing = true;
				else
					dadAgain2Singing = false;
			case 'dad Singing':
				if (value1 == 'true')
					dadSinging = true;
				else
					dadSinging = false;

			case 'gfAgain Singing':
				if (value1 == 'true')
					gfAgainSinging = true;
				else
					gfAgainSinging = false;

			case 'Insta Cam Zoom':
				defaultCamZoom = Std.parseFloat(value1);
				FlxG.camera.zoom = Std.parseFloat(value1);

			case 'Change Cam Zoom':
				defaultCamZoom = Std.parseFloat(value1);

			case 'Do Hardcoded Event':
				switch (Std.parseInt(value1))
				{
					case 1:
						trace('here btw');
						jomGlasses = new FlxSprite(dad.x - 900, dad.y - 800);
						jomGlasses.loadGraphic(Paths.image('knockout/shootstuff/jom/the what'));
						jomGlasses.scale.set(4,4);
						jomGlasses.angle = 20;
						add(jomGlasses);
						bluelasercheckimfuckingtiredmanletsgetthisdoneoverwith = true;
						FlxG.sound.play(Paths.sound('knockout/shootfunni/tord bang your mom'), 1);
						redLaser.alpha = 1;
						redLaser.animation.play('shoot');
						blueLaser.alpha = 1;
						blueLaser.animation.play('shoot');
					case 2:
						superCuphead.x += 1200;
						if (bfDodgin)
						{
							insert(this.members.indexOf(superCuphead) - 1, lylaceDead);
							//FlxG.sound.play(Paths.sound('knockout/knockout'), 1);
							trace('THAT\'S WHAT YOU GET FOR MAKING CUPHEAD OFFTUNE');
							var knock:FlxSprite = new FlxSprite();
							knock.frames = Paths.getSparrowAtlas('knockout/knock');
							knock.animation.addByPrefix('start','A KNOCKOUT!', 24, false);
							knock.animation.play('start');
							knock.scrollFactor.set();
							knock.updateHitbox();
							knock.cameras = [camHUD];
	
							knock.screenCenter();
							knock.antialiasing = ClientPrefs.globalAntialiasing;
							add(knock);
							knock.animation.finishCallback = function(funki:String) {
								FlxTween.tween(knock, {alpha: 0}, 0.5, {ease: FlxEase.quadIn, onComplete: function (twn:FlxTween) {remove(knock);}});
						}
						}
					case 3:
						FlxTween.tween(bg1, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(bg2, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(bg3, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(rain1, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(rain2, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(cupheadShid, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(cupheadGrain, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(jomGlasses, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(dad, {alpha: 0.00001}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(camHUD, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(camHUDier, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(gf, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(gfAgain, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(dadBETADCIU, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(boyfriend, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(boyfriendBETADCIU, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(superCircleCuphead, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(lylaceDead, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						for (i in funniRects)
						{
							FlxTween.tween(i, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						}
						for (i in moreRects)
						{
							FlxTween.tween(i, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
						}
					case 4:
						FlxTween.tween(dad, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(boyfriend, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(gf, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(gfAgain, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(camHUD, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(camHUDier, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						BETADCIUAlphaCrazy = true;
						dadBETADCIU.x -= 900;
						dadBETADCIU.y -= 75;
						boyfriendBETADCIU.x -= 900;
						boyfriendBETADCIU.y -= 75;
						gf.x -= 700;
						gf.y -= 75;
						gfAgain.x -= 1400;
						gfAgain.y -= 75;
						firstPersonMode = true;
						gf.color = FlxColor.WHITE;
						gfAgain.color = FlxColor.WHITE;
						var dumb = CoolUtil.coolTextFile(Paths.txt('dumb'));
						var xfunni = Std.parseFloat(dumb[0]);
						var yfunni = Std.parseFloat(dumb[1]);
						defaultCamZoom = 0.8;
						var scale = 1;
						var posX = -230;
						var posY = 300;
						space = new FlxBackdrop(Paths.image('bigmonika/Sky'), 0.1, 0.1);
						space.velocity.set(-10, 0);
						space.x = posX;
						space.y = posY;
						// space.scale.set(1.65, 1.65);
						BG2 = new FlxSprite(posX, posY).loadGraphic(Paths.image('bigmonika/BG'));
						BG2.antialiasing = true;
						// bg.scale.set(2.3, 2.3);
						BG2.scrollFactor.set(0.4, 0.6);
		
						BG3 = new FlxSprite(posX - 110, posY + 464).loadGraphic(Paths.image('bigmonika/FG'));
						BG3.antialiasing = true;
						// stageFront.scale.set(1.5, 1.5);
						BG3.scrollFactor.set(1, 1);
						insert(this.members.indexOf(bg1) - 1, BG3);
						insert(this.members.indexOf(BG3) - 1, BG2);
						insert(this.members.indexOf(BG2) - 1, space);
					case 5:
						switch (Std.parseInt(value2))
						{
							case 1:
								iconP1.changeIcon('knockout/stamps-icon');
								healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
									FlxColor.fromRGB(69, 69, 248));
									
								healthBar.updateBar();
							case 2:
								iconP1.changeIcon('knockout/void');
								healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
									FlxColor.fromRGB(208, 167, 247));
									
								healthBar.updateBar();
							case 3:
								iconP1.changeIcon('knockout/icon-rosy');
								healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
									FlxColor.fromRGB(178, 51, 51));
									
								healthBar.updateBar();
							case 4:
								iconP1.changeIcon('knockout/doge');
								healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
									FlxColor.fromRGB(27, 179, 255));
									
								healthBar.updateBar();
							case 5:
								iconP1.changeIcon('knockout/crybit');
								healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
									FlxColor.fromRGB(248, 246, 246));
									
								healthBar.updateBar();
							case 6:
								iconP1.changeIcon('knockout/plasma');
								healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
									FlxColor.fromRGB(106, 153, 72));
									
								healthBar.updateBar();
						}
					case 6:
						switch (Std.parseInt(value2))
						{
							case 1:
								FlxTween.tween(space, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
								FlxTween.tween(BG2, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
								FlxTween.tween(BG3, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
								FlxTween.tween(dad, {alpha: 0.00001}, 0.3, {
									ease: FlxEase.quadIn,
									onComplete: function (twn:FlxTween)
									{
										BETADCIUYCrazy = true;
										triggerEventNote("Change Character", "dad", "lordX");
										defaultCamZoom = 0.55;
										FlxTween.tween(dad, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
									}
								});
							case 2:
								FlxTween.tween(FlxG.camera, {zoom: 10}, 0.3, {
									ease: FlxEase.quadIn,
									onComplete: function (twn:FlxTween)
									{
										defaultCamZoom = 0.55;
										BACKGROUNDMOMENTYOOOO.alpha = 1;
										triggerEventNote("Change Character", "dad", "ski");
									}
								});
							case 3:
								FlxTween.tween(BACKGROUNDMOMENTYOOOO, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
								FlxTween.tween(dad, {alpha: 0.00001}, 0.3, {
									ease: FlxEase.quadIn,
									onComplete: function (twn:FlxTween)
									{
										BETADCIUYCrazy = true;
										triggerEventNote("Change Character", "dad", "gold");
										defaultCamZoom = 0.55;
										FlxTween.tween(dad, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
									}
								});
							case 4:
								triggerEventNote("Change Character", "dad", "sonic");
								var SEGA = new FlxSprite(0,0, Paths.image('knockout/SEGA'));
								SEGA.cameras = [camHUDier];
								add(SEGA);
								defaultCamZoom = 0.8;
								SEGA.screenCenter();
								new FlxTimer().start(0.2, function(tmr:FlxTimer) {
									remove(SEGA);
									BG2.x = -400;
									BG2.y = 200;
									BG2.loadGraphic(Paths.image('sonicsez/sky'));
									BG2.alpha = 1;
								});
							case 5:
								FlxTween.tween(space, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
								FlxTween.tween(BG2, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
								FlxTween.tween(BG3, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
								FlxTween.tween(dad, {alpha: 0.00001}, 0.3, {
									ease: FlxEase.quadIn,
									onComplete: function (twn:FlxTween)
									{
										triggerEventNote("Change Character", "dad", "p2doll");
										defaultCamZoom = 0.55;
										FlxTween.tween(dad, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
									}
								});
						}
					case 7:
						BETADCIUAlphaCrazy = false;
						BETADCIUYCrazy = false;
						firstPersonMode = false;
						betadciucamera = true;
						FlxTween.tween(bg1, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(bg2, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(bg3, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(rain1, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(rain2, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(cupheadShid, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(cupheadGrain, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(superCircleCuphead, {alpha: 1}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(dadBETADCIU, {alpha: 1, x: 780, y: 1390}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(dad, {alpha: 0.00001}, 0.3, {
							ease: FlxEase.quadIn,
							onComplete: function (twn:FlxTween)
							{
								gf.color = 0xFFAEB8CF;
								gfAgain.color = 0xFFAEB8CF;
								iconP1.changeIcon('bf');
								iconP2.changeIcon('knockout/icon-cuphead-pissed');
								defaultCamZoom = 0.65;
								healthBar.createFilledBar(FlxColor.fromRGB(dadBETADCIU.healthColorArray[0], dadBETADCIU.healthColorArray[1], dadBETADCIU.healthColorArray[2]),
									FlxColor.fromRGB(boyfriendBETADCIU.healthColorArray[0], boyfriendBETADCIU.healthColorArray[1], boyfriendBETADCIU.healthColorArray[2]));
									
								healthBar.updateBar();
								//dadGroup.x += 500;
								//boyfriendGroup.x -= 350;
							}
						});
						FlxTween.tween(FlxG.camera, {zoom: 5}, 0.1, {ease: FlxEase.quadIn});
						FlxTween.tween(boyfriend, {alpha: 0.00001}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(boyfriendBETADCIU, {alpha: 1, x: 1800, y: 1330}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(gf, {alpha: 1, x: 1500, y: 950}, 0.3, {ease: FlxEase.quadIn});
						FlxTween.tween(gfAgain, {alpha: 1, x: 1000, y: 950}, 0.3, {ease: FlxEase.quadIn});
					case 8:
						switch (Std.parseInt(value2))
						{
							case 0:
								
								FlxTween.tween(this, {songBackSpriteWidth: FlxG.width}, 1.25,
									{
										onComplete: function(twn:FlxTween)
										{
											FlxTween.tween(displaySongName, {y: songBackSprite.y + 30, alpha: 1}, 0.40, {
												ease: FlxEase.elasticInOut,
												onComplete: function(twn:FlxTween)
												{
													trace (displaySongName.x + displaySongName.width - iconSongName.x);
													FlxTween.tween(this, {songNameDistance: 70}, 0.5, {
														ease: FlxEase.elasticInOut
													});
													FlxTween.tween(iconSongName, {alpha: 1}, 0.5, {
														ease: FlxEase.elasticInOut
													});
													FlxTween.tween(iconSongNameAgain, {alpha: 1}, 0.5, {
														ease: FlxEase.elasticInOut
													});
													FlxTween.tween(displayArtistName, {y: displaySongName.y + 50, alpha: 1}, 0.5, {
														ease: FlxEase.elasticInOut
													});
													
													new FlxTimer().start(2, function(tmr:FlxTimer)
													{
														FlxTween.tween(songBackSprite, {y: songBackSprite.y - 100, alpha: 0}, 0.5, {
															ease: FlxEase.elasticInOut
														});
														FlxTween.tween(displayArtistName, {y: displayArtistName.y - 100, alpha: 0}, 0.5, {
															ease: FlxEase.elasticInOut
														});
														FlxTween.tween(displaySongName, {y: displaySongName.y - 100, alpha: 0}, 0.5, {
															ease: FlxEase.elasticInOut
														});
														FlxTween.tween(iconSongName, {y: iconSongName.y - 100, alpha: 0}, 0.5, {
															ease: FlxEase.elasticInOut
														});
														FlxTween.tween(iconSongNameAgain, {alpha: 0}, 0.5, {
															ease: FlxEase.elasticInOut
														});
													});
												}
											});
										}
									});
							case 1:
								flashScreen(FlxColor.WHITE,0.5);
								bg1.loadGraphic(Paths.image('atrocity/moreBGs/bg'));
								bg1.y -= 520;
								rain1.visible = false;
								var thingything = 2;
								dad.scale.set(thingything,thingything);
								dad.updateHitbox();
						
								for (anim in dad.animOffsets.keys())
								{
									dad.animOffsets[anim] = [dad.animOffsets[anim][0]*thingything,dad.animOffsets[anim][1]*thingything];
								}
								dad.y += 370;
								dad.x += 370;
								dad.dance();
							case 2:
								bg2.loadGraphic(Paths.image('atrocity/moreBGs/bg1'));
								var thingything = 2;
								boyfriend.scale.set(thingything,thingything);
								boyfriend.updateHitbox();
						
								for (anim in boyfriend.animOffsets.keys())
								{
									boyfriend.animOffsets[anim] = [boyfriend.animOffsets[anim][0]*thingything,boyfriend.animOffsets[anim][1]*thingything];
								}
								boyfriend.scale.set(thingything,thingything);
								boyfriend.updateHitbox();
								boyfriend.y += 280;
								boyfriend.x += 400;
								boyfriend.dance();
							case 3:
								var thingything = 3;
								dadAgain1.scale.set(thingything,thingything);
								dadAgain1.updateHitbox();
						
								for (anim in dadAgain1.animOffsets.keys())
								{
									dadAgain1.animOffsets[anim] = [dadAgain1.animOffsets[anim][0]*thingything,dadAgain1.animOffsets[anim][1]*thingything];
								}
								dadAgain1.scale.set(thingything,thingything);
								dadAgain1.updateHitbox();
								dadAgain1.y += 100;
								dadAgain1.x -= 800;
								FlxTween.tween(dadAgain1, {x: dadAgain1.x + 1200}, 0.5, {
									ease: FlxEase.quadIn,
									onComplete: function (twn:FlxTween) {
										FlxTween.tween(dadAgain1, {y: dadAgain1.y + 380}, 0.5, {ease: FlxEase.quadIn});
										FlxTween.tween(dad, {y: dad.y + 380}, 0.5, {ease: FlxEase.quadIn});
										FlxTween.tween(bg1, {y: bg1.y + 380}, 0.5, {ease: FlxEase.quadIn});
									}
								});
								dadAgain1.dance();
							case 4:
								dadSinging = true;
								flashScreen(FlxColor.WHITE,0.5);
								bg1.loadGraphic(Paths.image('atrocity/moreBGs/bg2'));
								bg1.y += 140;
								var thingything = 2;
								dad.scale.set(thingything,thingything);
								dad.updateHitbox();
						
								for (anim in dad.animOffsets.keys())
								{
									dad.animOffsets[anim] = [dad.animOffsets[anim][0]*thingything,dad.animOffsets[anim][1]*thingything];
								}
								dad.y += 300;
								dad.x += 300;
								dad.dance();
							case 5:
								bg2.loadGraphic(Paths.image('atrocity/moreBGs/bg3'));
								boyfriend.x += 1000;
								var thingything = 2;
								boyfriend.scale.set(thingything,thingything);
								boyfriend.updateHitbox();
						
								for (anim in boyfriend.animOffsets.keys())
								{
									boyfriend.animOffsets[anim] = [boyfriend.animOffsets[anim][0]*thingything,boyfriend.animOffsets[anim][1]*thingything];
								}
								boyfriend.scale.set(thingything,thingything);
								boyfriend.updateHitbox();
								boyfriend.y += 280;
								boyfriend.x += 400;
								boyfriend.dance();
								FlxTween.tween(boyfriend, {x: boyfriend.x - 1000}, 0.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(bg2, {x: bg2.x - 1000}, 0.5, {ease: FlxEase.quadInOut});
							case 6:
								triggerEventNote("Change Character", "bfagain", "chara-playable");
								remove(boyfriendAgain);
								roboInsert(bg3,1,boyfriendAgain);
								var the = boyfriendMapAgain.get('spooky-playable');
								roboInsert(bg3,1,the);
								var thingything = 2;
								the.scale.set(50,50);
								the.updateHitbox();
						
								for (anim in the.animOffsets.keys())
								{
									the.animOffsets[anim] = [the.animOffsets[anim][0]*50,the.animOffsets[anim][1]*50];
								}
								the.x = -1500;
								the.y = 7000;
								boyfriendAgain.scale.set(thingything,thingything);
								boyfriendAgain.updateHitbox();
								iconP1Again.visible = false;
						
								for (anim in boyfriendAgain.animOffsets.keys())
								{
									boyfriendAgain.animOffsets[anim] = [boyfriendAgain.animOffsets[anim][0]*thingything,boyfriendAgain.animOffsets[anim][1]*thingything];
								}
								boyfriendAgain.y += 280;
								boyfriendAgain.x += 400;
								boyfriendAgain.playAnim('YOU');
								boyfriendAgain.specialAnim = true;
								boyfriend.visible = false;
							case 7:
								FlxTween.tween(boyfriendAgain.scale, {x: 60, y: 60}, 0.2, {ease: FlxEase.quadIn});
								FlxTween.tween(boyfriendAgain, {x: boyfriendAgain.x - 600,y: boyfriendAgain.y + 3600}, 0.2, {
									ease: FlxEase.quadIn,
									onComplete: function (twn:FlxTween) {
										triggerEventNote("Change Character", "bf", "spooky-playable");
										
										bg2.loadGraphic(Paths.image('atrocity/moreBGs/bg4'));
										var thingything = 2;
										boyfriend.scale.set(thingything,thingything);
										boyfriend.updateHitbox();
								
										for (anim in boyfriend.animOffsets.keys())
										{
											boyfriend.animOffsets[anim] = [boyfriend.animOffsets[anim][0]*thingything,boyfriend.animOffsets[anim][1]*thingything];
										}
										boyfriend.scale.set(thingything,thingything);
										boyfriend.updateHitbox();
										boyfriend.y += 240;
										boyfriend.x += 400;
										triggerEventNote("Change Character", "bfagain", "spooky-playable");
										iconP1Again.visible = false;
										FlxTween.tween(boyfriendAgain.scale, {x: 2, y: 2}, 0.2, {ease: FlxEase.quadIn});
										FlxTween.tween(boyfriendAgain, {x: boyfriend.x, y: boyfriend.y}, 0.2, {
											ease: FlxEase.quadIn,
											onComplete: function (twn:FlxTween) {
												boyfriendAgain.visible = false;
												boyfriend.visible = true;
											}
										});
										boyfriendAgain.playAnim('singUP');
										boyfriendAgain.specialAnim = true;
									}
								});
							case 8:
								dad.alpha = 0.00001;
								FlxTween.tween(dad, {alpha: 1}, 0.2, {ease: FlxEase.quadIn});
								bg1.loadGraphic(Paths.image('atrocity/moreBGs/bg5'));
								var thingything = 2;
								dad.scale.set(thingything,thingything);
								dad.updateHitbox();
						
								for (anim in dad.animOffsets.keys())
								{
									dad.animOffsets[anim] = [dad.animOffsets[anim][0]*thingything,dad.animOffsets[anim][1]*thingything];
								}
								dad.y += 200;
								dad.x += 300;
								dad.dance();
							case 9:
								FlxTween.tween(iconP2, {alpha: 0.00001}, 0.2, {ease: FlxEase.quadIn});
								FlxTween.tween(dad, {alpha: 0.00001}, 0.2, {
									ease: FlxEase.quadIn,
									onComplete: function (twn:FlxTween) {
										boyfriend.alpha = 0.00001;
										bg1.alpha = 0.00001;
										bg2.alpha = 0.00001;
										bg1.loadGraphic(Paths.image('atrocity/moreBGs/bg6'));
										iconP1.alpha = 0.00001;
										flashScreen(FlxColor.WHITE,0.5);
									}
								});
							case 10:
								FlxTween.tween(iconP2, {alpha: 1}, 1, {ease: FlxEase.quadIn});
								FlxTween.tween(dad, {alpha: 1}, 1, {
									ease: FlxEase.quadIn,
									onComplete: function (twn:FlxTween) {
										FlxTween.tween(bg1, {alpha: 1}, 1, {ease: FlxEase.quadIn});
									}
								});
								var thingything = 2;
								dad.scale.set(thingything,thingything);
								dad.updateHitbox();
						
								for (anim in dad.animOffsets.keys())
								{
									dad.animOffsets[anim] = [dad.animOffsets[anim][0]*thingything,dad.animOffsets[anim][1]*thingything];
								}
								dad.y += 200;
								dad.x += 600;
								dad.dance();
							case 11:
								bg2.loadGraphic(Paths.image('atrocity/moreBGs/bg7'));
								FlxTween.tween(iconP1, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
								boyfriend.x += 1000;
								bg2.x += 1000;
								boyfriend.alpha = 1;
								bg2.alpha = 1;
								var thingything = 2;
								boyfriend.scale.set(thingything,thingything);
								boyfriend.updateHitbox();
						
								for (anim in boyfriend.animOffsets.keys())
								{
									boyfriend.animOffsets[anim] = [boyfriend.animOffsets[anim][0]*thingything,boyfriend.animOffsets[anim][1]*thingything];
								}
								boyfriend.y += 400;
								boyfriend.x += 600;
								FlxTween.tween(boyfriend, {x: boyfriend.x - 1000}, 1, {ease: FlxEase.quadInOut});
								FlxTween.tween(bg2, {x: bg2.x - 1000}, 1, {ease: FlxEase.quadInOut});
								boyfriend.dance();
							case 12:
								FlxTween.tween(iconP2, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
								FlxTween.tween(bg1, {alpha: 0}, 0.3, {ease: FlxEase.quadIn});
								FlxTween.tween(dad, {alpha: 0.00001}, 0.3, {
									ease: FlxEase.quadIn,
									onComplete: function (twn:FlxTween) {
										bg1.y += 962;
										bg1.alpha = 1;
										bg1.loadGraphic(Paths.image('atrocity/moreBGs/bg8'));
									}
								});
							case 13:
								var thingything = 2;
								dadAgain1.scale.set(thingything,thingything);
								dadAgain1.updateHitbox();

								for (anim in dadAgain1.animOffsets.keys())
								{
									dadAgain1.animOffsets[anim] = [dadAgain1.animOffsets[anim][0]*thingything,dadAgain1.animOffsets[anim][1]*thingything];
								}
								dadAgain1.y += 1100 + 962;
								dadAgain1.x += 400;
								dadAgain1.playAnim('singUP');
								dadAgain1.clipRect = new FlxRect(0, 0, 780, 400);
								//trace(dadAgain1.x); -90
								//trace(bg1.x);
								retroShake = true;
								dadAgain1.specialAnim = true;
								dadAgain1.animation.pause();
								FlxTween.tween(iconP2, {alpha: 1}, 0.868, {ease: FlxEase.quadOut});
								FlxTween.tween(dad, {y: dad.y - 962}, 0.868, {ease: FlxEase.quadOut});
								FlxTween.tween(dadAgain1, {y: dadAgain1.y - 962}, 0.868, {ease: FlxEase.quadOut});
								FlxTween.tween(bg1, {y: bg1.y - 962}, 0.868, {
									ease: FlxEase.quadOut,
									onComplete: function (twn:FlxTween) {
										flashScreen(FlxColor.WHITE,0.5);
										triggerEventNote("Change Character", "dad", "retrospectre");
										dad.alpha = 1;
										triggerEventNote("hide dadAgain1", "", "");
										retroShake = false;
										bg1.x = 0;
										dad.scale.set(thingything,thingything);
										dad.updateHitbox();
		
										for (anim in dad.animOffsets.keys())
										{
											dad.animOffsets[anim] = [dad.animOffsets[anim][0]*thingything,dad.animOffsets[anim][1]*thingything];
										}
										dad.y += 600;
										dad.x += 150;
										flashScreen(FlxColor.WHITE,0.5);

									}
								});
							case 14:
								FlxTween.tween(boyfriend, {y: boyfriend.y + 1000}, 0.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(bg2, {y: bg2.y + 1000}, 0.5, {
									ease: FlxEase.quadInOut,
									onComplete: function (twn:FlxTween) {
										bg2.y -= 1000;
										bg2.x += 1000;
									}
								});
							case 15:
								FlxTween.tween(boyfriend, {x: boyfriend.x + 1000}, 0.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(bg2, {x: bg2.x + 1000}, 0.5, {
									ease: FlxEase.quadInOut,
								});
							case 16:
								bg2.loadGraphic(Paths.image('atrocity/moreBGs/bg9'));
								var thingything = 2;
								boyfriend.scale.set(thingything,thingything);
								boyfriend.updateHitbox();
						
								for (anim in boyfriend.animOffsets.keys())
								{
									boyfriend.animOffsets[anim] = [boyfriend.animOffsets[anim][0]*thingything,boyfriend.animOffsets[anim][1]*thingything];
								}
								boyfriend.y += 400;
								boyfriend.x += 1500;
								FlxTween.tween(boyfriend, {x: boyfriend.x - 1000}, 0.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(bg2, {x: bg2.x - 1000}, 0.5, {ease: FlxEase.quadInOut});
								boyfriend.dance();
							case 17:
								var thingything = 2;
								dadAgain1.scale.set(thingything,thingything);
								dadAgain1.updateHitbox();
						
								for (anim in dadAgain1.animOffsets.keys())
								{
									dadAgain1.animOffsets[anim] = [dadAgain1.animOffsets[anim][0]*thingything,dadAgain1.animOffsets[anim][1]*thingything];
								}
								dadAgain1.y += 400;
								dadAgain1.x += 1500;
							case 18:
								remove(dadAgain1);
								roboInsert(dad, 1, dadAgain1);
								var thingything = 1.25;
								dadAgain1.scale.set(thingything,thingything);
								dadAgain1.updateHitbox();
						
								for (anim in dadAgain1.animOffsets.keys())
								{
									dadAgain1.animOffsets[anim] = [dadAgain1.animOffsets[anim][0]*thingything,dadAgain1.animOffsets[anim][1]*thingything];
								}
								dadAgain1.y += 1400;
								dadAgain1.x += 500;
								FlxTween.tween(dad, {x: dad.x - 800}, 0.4, {ease: FlxEase.quadInOut});
								if (dad.clipRect != null)
									coolnumber = dad.clipRect.width;
								FlxTween.tween(this, {coolnumber: coolnumber + 600}, 0.45, {ease: FlxEase.quadInOut, onUpdate: function (twn:FlxTween) {dad.clipRect = new FlxRect(0, 0, coolnumber, 1200);}});
								FlxTween.tween(dadAgain1, {y: dadAgain1.y - 1000}, 0.5, {ease: FlxEase.quadInOut});
							case 19:
								var thingything = 2;
								flashScreen(FlxColor.WHITE,0.5);
								dad.scale.set(thingything,thingything);
								dad.updateHitbox();

								for (anim in dad.animOffsets.keys())
								{
									dad.animOffsets[anim] = [dad.animOffsets[anim][0]*thingything,dad.animOffsets[anim][1]*thingything];
								}
								dad.y += 400;
								dad.x += 250;
								bg1.loadGraphic(Paths.image('atrocity/moreBGs/bg10'));
								bg2.x += 1000;
								boyfriend.alpha = 0;
								iconP1.alpha = 0;
							case 20:
								boyfriend.alpha = 1;
								bg2.loadGraphic(Paths.image('atrocity/moreBGs/bg11'));
								var thingything = 2;
								boyfriend.scale.set(thingything,thingything);
								boyfriend.updateHitbox();
						
								for (anim in boyfriend.animOffsets.keys())
								{
									boyfriend.animOffsets[anim] = [boyfriend.animOffsets[anim][0]*thingything,boyfriend.animOffsets[anim][1]*thingything];
								}
								boyfriend.y += 400;
								boyfriend.x += 1500;
								FlxTween.tween(bg2, {x: bg2.x - 1000}, 0.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(iconP1, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(boyfriend, {x: boyfriend.x - 1000}, 0.5, {ease: FlxEase.quadInOut});
							case 21:
								var thingything = 2;
								flashScreen(FlxColor.WHITE,0.5);
								dad.scale.set(thingything,thingything);
								dad.updateHitbox();

								for (anim in dad.animOffsets.keys())
								{
									dad.animOffsets[anim] = [dad.animOffsets[anim][0]*thingything,dad.animOffsets[anim][1]*thingything];
								}
								dad.y += 400;
								dad.x += 250;
								bg1.loadGraphic(Paths.image('atrocity/moreBGs/bg12'));
								flashScreen(FlxColor.WHITE,0.5);
								boyfriend.alpha = 0.00001;
								iconP1.alpha = 0.00001;
								bg2.alpha = 0;
							case 22:
								boyfriend.alpha = 1;
								bg2.alpha = 1;
								var thingything = 2;
								bg2.x += 1000;
								boyfriend.scale.set(thingything,thingything);
								boyfriend.updateHitbox();

								for (anim in boyfriend.animOffsets.keys())
								{
									boyfriend.animOffsets[anim] = [boyfriend.animOffsets[anim][0]*thingything,boyfriend.animOffsets[anim][1]*thingything];
								}
								boyfriend.y += 400;
								boyfriend.x += 450 + 1000;
								FlxTween.tween(boyfriend, {x: boyfriend.x - 1000}, 0.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(iconP1, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(bg2, {x: bg2.x - 1000}, 0.5, {ease: FlxEase.quadInOut});
								bg2.loadGraphic(Paths.image('atrocity/moreBGs/bg13'));
							case 23:
								var thingything = 2;
								dadAgain1.scale.set(thingything,thingything);
								dadAgain1.updateHitbox();
						
								for (anim in dadAgain1.animOffsets.keys())
								{
									dadAgain1.animOffsets[anim] = [dadAgain1.animOffsets[anim][0]*thingything,dadAgain1.animOffsets[anim][1]*thingything];
								}
								dadAgain1.y += 400;
								dadAgain1.x += 500 - 881;
								dadAgain1.dance();
								bg6.visible = true;
								FlxTween.tween(bg1, {x: bg1.x + 881}, 0.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(bg2, {x: bg2.x + 881}, 0.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(bg6, {x: bg6.x + 881}, 0.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(boyfriend, {x: boyfriend.x + 881}, 0.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(dad, {x: dad.x + 881}, 0.5, {ease: FlxEase.quadInOut});
								FlxTween.tween(dadAgain1, {x: dadAgain1.x + 881}, 0.5, {ease: FlxEase.quadInOut});
							case 24:
								flashScreen(FlxColor.WHITE,0.5);
								dad.x -= 881;
								var thingything = 2;
								boyfriend.scale.set(thingything,thingything);
								boyfriend.updateHitbox();
						
								for (anim in boyfriend.animOffsets.keys())
								{
									boyfriend.animOffsets[anim] = [boyfriend.animOffsets[anim][0]*thingything,boyfriend.animOffsets[anim][1]*thingything];
								}
								boyfriend.y += 400;
								boyfriend.x += 500;
							case 25:
								var thingything = 2;
								boyfriendAgain.scale.set(thingything,thingything);
								boyfriendAgain.updateHitbox();

								for (anim in boyfriendAgain.animOffsets.keys())
								{
									boyfriendAgain.animOffsets[anim] = [boyfriendAgain.animOffsets[anim][0]*thingything,boyfriendAgain.animOffsets[anim][1]*thingything];
								}
								boyfriendAgain.y += 200;
								boyfriendAgain.x += 700 + 600;
								boyfriendAgain.dance();
								FlxTween.tween(boyfriendAgain, {x: boyfriendAgain.x - 700}, 0.2, {ease: FlxEase.quadInOut});
							case 26:
								
								iconP1Again.visible = false;
								var thingything = 2;
								boyfriend.scale.set(thingything,thingything);
								boyfriend.updateHitbox();

								for (anim in boyfriend.animOffsets.keys())
								{
									boyfriend.animOffsets[anim] = [boyfriend.animOffsets[anim][0]*thingything,boyfriend.animOffsets[anim][1]*thingything];
								}
								boyfriend.y += 400;
								boyfriend.x += 450;
								boyfriend.dance();
							case 27:
								bg1.alpha = 0;
								bg2.alpha = 0;
								bg6.alpha = 0;
								boyfriend.visible = false;
								var thingything = 2;
								flashScreen(FlxColor.WHITE,0.1);
								dad.scale.set(thingything,thingything);
								dad.updateHitbox();

								for (anim in dad.animOffsets.keys())
								{
									dad.animOffsets[anim] = [dad.animOffsets[anim][0]*thingything,dad.animOffsets[anim][1]*thingything];
								}
								dad.y += 300;
								dad.x += 50;
							case 28:
								camHUD.alpha = 0;
								flashScreen(FlxColor.WHITE,0.5);
								bg3.acceleration.y = 1200;
								bg3.velocity.y -= 300;
								FlxG.camera.shake(0.05, 0.1);
								bg3.velocity.x += FlxG.random.int(-50, 50);
								bg4.visible = false;
								bg5.visible = false;
								bg1.loadGraphic(Paths.image('snow shit/castle'));
								bg2.loadGraphic(Paths.image('snow shit/bridge'));
								bg6.loadGraphic(Paths.image('snow shit/stage'));
								bg1.x = -620;
								bg1.y = -1100;
								bg2.x = -650;
								bg2.y = -100;
								bg6.x = -650;
								bg6.y = 800;
								dadAgain1.x += 800;
								dadAgain1.y += 200;
								FlxTween.tween(dad.scale, {x: 1, y: 1}, 0.2, {ease: FlxEase.quadIn, onComplete: function (twn:FlxTween) {dad.updateHitbox();}});
								FlxTween.tween(bg1, {alpha: 1}, 0.2, {ease: FlxEase.quadIn});
								FlxTween.tween(bg2, {alpha: 1}, 0.2, {ease: FlxEase.quadIn});
								FlxTween.tween(bg6, {alpha: 1}, 0.2, {ease: FlxEase.quadIn});
								var thingything = 0.5;

								for (anim in dad.animOffsets.keys())
								{
									dad.animOffsets[anim] = [dad.animOffsets[anim][0]*thingything,dad.animOffsets[anim][1]*thingything];
								}
								FlxG.sound.play(Paths.sound('atrocity/bam'), 1);
							case 29:
								FlxTween.tween(camHUD, {alpha: 1}, 0.75, {ease: FlxEase.quadIn});
								boyfriend.x += 700;
								boyfriend.y += 2000;
								FlxTween.tween(boyfriend, {y: boyfriend.y - 2300}, 0.75, {ease: FlxEase.quadInOut});
								boyfriendAgain.x += 1900;
								FlxTween.tween(boyfriendAgain, {x: boyfriendAgain.x - 1000}, 1, {ease: FlxEase.quadInOut});
								FlxTween.tween(boyfriendAgain, {y: boyfriendAgain.y - 500}, 1.5, {ease: FlxEase.quadInOut});
							case 30:
								boyfriend.x += 700;
								boyfriend.y -= 300;
							case 31:
								flashScreen(FlxColor.WHITE,0.1);
								boyfriend.x += 800;
								boyfriend.y += 250;
								boyfriendAgain.x += 700;
								boyfriendAgain.y += 200;
							case 32:
								flashScreen(FlxColor.WHITE,0.1);
								boyfriend.x += 800;
								boyfriend.y += 350;
								boyfriendAgain.x += 1000;
								boyfriendAgain.y += 350;
							case 33:
								flashScreen(FlxColor.WHITE,0.1);
								boyfriend.x += 800;
								boyfriend.y += 250;
							case 34:
								defaultCamZoom = 0.5;
								dadAgain2.x += 800 + 670;
								dadAgain2.y += 250;
								FlxTween.tween(dadAgain2, {x: dadAgain2.x - 570}, 0.25, {ease: FlxEase.quadInOut});
								boyfriend.x += 1000;
								boyfriend.y += 500;
								FlxTween.tween(boyfriend, {x: boyfriend.x - 1000}, 1, {ease: FlxEase.quadInOut});
								FlxTween.tween(boyfriend, {y: boyfriend.y - 500}, 1.5, {ease: FlxEase.quadInOut});
								boyfriendAgain.x += 1000;
								boyfriendAgain.y += 500;
								FlxTween.tween(boyfriendAgain, {x: boyfriendAgain.x - 1000}, 1, {ease: FlxEase.quadInOut});
								FlxTween.tween(boyfriendAgain, {y: boyfriendAgain.y - 500}, 1.5, {ease: FlxEase.quadInOut});
							case 35:
								flashScreen(FlxColor.WHITE,3);
								dad.alpha = 0.000001;
								dadAgain1.alpha = 0.000001;
								dadAgain2.alpha = 0.000001;
								boyfriend.alpha = 0.000001;
								boyfriendAgain.alpha = 0.000001;
								bg1.alpha = 0.000001;
								bg2.alpha = 0.000001;
								bg6.alpha = 0.000001;
							case 36:
								iconP2Again1.visible = false;
								iconP2Again2.visible = false;
								iconP1Again.visible = false;
								FlxTween.tween(dad, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
								FlxTween.tween(boyfriend, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
						}
					case 9:
						switch (Std.parseInt(value2))
						{
							case 0:
								FlxTween.tween(dad, {alpha: 0.00001}, 0.6, {ease: FlxEase.quadInOut});
								FlxTween.tween(dadBETADCIU, {alpha: 1, x: dadBETADCIU.x + 500}, 0.6, {ease: FlxEase.quadInOut});
								iconP2.changeIcon(dadBETADCIU.healthIcon);
								healthBar.createFilledBar(FlxColor.fromRGB(dadBETADCIU.healthColorArray[0], dadBETADCIU.healthColorArray[1], dadBETADCIU.healthColorArray[2]),
									FlxColor.fromRGB(boyfriendBETADCIU.healthColorArray[0], boyfriendBETADCIU.healthColorArray[1], boyfriendBETADCIU.healthColorArray[2]));
								healthBar.updateBar();
							case 1:
								FlxTween.tween(boyfriend, {alpha: 0.00001}, 0.6, {ease: FlxEase.quadInOut});
								FlxTween.tween(boyfriendBETADCIU, {alpha: 1, x: boyfriendBETADCIU.x - 500}, 0.6, {ease: FlxEase.quadInOut});
								iconP1.changeIcon(boyfriendBETADCIU.healthIcon);
								healthBar.createFilledBar(FlxColor.fromRGB(dadBETADCIU.healthColorArray[0], dadBETADCIU.healthColorArray[1], dadBETADCIU.healthColorArray[2]),
									FlxColor.fromRGB(boyfriendBETADCIU.healthColorArray[0], boyfriendBETADCIU.healthColorArray[1], boyfriendBETADCIU.healthColorArray[2]));
								healthBar.updateBar();
							case 2:
								currentWindowLocation = [Lib.application.window.x, Lib.application.window.y];
								Lib.application.window.x += FlxG.random.int(-100, 100);
								Lib.application.window.y += FlxG.random.int(-100, 100);
							case 3:
								Lib.application.window.x += FlxG.random.int(-100, 100);
								Lib.application.window.y += FlxG.random.int(-100, 100);
							case 4:
								FlxTween.tween(Lib.application.window, {x: currentWindowLocation[0], y: currentWindowLocation[1]}, 0.8, {onUpdate: function (twn:FlxTween) {
									Lib.application.window.x += FlxG.random.int(-100, 100);
									Lib.application.window.y += FlxG.random.int(-100, 100);
								}});
							case 5:
								Lib.application.window.x = currentWindowLocation[0];
								Lib.application.window.y = currentWindowLocation[1];
						}
					case 10:
						
						FlxTween.tween(this, {ccsongBackSpriteWidth: FlxG.width}, 1.25,
							{
								onComplete: function(twn:FlxTween)
								{
									FlxTween.tween(ccdisplaySongName, {y: ccsongBackSprite.y + 30, alpha: 1}, 0.40, {
										ease: FlxEase.elasticInOut,
										onComplete: function(twn:FlxTween)
										{
											trace (ccdisplaySongName.x + ccdisplaySongName.width - cciconSongName.x);
											FlxTween.tween(this, {ccsongNameDistance: 70}, 0.5, {
												ease: FlxEase.elasticInOut
											});
											FlxTween.tween(cciconSongName, {alpha: 1}, 0.5, {
												ease: FlxEase.elasticInOut
											});
											FlxTween.tween(cciconSongNameAgain, {alpha: 1}, 0.5, {
												ease: FlxEase.elasticInOut
											});
											FlxTween.tween(ccdisplayArtistName, {y: ccdisplaySongName.y + 50, alpha: 1}, 0.5, {
												ease: FlxEase.elasticInOut
											});
											
											new FlxTimer().start(2, function(tmr:FlxTimer)
											{
												FlxTween.tween(ccsongBackSprite, {y: ccsongBackSprite.y - 100, alpha: 0}, 0.5, {
													ease: FlxEase.elasticInOut
												});
												FlxTween.tween(ccdisplayArtistName, {y: ccdisplayArtistName.y - 100, alpha: 0}, 0.5, {
													ease: FlxEase.elasticInOut
												});
												FlxTween.tween(ccdisplaySongName, {y: ccdisplaySongName.y - 100, alpha: 0}, 0.5, {
													ease: FlxEase.elasticInOut
												});
												FlxTween.tween(cciconSongName, {y: cciconSongName.y - 100, alpha: 0}, 0.5, {
													ease: FlxEase.elasticInOut
												});
												FlxTween.tween(cciconSongNameAgain, {alpha: 0}, 0.5, {
													ease: FlxEase.elasticInOut
												});
											});
										}
									});
								}
							});
					case 11:
						
						FlxTween.tween(this, {RobosongBackSpriteWidth: FlxG.width}, 1.25,
							{
								onComplete: function(twn:FlxTween)
								{
									FlxTween.tween(RobodisplaySongName, {y: RobosongBackSprite.y + 30, alpha: 1}, 0.40, {
										ease: FlxEase.elasticInOut,
										onComplete: function(twn:FlxTween)
										{
											trace (RobodisplaySongName.x + RobodisplaySongName.width - RoboiconSongName.x);
											FlxTween.tween(this, {RobosongNameDistance: 70}, 0.5, {
												ease: FlxEase.elasticInOut
											});
											FlxTween.tween(RoboiconSongName, {alpha: 1}, 0.5, {
												ease: FlxEase.elasticInOut
											});
											FlxTween.tween(RoboiconSongNameAgain, {alpha: 1}, 0.5, {
												ease: FlxEase.elasticInOut
											});
											FlxTween.tween(RobodisplayArtistName, {y: RobodisplaySongName.y + 50, alpha: 1}, 0.5, {
												ease: FlxEase.elasticInOut
											});
											
											new FlxTimer().start(2, function(tmr:FlxTimer)
											{
												FlxTween.tween(RobosongBackSprite, {y: RobosongBackSprite.y - 100, alpha: 0}, 0.5, {
													ease: FlxEase.elasticInOut
												});
												FlxTween.tween(RobodisplayArtistName, {y: RobodisplayArtistName.y - 100, alpha: 0}, 0.5, {
													ease: FlxEase.elasticInOut
												});
												FlxTween.tween(RobodisplaySongName, {y: RobodisplaySongName.y - 100, alpha: 0}, 0.5, {
													ease: FlxEase.elasticInOut
												});
												FlxTween.tween(RoboiconSongName, {y: RoboiconSongName.y - 100, alpha: 0}, 0.5, {
													ease: FlxEase.elasticInOut
												});
												FlxTween.tween(RoboiconSongNameAgain, {alpha: 0}, 0.5, {
													ease: FlxEase.elasticInOut
												});
											});
										}
									});
								}
							});
					case 12:
						switch (Std.parseInt(value2))
						{
							case 0:
								FlxTween.tween(bg1, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});
							case 1:
								bg3.alpha = 0;
								bg4.alpha = 0;
								bg5.alpha = 0;
								bawShader = new BlackAndWhiteEffect(0.1);
								bawShader2 = new BlackAndWhiteEffect(0.3);
								addShaderToCamera('camGame', bawShader);
								addShaderToCamera('camHUD', bawShader2);
								addShaderToCamera('camHUDier', bawShader2);
							case 2:
								bg3.alpha = 1/3;
								bg4.alpha = 1/3;
								bg5.alpha = 1/3;
								removeShaderFromCamera('camGame', bawShader);
								removeShaderFromCamera('camHUD', bawShader2);
								removeShaderFromCamera('camHUDier', bawShader2);

							case 3:
								var songName:String = Paths.formatToSongPath(SONG.song);
								var file:String = Paths.json(songName + '/dialogueChant'); //dialogueTiky dumbass
								#if sys
								if (#if MODS_ALLOWED FileSystem.exists(Paths.modsJson(songName + '/dialogueChant')) || #end FileSystem.exists(file))
								#else
								if (OpenFlAssets.exists(file))
								#end
								{
									//clearEvents();
									var events = parseDialogue(file);
									roboticDialogues = events.dialogues.copy();
								}
								textBox = new TextBox(0, 400, 125, FlxColor.fromRGB(0, 0, 0), 0.75, roboticDialogues[0].line, 'RoboVerse/robotic', true, 5);
								textBox.allDialogues = roboticDialogues;
								add(textBox);
								textBox.cameras = [camHUDier];
								textBox.goToNextDialogue();
								textBox.alpha = 0;
								textBox.onComplete = nopenothing;
							case 4:
									var sponge:FlxSprite = new FlxSprite(dad.getGraphicMidpoint().x - 400,
									dad.getGraphicMidpoint().y - 420).loadGraphic(Paths.image('milk/asgore', 'shared'));

								add(sponge);

								dad.visible = false;

								new FlxTimer().start(0.7, function(tmr:FlxTimer)
								{
									remove(sponge);
									dad.visible = true;
								});
							case 5:
								dad.visible = true;
						}
				}
			
			case 'Flash':
				trace('aaaaaaaaaaaaaa');
				if (ClientPrefs.flashing)
					flashScreen(FlxColor.fromString(value1), Std.parseFloat(value2));

			case 'Cuphead super shot':
				superType = 'normal';
				dadBETADCIU.playAnim('Hadoken!!');
				dadBETADCIU.specialAnim = true;
				switch (dad.curCharacter)
				{
					case 'extiky':
						dad.playAnim('Hank');
				}
				cupheadAlert();
				bfDodgin = false;
				dodge.animation.play('idle');
				cupheadShooting = false;
			
			case 'Cuphead super shot circle':
				superType = 'round';
				dadBETADCIU.playAnim('Hadoken!!');
				dadBETADCIU.specialAnim = true;
				cupheadAlert();
				bfDodgin = false;
				dodge.animation.play('idle');
				cupheadShooting = false;
			
			case 'Cuphead start shooting':
				cupheadShooting = true;
				shotType = 'blue';
				dad.dance();
				dadBETADCIU.dance();
				monikaHit = false;
				if (dad.curCharacter == 'lordX')
				{
					for (i in 0...4) {
						var cross:FlxSprite = new FlxSprite(playerStrums.members[i].x + 5, playerStrums.members[i].y, Paths.image('knockout/shootstuff/one projectile/cross'));
						cross.alpha = 0;
						cross.y -= 30;
						FlxTween.tween(cross, {alpha: 1, y: cross.y + 30}, 0.3, {ease: FlxEase.quadIn});
						crossArray.push(cross);
						crossed[i] = true;
						cross.cameras = [camHUDier];
						PlayState.instance.add(cross);
					}
					dumbasstext2.text = 'ATTACK!!!!';
					dumbasstext2.cameras = [camHUD];
					add(dumbasstext2);
					dumbasstext2.screenCenter();
				}
			
			case 'Cuphead start shooting chaser':
				cupheadShooting = true;
				shotType = 'green';

			case 'Cuphead stop shooting':
				cupheadShooting = false;
				shotType = '';
	
			case 'tween iconp2again2 to funni place':
				FlxTween.tween(this, {iconDistance2: 0}, 0.5, {ease: FlxEase.quadInOut});
				FlxTween.tween(iconP2Again2, {angle: 360 * 3}, 0.5, {ease: FlxEase.quadInOut});

			case 'Change Scroll Speed':
				if (songSpeedType == "constant")
					return;
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 1;
				if(Math.isNaN(val2)) val2 = 0;

				var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * val1;

				if(val2 <= 0)
				{
					songSpeed = newValue;
				}
				else
				{
					songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, val2, {ease: FlxEase.linear, onComplete:
						function (twn:FlxTween)
						{
							songSpeedTween = null;
						}
					});
				}
		}
		callOnLuas('onEvent', [eventName, value1, value2]);
	}

	function moveCameraSection(?id:Int = 0):Void {
		if(SONG.notes[id] == null) return;

		if (gf != null && SONG.notes[id].gfSection)
		{
			camFollow.set(gf.getMidpoint().x, gf.getMidpoint().y);
			camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
			camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
			tweenCamIn();
			callOnLuas('onMoveCamera', ['gf']);
			return;
		}

		if (!SONG.notes[id].mustHitSection)
		{
			//moveCamera(true);
			callOnLuas('onMoveCamera', ['dad']);
		}
		else
		{
			//moveCamera(false);
			callOnLuas('onMoveCamera', ['boyfriend']);
		}
	}

	var cameraTwn:FlxTween;
	public function moveCamera(isDad:Bool)
	{
		if(isDad)
		{
			camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
			camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
			tweenCamIn();
		}
		else
		{
			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
			camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];

			if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1)
			{
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
					function (twn:FlxTween)
					{
						cameraTwn = null;
					}
				});
			}
		}
	}

	function tweenCamIn() {
		if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1.3) {
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	//Any way to do this without using a different function? kinda dumb
	private function onSongComplete()
	{
		finishSong(false);
	}
	public function finishSong(?ignoreNoteOffset:Bool = false):Void
	{
		var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.

		updateTime = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		vocals.pause();
		if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
			finishCallback();
		} else {
			finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
				finishCallback();
			});
		}
	}


	public var transitioning = false;
	public function endSong():Void
	{
		//Should kill you if you tried to cheat
		if(!startingSong) {
			notes.forEach(function(daNote:Note) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			});
			for (daNote in unspawnNotes) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			}

			if(doDeathCheck()) {
				return;
			}
		}
		
		timeBarBG.visible = false;
		timeBar.visible = false;
		timeTxt.visible = false;
		canPause = false;
		endingSong = true;
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		deathCounter = 0;
		seenCutscene = false;

		#if ACHIEVEMENTS_ALLOWED
		if(achievementObj != null) {
			return;
		} else {
			var achieve:String = checkForAchievement(['week1_nomiss', 'week2_nomiss', 'week3_nomiss', 'week4_nomiss',
				'week5_nomiss', 'week6_nomiss', 'week7_nomiss', 'ur_bad',
				'ur_good', 'hype', 'two_keys', 'toastie', 'debugger']);

			if(achieve != null) {
				startAchievement(achieve);
				return;
			}
		}
		#end
		
		#if LUA_ALLOWED
		var ret:Dynamic = callOnLuas('onEndSong', []);
		#else
		var ret:Dynamic = FunkinLua.Function_Continue;
		#end

		if(ret != FunkinLua.Function_Stop && !transitioning) {
			if (SONG.validScore)
			{
				#if !switch
				var percent:Float = ratingPercent;
				if(Math.isNaN(percent)) percent = 0;
				Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent);
				#end
			}

			if (chartingMode)
			{
				openChartEditor();
				return;
			}

			if (isStoryMode)
			{
				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					cancelMusicFadeTween();
					if(FlxTransitionableState.skipNextTransIn) {
						CustomFadeTransition.nextCamera = null;
					}
					MusicBeatState.switchState(new StoryMenuState());

					// if ()
					if(!ClientPrefs.getGameplaySetting('practice', false) && !ClientPrefs.getGameplaySetting('botplay', false)) {
						StoryMenuState.weekCompleted.set(WeekData.weeksList[storyWeek], true);

						if (SONG.validScore)
						{
							Highscore.saveWeekScore(WeekData.getWeekFileName(), campaignScore, storyDifficulty);
						}

						FlxG.save.data.weekCompleted = StoryMenuState.weekCompleted;
						FlxG.save.flush();
					}
					changedDifficulty = false;
				}
				else
				{
					var difficulty:String = CoolUtil.getDifficultyFilePath();

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

					var winterHorrorlandNext = (Paths.formatToSongPath(SONG.song) == "eggnog");
					if (winterHorrorlandNext)
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if(winterHorrorlandNext) {
						new FlxTimer().start(1.5, function(tmr:FlxTimer) {
							cancelMusicFadeTween();
							LoadingState.loadAndSwitchState(new PlayState());
						});
					} else {
						cancelMusicFadeTween();
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				cancelMusicFadeTween();
				if(FlxTransitionableState.skipNextTransIn) {
					CustomFadeTransition.nextCamera = null;
				}

				FlxG.sound.music.stop();
				var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
				if (RoboticFunctions.ifBeatenSong(PlayState.SONG.song) && !usedPractice)
					LoadingState.loadAndSwitchState(new FreeplayState());
				else
					LoadingState.loadAndSwitchState(new RoboCoin());
			}
			transitioning = true;
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	var achievementObj:AchievementObject = null;
	function startAchievement(achieve:String) {
		achievementObj = new AchievementObject(achieve, camOther);
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve);
	}
	function achievementEnd():Void
	{
		achievementObj = null;
		if(endingSong && !inCutscene) {
			endSong();
		}
	}
	#end

	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	public var totalPlayed:Int = 0;
	public var totalNotesHit:Float = 0.0;

	public var showCombo:Bool = true;
	public var showRating:Bool = true;

	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
		//trace(noteDiff, ' ' + Math.abs(note.strumTime - Conductor.songPosition));

		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		//tryna do MS based judgment due to popular demand
		var daRating:String = Conductor.judgeNote(note, noteDiff);

		switch (daRating)
		{
			case "shit": // shit
				totalNotesHit += 0;
				note.ratingMod = 0;
				score = 50;
				if(!note.ratingDisabled) shits++;
			case "bad": // bad
				totalNotesHit += 0.5;
				note.ratingMod = 0.5;
				score = 100;
				if(!note.ratingDisabled) bads++;
			case "good": // good
				totalNotesHit += 0.75;
				note.ratingMod = 0.75;
				score = 200;
				if(!note.ratingDisabled) goods++;
			case "sick": // sick
				totalNotesHit += 1;
				note.ratingMod = 1;
				if(!note.ratingDisabled) sicks++;
		}
		note.rating = daRating;

		if(daRating == 'sick' && !note.noteSplashDisabled)
		{
			spawnNoteSplashOnNote(note);
		}

		if(!practiceMode && !cpuControlled) {
			songScore += score;
			if(!note.ratingDisabled)
			{
				songHits++;
				totalPlayed++;
				RecalculateRating();
			}

			if(ClientPrefs.scoreZoom)
			{
				if(scoreTxtTween != null) {
					scoreTxtTween.cancel();
				}
				scoreTxt.scale.x = 1.075;
				scoreTxt.scale.y = 1.075;
				scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
					onComplete: function(twn:FlxTween) {
						scoreTxtTween = null;
					}
				});
			}
		}

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (PlayState.isPixelStage)
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.cameras = [camHUD];
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.visible = (!ClientPrefs.hideHud && showRating);
		rating.x += ClientPrefs.comboOffset[0];
		rating.y -= ClientPrefs.comboOffset[1];

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.cameras = [camHUD];
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.visible = (!ClientPrefs.hideHud && showCombo);
		comboSpr.x += ClientPrefs.comboOffset[0];
		comboSpr.y -= ClientPrefs.comboOffset[1];


		comboSpr.velocity.x += FlxG.random.int(1, 10);
		insert(members.indexOf(strumLineNotes), rating);

		if (!PlayState.isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.85));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.85));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		if(combo >= 1000) {
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}
		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.cameras = [camHUD];
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			numScore.x += ClientPrefs.comboOffset[2];
			numScore.y -= ClientPrefs.comboOffset[3];

			if (!PlayState.isPixelStage)
			{
				numScore.antialiasing = ClientPrefs.globalAntialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
			numScore.visible = !ClientPrefs.hideHud;

			//if (combo >= 10 || combo == 0)
				insert(members.indexOf(strumLineNotes), numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
	}

	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		//trace('Pressed: ' + eventKey);

		if (!cpuControlled && !paused && key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || ClientPrefs.controllerMode))
		{
			if(!boyfriend.stunned && generatedMusic && !endingSong)
			{
				//more accurate hit time for the ratings?
				var lastTime:Float = Conductor.songPosition;
				Conductor.songPosition = FlxG.sound.music.time;

				var canMiss:Bool = !ClientPrefs.ghostTapping;

				// heavily based on my own code LOL if it aint broke dont fix it
				var pressNotes:Array<Note> = [];
				//var notesDatas:Array<Int> = [];
				var notesStopped:Bool = false;

				var sortedNotesList:Array<Note> = [];
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote)
					{
						if(daNote.noteData == key)
						{
							sortedNotesList.push(daNote);
							//notesDatas.push(daNote.noteData);
						}
						canMiss = true;
					}
				});
				sortedNotesList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

				if (sortedNotesList.length > 0) {
					for (epicNote in sortedNotesList)
					{
						for (doubleNote in pressNotes) {
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
								doubleNote.kill();
								notes.remove(doubleNote, true);
								doubleNote.destroy();
							} else
								notesStopped = true;
						}
							
						// eee jack detection before was not super good
						if (!notesStopped) {
							if (!crossed[epicNote.noteData])
								goodNoteHit(epicNote);
							pressNotes.push(epicNote);
						}

					}
				}
				else if (canMiss) {
					noteMissPress(key);
					callOnLuas('noteMissPress', [key]);
				}

				// I dunno what you need this for but here you go
				//									- Shubs

				// Shubs, this is for the "Just the Two of Us" achievement lol
				//									- Shadow Mario
				keysPressed[key] = true;

				//more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
				Conductor.songPosition = lastTime;
			}

			var spr:StrumNote = playerStrums.members[key];
			if(spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyPress', [key]);
		}
		//trace('pressed: ' + controlArray);
	}
	
	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		if(!cpuControlled && !paused && key > -1)
		{
			var spr:StrumNote = playerStrums.members[key];
			if(spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyRelease', [key]);
		}
		//trace('released: ' + controlArray);
	}

	private function getKeyFromEvent(key:FlxKey):Int
	{
		if(key != NONE)
		{
			for (i in 0...keysArray.length)
			{
				for (j in 0...keysArray[i].length)
				{
					if(key == keysArray[i][j])
					{
						return i;
					}
				}
			}
		}
		return -1;
	}

	// Hold notes
	private function keyShit():Void
	{
		// HOLDING
		var up = controls.NOTE_UP;
		var right = controls.NOTE_RIGHT;
		var down = controls.NOTE_DOWN;
		var left = controls.NOTE_LEFT;
		var controlHoldArray:Array<Bool> = [left, down, up, right];
		
		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var controlArray:Array<Bool> = [controls.NOTE_LEFT_P, controls.NOTE_DOWN_P, controls.NOTE_UP_P, controls.NOTE_RIGHT_P];
			if(controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if(controlArray[i])
						onKeyPress(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, -1, keysArray[i][0]));
				}
			}
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (!boyfriend.stunned && generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (daNote.isSustainNote && controlHoldArray[daNote.noteData] && daNote.canBeHit 
				&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit) {
					if (!crossed[daNote.noteData])
						goodNoteHit(daNote);
				}
			});

			if (controlHoldArray.contains(true) && !endingSong) {
				#if ACHIEVEMENTS_ALLOWED
				var achieve:String = checkForAchievement(['oversinging']);
				if (achieve != null) {
					startAchievement(achieve);
				}
				#end
			}
			else
			{
				if (boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					boyfriend.dance();
				if (boyfriendAgain.holdTimer > Conductor.stepCrochet * 0.001 * boyfriendAgain.singDuration && boyfriendAgain.animation.curAnim.name.startsWith('sing') && !boyfriendAgain.animation.curAnim.name.endsWith('miss'))
					boyfriendAgain.dance();
				if (boyfriendBETADCIU.holdTimer > Conductor.stepCrochet * 0.001 * boyfriendBETADCIU.singDuration && boyfriendBETADCIU.animation.curAnim.name.startsWith('sing') && !boyfriendBETADCIU.animation.curAnim.name.endsWith('miss'))
					boyfriendBETADCIU.dance();
				//boyfriend.animation.curAnim.finish();
			}
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var controlArray:Array<Bool> = [controls.NOTE_LEFT_R, controls.NOTE_DOWN_R, controls.NOTE_UP_R, controls.NOTE_RIGHT_R];
			if(controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if(controlArray[i])
						onKeyRelease(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, -1, keysArray[i][0]));
				}
			}
		}
	}

	function noteMiss(daNote:Note):Void { //You didn't hit the key and let it go offscreen, also used by Hurt Notes
		//Dupe note remove
		notes.forEachAlive(function(note:Note) {
			if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 1) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});
		combo = 0;

		health -= daNote.missHealth * healthLoss;
		if (daNote.missHealth * healthLoss < 0)
			interupt = true;
		if(instakillOnMiss)
		{
			vocals.volume = 0;
			doDeathCheck(true);
		}

		//For testing purposes
		//trace(daNote.missHealth);
		songMisses++;
		vocals.volume = 0;
		if(!practiceMode) songScore -= 10;
		
		totalPlayed++;
		RecalculateRating();

		var char:Character = boyfriend;
		if(daNote.gfNote) {
			if (!gfAgainSinging)
				char = gf;
			else
				char = gfAgain;
		}

		if(char != null && char.hasMissAnimations)
		{
			var daAlt = '';
			if(daNote.noteType == 'Alt Animation') daAlt = '-alt';

			var animToPlay:String = singAnimations[Std.int(Math.abs(daNote.noteData))] + 'miss' + daAlt;
			
			if (char.scale.x < 0)
			{
				if (Std.int(Math.abs(daNote.noteData)) == 3)
					animToPlay = singAnimations[0] + daAlt;
				
				if (Std.int(Math.abs(daNote.noteData)) == 0)
					animToPlay = singAnimations[3] + daAlt;
			}
			switch (betadciuMoment)
			{
				case true:
					if (curStage == 'knockout')
					{
						if (!boyfriendBETADCIU.specialAnim && boyfriendBETADCIU.animation.curAnim.name != 'attack')
							boyfriendBETADCIU.playAnim(animToPlay, true);
						if (((char != gf && char.curCharacter != boyfriendBETADCIU.curCharacter) || (char == gf)) && !char.specialAnim)
							char.playAnim(animToPlay, true);
					}
					else
					{
						boyfriendBETADCIU.playAnim(animToPlay, true);
						if ((char != gf && char.curCharacter != boyfriendBETADCIU.curCharacter) || (char == gf))
							char.playAnim(animToPlay, true);
					}

				default:
					if (curStage == 'knockout')
					{
						if (!char.specialAnim)
							char.playAnim(animToPlay, true);
					}
					else
					{
						char.playAnim(animToPlay, true);
						
						//atrocity
						if (curStage == 'jelly')
						{
							switch (dad.curCharacter)
							{
									
							}
						}
					}
			}
			if (boyfriendAgainSinging)
				boyfriendAgain.playAnim(animToPlay, true);
		}

		callOnLuas('noteMiss', [notes.members.indexOf(daNote), daNote.noteData, daNote.noteType, daNote.isSustainNote]);
	}

	function noteMissPress(direction:Int = 1):Void //You pressed a key when there was no notes to press for this key
	{
		if (!boyfriend.stunned)
		{
			health -= 0.05 * healthLoss;
			if(instakillOnMiss)
			{
				vocals.volume = 0;
				doDeathCheck(true);
			}

			if(ClientPrefs.ghostTapping) return;

			trace(gf.animOffsets.exists('sad'));
			if (combo > 5 && gf != null && gf.animOffsets.exists('sad'))
			{
				trace('man');
				gf.playAnim('sad', true);
				gfAgain.playAnim('sad', true);
			}
			combo = 0;

			if(!practiceMode) songScore -= 10;
			if(!endingSong) {
				songMisses++;
			}
			totalPlayed++;
			RecalculateRating();

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			/*boyfriend.stunned = true;

			// get stunned for 1/60 of a second, makes you able to
			new FlxTimer().start(1 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});*/

			if(boyfriend.hasMissAnimations) {
				boyfriend.playAnim(singAnimations[Std.int(Math.abs(direction))] + 'miss', true);
			}
			vocals.volume = 0;
		}
	}

	function opponentNoteHit(note:Note):Void
	{
		if (Paths.formatToSongPath(SONG.song) != 'tutorial')
			camZooming = true;

		if(note.noteType == 'Hey!' && dad.animOffsets.exists('hey')) {
			dad.playAnim('hey', true);
			dad.specialAnim = true;
			dad.heyTimer = 0.6;
		} else if(!note.noAnimation) {
			var altAnim:String = "";

			var curSection:Int = Math.floor(curStep / 16);
			if (SONG.notes[curSection] != null)
			{
				if (SONG.notes[curSection].altAnim || note.noteType == 'Alt Animation') {
					altAnim = '-alt';
				}
			}

			var char:Character = dad;
			if (char.curCharacter == 'snow' && curStage == 'jelly' && health > 0.4)
				health -= 0.01;
			if (char.curCharacter == 'qt-kb')
				if(SONG.song.toLowerCase() == 'headache' && curStep > 783) altAnim = '-together';
			var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))] + altAnim;
			if (char.scale.x < 0)
			{
				if (Std.int(Math.abs(note.noteData)) == 3)
					animToPlay = singAnimations[0] + altAnim;
				
				if (Std.int(Math.abs(note.noteData)) == 0)
					animToPlay = singAnimations[3] + altAnim;
			}
			if(note.gfNote) {
				if (!gfAgainSinging)
					char = gf;
				else
					char = gfAgain;
			}

			if(char != null)
			{
				switch (dad.curCharacter)
				{
					case 'extiky': // 60% chance
					if (FlxG.random.bool(60) && !spookyRendered && !note.isSustainNote) // create spooky text :flushed:
					{
						createSpookyText(HatKidLinesSing[FlxG.random.int(0, HatKidLinesSing.length)], ExTrickyLinesSing[FlxG.random.int(0, ExTrickyLinesSing.length)]);
					}
				}
				switch(curStage)
				{
					case 'auditorHell':
						if (hatturn)
						{
							dadAgain1.playAnim(animToPlay + altAnim, true);
							if (animToPlay == 'singUP')
							{
								hatSpikes.visible = true;
								if (hatSpikes.animation.finished)
									hatSpikes.animation.play('spike');
							}
							else
							{
								hatSpikes.animation.resume();
								//trace('go back spikes');
								hatSpikes.animation.finishCallback = function(pog:String) {
									//trace('finished');
									hatSpikes.visible = false;
									hatSpikes.animation.finishCallback = null;
								}
							}
						}
						//trace('spikes');
						if (tikturn)
						{
							if (animToPlay == 'singUP')
							{
								exSpikes.visible = true;
								if (exSpikes.animation.finished)
									exSpikes.animation.play('spike');
							}
							else
							{
								exSpikes.animation.resume();
								//trace('go back spikes');
								exSpikes.animation.finishCallback = function(pog:String) {
									//trace('finished');
									exSpikes.visible = false;
									exSpikes.animation.finishCallback = null;
								}
							}
							if (!(curBeat >= 532 && curBeat <= 536 && curSong.toLowerCase() == "expurgation"))
							{
								dad.playAnim(animToPlay + altAnim, true);
							}
						}
					default:
						if (curStage == 'pegmeplease')
						{
							circ2.angle += 5;
							circ1.angle += 5;
						}
						
						switch (betadciuMoment)
						{
							case true:
								if (curStage == 'knockout')
								{
									if ((char.specialAnim && cupheadShooting) || !char.specialAnim)
									{
										if (shotType == 'green' && !note.isSustainNote && !dadBETADCIU.specialAnim && dadBETADCIU.animation.curAnim.name != 'Hadoken!!')
										{
											if (dad.alpha > 0)
											{
												dadBETADCIU.playAnim(animToPlay + '-alt', true);
												dadBETADCIU.holdTimer = 0;
												cupheadShootAShot(false);
											}
										}
										else if (((dadBETADCIU.specialAnim && cupheadShooting) || !dadBETADCIU.specialAnim)  && dadBETADCIU.animation.curAnim.name != 'Hadoken!!')
										{
											if (dad.alpha > 0)
											{
												dadBETADCIU.playAnim(animToPlay.replace('-together', ''), true);
												dadBETADCIU.holdTimer = 0;
											}
										}
										if ((dadBETADCIU.specialAnim && cupheadShooting) || !dadBETADCIU.specialAnim)
										if (shotType == 'green' && !note.isSustainNote)
										{
											if (dadBETADCIU.curCharacter != dad.curCharacter)
											{
												if (dadAgain1Singing)
													dadAgain1.playAnim(animToPlay, true);
												if (dadAgain2Singing)
													dadAgain2.playAnim(animToPlay, true);
												char.playAnim(animToPlay, true);
												char.holdTimer = 0;
												if (dad.curCharacter.startsWith('ruv') || (dadAgain1Singing && dadAgain1.curCharacter.startsWith('ruv')))
													FlxG.camera.shake(0.01,0.1);
											}
											if (dad.alpha > 0)
											{
												switch (dad.curCharacter)
												{
													case 'ankha':
														cupheadShootAShotAnkha(false);
													case 'ChampionKnightEX':
														cupheadShootAShotSamantha(false);
													case 'sunky':
														cupheadShootAShotSunky(false);
													case 'eduardo':
														cupheadShootAShotWell(false);
													case 'agressive-yuri':
														cupheadShootAShotYuri(false);
													case 'selever':
														cupheadShootAShotSelever(false);
													case 'rose-opponent':
														cupheadShootAShotRose(false);
												}
												if (gfAgainSinging)
													cupheadShootAShotSusan(false);
											}
										}
										else
										{
											if (dadBETADCIU.curCharacter != dad.curCharacter)
											{
												if (dadAgain1Singing)
													dadAgain1.playAnim(animToPlay, true);
												if (dadAgain2Singing)
													dadAgain2.playAnim(animToPlay, true);
												char.playAnim(animToPlay, true);
												char.holdTimer = 0;
												if (dad.curCharacter.startsWith('ruv') || (dadAgain1Singing && dadAgain1.curCharacter.startsWith('ruv')) || (dadAgain2Singing && dadAgain2.curCharacter.startsWith('ruv')))
													FlxG.camera.shake(0.01,0.1);
											}
										}
									}
								}
								else
								{
									if (dad.alpha > 0)
									{
										dadBETADCIU.playAnim(animToPlay.replace('-together', ''), true);
										dadBETADCIU.holdTimer = 0;
										if (dadBETADCIU.curCharacter != dad.curCharacter)
										{
											if (dadAgain1Singing)
												dadAgain1.playAnim(animToPlay, true);
											if (dadAgain2Singing)
												dadAgain2.playAnim(animToPlay, true);
											char.playAnim(animToPlay, true);
											char.holdTimer = 0;
											if (dad.curCharacter.startsWith('ruv') || (dadAgain1Singing && dadAgain1.curCharacter.startsWith('ruv')) || (dadAgain2Singing && dadAgain2.curCharacter.startsWith('ruv')))
												FlxG.camera.shake(0.01,0.1);
										}
									}
								}

							default:
								if (curStage == 'knockout')
								{
									if (!char.specialAnim)
									{
										
										if (shotType == 'green' && !note.isSustainNote)
										{
											char.playAnim(animToPlay + '-alt', true);
											char.holdTimer = 0;
											cupheadShootAShot(false);
											if (dad.alpha > 0)
											{
												switch (dad.curCharacter)
												{
													case 'ankha':
														cupheadShootAShotAnkha(false);
													case 'ChampionKnightEX':
														cupheadShootAShotSamantha(false);
													case 'sunky':
														cupheadShootAShotSunky(false);
													case 'eduardo':
														cupheadShootAShotWell(false);
													case 'agressive-yuri':
														cupheadShootAShotYuri(false);
													case 'selever':
														cupheadShootAShotSelever(false);
													case 'rose-opponent':
														cupheadShootAShotRose(false);
												}
												if (gfAgainSinging)
													cupheadShootAShotSusan(false);
											}
										}
										else
										{
											if (dadAgain1Singing)
												dadAgain1.playAnim(animToPlay, true);
											if (dadAgain2Singing)
												dadAgain2.playAnim(animToPlay, true);
											char.playAnim(animToPlay, true);
											char.holdTimer = 0;
											if (dad.curCharacter.startsWith('ruv') || (dadAgain1Singing && dadAgain1.curCharacter.startsWith('ruv')) || (dadAgain2Singing && dadAgain2.curCharacter.startsWith('ruv')))
												FlxG.camera.shake(0.01,0.1);
										}
									}
								}
								else
								{
									
									switch (boyfriend.curCharacter)
									{
										case 'extiky': // 60% chance
										if (FlxG.random.bool(60) && !spookyRendered && !note.isSustainNote) // create spooky text :flushed:
										{
											createSpookyText(HatKidLinesSing[FlxG.random.int(0, HatKidLinesSing.length)], ExTrickyLinesSing[FlxG.random.int(0, ExTrickyLinesSing.length)]);
										}
									}
									if (dadAgain2Singing)
										dadAgain2.playAnim(animToPlay, true);
									if (dadAgain1Singing)
									{
										switch (curStage)
										{
											case 'jelly':
												if (curStep > 1791)
													dadAgain1.playAnim(animToPlay + '-alt', true);
												else
													dadAgain1.playAnim(animToPlay, true);
											default:
												dadAgain1.playAnim(animToPlay, true);
										}
									}
									if (dadSinging)
										char.playAnim(animToPlay, true);
									char.holdTimer = 0;
									if (dad.curCharacter.startsWith('ruv') || (dadAgain1Singing && dadAgain1.curCharacter.startsWith('ruv')) || (dadAgain2Singing && dadAgain2.curCharacter.startsWith('ruv')))
										FlxG.camera.shake(0.01,0.1);
									
									//atrocity
									if (curStage == 'jelly')
									{
										switch (dadAgain1.curCharacter)
										{
											case 'Papyrus_IC':
												if (dadAgain1.animation.curAnim.name.startsWith('singLEFT'))
													dadAgain1.clipRect = new FlxRect(0, 0, 480, 600);
												if (dadAgain1.animation.curAnim.name.startsWith('singRIGHT'))
													dadAgain1.clipRect = new FlxRect(0, 0, 400, 600);
												if (dadAgain1.animation.curAnim.name.startsWith('singUP'))
													dadAgain1.clipRect = new FlxRect(0, 60, 420, 600);
												if (dadAgain1.animation.curAnim.name.startsWith('singDOWN'))
													dadAgain1.clipRect = new FlxRect(0, 0, 380, 600);
												
											//case 'carey':
											//	if (dadAgain1.animation.curAnim.name.startsWith('singLEFT'))
											//		dadAgain1.clipRect = new FlxRect(0, 0, 480, 565);
											//	if (dadAgain1.animation.curAnim.name.startsWith('singRIGHT'))
											//		dadAgain1.clipRect = new FlxRect(0, 0, 460, 565);
											//	if (dadAgain1.animation.curAnim.name.startsWith('singUP'))
											//		dadAgain1.clipRect = new FlxRect(0, 0, 470, 565);
											//	if (dadAgain1.animation.curAnim.name.startsWith('singDOWN'))
											//		dadAgain1.clipRect = new FlxRect(0, 0, 460, 565);
										}
										switch (dad.curCharacter)
										{
											case 'Sans_IC':
												if (dad.animation.curAnim.name.startsWith('singLEFT'))
													dad.clipRect = new FlxRect(0, 0, 480, 400);
												if (dad.animation.curAnim.name.startsWith('singRIGHT'))
													dad.clipRect = new FlxRect(0, 0, 400, 400);
												if (dad.animation.curAnim.name.startsWith('singUP'))
													dad.clipRect = new FlxRect(0, 0, 420, 400);
												if (dad.animation.curAnim.name.startsWith('singDOWN'))
													dad.clipRect = new FlxRect(0, 0, 420, 400);
											case 'sans':
												if (dad.animation.curAnim.name.startsWith('singLEFT'))
													dad.clipRect = new FlxRect(0, 0, 480, 400);
												if (dad.animation.curAnim.name.startsWith('singRIGHT'))
													dad.clipRect = new FlxRect(0, 0, 370, 400);
												if (dad.animation.curAnim.name.startsWith('singUP'))
													dad.clipRect = new FlxRect(0, 0, 390, 400);
												if (dad.animation.curAnim.name.startsWith('singDOWN'))
													dad.clipRect = new FlxRect(0, 0, 420, 400);
											case 'zardy':
												if (dad.animation.curAnim.name.startsWith('singLEFT'))
													dad.clipRect = new FlxRect(0, 0, 520, 1200);
												if (dad.animation.curAnim.name.startsWith('singRIGHT'))
													dad.clipRect = new FlxRect(0, 0, 380, 1200);
												if (dad.animation.curAnim.name.startsWith('singUP'))
													dad.clipRect = new FlxRect(0, 0, 400, 1200);
												if (dad.animation.curAnim.name.startsWith('singDOWN'))
													dad.clipRect = new FlxRect(0, 0, 580, 1200);
											case 'derg':
												if (dad.animation.curAnim.name.startsWith('singLEFT'))
													dad.clipRect = new FlxRect(0, 0, 480, 565);
												if (dad.animation.curAnim.name.startsWith('singRIGHT'))
													dad.clipRect = new FlxRect(0, 0, 450, 565);
												if (dad.animation.curAnim.name.startsWith('singUP'))
													dad.clipRect = new FlxRect(0, 0, 450, 565);
												if (dad.animation.curAnim.name.startsWith('singDOWN'))
													dad.clipRect = new FlxRect(0, 0, 460, 565);
											case 'retrospectre':
												if (dad.animation.curAnim.name.startsWith('singLEFT'))
													dad.clipRect = new FlxRect(0, 0, 800, 1200);
												if (dad.animation.curAnim.name.startsWith('singRIGHT'))
													dad.clipRect = new FlxRect(0, 0, 680, 1200);
												if (dad.animation.curAnim.name.startsWith('singUP'))
													dad.clipRect = new FlxRect(0, 0, 770, 1200);
												if (dad.animation.curAnim.name.startsWith('singDOWN'))
													dad.clipRect = new FlxRect(0, 0, 800, 1200);
											case 'carey':
												if (dad.animation.curAnim.name.startsWith('singLEFT'))
													dad.clipRect = new FlxRect(0, 0, 480, 565);
												if (dad.animation.curAnim.name.startsWith('singRIGHT'))
													dad.clipRect = new FlxRect(0, 0, 460, 565);
												if (dad.animation.curAnim.name.startsWith('singUP'))
													dad.clipRect = new FlxRect(0, 0, 470, 565);
												if (dad.animation.curAnim.name.startsWith('singDOWN'))
													dad.clipRect = new FlxRect(0, 0, 460, 565);
										}
									}
								}
						}
		
				}
			}
		}

		if (SONG.needsVoices)
		{
			vocals.volume = 1;
			if (dad.alpha == 0 && curStage == 'knockout')
				vocals.volume = 0;
		}

		var time:Float = 0.15;
		if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
			time += 0.15;
		}
		StrumPlayAnim(true, Std.int(Math.abs(note.noteData)) % 4, time);
		note.hitByOpponent = true;

		callOnLuas('opponentNoteHit', [notes.members.indexOf(note), Math.abs(note.noteData), note.noteType, note.isSustainNote]);

		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (note.noteType == 'Parry Note')
		{
			FlxG.sound.play(Paths.sound('knockout/shootfunni/parry'), 1);
		}
		if (note.noteType == 'Parry Note')
		{
			if(superCardTween != null) {
				superCardTween.cancel();
			}
			superCard.animation.play('parry', true);
			superCardCharge = 147;
		}
		if (!note.wasGoodHit)
		{
			if (ClientPrefs.hitsoundVolume > 0 && !note.hitsoundDisabled)
			{
				FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
			}

			if((cpuControlled || roboRoboPerkActivated) && (note.ignoreNote || note.hitCausesMiss)) return;

			if(note.hitCausesMiss) {
				noteMiss(note);
				if(!note.noteSplashDisabled && !note.isSustainNote) {
					spawnNoteSplashOnNote(note);
				}

				switch(note.noteType) {
					case 'Hurt Note': //Hurt note
						if(boyfriend.animation.getByName('hurt') != null) {
							boyfriend.playAnim('hurt', true);
							boyfriend.specialAnim = true;
						}
					case 'TikyHat Note': //TikyHat Note
						if(boyfriend.animation.getByName('hurt') != null) {
							boyfriend.playAnim('hurt', true);
							boyfriend.specialAnim = true;
						}
						// lol death
						health = 0;
						shouldBeDead = true;
						FlxG.sound.play(Paths.sound('expurgation/death', 'shared'));
				}
				
				note.wasGoodHit = true;
				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}

			if (!note.isSustainNote)
			{
				combo += 1;
				popUpScore(note);
				if(combo > 9999) combo = 9999;
			}
			if (!grabbed && (note.hitHealth * healthGain > 0))
				health += note.hitHealth * healthGain;
			if ((note.hitHealth * healthGain > 0))
			{
				health += note.hitHealth * healthGain;
				interupt = true;
			}

			if(!note.noAnimation) {
				var daAlt = '';
				if(note.noteType == 'Alt Animation') daAlt = '-alt';
	
				var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];
				

				if(note.gfNote) 
				{
					if (gf.scale.x < 0)
					{
						if (Std.int(Math.abs(note.noteData)) == 3)
							animToPlay = singAnimations[0] + daAlt;
						
						if (Std.int(Math.abs(note.noteData)) == 0)
							animToPlay = singAnimations[3] + daAlt;
					}
					if(gf != null)
					{
						if (gfAgainSinging)
						{
							gfAgain.playAnim(animToPlay + daAlt, true);
							gfAgain.holdTimer = 0;
						}
						else
						{
							gf.playAnim(animToPlay + daAlt, true);
							gf.holdTimer = 0;
						}
					}
				}
				else
				{
					if (gf.scale.x < 0)
					{
						if (Std.int(Math.abs(note.noteData)) == 3)
							animToPlay = singAnimations[0] + daAlt;
						
						if (Std.int(Math.abs(note.noteData)) == 0)
							animToPlay = singAnimations[3] + daAlt;
					}
					
					switch (betadciuMoment)
					{
						case true:
							if (curStage == 'knockout')
							{
								if (superCardTween == null || !superCardTween.active)
									superCardCharge += 1;
								if (!boyfriendBETADCIU.specialAnim && boyfriendBETADCIU.animation.curAnim.name != 'attack')
								{
									boyfriendBETADCIU.playAnim(animToPlay, true);
									boyfriendBETADCIU.holdTimer = 0;
									boyfriendBETADCIU.playAnim(animToPlay, true);
									if (boyfriendAgainSinging)
										boyfriendAgain.playAnim(animToPlay, true);
									boyfriendBETADCIU.holdTimer = 0;
									if (boyfriendBETADCIU.curCharacter != boyfriend.curCharacter)
									{
										boyfriend.playAnim(animToPlay + daAlt, true);
										boyfriend.holdTimer = 0;
									}
									if (boyfriend.curCharacter.startsWith('ruv') || (boyfriendAgainSinging && boyfriendAgain.curCharacter.startsWith('ruv')))
										FlxG.camera.shake(0.01,0.1);
								}
							}
							else
							{
								boyfriendBETADCIU.playAnim(animToPlay, true);
								if (boyfriendAgainSinging)
									boyfriendAgain.playAnim(animToPlay, true);
								boyfriendBETADCIU.holdTimer = 0;
								if (boyfriendBETADCIU.curCharacter != boyfriend.curCharacter)
								{
									boyfriend.playAnim(animToPlay + daAlt, true);
									boyfriend.holdTimer = 0;
								}
								if (boyfriend.curCharacter.startsWith('ruv') || (boyfriendAgainSinging && boyfriendAgain.curCharacter.startsWith('ruv')))
									FlxG.camera.shake(0.01,0.1);
							}

						default:
							
							if (curStage == 'pegmeplease')
							{
								circ2.angle -= 5;
								circ1.angle -= 5;
							}
							if (boyfriendAgainSinging)
								boyfriendAgain.playAnim(animToPlay, true);
							if (curStage == 'knockout')
							{
								if (superCardTween == null || !superCardTween.active)
									superCardCharge += 1;
								if (!boyfriend.specialAnim)
								{
									boyfriend.playAnim(animToPlay + daAlt, true);
									boyfriend.holdTimer = 0;
								}
							}
							else
							{
								boyfriend.playAnim(animToPlay + daAlt, true);
								boyfriend.holdTimer = 0;
								
								switch (boyfriend.curCharacter)
								{
									case '8owser':
										boyfriend.clipRect = new FlxRect(0, 0, 600, 600);
									case 'grey-playable':
										if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
											boyfriend.clipRect = new FlxRect(0, 0, 595, 400);
										if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
											boyfriend.clipRect = new FlxRect(0, 0, 600, 400);
										if (boyfriend.animation.curAnim.name.startsWith('singUP'))
											boyfriend.clipRect = new FlxRect(0, 0, 600, 500);
										if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
											boyfriend.clipRect = new FlxRect(0, 0, 600, 400);
									case 'spooky-playable':
										if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
											boyfriend.clipRect = new FlxRect(0, 0, 330, 400);
										if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
											boyfriend.clipRect = new FlxRect(100, 0, 600, 400);
										if (boyfriend.animation.curAnim.name.startsWith('singUP'))
											boyfriend.clipRect = new FlxRect(0, 0, 600, 500);
										if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
											boyfriend.clipRect = new FlxRect(0, 0, 600, 400);
									case 'ace-playable':
										if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
											boyfriend.clipRect = new FlxRect(110, 0, 450, 800);
										if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
											boyfriend.clipRect = new FlxRect(180, 0, 370, 800);
										if (boyfriend.animation.curAnim.name.startsWith('singUP'))
											boyfriend.clipRect = new FlxRect(200, 0, 600, 800);
										if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
											boyfriend.clipRect = new FlxRect(150, 0, 600, 800);
									//case 'edd-playable':
									//	if (boyfriend.animation.curAnim.name.startsWith('singLEFT'))
									//		boyfriend.clipRect = new FlxRect(0, 0, 400, 500);
									//	if (boyfriend.animation.curAnim.name.startsWith('singRIGHT'))
									//		boyfriend.clipRect = new FlxRect(0, 0, 330, 500);
									//	if (boyfriend.animation.curAnim.name.startsWith('singUP'))
									//		boyfriend.clipRect = new FlxRect(0, 0, 600, 500);
									//	if (boyfriend.animation.curAnim.name.startsWith('singDOWN'))
									//		boyfriend.clipRect = new FlxRect(0, 0, 600, 500);
								}
							}
					}
				}

				if(note.noteType == 'Hey!') {
					if (gf.scale.x < 0)
					{
						if (Std.int(Math.abs(note.noteData)) == 3)
							animToPlay = singAnimations[0] + daAlt;
						
						if (Std.int(Math.abs(note.noteData)) == 0)
							animToPlay = singAnimations[3] + daAlt;
					}
					if(boyfriend.animOffsets.exists('hey')) {
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.6;
					}
	
					if(gf != null && gf.animOffsets.exists('cheer')) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
					}
				}
			}

			if(cpuControlled || roboRoboPerkActivated) {
				var time:Float = 0.15;
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
					time += 0.15;
				}
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)) % 4, time);
			} else {
				playerStrums.forEach(function(spr:StrumNote)
				{
					if (Math.abs(note.noteData) == spr.ID)
					{
						spr.playAnim('confirm', true);
					}
				});
			}
			note.wasGoodHit = true;
			vocals.volume = 1;

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {
		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;
		
		var hue:Float = ClientPrefs.arrowHSV[data % 4][0] / 360;
		var sat:Float = ClientPrefs.arrowHSV[data % 4][1] / 100;
		var brt:Float = ClientPrefs.arrowHSV[data % 4][2] / 100;
		if(note != null) {
			skin = note.noteSplashTexture;
			hue = note.noteSplashHue;
			sat = note.noteSplashSat;
			brt = note.noteSplashBrt;
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		if (skin == 'notes/IC_NoteSplash')
		{
			x+=37.5;
			y+=37.5;
		}
		if (skin == 'notes/ParryNOTE_assetsSplash')
		{
			x-=85;
			y-=85;
		}
		splash.setupNoteSplash(x, y, data, skin, hue, sat, brt);
		grpNoteSplashes.add(splash);
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	var carTimer:FlxTimer;
	function fastCarDrive()
	{
		//trace('Car drive');
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		carTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
			carTimer = null;
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			if (gf != null)
			{
				gf.playAnim('hairBlow');
				gf.specialAnim = true;
			}
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		if(gf != null)
		{
			gf.danced = false; //Sets head to the correct position once the animation ends
			gf.playAnim('hairFall');
			gf.specialAnim = true;
		}
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		if(!ClientPrefs.lowQuality) halloweenBG.animation.play('halloweem bg lightning strike');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if(boyfriend.animOffsets.exists('scared')) {
			boyfriend.playAnim('scared', true);
		}

		if(gf != null && gf.animOffsets.exists('scared')) {
			gf.playAnim('scared', true);
		}

		if(ClientPrefs.camZooms) {
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;

			if(!camZooming) { //Just a way for preventing it to be permanently zoomed until Skid & Pump hits a note
				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.5);
				FlxTween.tween(camHUD, {zoom: 1}, 0.5);
			}
		}

		if(ClientPrefs.flashing) {
			halloweenWhite.alpha = 0.4;
			FlxTween.tween(halloweenWhite, {alpha: 0.5}, 0.075);
			FlxTween.tween(halloweenWhite, {alpha: 0}, 0.25, {startDelay: 0.15});
		}
	}

	function killHenchmen():Void
	{
		if(!ClientPrefs.lowQuality && ClientPrefs.violence && curStage == 'limo') {
			if(limoKillingState < 1) {
				limoMetalPole.x = -400;
				limoMetalPole.visible = true;
				limoLight.visible = true;
				limoCorpse.visible = false;
				limoCorpseTwo.visible = false;
				limoKillingState = 1;

				#if ACHIEVEMENTS_ALLOWED
				Achievements.henchmenDeath++;
				FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
				var achieve:String = checkForAchievement(['roadkill_enthusiast']);
				if (achieve != null) {
					startAchievement(achieve);
				} else {
					FlxG.save.flush();
				}
				FlxG.log.add('Deaths: ' + Achievements.henchmenDeath);
				#end
			}
		}
	}

	function resetLimoKill():Void
	{
		if(curStage == 'limo') {
			limoMetalPole.x = -500;
			limoMetalPole.visible = false;
			limoLight.x = -500;
			limoLight.visible = false;
			limoCorpse.x = -500;
			limoCorpse.visible = false;
			limoCorpseTwo.x = -500;
			limoCorpseTwo.visible = false;
		}
	}

	private var preventLuaRemove:Bool = false;
	override function destroy() {
		preventLuaRemove = true;
		for (i in 0...luaArray.length) {
			luaArray[i].call('onDestroy', []);
			luaArray[i].stop();
		}
		luaArray = [];

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		super.destroy();
	}

	public static function cancelMusicFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	public function removeLua(lua:FunkinLua) {
		if(luaArray != null && !preventLuaRemove) {
			luaArray.remove(lua);
		}
	}

	var lastStepHit:Int = -1;
	override function stepHit()
	{
		super.stepHit();
		if (curStep != lastStepHit)
		{
			switch (curStage)
			{
				case 'auditorHell':
					if (curStep > 2128 && curStep < 2656)
						defaultCamZoom += 0.001;
						
					switch (curStep)
					{
						case 384:
							doStopSign(0);
						case 511:
							doStopSign(2);
							doStopSign(0);
						case 610:
							doStopSign(3);
						case 720:
							doStopSign(2);
						case 991:
							doStopSign(3);
						case 1184:
							doStopSign(2);
						case 1218:
							doStopSign(0);
						case 1235:
							doStopSign(0, true);
						case 1200:
							doStopSign(3);
						case 1328:
							doStopSign(0, true);
							doStopSign(2);
						case 1439:
							doStopSign(3, true);
						case 1567:
							doStopSign(0);
						case 1584:
							doStopSign(0, true);
						case 1600:
							doStopSign(2);
						case 1706:
							doStopSign(3);
						case 1917:
							doStopSign(0);
						case 1923:
							doStopSign(0, true);
						case 1927:
							doStopSign(0);
						case 1932:
							doStopSign(0, true);
						case 2032:
							doStopSign(2);
							doStopSign(0);
						case 2036:
							doStopSign(0, true);
						case 2162:
							doStopSign(2);
							doStopSign(3);
						case 2193:
							doStopSign(0);
						case 2202:
							doStopSign(0, true);
						case 2239:
							doStopSign(2, true);
						case 2258:
							doStopSign(0, true);
						case 2304:
							doStopSign(0, true);
							doStopSign(0);
						case 2326:
							doStopSign(0, true);
						case 2336:
							doStopSign(3);
						case 2447:
							doStopSign(2);
							doStopSign(0, true);
							doStopSign(0);
						case 2480:
							doStopSign(0, true);
							doStopSign(0);
						case 2512:
							doStopSign(2);
							doStopSign(0, true);
							doStopSign(0);
						case 2544:
							doStopSign(0, true);
							doStopSign(0);
						case 2575:
							doStopSign(2);
							doStopSign(0, true);
							doStopSign(0);
						case 2608:
							doStopSign(0, true);
							doStopSign(0);
						case 2604:
							doStopSign(0, true);
						case 2655:
							doGremlin(20, 13, true);
					}
					switch (curStep + 1)
					{
						case 64:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 128:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 192:
							defaultCamZoom = 1.3;
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 256:
							defaultCamZoom = 0.55;
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 262:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 268:
							// DUET
							tikturn = true;
							hatturn = true;
						case 448:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 576:
							// DUET
							tikturn = true;
							hatturn = true;
						case 608:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 640:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 672:
							// DUET
							tikturn = true;
							hatturn = true;
						case 736:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 768:
							// DUET
							tikturn = true;
							hatturn = true;
						case 864:
							defaultCamZoom = 1.1;
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 920:
							defaultCamZoom = 0.55;
							// DUET
							tikturn = true;
							hatturn = true;
						case 924:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 1120:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 1248:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 1504:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 1632:
							// DUET
							tikturn = true;
							hatturn = true;
						case 1888:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 1892:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 1896:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 1900:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 1904:
							// DUET
							tikturn = true;
							hatturn = true;
						case 2016:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 2024:
							// DUET
							tikturn = true;
							hatturn = true;
						case 2084:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 2056:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 2080:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 2088:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 2096:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 2104:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 2112:
							// DUET
							tikturn = true;
							hatturn = true;
						case 2124:
							{
								var songName:String = Paths.formatToSongPath(SONG.song);
								var file:String = Paths.json(songName + '/dialogueTiky'); //dialogueTiky dumbass
								#if sys
								if (#if MODS_ALLOWED FileSystem.exists(Paths.modsJson(songName + '/dialogueTiky')) || #end FileSystem.exists(file))
								#else
								if (OpenFlAssets.exists(file))
								#end
								{
									//clearEvents();
									var events = parseDialogue(file);
									roboticDialogues = events.dialogues.copy();
								}
								textBox = new TextBox(0, 500, 50, FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]), 0.5, roboticDialogues[0].line, dad.healthIcon, true, 3);
								textBox.allDialogues = roboticDialogues;
								add(textBox);
								textBox.cameras = [camHUDier];
								textBox.appear();
								textBox.goToNextDialogue();
								textBox.onComplete = nopenothing;
							}
							{
								var songName:String = Paths.formatToSongPath(SONG.song);
								var file:String = Paths.json(songName + '/dialogueHat'); //dialogoueHat dumbass
								#if sys
								if (#if MODS_ALLOWED FileSystem.exists(Paths.modsJson(songName + '/dialogueHat')) || #end FileSystem.exists(file))
								#else
								if (OpenFlAssets.exists(file))
								#end
								{
									//clearEvents();
									var events = parseDialogue(file);
									roboticDialogues = events.dialogues.copy();
								}
								textBox = new TextBox(0, 425, 50, FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]), 0.5, roboticDialogues[0].line, dadAgain1.healthIcon, true, 3);
								textBox.allDialogues = roboticDialogues;
								add(textBox);
								textBox.cameras = [camHUDier];
								textBox.appear();
								textBox.goToNextDialogue();
								textBox.onComplete = nopenothing;
							}
						case 2128:
							defaultCamZoom = 0.15;
						case 2144:
							defaultCamZoom = 0.55;
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 2208:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 2272:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 2336:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 2400:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 2432:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 2464:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 2496:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 2528:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 2560:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 2592:
							// TRICKY SOLO
							tikturn = true;
							hatturn = false;
						case 2624:
							// HAT KID SOLO
							tikturn = false;
							hatturn = true;
						case 2656:
							defaultCamZoom = 0.55;
							// DUET
							tikturn = true;
							hatturn = true;
					}
				/*case 'knockout':
					
					switch (curStep + 1)
					{
						
						case 840:
							{
								var songName:String = Paths.formatToSongPath(SONG.song);
								var file:String = Paths.json(songName + '/dialogueWell'); //dialogueTiky dumbass
								#if sys
								if (#if MODS_ALLOWED FileSystem.exists(Paths.modsJson(songName + '/dialogueWell')) || #end FileSystem.exists(file))
								#else
								if (OpenFlAssets.exists(file))
								#end
								{
									//clearEvents();
									var events = parseDialogue(file);
									roboticDialogues = events.dialogues.copy();
								}
								textBox = new TextBox(0, 500, 50, FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]), 0.5, roboticDialogues[0].line, 'knockout/icon-eduardo', true, 3);
								textBox.allDialogues = roboticDialogues;
								add(textBox);
								textBox.cameras = [camHUDier];
								textBox.appear();
								textBox.goToNextDialogue();
								textBox.onComplete = nopenothing;
							}
					}*/
				}
	}
		if (spookyRendered && spookySteps + 3 < curStep)
		{
			if (resetSpookyText)
			{
				remove(spookyText);
				spookyRendered = false;
			}
			tstatic.alpha = 0;
			if (curStage == 'auditorHell')
				tstatic.alpha = 0.1;
		}
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > 20))
		{
			resyncVocals();
		}

		if(curStep == lastStepHit) {
			return;
		}

		lastStepHit = curStep;
		setOnLuas('curStep', curStep);
		callOnLuas('onStepHit', []);
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var lastBeatHit:Int = -1;
	
	
	var spinNumber:Float = 0;
	function spinPillars(?pillarArray:Array<FlxSprite> = null, spinDistance:Float = 1000, ?spinSpeed:Float = 1, distanceBetween:Float = 10, ?originPoint:Float = 500)
	{
		spinNumber += spinSpeed * (120/ClientPrefs.framerate);
		for (i in 0...pillarArray.length)
		{
			pillarArray[i].x = originPoint + Math.sin(spinNumber - distanceBetween * i) * spinDistance;
		}
	}
	function movePillars(?pillarArray:Array<FlxSprite> = null, ?movespeed:Float = 10, ?endplace:Float = 1000)
	{
		var startedCounting:Bool = false;
		var smallestX:Float = 0;
		var highestX:Float = 0;
		var theSmallestI:Int = 0;
		var theHighestI:Int = 0;
		for (i in 0...pillarArray.length)
		{
			if (!startedCounting)
			{
				startedCounting = true;
				smallestX = pillarArray[i].x;
				highestX = pillarArray[i].x;
			}
			else
			{
				if (pillarArray[i].x < smallestX)
				{
					smallestX = pillarArray[i].x;
					theSmallestI = i;
				}
				if (pillarArray[i].x > highestX)
				{
					highestX = pillarArray[i].x;
					theHighestI = i;
				}
			}
		}
		for (i in 0...pillarArray.length)
		{
			var beforeI = i - 1;
			if (beforeI < 0)
				beforeI = pillarArray.length-1;
			var afterI = i + 1;
			if (afterI >= pillarArray.length)
				afterI = 0;
			if (movespeed >= 0)
			{
				if (i == theHighestI)
				{
					pillarArray[i].x += movespeed * (120/ClientPrefs.framerate);
				}
				else
				{
					pillarArray[i].x = pillarArray[afterI].x - pillarArray[i].width;
				}
				if (pillarArray[i].x > endplace)
				{
					pillarArray[i].x = pillarArray[afterI].x - pillarArray[i].width;
					theHighestI = beforeI;
				}
			}
			else
			{
				if (i == theSmallestI)
				{
					pillarArray[i].x += movespeed * (120/ClientPrefs.framerate);
				}
				else
				{
					pillarArray[i].x = pillarArray[beforeI].x + pillarArray[beforeI].width;
				}
				if (pillarArray[i].x < endplace)
				{
					theSmallestI = afterI;
					pillarArray[i].x = pillarArray[beforeI].x + pillarArray[beforeI].width;
				}
			}
		}
	}
	var audioBuffers:Array<AudioBuffer> = [null, null];
	function pillarsThing(?pillarArray:Array<FlxSprite> = null, isVocals:Int = 0, theBase:Int = 0, basevalue:Float = 600, smooththing:Bool = false, heightValue:Float = 2, ?goweeee:Bool = true, ?speedValue:Float = 50, ?loopThis:Bool = false, ?divideby:Int = 3)
	{
		var maxpillars = pillarArray.length;
		if (loopThis)
		{
			maxpillars = Std.int(pillarArray.length/divideby);
		}
		var increasething = 1;
		if (smooththing)
			increasething = 2;
			
		fUNNINUMBERLOL += increasething;
		if (fUNNINUMBERLOL >= maxpillars)
			fUNNINUMBERLOL = 0;
		var i = fUNNINUMBERLOL;
		//for (i in 0...pillarArray.length)
		if (!smooththing || (smooththing && i % 2 == 0))
		{
			var sampleMult:Float = audioBuffers[isVocals].sampleRate / 44100;
			var index:Int = Std.int(FlxG.sound.music.time * 44.0875 * sampleMult);
			var drawIndex:Int = 0;
			var samplesPerRow = 1;
			var waveBytes:Bytes = audioBuffers[isVocals].data.toBytes();
			
			var min:Float = 0;
			var max:Float = 0;
			
			while (drawIndex < 2)
			{
				var byte:Int = waveBytes.getUInt16(index * 4);

				if (byte > 65535 / 2)
					byte -= 65535;
	
				var sample:Float = (byte / 65535);
	
				if (sample > 0)
				{
					if (sample > max)
						max = sample;
				}
				else if (sample < 0)
				{
					if (sample < min)
						min = sample;
				}
	
				if ((index % samplesPerRow) == 0)
				{
					// trace("min: " + min + ", max: " + max);
	
					/*if (drawIndex > gridBG.height)
					{
						drawIndex = 0;
					}*/

					if (theBase == 1)
					{
						//trace('GREEN');
						//trace((Math.abs(min) + Math.abs(max)) * 1000);
						if (loopThis)
						{
							for (z in 0...divideby)
							{
								if (isVocals == 1)
								{
									if (((pillarArray[i + maxpillars * z].y > basevalue - (Math.abs(min) + Math.abs(max)) * 1000 * heightValue * vocals.volume * FlxG.sound.volume) && goweeee) || !goweeee)
										pillarArray[i + maxpillars * z].y = basevalue - (Math.abs(min) + Math.abs(max)) * 1000 * heightValue * vocals.volume * FlxG.sound.volume;
								}
								else
								{
									if (((pillarArray[i + maxpillars * z].y > basevalue - (Math.abs(min) + Math.abs(max)) * 1000 * heightValue * FlxG.sound.volume) && goweeee) || !goweeee)
										pillarArray[i + maxpillars * z].y = basevalue - (Math.abs(min) + Math.abs(max)) * 1000 * heightValue * FlxG.sound.volume;
								}
							}
						}
						else
						{
							if (isVocals == 1)
							{
								if (((pillarArray[i].y > basevalue - (Math.abs(min) + Math.abs(max)) * 1000 * heightValue * vocals.volume * FlxG.sound.volume) && goweeee) || !goweeee)
									pillarArray[i].y = basevalue - (Math.abs(min) + Math.abs(max)) * 1000 * heightValue * vocals.volume * FlxG.sound.volume;
							}
							else
							{
								if (((pillarArray[i].y > basevalue - (Math.abs(min) + Math.abs(max)) * 1000 * heightValue * FlxG.sound.volume) && goweeee) || !goweeee)
									pillarArray[i].y = basevalue - (Math.abs(min) + Math.abs(max)) * 1000 * heightValue * FlxG.sound.volume;
							}
						}
					}
					else
					{
						//trace('PINK');
						if (loopThis)
						{
							for (z in 0...divideby)
							{
								if (((pillarArray[i + maxpillars * z].y < basevalue + (Math.abs(min) + Math.abs(max)) * 1000 * heightValue) && goweeee) || !goweeee)
									pillarArray[i + maxpillars * z].y = basevalue + (Math.abs(min) + Math.abs(max)) * 1000 * heightValue;
							}
						}
						else
						{
							if (((pillarArray[i].y < basevalue + (Math.abs(min) + Math.abs(max)) * 1000 * heightValue) && goweeee) || !goweeee)
								pillarArray[i].y = basevalue + (Math.abs(min) + Math.abs(max)) * 1000 * heightValue;
						}
					}
					//waveformSprite.pixels.fillRect(new Rectangle(Std.int((GRID_SIZE * 4) - pixelsMin), drawIndex, pixelsMin + pixelsMax, 1), FlxColor.ORANGE);
					drawIndex++;
	
					min = 0;
					max = 0;
				}
	
				index++;
			}
		}
		if (smooththing)
		{
			for (j in 0...pillarArray.length)
			{
				if (j % 2 != 0)
					pillarArray[j].y = pillarArray[j-1].y + (pillarArray[j+1].y - pillarArray[j-1].y)/2;
			}
		}
		if (goweeee)
		{
			for (j in 0...pillarArray.length)
			{
				if (theBase == 1)
				{
					if (pillarArray[j].y < basevalue)
						pillarArray[j].y += (basevalue - pillarArray[j].y) / (speedValue / (120/ClientPrefs.framerate));
				}
				else
				{
					if (pillarArray[j].y > basevalue)
						pillarArray[j].y += (basevalue - pillarArray[j].y) / (speedValue / (120/ClientPrefs.framerate));
				}
			}
		}
		//pillarArray[j].y += 120/ClientPrefs.framerate * 5;
			/*{	
				pillarArray[i].y = funniVariable[i] + randomfunni[i];
				if (randomfunni[i] < 0)
					randomfunni[i] /= 1.1;
			}*/
	}
	function loadAudioBuffer() {
		if(audioBuffers[0] != null) {
			audioBuffers[0].dispose();
		}
		audioBuffers[0] = null;
		#if MODS_ALLOWED
		if(FileSystem.exists(Paths.modFolders('songs/' + SONG.song.toLowerCase().replace(' ', '-') + '/Inst.ogg'))) {
			audioBuffers[0] = AudioBuffer.fromFile(Paths.modFolders('songs/' + SONG.song.toLowerCase().replace(' ', '-') + '/Inst.ogg'));
			//trace('Custom vocals found');
		}
		else { #end
			var leVocals:String = Paths.getPath(SONG.song.toLowerCase().replace(' ', '-') + '/Inst.' + Paths.SOUND_EXT, SOUND, 'songs');
			if (OpenFlAssets.exists(leVocals)) { //Vanilla inst
				audioBuffers[0] = AudioBuffer.fromFile('./' + leVocals.substr(6));
				//trace('Inst found');
			}
		#if MODS_ALLOWED
		}
		#end

		if(audioBuffers[1] != null) {
			audioBuffers[1].dispose();
		}
		audioBuffers[1] = null;
		#if MODS_ALLOWED
		trace('songs/' + SONG.song.toLowerCase().replace(' ', '-') + '/Voices.ogg');
		if(FileSystem.exists(Paths.modFolders('songs/' + SONG.song.toLowerCase().replace(' ', '-') + '/Voices.ogg'))) {
			audioBuffers[1] = AudioBuffer.fromFile(Paths.modFolders('songs/' + SONG.song.toLowerCase() + '/Voices.ogg'));
			//trace('Custom vocals found');
		} else { #end
			var leVocals:String = Paths.getPath(SONG.song.toLowerCase().replace(' ', '-') + '/Voices.' + Paths.SOUND_EXT, SOUND, 'songs');
			if (OpenFlAssets.exists(leVocals)) { //Vanilla voices
				audioBuffers[1] = AudioBuffer.fromFile('./' + leVocals.substr(6));
				//trace('Voices found, LETS FUCKING GOOOO');
			}
		#if MODS_ALLOWED
		}
		#end
	}
	
	override function beatHit()
	{
		for (i in 0...funniRects.length)
		{
			randomfunni[i] = FlxG.random.int(-150, 0);
		}
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			//trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				//FlxG.log.add('CHANGED BPM!');
				setOnLuas('curBpm', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}
			setOnLuas('mustHitSection', SONG.notes[Math.floor(curStep / 16)].mustHitSection);
			setOnLuas('altAnim', SONG.notes[Math.floor(curStep / 16)].altAnim);
			setOnLuas('gfSection', SONG.notes[Math.floor(curStep / 16)].gfSection);
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !endingSong && !isCameraOnForcedPos)
		{
			moveCameraSection(Std.int(curStep / 16));
		}
		if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.scale.set(1.2, 1.2);
		iconP2.scale.set(1.2, 1.2);
		iconP1Again.scale.set(1.2, 1.2);
		iconP2Again1.scale.set(1.2, 1.2);
		iconP2Again2.scale.set(1.2, 1.2);

		iconP1.updateHitbox();
		iconP2.updateHitbox();
		iconP1Again.updateHitbox();
		iconP2Again1.updateHitbox();
		iconP2Again2.updateHitbox();
		
		if (gf != null && curBeat % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && !gf.stunned && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
		{
			gf.dance();
			if (curStage == 'auditorHell' || (SONG.song.toLowerCase() == 'ejected' && !roseturn))
				lol86.dance();
		}
		if (gfAgain != null && curBeat % Math.round(gfSpeed * gfAgain.danceEveryNumBeats) == 0 && !gfAgain.stunned && gfAgain.animation.curAnim.name != null && !gfAgain.animation.curAnim.name.startsWith("sing") && !gfAgain.stunned)
		{
			gfAgain.dance();
		}
		if (curBeat % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
		{
			boyfriend.dance();
		}
		if (curBeat % boyfriendAgain.danceEveryNumBeats == 0 && boyfriendAgain.animation.curAnim != null && !boyfriendAgain.animation.curAnim.name.startsWith('sing') && !boyfriendAgain.stunned)
		{
			boyfriendAgain.dance();
		}
		if (curBeat % boyfriendBETADCIU.danceEveryNumBeats == 0 && boyfriendBETADCIU.animation.curAnim != null && !boyfriendBETADCIU.animation.curAnim.name.startsWith('sing') && !boyfriendBETADCIU.stunned)
		{
			boyfriendBETADCIU.dance();
		}
		if (curBeat % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
		{
			dad.dance();
		}
		if (curBeat % dadAgain1.danceEveryNumBeats == 0 && dadAgain1.animation.curAnim != null && !dadAgain1.animation.curAnim.name.startsWith('sing') && !dadAgain1.stunned)
		{
			dadAgain1.dance();
		}
		if (curBeat % dadAgain2.danceEveryNumBeats == 0 && dadAgain2.animation.curAnim != null && !dadAgain2.animation.curAnim.name.startsWith('sing') && !dadAgain2.stunned)
		{
			dadAgain2.dance();
		}
		if (curBeat % dadBETADCIU.danceEveryNumBeats == 0 && dadBETADCIU.animation.curAnim != null && !dadBETADCIU.animation.curAnim.name.startsWith('sing') && !dadBETADCIU.stunned)
		{
			if (dad.alpha > 0 && dadBETADCIU.animation.curAnim.name != 'oops')
			{
				dadBETADCIU.dance();
			}
		}

		switch (curStage)
		{
			case 'school':
				if(!ClientPrefs.lowQuality) {
					bgGirls.dance();
				}

			case 'mall':
				if(!ClientPrefs.lowQuality) {
					upperBoppers.dance(true);
				}

				if(heyTimer <= 0) bottomBoppers.dance(true);
				santa.dance(true);

			case 'limo':
				if(!ClientPrefs.lowQuality) {
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});
				}

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case 'knockout':
				if(!ClientPrefs.lowQuality) {
				}
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:BGSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1, [curLight]);

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (curStage == 'spooky' && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
		lastBeatHit = curBeat;

		setOnLuas('curBeat', curBeat); //DAWGG?????
		callOnLuas('onBeatHit', []);
	}

	public var closeLuas:Array<FunkinLua> = [];
	public function callOnLuas(event:String, args:Array<Dynamic>):Dynamic {
		var returnVal:Dynamic = FunkinLua.Function_Continue;
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			var ret:Dynamic = luaArray[i].call(event, args);
			if(ret != FunkinLua.Function_Continue) {
				returnVal = ret;
			}
		}

		for (i in 0...closeLuas.length) {
			luaArray.remove(closeLuas[i]);
			closeLuas[i].stop();
		}
		#end
		return returnVal;
	}

	public function setOnLuas(variable:String, arg:Dynamic) {
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			luaArray[i].set(variable, arg);
		}
		#end
	}
	function doGremlin(hpToTake:Int, duration:Int, persist:Bool = false)
	{
		interupt = false;

		grabbed = true;

		totalDamageTaken = 0;

		var gramlan:FlxSprite = new FlxSprite(0, 0);

		gramlan.frames = Paths.getSparrowAtlas('expurgation/mech/HP GREMLIN', 'shared');

		gramlan.setGraphicSize(Std.int(gramlan.width * 2));
		gramlan.updateHitbox();
		gramlan.setGraphicSize(Std.int(gramlan.width * 0.76));

		gramlan.cameras = [camHUD];

		gramlan.x = iconP1.x;
		gramlan.y = healthBarBG.y - 325;

		gramlan.animation.addByIndices('come', 'HP Gremlin ANIMATION', [0, 1], "", 24, false);
		gramlan.animation.addByIndices('grab', 'HP Gremlin ANIMATION', [
			2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24
		], "", 24, false);
		gramlan.animation.addByIndices('hold', 'HP Gremlin ANIMATION', [25, 26, 27, 28], "", 24);
		gramlan.animation.addByIndices('release', 'HP Gremlin ANIMATION', [29, 30, 31, 32, 33], "", 24, false);

		gramlan.antialiasing = true;

		add(gramlan);

		if (ClientPrefs.downScroll)
		{
			gramlan.flipY = true;
			gramlan.y -= 150;
		}

		// over use of flxtween :)

		var startHealth = health;
		var toHealth = (hpToTake / 100) * startHealth; // simple math, convert it to a percentage then get the percentage of the health

		var perct = toHealth / 2 * 100;

		trace('start: $startHealth\nto: $toHealth\nwhich is prect: $perct');

		var onc:Bool = false;

		FlxG.sound.play(Paths.sound('expurgation/GremlinWoosh', 'shared'));

		gramlan.animation.play('come');
		var tempTimer = new FlxTimer();
		tempTimer.start(0.14, function(tmr:FlxTimer)
		{
			gramlan.animation.play('grab');
			FlxTween.tween(gramlan, {x: iconP1.x - 140}, 1, {
				ease: FlxEase.elasticIn,
				onComplete: function(tween:FlxTween)
				{
					trace('I got em');
					gramlan.animation.play('hold');
					FlxTween.tween(gramlan, {
						x: (healthBar.x + (healthBar.width * (FlxMath.remapToRange(perct, 0, 100, 100, 0) * 0.01) - 26)) - 75
					}, duration, {
						onUpdate: function(tween:FlxTween)
						{
							// lerp the health so it looks pog
							if (interupt && !onc && !persist)
							{
								onc = true;
								trace('oh shit');
								gramlan.animation.play('release');
								gramlan.animation.finishCallback = function(pog:String)
								{
									gramlan.alpha = 0;
								}
							}
							else if (!interupt || persist)
							{
								var pp = FlxMath.lerp(startHealth, toHealth, tween.percent);
								if (pp <= 0)
									pp = 0.1;
								health = pp;
							}

							if (shouldBeDead)
								health = 0;
						},
						onComplete: function(tween:FlxTween)
						{
							if (interupt && !persist)
							{
								remove(gramlan);
								grabbed = false;
							}
							else
							{
								trace('oh shit');
								gramlan.animation.play('release');
								if (persist && totalDamageTaken >= 0.7)
									health -= totalDamageTaken; // just a simple if you take a lot of damage wtih this, you'll loose probably.
								gramlan.animation.finishCallback = function(pog:String)
								{
									remove(gramlan);
								}
								grabbed = false;
							}
						}
					});
				}
			});
			FlxDestroyUtil.destroy(tempTimer);
		});
	}

	public function addShaderToCamera(cam:String,effect:ShaderEffect):ShaderEffect{//STOLE FROM ANDROMEDA AND PSYCH ENGINE 0.5.1 WITH SHADERS
        switch(cam.toLowerCase()) {
            case 'camhud' | 'hud' | 'camhudier':
                    camHUDShaders.push(effect);
                    var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
                    for(i in camHUDShaders){
                      newCamEffects.push(new ShaderFilter(i.shader));
                    }
                    camHUD.setFilters(newCamEffects);
            case 'camother' | 'other':
                    camOtherShaders.push(effect);
                    var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
                    for(i in camOtherShaders){
                      newCamEffects.push(new ShaderFilter(i.shader));
                    }
                    camOther.setFilters(newCamEffects);
            case 'camgame' | 'game':
                    camGameShaders.push(effect);
                    var newCamEffects:Array<BitmapFilter>=[]; // IT SHUTS HAXE UP IDK WHY BUT WHATEVER IDK WHY I CANT JUST ARRAY<SHADERFILTER>
                    for(i in camGameShaders){
                      newCamEffects.push(new ShaderFilter(i.shader));
                    }
                    camGame.setFilters(newCamEffects);
            default:
                if(modchartSprites.exists(cam)) {
                    Reflect.setProperty(modchartSprites.get(cam),"shader",effect.shader);
                } else if(modchartTexts.exists(cam)) {
                    Reflect.setProperty(modchartTexts.get(cam),"shader",effect.shader);
                } else {
                    var OBJ = Reflect.getProperty(PlayState.instance,cam);
                    Reflect.setProperty(OBJ,"shader", effect.shader);
                }
        }
		return effect;
	}
	
	public function removeShaderFromCamera(cam:String,effect:ShaderEffect){
        switch(cam.toLowerCase()) {
            case 'camhud' | 'hud' | 'camhudier': 
				camHUDShaders.remove(effect);
				var newCamEffects:Array<BitmapFilter>=[];
				for(i in camHUDShaders){
				newCamEffects.push(new ShaderFilter(i.shader));
				}
				camHUD.setFilters(newCamEffects);
			case 'camother' | 'other': 
					camOtherShaders.remove(effect);
					var newCamEffects:Array<BitmapFilter>=[];
					for(i in camOtherShaders){
					newCamEffects.push(new ShaderFilter(i.shader));
					}
					camOther.setFilters(newCamEffects);
			default: 
				camGameShaders.remove(effect);
				var newCamEffects:Array<BitmapFilter>=[];
				for(i in camGameShaders){
				newCamEffects.push(new ShaderFilter(i.shader));
				}
				camGame.setFilters(newCamEffects);
        }
    }
    
	public function clearShaderFromCamera(cam:String){
        switch(cam.toLowerCase()) {
            case 'camhud' | 'hud': 
                camHUDShaders = [];
                var newCamEffects:Array<BitmapFilter>=[];
                camHUD.setFilters(newCamEffects);
            case 'camother' | 'other': 
                camOtherShaders = [];
                var newCamEffects:Array<BitmapFilter>=[];
                camOther.setFilters(newCamEffects);
            default: 
                camGameShaders = [];
                var newCamEffects:Array<BitmapFilter>=[];
                camGame.setFilters(newCamEffects);
        }
        
    }

	function doStopSign(sign:Int = 0, fuck:Bool = false)
	{
		trace('sign ' + sign);
		var daSign:FlxSprite = new FlxSprite(0, 0);
		// CachedFrames.cachedInstance.get('sign')

		daSign.frames = Paths.getSparrowAtlas('expurgation/mech/Sign_Post_Mechanic','shared');

		daSign.setGraphicSize(Std.int(daSign.width * 4));
		daSign.updateHitbox();
		daSign.setGraphicSize(Std.int(daSign.width * 0.67));

		daSign.cameras = [camHUD];

		switch (sign)
		{
			case 0:
				daSign.animation.addByPrefix('sign', 'Signature Stop Sign 1', 24, false);
				daSign.x = FlxG.width - 650;
				daSign.angle = -90;
				daSign.y = -300;
			case 1:
			/*daSign.animation.addByPrefix('sign','Signature Stop Sign 2',20, false);
				daSign.x = FlxG.width - 670;
				daSign.angle = -90; */ // this one just doesn't work???
			case 2:
				daSign.animation.addByPrefix('sign', 'Signature Stop Sign 3', 24, false);
				daSign.x = FlxG.width - 780;
				daSign.angle = -90;
				if (ClientPrefs.downScroll)
					daSign.y = -395;
				else
					daSign.y = -980;
			case 3:
				daSign.animation.addByPrefix('sign', 'Signature Stop Sign 4', 24, false);
				daSign.x = FlxG.width - 1070;
				daSign.angle = -90;
				daSign.y = -145;
		}
		add(daSign);
		daSign.flipX = fuck;
		daSign.animation.play('sign');
		daSign.animation.finishCallback = function(pog:String)
		{
			remove(daSign);
			trace('ended sign');
		}
	}

	function doClone(side:Int)
	{
		switch (side)
		{
			case 0:
				if (cloneOne.alpha == 1)
					return;
				cloneOne.x = dad.x - 20 - 250;
				cloneOne.y = dad.y + 140 - 100;
				cloneOne.alpha = 1;

				cloneOne.animation.play('clone');
				cloneOne.animation.finishCallback = function(pog:String)
				{
					cloneOne.alpha = 0;
				}
			case 1:
				if (cloneTwo.alpha == 1)
					return;
				cloneTwo.x = dad.x + 390 - 250;
				cloneTwo.y = dad.y + 140 - 100;
				cloneTwo.alpha = 1;

				cloneTwo.animation.play('clone');
				cloneTwo.animation.finishCallback = function(pog:String)
				{
					cloneTwo.alpha = 0;
				}
		}
	}


	var resetSpookyText:Bool = true;

	function resetSpookyTextManual():Void
	{
		trace('reset spooky');
		spookySteps = curStep;
		spookyRendered = true;
		tstatic.alpha = 0.5;
		FlxG.sound.play(Paths.sound('staticSound', 'shared'));
		resetSpookyText = true;
	}

	function manuallymanuallyresetspookytextmanual()
	{
		remove(spookyText);
		spookyRendered = false;
		tstatic.alpha = 0;
	}
	function createSpookyText(hattext:String, tiktext:String, x:Float = -1111111111111, y:Float = -1111111111111, fontSize:Int = 128):Void
	{
		var chosentext = '';
		spookySteps = curStep;
		spookyRendered = true;
		tstatic.alpha = 0.5;
		FlxG.sound.play(Paths.sound('expurgation/staticSound', 'shared'));
		if (hatturn && tikturn)
		{
			if (FlxG.random.int(0, 1) == 1)
			{
				spookyText = new FlxText((x == -1111111111111 ? FlxG.random.float(dadAgain1.x - 50, dadAgain1.x + 30) : x),
					(y == -1111111111111 ? FlxG.random.float(dadAgain1.y + 100, dadAgain1.y + 200) : y));
				chosentext = hattext;
				spookyText.setFormat(Paths.font('Curse Casual.ttf'), 128, FlxColor.PURPLE);
				tstatic.loadGraphic(Paths.image('expurgation/HatStatic', 'shared'), true, 320, 180);
			}
			else
			{
				spookyText = new FlxText((x == -1111111111111 ? FlxG.random.float(dad.x + 40, dad.x + 120) : x),
					(y == -1111111111111 ? FlxG.random.float(dad.y + 200, dad.y + 300) : y));
				chosentext = tiktext;
				spookyText.setFormat("Impact", 128, FlxColor.RED);
				tstatic.loadGraphic(Paths.image('expurgation/TrickyStatic', 'shared'), true, 320, 180);
			}
		}
		else if (hatturn)
		{
			spookyText = new FlxText((x == -1111111111111 ? FlxG.random.float(dadAgain1.x - 50, dadAgain1.x + 30) : x),
				(y == -1111111111111 ? FlxG.random.float(dadAgain1.y + 100, dadAgain1.y + 200) : y));
			chosentext = hattext;
			spookyText.setFormat(Paths.font('Curse Casual.ttf'), 128, FlxColor.PURPLE);
			tstatic.loadGraphic(Paths.image('expurgation/HatStatic', 'shared'), true, 320, 180);
		}
		else
		{
			spookyText = new FlxText((x == -1111111111111 ? FlxG.random.float(dad.x + 40, dad.x + 120) : x),
				(y == -1111111111111 ? FlxG.random.float(dad.y + 200, dad.y + 300) : y));
			chosentext = tiktext;
			spookyText.setFormat("Impact", 128, FlxColor.RED);
			tstatic.loadGraphic(Paths.image('expurgation/TrickyStatic', 'shared'), true, 320, 180);
		}
		spookyText.bold = true;
		if (spookyText.text != null && chosentext != null)
			spookyText.text = chosentext;
		add(spookyText);
	}

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	public var ratingName:String = '?';
	public var ratingPercent:Float;
	public var ratingFC:String;
	public function RecalculateRating() {
		setOnLuas('score', songScore);
		setOnLuas('misses', songMisses);
		setOnLuas('hits', songHits);

		var ret:Dynamic = callOnLuas('onRecalculateRating', []);
		if(ret != FunkinLua.Function_Stop)
		{
			if(totalPlayed < 1) //Prevent divide by 0
				ratingName = '?';
			else
			{
				// Rating Percent
				ratingPercent = Math.min(1, Math.max(0, totalNotesHit / totalPlayed));
				//trace((totalNotesHit / totalPlayed) + ', Total: ' + totalPlayed + ', notes hit: ' + totalNotesHit);

				// Rating Name
				if(ratingPercent >= 1)
				{
					ratingName = ratingStuff[ratingStuff.length-1][0]; //Uses last string
				}
				else
				{
					for (i in 0...ratingStuff.length-1)
					{
						if(ratingPercent < ratingStuff[i][1])
						{
							ratingName = ratingStuff[i][0];
							break;
						}
					}
				}
			}

			// Rating FC
			ratingFC = "";
			if (sicks > 0) ratingFC = "SFC";
			if (goods > 0) ratingFC = "GFC";
			if (bads > 0 || shits > 0) ratingFC = "FC";
			if (songMisses > 0 && songMisses < 10) ratingFC = "SDCB";
			else if (songMisses >= 10) ratingFC = "Clear";
		}
		setOnLuas('rating', ratingPercent);
		setOnLuas('ratingName', ratingName);
		setOnLuas('ratingFC', ratingFC);
	}

	private function saveDialogue()
	{
		var json = {
			"dialogues": roboticDialogues,
		};

		var data:String = Json.stringify(json, "\t");

		if ((data != null) && (data.length > 0))
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data.trim(), "DialogueThing.json");
		}
	}

	function ClipboardAdd(prefix:String = ''):String {
		if(prefix.toLowerCase().endsWith('v')) //probably copy paste attempt
		{
			prefix = prefix.substring(0, prefix.length-1);
		}

		var text:String = prefix + Clipboard.text.replace('\n', '');
		return text;
	}

	function onSaveComplete(_):Void
	{
		//didAThing = true;
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved TEXTBOX DATA.");
	}

	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	public function nopenothing():Void
	{
		//lmao
	}

	public function stepCheck(val1:Float, val2:Float):Bool
	{
		if (curStep >= val1 && curStep < val2)
			return true;
		else
			return false;
	}

	public function roboInsert(variable1:Dynamic, distance:Int, variable2:Dynamic) {
		insert(this.members.indexOf(variable1) + distance, variable2);
	}

	var attackedBefore:Bool = false;
	public function attackOpponent():Void
	{
		if (!attackedBefore)
		{
			attackedBefore = true;
			var songName:String = Paths.formatToSongPath(SONG.song);
			var file:String = Paths.json(songName + '/dialogueCup'); //dialogueTiky dumbass
			#if sys
			if (#if MODS_ALLOWED FileSystem.exists(Paths.modsJson(songName + '/dialogueCup')) || #end FileSystem.exists(file))
			#else
			if (OpenFlAssets.exists(file))
			#end
			{
				//clearEvents();
				var events = parseDialogue(file);
				roboticDialogues = events.dialogues.copy();
			}
			textBox = new TextBox(0, 400, 50, FlxColor.fromRGB(dadBETADCIU.healthColorArray[0], dadBETADCIU.healthColorArray[1], dadBETADCIU.healthColorArray[2]), 0.5, roboticDialogues[0].line, dadBETADCIU.healthIcon, true, 3);
			textBox.allDialogues = roboticDialogues;
			add(textBox);
			textBox.cameras = [camHUDier];
			textBox.goToNextDialogue();
			textBox.alpha = 0;
			textBox.onComplete = nopenothing;
		}
		switch (dad.curCharacter)
		{
			case 'big-monika':
				monikaHit = true;
			case 'lordX':
				if (crossArray.length > 1)
				{
					for (i in 0...4)
					{
						crossed[i] = false;
						crossArray[i].destroy();
					}
					crossArray = [];
				}
				remove(dumbasstext2);
		}
		//Yep, I made this function just for the taeyai attack
		var the = cupheadShooting;
		cupheadShooting = false;

		if (!hurtSound.playing)
		{
			hurtSound.play(true);
			health += 0.3;
			if (dad.curCharacter == 'ankha')
				FlxG.sound.play(Paths.sound('knockout/shootfunni/ankhahurt'), 1);
		}
		switch (dad.curCharacter)
		{
			case 'furscorns' | 'majin':
				dad.playAnim('singLEFT');
			case 'ChampionKnightEX':
				dad.playAnim('singDOWN');
			case 'sunky':
				dad.playAnim('singRIGHT');
			case 'big-monika' | 'lordX':
				// SEX IS COOL
			case 'Sans_IC':
				FlxTween.tween(dad, {x: dad.x - 300}, 0.6, {ease: FlxEase.quadOut,
				onComplete: function (twn:FlxTween)
					{
						FlxTween.tween(dad, {x: dad.x + 300}, 0.6, {ease: FlxEase.quadInOut});
					}
				});
			default:
				dad.playAnim('hurt', true);
		}
		if (dadAgain1Singing)
		{
			dadAgain1.playAnim('hurt', true);
			dadAgain1.specialAnim = true;
		}
		if (gfAgainSinging)
		{
			if (the && shotType == 'blue')
				gfAgain.playAnim('DIE-hurt', true);
			else
				gfAgain.playAnim('sad', true);
			gfAgain.specialAnim = true;
		}
		if (dad.alpha > 0)
		{
			dad.specialAnim = true;
			dadBETADCIU.playAnim('hurt');
			dadBETADCIU.specialAnim = true;
		}
		cupheadShooting = false;
	}

	public function betadciuMomentBF():Void
	{
		switch (curStage)
		{
			case 'knockout':
				FlxTween.tween(boyfriend, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(boyfriendGroup, {x: boyfriendGroup.x + 350}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(boyfriendBETADCIU, {alpha: 0.6}, 0.6, {ease: FlxEase.quadInOut});
				boyfriendGroupAgain.x += 400;
			default:
				FlxTween.tween(boyfriend, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(boyfriendBETADCIU, {alpha: 0.6, x: boyfriendBETADCIU.x + 500}, 0.6, {ease: FlxEase.quadInOut});
		}
	}
	public function betadciuMomentDAD():Void
	{
		switch (curStage)
		{
			case 'knockout':
				FlxTween.tween(dadBETADCIU, {alpha: 0.6}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(dad, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(dadGroup, {x: dadGroup.x - 500}, 0.6, {ease: FlxEase.quadInOut});
				dadGroupAgain1.x -= 400;
			default:
				FlxTween.tween(dad, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
				FlxTween.tween(dadBETADCIU, {alpha: 0.6, x: dadBETADCIU.x - 500}, 0.6, {ease: FlxEase.quadInOut});
				//dadAgain1.y = dad.y + 280;
		}
	}

	/**
	 * Called if there is an error while saving the gameplay recording.
	 */
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving Level data");
	}

	public static function parseDialogue(path:String):Jdialogue {
		#if MODS_ALLOWED
		if(FileSystem.exists(path))
		{
			return cast Json.parse(File.getContent(path));
		}
		#end
		return cast Json.parse(Assets.getText(path));
	}

	public static function parseJSONshit(rawJson:String):Jdialogue
	{
		var swagShit:Jdialogue = cast Json.parse(rawJson);
		return swagShit;
	}
	#if ACHIEVEMENTS_ALLOWED
	private function checkForAchievement(achievesToCheck:Array<String> = null):String
	{
		if(chartingMode) return null;

		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		for (i in 0...achievesToCheck.length) {
			var achievementName:String = achievesToCheck[i];
			if(!Achievements.isAchievementUnlocked(achievementName) && !cpuControlled) {
				var unlock:Bool = false;
				switch(achievementName)
				{
					case 'week1_nomiss' | 'week2_nomiss' | 'week3_nomiss' | 'week4_nomiss' | 'week5_nomiss' | 'week6_nomiss' | 'week7_nomiss':
						if(isStoryMode && campaignMisses + songMisses < 1 && CoolUtil.difficultyString() == 'HARD' && storyPlaylist.length <= 1 && !changedDifficulty && !usedPractice)
						{
							var weekName:String = WeekData.getWeekFileName();
							switch(weekName) //I know this is a lot of duplicated code, but it's easier readable and you can add weeks with different names than the achievement tag
							{
								case 'week1':
									if(achievementName == 'week1_nomiss') unlock = true;
								case 'week2':
									if(achievementName == 'week2_nomiss') unlock = true;
								case 'week3':
									if(achievementName == 'week3_nomiss') unlock = true;
								case 'week4':
									if(achievementName == 'week4_nomiss') unlock = true;
								case 'week5':
									if(achievementName == 'week5_nomiss') unlock = true;
								case 'week6':
									if(achievementName == 'week6_nomiss') unlock = true;
								case 'week7':
									if(achievementName == 'week7_nomiss') unlock = true;
							}
						}
					case 'ur_bad':
						if(ratingPercent < 0.2 && !practiceMode) {
							unlock = true;
						}
					case 'ur_good':
						if(ratingPercent >= 1 && !usedPractice) {
							unlock = true;
						}
					case 'roadkill_enthusiast':
						if(Achievements.henchmenDeath >= 100) {
							unlock = true;
						}
					case 'oversinging':
						if(boyfriend.holdTimer >= 10 && !usedPractice) {
							unlock = true;
						}
					case 'hype':
						if(!boyfriendIdled && !usedPractice) {
							unlock = true;
						}
					case 'two_keys':
						if(!usedPractice) {
							var howManyPresses:Int = 0;
							for (j in 0...keysPressed.length) {
								if(keysPressed[j]) howManyPresses++;
							}

							if(howManyPresses <= 2) {
								unlock = true;
							}
						}
					case 'toastie':
						if(/*ClientPrefs.framerate <= 60 &&*/ ClientPrefs.lowQuality && !ClientPrefs.globalAntialiasing && !ClientPrefs.imagesPersist) {
							unlock = true;
						}
					case 'debugger':
						if(Paths.formatToSongPath(SONG.song) == 'test' && !usedPractice) {
							unlock = true;
						}
				}

				if(unlock) {
					//Achievements.unlockAchievement(achievementName);
					//return achievementName;
				}
			}
		}
		return null;
	}
	#end

	var curLight:Int = 0;
	var curLightEvent:Int = 0;
}

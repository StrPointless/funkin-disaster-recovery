package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import lime.app.Application;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.graphics.FlxGraphic;
import LoadingState.LoadingScreens;
import WeekData;
import Achievements;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var scoreText:FlxText;

	private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;

	var txtWeekTitle:FlxText;
	var bgSprite:FlxSprite;

	private static var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var bg:FlxSprite;
	/*var arrowLeft:FlxSprite;
	var arrowRight:FlxSprite;
	var arrowUp:FlxSprite;
	var arrowDown:FlxSprite;*/
	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var upArrow:FlxSprite;
	var downArrow:FlxSprite;

	//Story menu Amogus vars - luci
	var redAmogus:FlxSprite;
	var blueAmogus:FlxSprite;
	var orangeAmogus:FlxSprite;
	var pinkAmogus:FlxSprite;
	var greenAmogus:FlxSprite;
	var cyanAmogus:FlxSprite;
	var antigueAmogus:FlxSprite;
	var autumnAmogus:FlxSprite;
	var bwAmogus:FlxSprite;
	var cherryBlossomsatNightAmogus:FlxSprite;
	var darkForestAmogus:FlxSprite;
	var dawingSkyAmogus:FlxSprite;
	var gemstoneAmethystAmogus:FlxSprite;
	var macaroonAmogus:FlxSprite;
	var pastelAmogus:FlxSprite;
	var pastelPinkAmogus:FlxSprite;
	var goldAmogus:FlxSprite;
	var invertedChromaticAbbrevationAmogus:FlxSprite;
	var monochromeAmogus:FlxSprite;
	var spectrumAmogus:FlxSprite;
	var rainbowAmogus:FlxSprite;
	var corruptAmogus:FlxSprite;
	var mosaicAmogus:FlxSprite;
	var averageAmogus:FlxSprite;
	var clutchAmogus:FlxSprite;
	var randomInt:Int;
	var amogusPicker:FlxSprite;

	var loadedWeeks:Array<WeekData> = [];

	public var camOther:FlxCamera;

	var loadOut:GateTransition;
	var loadIn:GateTransition;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		FlxG.mouse.visible = true;
		FlxG.mouse.enabled = true;

		Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - In Story Menu";

		if(ClientPrefs.transitionStyle){
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		loadIn = new GateTransition(0,0,'in');
		loadOut = new GateTransition(0,0,'out');
		loadIn.animation.finishCallback = function(string:String){
		remove(loadIn);
		};
		loadOut.alpha = 0;
		loadOut.scrollFactor.set(0,0);
		loadIn.scrollFactor.set(0,0);
		}

		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;
		persistentUpdate = persistentDraw = true;

		camOther = new FlxCamera();
		FlxG.cameras.add(camOther, false);
		camOther.bgColor.alpha = 0;
		CustomFadeTransition.nextCamera = camOther;

		scoreText = new FlxText(522, 508, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		bg = new FlxSprite().loadGraphic(Paths.image('storyBG'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();
		bg.y -= 50;

		/*arrowLeft = new FlxSprite().loadGraphic(Paths.image('arrowLeft'));
		arrowLeft.antialiasing = ClientPrefs.globalAntialiasing;
		add(arrowLeft);
		arrowLeft.screenCenter();
		arrowLeft.y -= 50;

		arrowRight = new FlxSprite().loadGraphic(Paths.image('arrowRight'));
		arrowRight.antialiasing = ClientPrefs.globalAntialiasing;
		add(arrowRight);
		arrowRight.screenCenter();
		arrowRight.y -= 50;

		arrowUp = new FlxSprite().loadGraphic(Paths.image('arrowUp'));
		arrowUp.antialiasing = ClientPrefs.globalAntialiasing;
		add(arrowUp);
		arrowUp.screenCenter();
		arrowUp.y -= 50;

		arrowDown = new FlxSprite().loadGraphic(Paths.image('arrowDown'));
		arrowDown.antialiasing = ClientPrefs.globalAntialiasing;
		add(arrowDown);
		arrowDown.screenCenter();
		arrowDown.y -= 50;*/

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('arrows');
		var bgYellow:FlxSprite = new FlxSprite(0, 155).makeGraphic(FlxG.width, 386, 0xFFF9CF51);
		bgSprite = new FlxSprite(0, 155);
		bgYellow.scale.x = 0.5;
		bgYellow.scale.y = 0.5;
		bgSprite.scale.x = 0.5;
		bgSprite.scale.y = 0.5;
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		//var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		//add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - In Story Menu";
		#end

		var num:Int = 0;
		for (i in 0...WeekData.weeksList.length)
		{
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var isLocked:Bool = weekIsLocked(WeekData.weeksList[i]);
			if(!isLocked || !weekFile.hiddenUntilUnlocked)
			{
				loadedWeeks.push(weekFile);
				WeekData.setDirectoryFromWeek(weekFile);
				var weekThing:MenuItem = new MenuItem(0, bgSprite.y + 396, WeekData.weeksList[i]);
				weekThing.y += ((weekThing.height + 20) * num);
				weekThing.targetX = num;
				grpWeekText.add(weekThing);

				weekThing.screenCenter(X);
				weekThing.antialiasing = ClientPrefs.globalAntialiasing;
				// weekThing.updateHitbox();

				// Needs an offset thingie
				if (isLocked)
				{
					var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
					lock.frames = ui_tex;
					lock.animation.addByPrefix('lock', 'lock');
					lock.animation.play('lock');
					lock.ID = i;
					lock.antialiasing = ClientPrefs.globalAntialiasing;
					grpLocks.add(lock);
				}
				num++;
			}
		}

		WeekData.setDirectoryFromWeek(loadedWeeks[0]);
		var charArray:Array<String> = loadedWeeks[0].weekCharacters;
		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, charArray[char]);
			weekCharacterThing.y += 70;
			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		redAmogus = new FlxSprite(1110,525);
		redAmogus.frames = Paths.getSparrowAtlas('menuAmogus/redAmogus');
		redAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		redAmogus.animation.addByPrefix('squezee', 'redAmogusSquezee', 24, false);
		
		blueAmogus = new FlxSprite(1110,525);
		blueAmogus.frames = Paths.getSparrowAtlas('menuAmogus/blueAmogus');
		blueAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		blueAmogus.animation.addByPrefix('squezee', 'blueAmogusSquezee', 24, false);

		orangeAmogus = new FlxSprite(1110,525);
		orangeAmogus.frames = Paths.getSparrowAtlas('menuAmogus/orangeAmogus');
		orangeAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		orangeAmogus.animation.addByPrefix('squezee', 'orangeAmogusSquezee', 24, false);

		pinkAmogus = new FlxSprite(1110,525);
		pinkAmogus.frames = Paths.getSparrowAtlas('menuAmogus/pinkAmogus');
		pinkAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		pinkAmogus.animation.addByPrefix('squezee', 'pinkAmogusSquezee', 24, false);

		greenAmogus = new FlxSprite(1110,525);
		greenAmogus.frames = Paths.getSparrowAtlas('menuAmogus/greenAmogus');
		greenAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		greenAmogus.animation.addByPrefix('squezee', 'greenAmogusSquezee', 24, false);

		cyanAmogus = new FlxSprite(1110,525);
		cyanAmogus.frames = Paths.getSparrowAtlas('menuAmogus/cyanAmogus');
		cyanAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		cyanAmogus.animation.addByPrefix('squezee', 'cyanAmogusSquezee', 24, false);

		antigueAmogus = new FlxSprite(1110,525);
		antigueAmogus.frames = Paths.getSparrowAtlas('menuAmogus/antigueAmogus');
		antigueAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		antigueAmogus.animation.addByPrefix('squezee', 'antigueAmogusSquezee', 24, false);

		autumnAmogus = new FlxSprite(1110,525);
		autumnAmogus.frames = Paths.getSparrowAtlas('menuAmogus/autumnAmogus');
		autumnAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		autumnAmogus.animation.addByPrefix('squezee', 'autumnAmogusSquezee', 24, false);

		bwAmogus = new FlxSprite(1110,525);
		bwAmogus.frames = Paths.getSparrowAtlas('menuAmogus/bwAmogus');
		bwAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		bwAmogus.animation.addByPrefix('squezee', 'bwAmogusSquezee', 24, false);

		cherryBlossomsatNightAmogus = new FlxSprite(1110,525);
		cherryBlossomsatNightAmogus.frames = Paths.getSparrowAtlas('menuAmogus/cherryBlossomsatNightAmogus');
		cherryBlossomsatNightAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		cherryBlossomsatNightAmogus.animation.addByPrefix('squezee', 'cherryBlossomsatNightAmogusSquezee', 24, false);

		darkForestAmogus = new FlxSprite(1110,525);
		darkForestAmogus.frames = Paths.getSparrowAtlas('menuAmogus/darkForestAmogus');
		darkForestAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		darkForestAmogus.animation.addByPrefix('squezee', 'darkForestAmogusSquezee', 24, false);

		dawingSkyAmogus = new FlxSprite(1110,525);
		dawingSkyAmogus.frames = Paths.getSparrowAtlas('menuAmogus/dawingSkyAmogus');
		dawingSkyAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		dawingSkyAmogus.animation.addByPrefix('squezee', 'dawingSkyAmogusSquezee', 24, false);

		gemstoneAmethystAmogus = new FlxSprite(1110,525);
		gemstoneAmethystAmogus.frames = Paths.getSparrowAtlas('menuAmogus/gemstoneAmethystAmogus');
		gemstoneAmethystAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		gemstoneAmethystAmogus.animation.addByPrefix('squezee', 'gemstoneAmethystAmogusSquezee', 24, false);

		gemstoneAmethystAmogus = new FlxSprite(1110,525);
		gemstoneAmethystAmogus.frames = Paths.getSparrowAtlas('menuAmogus/gemstoneAmethystAmogus');
		gemstoneAmethystAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		gemstoneAmethystAmogus.animation.addByPrefix('squezee', 'gemstoneAmethystAmogusSquezee', 24, false);

		gemstoneAmethystAmogus = new FlxSprite(1110,525);
		gemstoneAmethystAmogus.frames = Paths.getSparrowAtlas('menuAmogus/gemstoneAmethystAmogus');
		gemstoneAmethystAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		gemstoneAmethystAmogus.animation.addByPrefix('squezee', 'gemstoneAmethystAmogusSquezee', 24, false);

		pastelPinkAmogus = new FlxSprite(1110,525);
		pastelPinkAmogus.frames = Paths.getSparrowAtlas('menuAmogus/pastelPinkAmogus');
		pastelPinkAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		pastelPinkAmogus.animation.addByPrefix('squezee', 'pastelPinkAmogusSquezee', 24, false);

		goldAmogus = new FlxSprite(1110,525);
		goldAmogus.frames = Paths.getSparrowAtlas('menuAmogus/goldAmogus');
		goldAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		goldAmogus.animation.addByPrefix('squezee', 'goldAmogusSquezee', 24, false);

		invertedChromaticAbbrevationAmogus = new FlxSprite(1110,525);
		invertedChromaticAbbrevationAmogus.frames = Paths.getSparrowAtlas('menuAmogus/invertedChromaticAbbrevationAmogus');
		invertedChromaticAbbrevationAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		invertedChromaticAbbrevationAmogus.animation.addByPrefix('squezee', 'invertedChromaticAbbrevationAmogusSquezee', 24, false);

		monochromeAmogus = new FlxSprite(1110,525);
		monochromeAmogus.frames = Paths.getSparrowAtlas('menuAmogus/monochromeAmogus');
		monochromeAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		monochromeAmogus.animation.addByPrefix('squezee', 'monochromeAmogusSquezee', 24, false);

		spectrumAmogus = new FlxSprite(1110,525);
		spectrumAmogus.frames = Paths.getSparrowAtlas('menuAmogus/spectrumAmogus');
		spectrumAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		spectrumAmogus.animation.addByPrefix('squezee', 'spectrumAmogusSquezee', 24, false);

		rainbowAmogus = new FlxSprite(1110,525);
		rainbowAmogus.frames = Paths.getSparrowAtlas('menuAmogus/rainbowAmogus');
		rainbowAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		rainbowAmogus.animation.addByPrefix('squezee', 'rainbowAmogusSquezee', 24, false);

		corruptAmogus = new FlxSprite(1110,525);
		corruptAmogus.frames = Paths.getSparrowAtlas('menuAmogus/corruptAmogus');
		corruptAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		corruptAmogus.animation.addByPrefix('squezee', 'corruptAmogusSquezee', 24, false);

		corruptAmogus = new FlxSprite(1110,525);
		corruptAmogus.frames = Paths.getSparrowAtlas('menuAmogus/corruptAmogus');
		corruptAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		corruptAmogus.animation.addByPrefix('squezee', 'corruptAmogusSquezee', 24, false);

		mosaicAmogus = new FlxSprite(1110,525);
		mosaicAmogus.frames = Paths.getSparrowAtlas('menuAmogus/mosaicAmogus');
		mosaicAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		mosaicAmogus.animation.addByPrefix('squezee', 'mosaicAmogusSquezee', 24, false);

		averageAmogus = new FlxSprite(1110,505);
		averageAmogus.frames = Paths.getSparrowAtlas('menuAmogus/averageAmogus');
		averageAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		averageAmogus.animation.addByPrefix('squezee', 'averageAmogusSquezee', 24, false);

		clutchAmogus = new FlxSprite(1110,505);
		clutchAmogus.frames = Paths.getSparrowAtlas('menuAmogus/clutchAmogus');
		clutchAmogus.antialiasing = ClientPrefs.globalAntialiasing;
		clutchAmogus.animation.addByPrefix('squezee', 'clutchAmogusSquezee', 24, false);

		leftArrow = new FlxSprite().loadGraphic(Paths.image('mainmenu/arrowLeft'));
		//leftArrow.scrollFactor.set(0, yScroll);
		leftArrow.updateHitbox();
		leftArrow.screenCenter();
		leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		add(leftArrow);

		/*leftArrow = new FlxSprite();
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');*/
		leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		add(leftArrow);
		leftArrow.x = 150;
		leftArrow.y = 282;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		sprDifficulty = new FlxSprite();
		sprDifficulty.antialiasing = ClientPrefs.globalAntialiasing;
		add(sprDifficulty);
		//sprDifficulty.x = 530;
		sprDifficulty.y = 595;

		rightArrow = new FlxSprite().loadGraphic(Paths.image('mainmenu/arrowRight'));
		//rightArrow.scrollFactor.set(0, yScroll);
		rightArrow.updateHitbox();
		rightArrow.screenCenter();
		rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		add(rightArrow);
		rightArrow.x = 975;
		rightArrow.y = 282;

		/*rightArrow = new FlxSprite(leftArrow.x + 806, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');*/
		//rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		//add(rightArrow);

		upArrow = new FlxSprite();
		upArrow.frames = ui_tex;
		upArrow.animation.addByPrefix('idle', 'arrow up');
		upArrow.animation.addByPrefix('press', "arrow push up", 24, false);
		upArrow.animation.play('idle');
		upArrow.antialiasing = ClientPrefs.globalAntialiasing;
		difficultySelectors.add(upArrow);
		upArrow.x = 635;
		upArrow.y = 544;

		downArrow = new FlxSprite(upArrow.x - 70, upArrow.y);
		downArrow.frames = ui_tex;
		downArrow.animation.addByPrefix('idle', 'arrow down');
		downArrow.animation.addByPrefix('press', "arrow push down", 24, false);
		downArrow.animation.play('idle');
		downArrow.antialiasing = ClientPrefs.globalAntialiasing;
		difficultySelectors.add(downArrow);
		downArrow.x = 624;
		downArrow.y = 665;

		add(bgYellow);
		add(bgSprite);
		add(grpWeekCharacters);

		//Amogus picking section - luci
		randomInt = FlxG.random.int(0,99);

		if (randomInt >= 0 && randomInt <= 5){
			amogusPicker = redAmogus;
		} else if (randomInt >= 6 && randomInt <= 10){
			amogusPicker = blueAmogus;
		}  else if (randomInt >= 11 && randomInt <= 15){
			amogusPicker = orangeAmogus;
		}  else if (randomInt >= 16 && randomInt <= 20){
			amogusPicker = pinkAmogus;
		}  else if (randomInt >= 21 && randomInt <= 25){
			amogusPicker = greenAmogus;
		}  else if (randomInt >= 26 && randomInt <= 30){
			amogusPicker = cyanAmogus;
		}  else if (randomInt >= 31 && randomInt <= 35){
			amogusPicker = antigueAmogus;
		}  else if (randomInt >= 36 && randomInt <= 40){
			amogusPicker = autumnAmogus;
		}  else if (randomInt >= 41 && randomInt <= 44){
			amogusPicker = bwAmogus;
		}  else if (randomInt >= 45 && randomInt <= 48){
			amogusPicker = cherryBlossomsatNightAmogus;
		}  else if (randomInt >= 49 && randomInt <= 53){
			amogusPicker = darkForestAmogus;
		}  else if (randomInt >= 54 && randomInt <= 58){
			amogusPicker = dawingSkyAmogus;
		}  else if (randomInt >= 59 && randomInt <= 63){
			amogusPicker = gemstoneAmethystAmogus;
		}  else if (randomInt >= 64 && randomInt <= 68){
			amogusPicker = macaroonAmogus;
		}  else if (randomInt >= 69 && randomInt <= 72){
			amogusPicker = pastelAmogus;
		}  else if (randomInt >= 73 && randomInt <= 76){
			amogusPicker = pastelPinkAmogus;
		}  else if (randomInt >= 77 && randomInt <= 80){
			amogusPicker = goldAmogus;
		}  else if (randomInt >= 81 && randomInt <= 83){
			amogusPicker = invertedChromaticAbbrevationAmogus;
		}  else if (randomInt >= 84 && randomInt <= 86){
			amogusPicker = monochromeAmogus;
		}  else if (randomInt >= 87 && randomInt <= 89){
			amogusPicker = spectrumAmogus;
		}  else if (randomInt >= 90 && randomInt <= 91){
			amogusPicker = rainbowAmogus;
		}  else if (randomInt >= 92 && randomInt <= 93){
			amogusPicker = corruptAmogus;
		}  else if (randomInt >= 94 && randomInt <= 95){
			amogusPicker = mosaicAmogus;
		}  else if (randomInt >= 96 && randomInt <= 97){
			amogusPicker = averageAmogus;
		}  else if (randomInt >= 98 && randomInt <= 99){
			amogusPicker = clutchAmogus;
		}

		if (amogusPicker == null) amogusPicker = redAmogus;

		add(amogusPicker);

		#if ACHIEVEMENTS_ALLOWED
		var achieve2:String = checkForAchievement(['macaroon_amogus', 'pastel_amogus',	'pastel_pink_amogus', 'golden_amogus','inverted_amogus','monochrome_amogus','spectrum_amogus','rainbow_amogus','corrupt_amogus','mosaic_amogus','average_amogus','clutch_amogus']);
		if (achieve2 != null) {
			startAchievement(achieve2);
		} else {
			FlxG.save.flush();
		}
		#end

		var tracksSprite:FlxSprite = new FlxSprite(FlxG.width * 0.07, bgSprite.y + 353).loadGraphic(Paths.image('Menu_Tracks'));
		tracksSprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(tracksSprite);

		txtTracklist = new FlxText(FlxG.width * 0.05, tracksSprite.y + 60, 0, "", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		changeWeek();
		changeDifficulty();

		if(ClientPrefs.transitionStyle){
		add(loadIn);
        add(loadOut);
		loadIn.animation.play('GateTransition');
		}

		super.create();
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}

	override function update(elapsed:Float)
	{

		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;

		scoreText.text = "WEEK SCORE:" + lerpScore;

		// FlxG.watch.addQuick('font', scoreText.font);

		if (!movedBack && !selectedWeek)
		{
			var upP = controls.UI_UP_P;
			var downP = controls.UI_DOWN_P;
			var leftP = controls.UI_LEFT_P;
			var rightP = controls.UI_RIGHT_P;

			if (leftP||FlxG.mouse.justPressed && FlxG.mouse.overlaps(leftArrow))
			{
				leftArrow.animation.play('press');
				changeWeek(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			} else {
				leftArrow.animation.play('idle');
			}

			if (rightP||FlxG.mouse.justPressed && FlxG.mouse.overlaps(rightArrow))
			{
				rightArrow.animation.play('press');
				changeWeek(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));
			} else {
				rightArrow.animation.play('idle');
			}

			if (ClientPrefs.middleMouseScroll){
			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeWeek(-FlxG.mouse.wheel);
				changeDifficulty();
			}
			}

			if (controls.UI_UP||FlxG.mouse.justPressed && FlxG.mouse.overlaps(upArrow))
				upArrow.animation.play('press');
			else
				upArrow.animation.play('idle');

			if (controls.UI_DOWN||FlxG.mouse.justPressed && FlxG.mouse.overlaps(downArrow))
				downArrow.animation.play('press');
			else
				downArrow.animation.play('idle');

			if(FlxG.mouse.justPressed && FlxG.mouse.overlaps(amogusPicker)){
				if (amogusPicker != null){
				amogusPicker.animation.finish();
				amogusPicker.animation.play('squezee');
				FlxG.sound.play(Paths.sound('RubberDuck'));

				#if ACHIEVEMENTS_ALLOWED
				Achievements.amogusSqueezes++;
				FlxG.save.data.amogusSqueezes = Achievements.amogusSqueezes;
				var achieve:String = checkForAchievement(['amogus_abuser']);
				if (achieve != null) {
					startAchievement(achieve);
				} else {
					FlxG.save.flush();
				}
				FlxG.log.add('Squeezes: ' + Achievements.amogusSqueezes);
				#end
				}
			}

			if (controls.UI_UP_P||FlxG.mouse.justPressed && FlxG.mouse.overlaps(upArrow))
				changeDifficulty(1);
			else if (controls.UI_DOWN_P||FlxG.mouse.justPressed && FlxG.mouse.overlaps(downArrow))
				changeDifficulty(-1);
			else if (upP || downP)
				changeDifficulty();

			if(FlxG.keys.justPressed.CONTROL)
			{
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			}
			else if(controls.RESET)
			{
				persistentUpdate = false;
				openSubState(new ResetScoreSubState('', curDifficulty, '', curWeek));
				//FlxG.sound.play(Paths.sound('scrollMenu'));
			}
			else if (controls.ACCEPT||FlxG.mouse.justPressed && FlxG.mouse.overlaps(grpWeekText))
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			if(ClientPrefs.transitionStyle){
			loadOut.alpha = 1;
			loadOut.animation.play('GateTransition');
			Achievements.amogusSqueezes = -1;
			loadOut.animation.finishCallback = function(string:String){
			FlxG.switchState(new MainMenuState());
			};
			} else {
			MusicBeatState.switchState(new MainMenuState());
			}
		}

		super.update(elapsed);

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
			lock.visible = (lock.y > FlxG.height / 2);
		});
	}

	#if ACHIEVEMENTS_ALLOWED
	var achievementObj:AchievementObject = null;
	function startAchievement(achieve2:String) {
		achievementObj = new AchievementObject(achieve2, camOther);
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve2);
	}
	function achievementEnd():Void
	{
		achievementObj = null;
	}
	#end

	#if ACHIEVEMENTS_ALLOWED
	private function checkForAchievement(achievesToCheck:Array<String> = null):String
	{
		for (i in 0...achievesToCheck.length) {
			var achievementName:String = achievesToCheck[i];
			if(!Achievements.isAchievementUnlocked(achievementName)) {
				var unlock:Bool = false;
				var weekName:String = WeekData.getWeekFileName();
				switch(achievementName)
				{
					case 'amogus_abuser':
						if (Achievements.amogusSqueezes >= 50){
							unlock = true;
							
							FlxG.mouse.visible = false;
							FlxG.mouse.enabled = false;

							selectedWeek = true;

							new FlxTimer().start(3, function(tmr:FlxTimer)
								{

							var diffic = CoolUtil.defaultDifficulties[2];
							if (diffic == null) 
							diffic = '';
				
							PlayState.storyPlaylist = ["rebirth"];
				
							PlayState.storyDifficulty = 2;
				
							PlayState.isStoryMode = true;
				
							PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + "-" + diffic, PlayState.storyPlaylist[0].toLowerCase());
							PlayState.campaignScore = 0;
							PlayState.campaignMisses = 0;

							FlxG.sound.play(Paths.sound('correct'));
				
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
							LoadingState.loadAndSwitchState(new PlayState());
							FlxG.sound.music.volume = 0;
							});
							});
						}
					case 'macaroon_amogus':
						if(amogusPicker == macaroonAmogus) {
							unlock = true;
							}
					case 'pastel_amogus':
						if(amogusPicker == pastelAmogus) {
							unlock = true;
							}
					case 'pastel_pink_amogus':
						if(amogusPicker == pastelPinkAmogus) {
						unlock = true;
							}
					case 'golden_amogus':
						if(amogusPicker == goldAmogus) {
						unlock = true;
							}
					case 'inverted_amogus':
						if(amogusPicker == invertedChromaticAbbrevationAmogus) {
						unlock = true;
							}
					case 'monochrome_amogus':
						if(amogusPicker == monochromeAmogus) {
						unlock = true;
							}
					case 'spectrum_amogus':
						if(amogusPicker == spectrumAmogus) {
						unlock = true;
							}
					case 'rainbow_amogus':
						if(amogusPicker == rainbowAmogus) {
						unlock = true;
							}
					case 'corrupt_amogus':
						if(amogusPicker == corruptAmogus) {
						unlock = true;
							}
					case 'mosaic_amogus':
						if(amogusPicker == mosaicAmogus) {
						unlock = true;
							}
					case 'average_amogus':
						if(amogusPicker == averageAmogus) {
						unlock = true;
							}
					case 'clutch_amogus':
						if(amogusPicker == clutchAmogus) {
						unlock = true;
							}
						}

				if(unlock) {
					Achievements.unlockAchievement(achievementName);
					return achievementName;
				}
			}
		}
		return null;
	}	#end

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (!weekIsLocked(loadedWeeks[curWeek].fileName))
		{
			if (stopspamming == false)
			{
				FlxG.mouse.visible = false;
				FlxG.mouse.enabled = false;
				
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();

				var bf:MenuCharacter = grpWeekCharacters.members[1];
				if(bf.character != '' && bf.hasConfirmAnimation) grpWeekCharacters.members[1].animation.play('confirm');
				stopspamming = true;
			}

			// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
			for (i in 0...leWeek.length) {
				songArray.push(leWeek[i][0]);
			}

			// Nevermind that's stupid lmao
			PlayState.storyPlaylist = songArray;
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
			if(diffic == null) diffic = '';

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			switch (StringTools.replace(PlayState.storyPlaylist[0]," ", "-").toLowerCase()) {
				default:
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
					openSubState(new LoadingScreens());
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = false;
					new FlxTimer().start(1, function(tmr:FlxTimer){
				LoadingState.loadAndSwitchState(new PlayState(), true);
				});
			});
		}
		} else {
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
	}

	var tweenDifficulty:FlxTween;
	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		WeekData.setDirectoryFromWeek(loadedWeeks[curWeek]);

		var diff:String = CoolUtil.difficulties[curDifficulty];
		var newImage:FlxGraphic = Paths.image('menudifficulties/' + Paths.formatToSongPath(diff));
		//trace(Paths.currentModDirectory + ', menudifficulties/' + Paths.formatToSongPath(diff));

		if(sprDifficulty.graphic != newImage)
		{
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.x = (1822 - sprDifficulty.width) / 3;
			sprDifficulty.alpha = 0;
		//	sprDifficulty.y = downArrow.y - 15;

			if(tweenDifficulty != null) tweenDifficulty.cancel();
			tweenDifficulty = FlxTween.tween(sprDifficulty, {alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
			{
				tweenDifficulty = null;
			}});
		}
		lastDifficultyName = diff;

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= loadedWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = loadedWeeks.length - 1;

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);

		var leName:String = leWeek.storyName;
		txtWeekTitle.text = leName.toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 25);
		txtWeekTitle.y  = 160;

		var bullShit:Int = 0;

		var unlocked:Bool = !weekIsLocked(leWeek.fileName);
		for (item in grpWeekText.members)
		{
			item.targetX = bullShit - curWeek;
			item.targetY = curWeek;
			if (item.targetX == Std.int(0) && unlocked)
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		bgSprite.visible = true;
		var assetName:String = leWeek.weekBackground;
		if(assetName == null || assetName.length < 1) {
			bgSprite.visible = false;
		} else {
			bgSprite.loadGraphic(Paths.image('menubackgrounds/menu_' + assetName));
		}
		PlayState.storyWeek = curWeek;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5
		difficultySelectors.visible = unlocked;

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
		updateText();
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	function updateText()
	{
		var weekArray:Array<String> = loadedWeeks[curWeek].weekCharacters;
		for (i in 0...grpWeekCharacters.length) {
			grpWeekCharacters.members[i].changeCharacter(weekArray[i]);
		}

		var leWeek:WeekData = loadedWeeks[curWeek];
		var stringThing:Array<String> = [];
		for (i in 0...leWeek.songs.length) {
			stringThing.push(leWeek.songs[i][0]);
		}

		txtTracklist.text = '';
		for (i in 0...stringThing.length)
		{
			txtTracklist.text += stringThing[i] + '\n';
		}

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}
}

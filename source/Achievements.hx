import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class Achievements {
	public static var achievementsStuff:Array<Dynamic> = [ //Name, Description, Achievement save tag, Hidden achievement
		["GF, I'm Coming!",			    "Beat Week 1 On Any Difficulty.",					'week1_done',		 false],
		["The Mysterious Skeleton...",  "Beat Week 1 On Hard without misses.",				'myst_week1',		 false],
		["That Robot Looks Like Me?!",	 	    "Beat Week 2 On Any Difficulty.",					'week2_done',		 false],
		["The Friendly Robot.",	 	    "Beat Week 2 On Hard without misses.",				'screwie_week2',		 false],
		//["The Rap Software!",	    	"Beat Week 2 On Hard without misses.",				'screwie_week2',	 false],
		["The Corrupted Robot.",	    "Beat Week 3 On Any Difficulty.",					'week3_done',		 false],
		["Hot-Rude",	   			 	"Beat Week 3 On Hard without misses.",				'hotrod_week3',		 false],
		["That Was One Hell Of A Funkin' Disaster!",	"Beat Week 4 On Any Difficulty.",		'week4_done',		 false],
		["Unexpected Turn Of Events!",	"Beat Week 4 On Hard without misses.",				'week4_hard',		 false],
		["Battle Of The Tormented...",	"Finish 'Triple-Torment'.",							'tt_done',			  	 false],
		["Tormented But Still Skilled",	"Finish 'Triple-Torment On Hard Without Misses.",	'tt_no_miss',			  	 false],
		["The Red Danger.",				"Finish 'Lead Headed' On Hard Without Misses.",		'lh_no_miss',			  	 false],
		["Sorry Boys, The Candy's Mine.","Finish 'Masked-Melody' On Hard Without Misses.",		'mm_no_miss',			  	 false],
		["Spam-Machine-Gun",			"Finish 'Spectrum' On Hard Without Misses.",			'spectrum_no_miss',			  	 false],
		["I'm At My Limit.",			"Finish 'Breakdown' On Hard Without Missing More Than 20 Notes.",		'bd_20_miss',			  	 false],
		["Didn't I see this somewhere?","Finish 'Lo-Ghoul' On Hard Without Misses.",		'lg_no_miss',			  	 false],
		["Shadows...",					"Finish 'Shadows' On Hard Without Misses.",			'shadows_no_miss',			  	 false],
		["Amogus Abuser",       		"Squeeze The Amogus 50 Times.",						'amogus_abuser',		 true],
		["Macaroon! Shakaroon!",        "Get The Macaroon Amogus.",							'macaroon_amogus',		 true],
		["Pastel But Still Sus.",		"Get The Pastel Amogus.",							'pastel_amogus',		 true],
		["Didn't Know They Come Like That.","Get The Pastel Pink Amogus.",					'pastel_pink_amogus',		 true],
		["Golden And Sussy.",			"Get The Golden Amogus.",							'golden_amogus',		 true],
		["What Kind Of Amogus Even Are You?.",	"Get The Inverted Chromatic Abbrevation Amogus.",	'inverted_amogus',		 true],
		["I'm...deeeaaad...And Sussss.","Get The Monochrome Amogus.",						'monochrome_amogus',		 true],
		["Spectrum Song Reference.",	"Get The Spectrum Amogus.",							'spectrum_amogus',		 true],
		["Look! It's A Rainbow Amogus!","Get The Rainbow Amogus.",							'rainbow_amogus',		 true],
		["We Can Get Corrupted Too.",	"Get The Corrupt Amogus.",							'corrupt_amogus',		 true],
		["Imposter Caught In 16-Bit.",	"Get The Mosaic Amogus.",							'mosaic_amogus',		 true],
		["Average In Name...Rare In Type.",	"Get The Average Amogus.",						'average_amogus',		 true],
		["Your Friendly Maple Syrup Amogus!",	"Get The Cluch Amogus.",					'clutch_amogus',		 true],
		["Freaky on a Friday Night",	"Play on a Friday... Night.",						'friday_night_play',	 true],
		["What a Funkin' Disaster!",	"Complete a Song with a rating lower than 20%.",	'ur_bad',				false],
		["Perfectionist",				"Complete a Song with a rating of 100%.",			'ur_good',				false],
		["Oversinging Much...?",		"Hold down a note for 10 seconds.",					'oversinging',			false],
		["Hyperactive",					"Finish a Song without going Idle.",				'hype',					false],
		["Just the Two of Us",			"Finish a Song pressing only two keys.",			'two_keys',				false],
		["Toaster Gamer",				"Have you tried to run the game on a toaster?",		'toastie',				false],
		["Debugger",					"Beat the \"Test\" Stage from the Chart Editor.",	'debugger',				 true]
	];

	public static var achievementsMap:Map<String, Bool> = new Map<String, Bool>();

	public static var amogusSqueezes:Int = 0;
	public static function unlockAchievement(name:String):Void {
		FlxG.log.add('Completed achievement "' + name +'"');
		achievementsMap.set(name, true);
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
	}

	public static function isAchievementUnlocked(name:String) {
		if(achievementsMap.exists(name) && achievementsMap.get(name)) {
			return true;
		}
		return false;
	}

	public static function getAchievementIndex(name:String) {
		for (i in 0...achievementsStuff.length) {
			if(achievementsStuff[i][2] == name) {
				return i;
			}
		}
		return -1;
	}

	public static function loadAchievements():Void {
		if(FlxG.save.data != null) {
			if(FlxG.save.data.achievementsMap != null) {
				achievementsMap = FlxG.save.data.achievementsMap;
			}
			if(amogusSqueezes == 0 && FlxG.save.data.amogusSqueezes != null) {
				amogusSqueezes = FlxG.save.data.amogusSqueezes;
			}
		}
	}
}

class AttachedAchievement extends FlxSprite {
	public var sprTracker:FlxSprite;
	private var tag:String;
	public function new(x:Float = 0, y:Float = 0, name:String) {
		super(x, y);

		changeAchievement(name);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function changeAchievement(tag:String) {
		this.tag = tag;
		reloadAchievementImage();
	}

	public function reloadAchievementImage() {
		if(Achievements.isAchievementUnlocked(tag)) {
			loadGraphic(Paths.image('achievements/' + tag));
		} else {
			loadGraphic(Paths.image('achievements/lockedachievement'));
		}
		scale.set(0.7, 0.7);
		updateHitbox();
	}

	override function update(elapsed:Float) {
		if (sprTracker != null)
			setPosition(sprTracker.x - 130, sprTracker.y + 25);

		super.update(elapsed);
	}
}

class AchievementObject extends FlxSpriteGroup {
	public var onFinish:Void->Void = null;
	var alphaTween:FlxTween;
	public function new(name:String, ?camera:FlxCamera = null)
	{
		super(x, y);
		ClientPrefs.saveSettings();

		var id:Int = Achievements.getAchievementIndex(name);
		var achievementBG:FlxSprite = new FlxSprite(60, 50).makeGraphic(420, 120, FlxColor.BLACK);
		achievementBG.scrollFactor.set();

		var achievementIcon:FlxSprite = new FlxSprite(achievementBG.x + 10, achievementBG.y + 10).loadGraphic(Paths.image('achievements/' + name));
		achievementIcon.scrollFactor.set();
		achievementIcon.setGraphicSize(Std.int(achievementIcon.width * (2 / 3)));
		achievementIcon.updateHitbox();
		achievementIcon.antialiasing = ClientPrefs.globalAntialiasing;

		var achievementName:FlxText = new FlxText(achievementIcon.x + achievementIcon.width + 20, achievementIcon.y + 16, 280, Achievements.achievementsStuff[id][0], 16);
		achievementName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementName.scrollFactor.set();

		var achievementText:FlxText = new FlxText(achievementName.x, achievementName.y + 32, 280, Achievements.achievementsStuff[id][1], 16);
		achievementText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		achievementText.scrollFactor.set();

		add(achievementBG);
		add(achievementName);
		add(achievementText);
		add(achievementIcon);

		var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
		if(camera != null) {
			cam = [camera];
		}
		alpha = 0;
		achievementBG.cameras = cam;
		achievementName.cameras = cam;
		achievementText.cameras = cam;
		achievementIcon.cameras = cam;
		alphaTween = FlxTween.tween(this, {alpha: 1}, 0.5, {onComplete: function (twn:FlxTween) {
			alphaTween = FlxTween.tween(this, {alpha: 0}, 0.5, {
				startDelay: 2.5,
				onComplete: function(twn:FlxTween) {
					alphaTween = null;
					remove(this);
					if(onFinish != null) onFinish();
				}
			});
		}});
	}

	override function destroy() {
		if(alphaTween != null) {
			alphaTween.cancel();
		}
		super.destroy();
	}
}
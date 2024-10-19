package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.utils.Assets;
import flixel.FlxSubState;
import lime.app.Application;
import Achievements;

using StringTools;

class AchievementsMenuState extends MusicBeatState
{
	#if ACHIEVEMENTS_ALLOWED
	var options:Array<String> = [];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	private var achievementArray:Array<AttachedAchievement> = [];
	private var achievementIndex:Array<Int> = [];
	private var descText:FlxText;

	var loadOut:GateTransition;
	var loadIn:GateTransition;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Achievements Menu", null);
		Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - In Achievements Menu";
		#end

		if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
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

		FlxG.mouse.enabled = true;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesats/menuScrewie'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(menuBG);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		Achievements.loadAchievements();
		for (i in 0...Achievements.achievementsStuff.length) {
			if(!Achievements.achievementsStuff[i][3] || Achievements.achievementsMap.exists(Achievements.achievementsStuff[i][2])) {
				options.push(Achievements.achievementsStuff[i]);
				achievementIndex.push(i);
			}
		}

		for (i in 0...options.length) {
			var achieveName:String = Achievements.achievementsStuff[achievementIndex[i]][2];
			var optionText:Alphabet = new Alphabet(0, (100 * i) + 210, Achievements.isAchievementUnlocked(achieveName) ? Achievements.achievementsStuff[achievementIndex[i]][0] : '?', false, false);
			optionText.isMenuItem = true;
			optionText.x += 280;
			optionText.xAdd = 100;
			optionText.targetY = i;
			grpOptions.add(optionText);

			var icon:AttachedAchievement = new AttachedAchievement(optionText.x - 105, optionText.y, achieveName);
			icon.sprTracker = optionText;
			achievementArray.push(icon);
			add(icon);
		}

		descText = new FlxText(150, 600, 980, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);
		changeSelection();

		if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
			loadIn.animation.play('GateTransition');
			add(loadIn);
			add(loadOut);
			}

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (ClientPrefs.middleMouseScroll){
		if(FlxG.mouse.wheel != 0)
			{
			changeSelection(-FlxG.mouse.wheel);
		}
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if (FlxG.save.data.inAwards == true){
				MusicBeatState.switchState(new PlayState());
			} else {
			if (!ClientPrefs.legacyEngine){
				if (ClientPrefs.transitionStyle){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
					MusicBeatState.switchState(new options.OptionsState());
					});
					} else {
					MusicBeatState.switchState(new options.OptionsState());
					}
			} else {
					MusicBeatState.switchState(new legacy.LegacyMainMenuState());
			}
			}
		}
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}

		for (i in 0...achievementArray.length) {
			achievementArray[i].alpha = 0.6;
			if(i == curSelected) {
				achievementArray[i].alpha = 1;
			}
		}
		descText.text = Achievements.achievementsStuff[achievementIndex[curSelected]][1];
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	}
	#end
}

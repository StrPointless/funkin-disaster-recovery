package legacy;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.addons.ui.FlxUICheckBox;
import options.OptionsState;
import MainMenuState;

using StringTools;

class LegacyMainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	private var camMain:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		'new_engine', // Had to become Phantom Arcade and River Oaken to draw assets for the new option :Smug: - luci
		#if !switch 'donate', #end
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	//public static var addCursorOption:Bool = false;
	//public static var addCreditsRollOption:Bool = false;

	public static var BF:FlxSprite;
	public static var myst:FlxSprite;
	public static var screwie:FlxSprite;
	public static var hotRod:FlxSprite;
	public static var redlineBF:FlxSprite;
	public static var redlineGF:FlxSprite;
	public static var redlinePico:FlxSprite;
	public static var GF:FlxSprite;
	public static var halloweenPico:FlxSprite;
	public static var spectrum:FlxSprite;
	public static var breakdownBF:FlxSprite;

	public static var curCharacter:FlxSprite;

	var randomFloat:Float;
	public static var mmCheck:Bool = false;
	static var main_menu_characters:FlxUICheckBox = null;
	var black:FlxSprite;

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - In Main Menu (Legacy Edition)";
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		FlxG.mouse.visible = true;
		FlxG.mouse.enabled = true;

		main_menu_characters = new FlxUICheckBox(1115, 700, null, null, "Show Main Menu Characters.", 200);
		if (FlxG.save.data.main_menu_characters == null) FlxG.save.data.main_menu_characters = false;
		main_menu_characters.checked = FlxG.save.data.main_menu_characters;

		mmCheck = FlxG.save.data.main_menu_characters;

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;
		camMain = new FlxCamera();
		camMain.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxG.cameras.add(camMain);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		black = new FlxSprite(main_menu_characters.x - 4, main_menu_characters.y - 8).makeGraphic(170, 100, 0xb7000000);
		add(black);

		black.cameras = [camMain];

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesats/menuMyst'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesats/menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(150, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('legacyStuff/mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItem.x -= 40;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		main_menu_characters.cameras = [camMain];

		add(main_menu_characters);

		if (mmCheck){
			randomFloat = FlxG.random.float(0,99.999);
			if (randomFloat >= 0 && randomFloat <= 9.0909){
				BF = new FlxSprite();
				BF.frames = Paths.getSparrowAtlas('characters/Boyfriend_PhalvReanimation');
				BF.animation.addByPrefix('idle', 'BF idle dance0', 24, true);
				BF.animation.play('idle');
				BF.x = 1800;
				BF.scale.set(0.9,0.9);
				BF.screenCenter(Y);
				BF.y = 140;
				curCharacter = BF;
				FlxTween.tween(curCharacter, {x: 780}, 0.7, {ease: FlxEase.backOut});
				BF.cameras = [camMain];
			}  else if (randomFloat >= 9.0910 && randomFloat <= 18.181){
				myst = new FlxSprite();
				myst.frames = Paths.getSparrowAtlas('characters/MystR');
				myst.animation.addByPrefix('idle', 'MystR idle0', 24, true , true);
				myst.animation.play('idle');
				myst.x = 1800;
				myst.scale.set(0.6,0.6);
				myst.screenCenter(Y);
				curCharacter = myst;
				FlxTween.tween(curCharacter, {x: 635}, 0.7, {ease: FlxEase.backOut});
				myst.cameras = [camMain];
			}  else if (randomFloat >= 18.182 && randomFloat <= 27.272){		
				screwie = new FlxSprite();
				screwie.frames = Paths.getSparrowAtlas('characters/screwiehd');
				screwie.animation.addByPrefix('idle', 'screwiehd idle0', 24, true, true);
				screwie.animation.play('idle');
				screwie.x = 1800;
				screwie.scale.set(0.6,0.6);
				screwie.screenCenter(Y);
				screwie.y + 20;
				curCharacter = screwie;
				FlxTween.tween(curCharacter, {x: 550}, 0.7, {ease: FlxEase.backOut});
				screwie.cameras = [camMain];
			}  else if (randomFloat >= 27.273 && randomFloat <= 36.363){
				hotRod = new FlxSprite();
				hotRod.frames = Paths.getSparrowAtlas('characters/Hotrod');
				hotRod.animation.addByPrefix('idle', 'Hotrod idle0', 24, true, true);
				hotRod.animation.play('idle');
				hotRod.x = 1800;
				hotRod.screenCenter(Y);
				curCharacter = hotRod;
				FlxTween.tween(curCharacter, {x: 740}, 0.7, {ease: FlxEase.backOut});
				hotRod.cameras = [camMain];
			}  else if (randomFloat >= 36.364 && randomFloat <= 45.454){		
				redlineBF = new FlxSprite();
				redlineBF.frames = Paths.getSparrowAtlas('characters/RedlineBf');
				redlineBF.animation.addByPrefix('idle', 'BF idle dance0', 24, true);
				redlineBF.animation.play('idle');
				redlineBF.x = 1800;
				redlineBF.screenCenter(Y);
				curCharacter = redlineBF;
				FlxTween.tween(curCharacter, {x: 820}, 0.7, {ease: FlxEase.backOut});
				redlineBF.cameras = [camMain];
				if (!TitleState.unlockedSongs[0])
				redlineBF.color = FlxColor.BLACK;
			}  else if (randomFloat >= 45.455 && randomFloat <= 54.545){				
				redlineGF = new FlxSprite();
				redlineGF.frames = Paths.getSparrowAtlas('characters/RedlineGf');
				redlineGF.animation.addByPrefix('idle', 'GF Dancing Beat0', 24, true);
				redlineGF.animation.play('idle');
				redlineGF.x = 1800;
				redlineGF.scale.set(0.8,0.8);
				redlineGF.screenCenter(Y);
				curCharacter = redlineGF;
				FlxTween.tween(curCharacter, {x: 620}, 0.7, {ease: FlxEase.backOut});
				redlineGF.cameras = [camMain];
				if (!TitleState.unlockedSongs[0])
					redlineGF.color = FlxColor.BLACK;
			}  else if (randomFloat >= 54.546 && randomFloat <= 63.636){
				redlinePico = new FlxSprite();
				redlinePico.frames = Paths.getSparrowAtlas('characters/RedlinePico');
				redlinePico.animation.addByPrefix('idle', 'Pico Idle Dance0', 24, true);
				redlinePico.animation.play('idle');
				redlinePico.x = 1800;
				redlinePico.scale.set(0.9,0.9);
				redlinePico.screenCenter(Y);
				curCharacter = redlinePico;
				FlxTween.tween(curCharacter, {x: 800}, 0.7, {ease: FlxEase.backOut});
				redlinePico.cameras = [camMain];
				if (!TitleState.unlockedSongs[0])
					redlinePico.color = FlxColor.BLACK;
			}  else if (randomFloat >= 63.637 && randomFloat <= 72.727){			
				GF = new FlxSprite();
				GF.frames = Paths.getSparrowAtlas('characters/ovaries');
				GF.animation.addByPrefix('idle', 'GF Dancing Beat0', 24, true);
				GF.animation.play('idle');
				GF.x = 1800;
				GF.y = 140;
				curCharacter = GF;
				GF.cameras = [camMain];
				FlxTween.tween(curCharacter, {x: 820}, 0.7, {ease: FlxEase.backOut});
			}  else if (randomFloat >= 72.728 && randomFloat <= 81.818){
				halloweenPico = new FlxSprite();
				halloweenPico.frames = Paths.getSparrowAtlas('characters/Pico_Pumpkin');
				halloweenPico.animation.addByPrefix('idle', 'Pico Idle Dance0', 24, true);
				halloweenPico.animation.play('idle');
				halloweenPico.x = 1800;
				halloweenPico.screenCenter(Y);
				curCharacter = halloweenPico;
				FlxTween.tween(curCharacter, {x: 780}, 0.7, {ease: FlxEase.backOut});
				halloweenPico.cameras = [camMain];
				if (!TitleState.unlockedSongs[1])
					halloweenPico.color = FlxColor.BLACK;
			}  else if (randomFloat >= 81.819 && randomFloat <= 90.909){				
				spectrum = new FlxSprite();
				spectrum.frames = Paths.getSparrowAtlas('characters/stik');
				spectrum.animation.addByPrefix('idle', 'stik idle0', 24, true, true);
				spectrum.animation.play('idle');
				spectrum.x = 1800;
				spectrum.screenCenter(Y);
				curCharacter = spectrum;
				FlxTween.tween(curCharacter, {x: 800}, 0.7, {ease: FlxEase.backOut});
				spectrum.cameras = [camMain];
				if (TitleState.unlockedSongs[2])
					spectrum.color = FlxColor.BLACK;
			}  else if (randomFloat >= 90.910 && randomFloat <= 99.999){			
				breakdownBF = new FlxSprite();
				breakdownBF.frames = Paths.getSparrowAtlas('characters/bfbreakingdown');
				breakdownBF.animation.addByPrefix('idle', 'bfbreakingdown idle0', 24, true);
				breakdownBF.animation.play('idle');
				breakdownBF.x = 1800;
				breakdownBF.screenCenter(Y);
				curCharacter = breakdownBF;
				FlxTween.tween(curCharacter, {x: 650}, 0.7, {ease: FlxEase.backOut});
				breakdownBF.cameras = [camMain];
				if (!TitleState.unlockedSongs[3])
					breakdownBF.color = FlxColor.BLACK;
			}
				curCharacter.antialiasing = ClientPrefs.globalAntialiasing;
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "A Funkin' Disaster " + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		
			main_menu_characters.callback = function()
				{
					FlxG.save.data.main_menu_characters = main_menu_characters.checked;
					mmCheck = FlxG.save.data.main_menu_characters;
		};	

		if (mmCheck && curCharacter != null){
			add(curCharacter);
			//if (curCharacter == breakdownBF){
			//	FlxTween.tween(breakdownBF, {x: 650}, 0.7, {ease: FlxEase.quadOut});
			//}
		} else {
			remove(curCharacter);
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (ClientPrefs.middleMouseScroll){
			if(FlxG.mouse.wheel != 0)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					changeItem(-FlxG.mouse.wheel);
				}
			}

			if (controls.BACK)
			{
				selectedSomethin = true;

				if (mmCheck && curCharacter != null)
					FlxTween.tween(curCharacter, {x: 1800}, 0.7, {ease: FlxEase.backIn});
					remove(black);
					main_menu_characters.visible = false;

				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.mouse.visible = false;
				FlxG.mouse.enabled = false;

				if (mmCheck && curCharacter != null && optionShit[curSelected] != 'donate')
				FlxTween.tween(curCharacter, {x: 1800}, 0.7, {ease: FlxEase.backIn});
				main_menu_characters.visible = false;
				remove(black);

				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new legacy.LegacyStoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new legacy.LegacyFreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'new_engine':
										ClientPrefs.legacyEngine = false;
										FlxG.save.data.legacyEngine = ClientPrefs.legacyEngine;
										MusicBeatState.switchState(new MainMenuState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
										// The Reason why the Options State loadings through "LoadingState" is because sprites such as "NOTE_Assets" will only load through it and will crash the game if other mean is used. - luci
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;

				if (mmCheck && curCharacter != null)
					FlxTween.tween(curCharacter, {x: 1800}, 0.7, {ease: FlxEase.backIn});
					main_menu_characters.visible = false;
					remove(black);

				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
		//	spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}

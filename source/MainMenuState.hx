package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import options.OptionsState;
import legacy.LegacyMainMenuState;

#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	//var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	private var camMain:FlxCamera;

	var midSeparator:FlxSprite;
	var storyIcon:FlxSprite = new FlxSprite();
	var freeplayIcon:FlxSprite = new FlxSprite();
	var settingsIcon:FlxSprite = new FlxSprite();
	var gearsIcon:FlxSprite = new FlxSprite();
	var graveModeIcon:FlxSprite = new FlxSprite();
	var ghostModeIcon:FlxSprite = new FlxSprite();
	var howToPlay:FlxSprite = new FlxSprite();
	var legacyEngine:FlxSprite = new FlxSprite();
	var skull1:FlxSprite;
	var skull2:FlxSprite;

	//public static var addCursorOption:Bool = false;
	//public static var addCreditsRollOption:Bool = false;

	public static var coolModesEnabled:Bool = false;

	var loadOut:GateTransition;
	var loadIn:GateTransition;
	
	/*var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		#if !switch 'donate', #end
		'options'
	];*/

	//var magenta:FlxSprite;
	//var camFollow:FlxObject;
	//var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	override function create()
	{
		FlxG.mouse.visible = true;
		FlxG.mouse.enabled = true;

		if (ClientPrefs.transitionStyle){
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
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null, 'iconog');
		Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - In Main Menu";
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;
		camMain = new FlxCamera();
		camMain.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxG.cameras.add(camMain);
		FlxCamera.defaultCameras = [camGame];

		if (ClientPrefs.transitionStyle){
			loadIn.cameras = [camMain];
			loadOut.cameras = [camMain];
			}

		if (!ClientPrefs.isMotionSick){
		camGame.zoom = 0.8;

		FlxTween.tween(camGame, {zoom: 1}, 1, {
			ease: FlxEase.quadInOut,
		});
		}

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		coolModesEnabled = FlxG.save.data.coolModesEnabled;

		//var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainBG'));
		//bg.scrollFactor.set(0, yScroll);
		//bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		midSeparator = new FlxSprite().loadGraphic(Paths.image('mainmenu/midSeparator'));
		//midSeparator.scrollFactor.set(0, yScroll);
		midSeparator.setGraphicSize(Std.int(midSeparator.width + 312));
		midSeparator.updateHitbox();
		midSeparator.screenCenter();
		midSeparator.y += 50;
		midSeparator.antialiasing = ClientPrefs.globalAntialiasing;
		add(midSeparator);

		FlxTween.tween(midSeparator, {width: -290}, 1, {
			ease: FlxEase.quadInOut,
		});

		storyIcon = new FlxSprite().loadGraphic(Paths.image('mainmenu/story_mode'));
		//storyIcon.scrollFactor.set(0, yScroll);
		storyIcon.updateHitbox();
		storyIcon.screenCenter();
		storyIcon.y = 240;
		storyIcon.antialiasing = ClientPrefs.globalAntialiasing;
		add(storyIcon);

		//FlxTween.tween(storyIcon, {angle: 360}, 1.2, {ease: FlxEase.expoInOut});

		freeplayIcon = new FlxSprite().loadGraphic(Paths.image('mainmenu/freeplay'));
		//freeplayIcon.scrollFactor.set(0, yScroll);
		freeplayIcon.updateHitbox();
		freeplayIcon.screenCenter();
		freeplayIcon.x = 910;
		freeplayIcon.y = 248;
		freeplayIcon.antialiasing = ClientPrefs.globalAntialiasing;
		add(freeplayIcon);

		//FlxTween.tween(freeplayIcon, {angle: 360}, 1.2, {ease: FlxEase.expoInOut});

		settingsIcon = new FlxSprite().loadGraphic(Paths.image('mainmenu/settings'));
		//settingsIcon.scrollFactor.set(0, yScroll);
		settingsIcon.updateHitbox();
		settingsIcon.screenCenter();
		settingsIcon.x = 142;
		settingsIcon.y = 110;
		settingsIcon.antialiasing = ClientPrefs.globalAntialiasing;
		add(settingsIcon);

		//FlxTween.tween(settingsIcon, {angle: 360}, 1.2, {ease: FlxEase.expoInOut});

		gearsIcon = new FlxSprite().loadGraphic(Paths.image('mainmenu/gears'));
		//gearsIcon.scrollFactor.set(0, yScroll);
		gearsIcon.updateHitbox();
		gearsIcon.screenCenter();
		gearsIcon.x = 160;
		gearsIcon.y = 450;
		gearsIcon.antialiasing = ClientPrefs.globalAntialiasing;
		add(gearsIcon);

		//FlxTween.tween(gearsIcon, {angle: 360}, 1.2, {ease: FlxEase.expoInOut});

		graveModeIcon = new FlxSprite().loadGraphic(Paths.image('mainmenu/graveMode'));
		//graveModeIcon.scrollFactor.set(0, yScroll);
		graveModeIcon.updateHitbox();
		graveModeIcon.screenCenter();
		graveModeIcon.x += 15;
		graveModeIcon.y = 450;
		graveModeIcon.antialiasing = ClientPrefs.globalAntialiasing;
		add(graveModeIcon);

		//FlxTween.tween(graveModeIcon, {angle: 360}, 1.2, {ease: FlxEase.expoInOut});

		ghostModeIcon = new FlxSprite().loadGraphic(Paths.image('mainmenu/ghostMode'));
		//ghostModeIcon.scrollFactor.set(0, yScroll);
		ghostModeIcon.updateHitbox();
		ghostModeIcon.screenCenter();
		ghostModeIcon.x = 960;
		ghostModeIcon.y = 450;
		ghostModeIcon.antialiasing = ClientPrefs.globalAntialiasing;
		add(ghostModeIcon);

		if (!coolModesEnabled){
			graveModeIcon.color = FlxColor.BLACK;
			ghostModeIcon.color = FlxColor.BLACK;
		} else {
			graveModeIcon.color = FlxColor.WHITE;
			ghostModeIcon.color = FlxColor.WHITE;	
		}

		//FlxTween.tween(ghostModeIcon, {angle: 360}, 1.2, {ease: FlxEase.expoInOut});

		howToPlay = new FlxSprite().loadGraphic(Paths.image('mainmenu/howtoplay'));
		howToPlay.updateHitbox();
		howToPlay.screenCenter();
		//howToPlay.scale.x = 0.3;
		//howToPlay.scale.y = 0.3;
		howToPlay.x = 1025;
		howToPlay.y = 5;
		howToPlay.antialiasing = ClientPrefs.globalAntialiasing;
		add(howToPlay);

		skull1 = new FlxSprite().loadGraphic(Paths.image('mainmenu/skull1'));
		//skull1.scrollFactor.set(0, yScroll);
		skull1.updateHitbox();
		skull1.screenCenter();
		skull1.y = 38;
		skull1.antialiasing = ClientPrefs.globalAntialiasing;
		add(skull1);

		//FlxTween.tween(skull1, {angle: 360}, 1.2, {ease: FlxEase.expoInOut});

		skull2 = new FlxSprite().loadGraphic(Paths.image('mainmenu/skull2'));
		//skull2.scrollFactor.set(0, yScroll);
		skull2.updateHitbox();
		skull2.screenCenter();
		skull2.x = 1000;
		skull2.y = 132;
		skull2.antialiasing = ClientPrefs.globalAntialiasing;
		add(skull2);

		if (FlxG.save.data.finishedMainStory == true){
		legacyEngine = new FlxSprite().loadGraphic(Paths.image('mainmenu/legacyEngine')); //Had to make the sprite on my own since I couldn't get in contact with Yeetzer for nearly a month, but it turned out good after all - luci
		legacyEngine.updateHitbox();
		legacyEngine.screenCenter();
		legacyEngine.x = 3;
		legacyEngine.y = 3;
		legacyEngine.antialiasing = ClientPrefs.globalAntialiasing;
		add(legacyEngine);
		}

		//menuItems = new FlxTypedGroup<FlxSprite>();
		//add(menuItems);

		var scale:Float = 1;

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin': A Funkin Disaster v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		//changeItem();

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

		if (ClientPrefs.transitionStyle){
		loadIn.animation.play('GateTransition');
		add(loadIn);
		add(loadOut);
		}

		super.create();
		FlxG.sound.music.volume = 1;
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

		if (!selectedSomethin)
		{
			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				if (ClientPrefs.transitionStyle){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					deleteLoadIn('');
					new FlxTimer().start(1, function(tmr:FlxTimer){
				MusicBeatState.switchState(new TitleState());
				});
			} else {
				MusicBeatState.switchState(new TitleState());
			}
		}
		if (FlxG.keys.pressed.G && FlxG.keys.pressed.A && FlxG.keys.justPressed.Y){
			Sys.command("start mods/music/gaysong.mp3");
		}
				if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(storyIcon))
					{
							selectedSomethin = true;
							storyIcon.alpha = 0.8;
							storyIcon.scale.x = 0.9;
							storyIcon.scale.y = 0.9;
							FlxG.sound.play(Paths.sound('confirmMenu'));
							FlxG.mouse.visible = false;
							FlxG.mouse.enabled = false;
							if (ClientPrefs.transitionStyle){
							new FlxTimer().start(1, function(tmr:FlxTimer){
							loadOut.alpha = 1;
							loadOut.animation.play('GateTransition');
							deleteLoadIn('');
							});
							new FlxTimer().start(2, function(tmr:FlxTimer){
							MusicBeatState.switchState(new StoryMenuState());
					});
					} else {
						new FlxTimer().start(1, function(tmr:FlxTimer){
							MusicBeatState.switchState(new StoryMenuState());
					});
					}
					} else if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(freeplayIcon)){
							selectedSomethin = true;
							freeplayIcon.alpha = 0.8;
							freeplayIcon.scale.x = 0.9;
							freeplayIcon.scale.y = 0.9;
							FlxG.sound.play(Paths.sound('confirmMenu'));
							FlxG.mouse.visible = false;
							FlxG.mouse.enabled = false;
							if (ClientPrefs.transitionStyle){
							new FlxTimer().start(1, function(tmr:FlxTimer){
								loadOut.alpha = 1;
								loadOut.animation.play('GateTransition');
								deleteLoadIn('');
								});
							new FlxTimer().start(2, function(tmr:FlxTimer){
							MusicBeatState.switchState(new FreeplayState());
					});
					} else {
						new FlxTimer().start(1, function(tmr:FlxTimer){
							MusicBeatState.switchState(new FreeplayState());
					});
					}
					} else if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(settingsIcon)){
							selectedSomethin = true;
							settingsIcon.alpha = 0.8;
							settingsIcon.scale.x = 0.9;
							settingsIcon.scale.y = 0.9;
							FlxG.sound.play(Paths.sound('confirmMenu'));
							FlxG.mouse.visible = false;
							FlxG.mouse.enabled = false;
							if (ClientPrefs.transitionStyle){
							new FlxTimer().start(1, function(tmr:FlxTimer){
								loadOut.alpha = 1;
								loadOut.animation.play('GateTransition');
								deleteLoadIn('');
								});
							new FlxTimer().start(2, function(tmr:FlxTimer){
							LoadingState.loadAndSwitchState(new options.OptionsState());
					});
					} else {
						new FlxTimer().start(1, function(tmr:FlxTimer){
							LoadingState.loadAndSwitchState(new options.OptionsState());
					});
					}
					} else if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(gearsIcon)){
						selectedSomethin = true;
						gearsIcon.alpha = 0.8;
						gearsIcon.scale.x = 0.9;
						gearsIcon.scale.y = 0.9;
						FlxG.sound.play(Paths.sound('confirmMenu'));
						FlxG.mouse.visible = false;
						FlxG.mouse.enabled = false;
						if (ClientPrefs.transitionStyle){
						new FlxTimer().start(1, function(tmr:FlxTimer){
							loadOut.alpha = 1;
							loadOut.animation.play('GateTransition');
							deleteLoadIn('');
							});
						new FlxTimer().start(2, function(tmr:FlxTimer){
						MusicBeatState.switchState(new SteelWheelState());
				});
				} else {
					new FlxTimer().start(1, function(tmr:FlxTimer){
						MusicBeatState.switchState(new SteelWheelState());
				});
				}
				}  else if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(graveModeIcon)){
					if (coolModesEnabled){
					selectedSomethin = true;
					graveModeIcon.alpha = 0.8;
					graveModeIcon.scale.x = 0.9;
					graveModeIcon.scale.y = 0.9;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxG.mouse.visible = false;
					FlxG.mouse.enabled = false;
					if (ClientPrefs.transitionStyle){
					new FlxTimer().start(1, function(tmr:FlxTimer){
					FlxTransitionableState.skipNextTransIn = false;
					FlxTransitionableState.skipNextTransOut = false;
					//	loadOut.alpha = 1;
					//	loadOut.animation.play('GateTransition');
					//	deleteLoadIn('');
					//	});
					//new FlxTimer().start(2, function(tmr:FlxTimer){
					openSubState(new GraveModeSubState());
			});
			} else {
				new FlxTimer().start(1, function(tmr:FlxTimer){
					openSubState(new GraveModeSubState());
			});
			}
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}
			}  else if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(ghostModeIcon)){
				if (coolModesEnabled){
					selectedSomethin = true;
					ghostModeIcon.alpha = 0.8;
					ghostModeIcon.scale.x = 0.9;
					ghostModeIcon.scale.y = 0.9;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxG.mouse.visible = false;
					FlxG.mouse.enabled = false;
					if (ClientPrefs.transitionStyle){
					new FlxTimer().start(1, function(tmr:FlxTimer){						
					FlxTransitionableState.skipNextTransIn = false;
					FlxTransitionableState.skipNextTransOut = false;
					//	loadOut.alpha = 1;
					//	loadOut.animation.play('GateTransition');
					//	deleteLoadIn('');
					//	});
					//new FlxTimer().start(2, function(tmr:FlxTimer){
					openSubState(new GhostModeSubState());
					});
				} else {
					new FlxTimer().start(1, function(tmr:FlxTimer){
						openSubState(new GhostModeSubState());
				});
				}
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}
			}  else if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(howToPlay)){
					selectedSomethin = true;
					howToPlay.alpha = 0.8;
					howToPlay.scale.x = 0.9;
					howToPlay.scale.y = 0.9;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxG.mouse.visible = false;
					FlxG.mouse.enabled = false;
					if (ClientPrefs.transitionStyle){
					new FlxTimer().start(1, function(tmr:FlxTimer){
						loadOut.alpha = 1;
						loadOut.animation.play('GateTransition');
						deleteLoadIn('');
						});
					new FlxTimer().start(2, function(tmr:FlxTimer){
					MusicBeatState.switchState(new HowToPlayState());
					});
				} else {
					new FlxTimer().start(1, function(tmr:FlxTimer){
						MusicBeatState.switchState(new HowToPlayState());
					});
				}
			} else if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(legacyEngine) && FlxG.save.data.finishedMainStory == true){
				selectedSomethin = true;
				ClientPrefs.legacyEngine = true;
				FlxG.save.data.legacyEngine = ClientPrefs.legacyEngine;
				if(ClientPrefs.flashing) FlxFlicker.flicker(legacyEngine, 1.1, 0.15, false);
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxG.mouse.visible = false;
				FlxG.mouse.enabled = false;
				if (ClientPrefs.transitionStyle){
				new FlxTimer().start(1, function(tmr:FlxTimer){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					deleteLoadIn('');
					});
				new FlxTimer().start(2, function(tmr:FlxTimer){
				MusicBeatState.switchState(new legacy.LegacyMainMenuState());
				});
			} else {
				new FlxTimer().start(1, function(tmr:FlxTimer){
					MusicBeatState.switchState(new legacy.LegacyMainMenuState());
				});
			}
		}
							//});
						//}
					//});
			#if desktop
			if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				if (ClientPrefs.transitionStyle){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
				new FlxTimer().start(2, function(tmr:FlxTimer){
					MusicBeatState.switchState(new MasterEditorMenu());
				});
			} else {
			MusicBeatState.switchState(new MasterEditorMenu());
			}
			}
			#end
		}

		super.update(elapsed);

	/*	menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
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
				spr.animation.play('light');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});*/
	}
	function deleteLoadIn(string:String){
		loadIn.kill();
		}
}

package options;

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
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import lime.app.Application;
import Controls;

using StringTools;

class OptionsState extends MusicBeatState
{
	public static var options:Array<String> = ['Note Colors', 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay', 'Awards', 'Credits'];
	public static var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	public static var loadedFromOptionsMenu:Bool;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				/*if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
					openSubState(new options.NotesSubState());
				});
				} else {*/
				MusicBeatState.switchState(new options.NotesSubState());
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				//}
			case 'Controls':
				/*if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
					openSubState(new options.ControlsSubState());
				});
				} else {*/
				//openSubState(new options.ControlsSubState());
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				LoadingState.loadAndSwitchState(new options.ControlsSubState());
				//}
			case 'Graphics':
				/*if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
					openSubState(new options.GraphicsSettingsSubState());
				});
				} else {*/
				openSubState(new options.GraphicsSettingsSubState());
				//}
			case 'Visuals and UI':
				/*if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
						openSubState(new options.VisualsUISubState());
				});
				} else {*/
				openSubState(new options.VisualsUISubState());
				//}
			case 'Gameplay':
				/*if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
					openSubState(new options.GameplaySettingsSubState());
				});
				} else {*/
				openSubState(new options.GameplaySettingsSubState());
				//}
			case 'Adjust Delay and Combo':
				if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
					LoadingState.loadAndSwitchState(new options.NoteOffsetState());
				});
				} else {
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
				}
				FlxG.save.data.inNoteOffest = false;
			case 'Awards':
			/*	if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
						LoadingState.loadAndSwitchState(new AchievementsMenuState());
				});
				} else {*/
				LoadingState.loadAndSwitchState(new AchievementsMenuState());
				//}
			case 'Credits':
				/*if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
						LoadingState.loadAndSwitchState(new CreditsState());
				});
				} else {*/
				LoadingState.loadAndSwitchState(new CreditsState());
				//}
			case 'Screen Pack':
				/*if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
						FlxG.switchState(new options.ScreenPackSubState());
				});
				} else {*/
				FlxG.switchState(new options.ScreenPackSubState());
				//}
			case 'Credits Roll':
				loadedFromOptionsMenu = true;
				if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
						LoadingState.loadAndSwitchState(new CreditsRollState());
				});
				} else {
				LoadingState.loadAndSwitchState(new CreditsRollState());
				}
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	var loadOut:GateTransition;
	var loadIn:GateTransition;

	override function create() {
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
		Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - In Options";
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - In Options Menu";
		#end

		FlxG.mouse.enabled = true;

		var bg:FlxSprite = new FlxSprite();

		if (FlxG.save.data.cursorSprite == 4){
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesats/menuAverage'));
		} else {
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesats/menuDesat'));
		}
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true, false);
			optionText.screenCenter();
			optionText.y += (70 * (i - (options.length / 2))) + 50;
			optionText.scale.x = 0.9;
			optionText.scale.y = 0.9;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true, false);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true, false);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
			loadIn.animation.play('GateTransition');
			add(loadIn);
			add(loadOut);
			}

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
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
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-FlxG.mouse.wheel);
			}
		}

		if (controls.BACK) {
			if (!ClientPrefs.legacyEngine){
				if (ClientPrefs.transitionStyle){
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					loadOut = new GateTransition(0,0,'out');
					add(loadOut);
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
					MusicBeatState.switchState(new MainMenuState());
				});
				} else {
					MusicBeatState.switchState(new MainMenuState());
				}
			} else {
				MusicBeatState.switchState(new legacy.LegacyMainMenuState());
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
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
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}
package editors;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import lime.app.Application;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class MasterEditorMenu extends MusicBeatState
{
	var options:Array<String> = [
		'Week Editor',
		'Menu Character Editor',
		'Dialogue Editor',
		'Dialogue Portrait Editor',
		'Character Editor',
		'Chart Editor'
	];
	private var grpTexts:FlxTypedGroup<Alphabet>;
	private var directories:Array<String> = [null];

	private var curSelected = 0;
	private var curDirectory = 0;
	private var directoryTxt:FlxText;

	var loadOut:GateTransition;
	var loadIn:GateTransition;

	override function create()
	{
		FlxG.camera.bgColor = FlxColor.BLACK;
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Editors Main Menu", null);
		Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - Editors Main Menu";
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

		var bg:FlxSprite = new FlxSprite();
		if (FlxG.save.data.cursorSprite == 4){
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesats/menuAverage'));
		} else {
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesats/menuDesat'));
		}
		bg.scrollFactor.set();
		bg.color = 0xFF353535;
		add(bg);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var leText:Alphabet = new Alphabet(0, (70 * i) + 30, options[i], true, false);
			leText.isMenuItem = true;
			leText.targetY = i;
			grpTexts.add(leText);
		}
		
		#if MODS_ALLOWED
		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 42).makeGraphic(FlxG.width, 42, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		directoryTxt = new FlxText(textBG.x, textBG.y + 4, FlxG.width, '', 32);
		directoryTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		directoryTxt.scrollFactor.set();
		add(directoryTxt);
		
		for (folder in Paths.getModDirectories())
		{
			directories.push(folder);
		}

		var found:Int = directories.indexOf(Paths.currentModDirectory);
		if(found > -1) curDirectory = found;
		changeDirectory();
		#end
		changeSelection();

		if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
			loadIn.animation.play('GateTransition');
			add(loadIn);
			add(loadOut);
			}

		FlxG.mouse.visible = false;
		FlxG.mouse.enabled = true;
		super.create();
	}

	override function update(elapsed:Float)
	{

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}
		#if MODS_ALLOWED
		if(controls.UI_LEFT_P)
		{
			changeDirectory(-1);
		}
		if(controls.UI_RIGHT_P)
		{
			changeDirectory(1);
		}
		#end

		if(FlxG.mouse.wheel != 0)
		{
			changeSelection(-shiftMult * FlxG.mouse.wheel);
		}

		if (controls.BACK)
		{
			if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
				new FlxTimer().start(2, function(tmr:FlxTimer){
					if (!ClientPrefs.legacyEngine){
				
						MusicBeatState.switchState(new MainMenuState());
					} else {
						MusicBeatState.switchState(new legacy.LegacyMainMenuState());
					}
				});
			} else {
				if (!ClientPrefs.legacyEngine){
				
					MusicBeatState.switchState(new MainMenuState());
				} else {
					MusicBeatState.switchState(new legacy.LegacyMainMenuState());
				}
		}
	}

		if (controls.ACCEPT)
		{
			switch(options[curSelected]) {
				case 'Character Editor':
					if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
							loadOut.alpha = 1;
							loadOut.animation.play('GateTransition');
						new FlxTimer().start(2, function(tmr:FlxTimer){
						LoadingState.loadAndSwitchState(new CharacterEditorState(Character.DEFAULT_CHARACTER, false));
						});
					} else {
					LoadingState.loadAndSwitchState(new CharacterEditorState(Character.DEFAULT_CHARACTER, false));
					}
				case 'Week Editor':
					if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
						if(!ClientPrefs.legacyEngine){
						WeekEditorState.loadedFromLegacy = true;
						} else {
						WeekEditorState.loadedFromLegacy = false;
						}
							loadOut.alpha = 1;
							loadOut.animation.play('GateTransition');
						new FlxTimer().start(2, function(tmr:FlxTimer){
						LoadingState.loadAndSwitchState(new WeekEditorState());
						});
					} else {
						LoadingState.loadAndSwitchState(new WeekEditorState());
					}
				case 'Menu Character Editor':
					if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
							loadOut.alpha = 1;
							loadOut.animation.play('GateTransition');
						new FlxTimer().start(2, function(tmr:FlxTimer){
							LoadingState.loadAndSwitchState(new MenuCharacterEditorState());
						});
					} else {
						LoadingState.loadAndSwitchState(new MenuCharacterEditorState());
					}
				case 'Dialogue Portrait Editor':
					if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
							loadOut.alpha = 1;
							loadOut.animation.play('GateTransition');
						new FlxTimer().start(2, function(tmr:FlxTimer){
						LoadingState.loadAndSwitchState(new DialogueCharacterEditorState(), false);
						});
					} else {
					LoadingState.loadAndSwitchState(new DialogueCharacterEditorState(), false);
					}
				case 'Dialogue Editor':
					if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
							loadOut.alpha = 1;
							loadOut.animation.play('GateTransition');
						new FlxTimer().start(2, function(tmr:FlxTimer){
							LoadingState.loadAndSwitchState(new DialogueEditorState(), false);
						});
					} else {
					LoadingState.loadAndSwitchState(new DialogueEditorState(), false);
					}
				case 'Chart Editor'://felt it would be cool maybe
				if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
						loadOut.alpha = 1;
						loadOut.animation.play('GateTransition');
					new FlxTimer().start(2, function(tmr:FlxTimer){
						LoadingState.loadAndSwitchState(new ChartingState(), false);
					});
				} else {
					LoadingState.loadAndSwitchState(new ChartingState(), false);
				}
					PlayState.chartingMode = true;
			}

			FlxG.sound.music.volume = 0;
			#if PRELOAD_ALL
			FreeplayState.destroyFreeplayVocals();
			#end
		}
		
		var bullShit:Int = 0;
		for (item in grpTexts.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if (playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;
	}

	#if MODS_ALLOWED
	function changeDirectory(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curDirectory += change;

		if(curDirectory < 0)
			curDirectory = directories.length - 1;
		if(curDirectory >= directories.length)
			curDirectory = 0;
	
		WeekData.setDirectoryFromWeek();
		if(directories[curDirectory] == null || directories[curDirectory].length < 1)
			directoryTxt.text = '< No Mod Directory Loaded >';
		else
		{
			Paths.currentModDirectory = directories[curDirectory];
			directoryTxt.text = '< Loaded Mod Directory: ' + Paths.currentModDirectory + ' >';
		}
		directoryTxt.text = directoryTxt.text.toUpperCase();
	}
	#end
}
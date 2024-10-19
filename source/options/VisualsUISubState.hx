package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
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
import Controls;

using StringTools;

class VisualsUISubState extends BaseOptionsMenu
{
	var menuMusicList:Array<String>;
	var menuMmusicOptionList:Array<String> = [];

	public function new()
	{
		menuMusicList = sys.FileSystem.readDirectory('assets/music/mainMenu');
		for(i in 0...menuMusicList.length)
			{
				menuMmusicOptionList.push(menuMusicList[i].substring(0, menuMusicList[i].length - 4));
			}
			
		title = 'Visuals and UI - FD Edition';
		rpcTitle = 'Visuals & UI Settings Menu - FD Edition'; //for Discord Rich Presence

		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			'string',
			'Time Left',
			['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Transation Style',
			"If unchecked, the old transations will be used.",
			'transitionStyle',
			'bool',
			true);
		addOption(option);

		/*var option:Option = new Option('Engine Style',
			"If unchecked, the engine style will change to the legacy version style.",
			'legacyEngine',
			'bool',
			true);
		addOption(option);*/

		//Used as a temporary mean to change between the two and is no longer needed - luci

		var option:Option = new Option('Motion Sick',
			"If checked, Most of the engine tweens will get disabled.",
			'isMotionSick',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Score Text Zoom on Hit',
			"If unchecked, disables the Score text zooming\neverytime you hit a note.",
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		#if !mobile
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeFPSCounter;
		#end
		
		var option:Option = new Option('Pause Screen Song:',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			'string',
			'Tea Time',
			['None', 'Breakfast', 'Tea Time']);
		addOption(option);
		option.onChange = onChangePauseMusic;

		var option:Option = new Option('Menu Music:',
			"Which Song Do you Want To Play For The Main Menu?",
			'mainMenuMusic',
			'string',
			'freakyMenu(new)',
		menuMmusicOptionList);
		addOption(option);
		option.onChange = onChangeMainMenuMusic;

		#if !mobile
		var option:Option = new Option('Middle Mouse Scroll',
			"Uncheck this to disable middle mouse scrolling.",
			'middleMouseScroll',
			'bool',
		 	true);
		addOption(option);

		var option:Option = new Option('Privacy Mode',
		"Check this to hide your PC name from the title screen.",
		'privacyMode',
		'bool',
		 false);
	addOption(option);

	/*	var option:Option = new Option('Mouse Overlap Scroll',
			"Check this to Enable mouse overlap scrolling.",
			'mouseOverlapScroll',
			'bool',
			 false);
		addOption(option);*/
		#end

		/*var option:Option = new Option('New Countdown Style',
			"Uncheck this to change back to the old counter style.",
			'coolCounter',
			'bool',
			 true);
		addOption(option);*/
		
		#if CHECK_FOR_UPDATES
		var option:Option = new Option('Check for Updates',
			'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates',
			'bool',
			true);
		addOption(option);
		#end

		super();
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}

	function onChangeMainMenuMusic()
		{
			FlxG.sound.playMusic(Paths.music('/mainMenu/' + ClientPrefs.mainMenuMusic));
				changedMusic = true;
		}

	override function destroy()
	{
		if(changedMusic)
			{
				FlxG.sound.playMusic(Paths.music('/mainMenu/' + ClientPrefs.mainMenuMusic));
		super.destroy();
			}
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
	#end
}
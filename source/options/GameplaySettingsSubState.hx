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

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Gameplay Settings - FD Version';
		rpcTitle = 'Gameplay Settings Menu - FD Version'; //for Discord Rich Presence

		var option:Option = new Option('Health Bar Direction',
			'Check this to have the Health bar direction go from down to up. ',
			'hbDirection',
			'string',
			'Bottom-Side',
			['Bottom-Side', 'Left-Side', 'Right-Side']); // I might make it so the players can freely offset the health bar as desired - luci
		addOption(option);

		/*var option:Option = new Option('Health Bar Side',
			'Check this if you want the health bar to be on the left side. ',
			'hbSide',
			'bool',
			false);
		addOption(option);*/

		var option:Option = new Option('Gradient Health Bar',
			'Checking this will change your health bar style to be gradient.',
			'gradientHealthBar',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Gradient HB Color',
			'This will change the saturation of the gradient',
			'gradientHBColor',
			'int',
			-100);
		addOption(option);
		option.minValue = -225;
		option.maxValue = 225;

		var option:Option = new Option('Gradient HB Chunk Size',
			'This will change how smooth the gradient is, 1 is smooth',
			'gradientHBChunkSize',
			'int',
			1);
		addOption(option);
		option.minValue = 1;

		var option:Option = new Option('Gradient HB Rotation',
			'Changes the angle of the gradient, 90 degress is top to bottom, 180 is left to right',
			'gradientHBRotation',
			'int',
			180);
		addOption(option);
		option.minValue = 0;
		option.maxValue = 360;

		var option:Option = new Option('Gradient HB Border',
			'Adds a 1 pixel solid border to the health bar',
			'gradientHBBorder',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Gradient HB Border Color: ',
			'This will change the color of the border.',
			'gradientHBBorderColor',
			'string',
			'White',
			['White', 'Gray', 'Black', 'Green', 'Lime', 'Yellow', 'Orange', 'Red', 'Purple', 'Blue', 'Brown', 'Pink', 'Magenta', 'Cyan']);
		addOption(option);
		
		var option:Option = new Option('Time Bar Color: ',
	   		 'Changes The Color Of The Time Bar.To The Selected Character.',
	    	 'timeBarColor',
			 'string',
	    	 'Default',
	    	['Default', 'BF', 'GF', 'Opponent']);
  	    addOption(option);

		var option:Option = new Option('Controller Mode',
			'Check this if you want to play with\na controller instead of using your Keyboard.',
			'controllerMode',
			'bool',
			false);
		addOption(option);

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'If checked, notes go Down instead of Up, simple enough.', //Description
			'downScroll', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'If checked, your notes get centered.',
			'middleScroll',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Opponent Notes',
			'If unchecked, opponent notes get hidden.',
			'opponentStrums',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.",
			'ghostTapping',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Disable Reset Button',
			"If checked, pressing Reset won't do anything.",
			'noReset',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Hitsound Volume',
			'Funny notes does \"Tick!\" when you hit them."',
			'hitsoundVolume',
			'percent',
			0);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Rating Offset',
			'Changes how late/early you have to hit for a "Sick!"\nHigher values mean you have to hit later.',
			'ratingOffset',
			'int',
			0);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option('Sick! Hit Window',
			'Changes the amount of time you have\nfor hitting a "Sick!" in milliseconds.',
			'sickWindow',
			'int',
			45);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option('Good Hit Window',
			'Changes the amount of time you have\nfor hitting a "Good" in milliseconds.',
			'goodWindow',
			'int',
			90);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option('Bad Hit Window',
			'Changes the amount of time you have\nfor hitting a "Bad" in milliseconds.',
			'badWindow',
			'int',
			135);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option('Safe Frames',
			'Changes how many frames you have for\nhitting a note earlier or late.',
			'safeFrames',
			'float',
			10);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super();
	}

	function onChangeHitsoundVolume()
	{
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
	}
}
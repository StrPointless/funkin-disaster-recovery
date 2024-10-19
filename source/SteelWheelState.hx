package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import Controls;

using StringTools;

class SteelWheelState extends MusicBeatState
{
	var easterEggKeys:Array<String> = [
		'demonsdance', 'halloweenparty', 'password', 'darknessmyoldfriend', 'ilikecheating', 'ledumbidea', 'shades','gachalife', 'sonicdotexe', 'danganronpa', 'redalert', 'giygasXXX'
	];
	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var passwordBuffer:String = '';
	var bufferPrinter:FlxText;
	var bufferPrinterBG:FlxText;

	var menuText:FlxText;
	var menuTextBG:FlxText;

	override function create()
		{

			#if desktop
			DiscordClient.changePresence('In the Gears menu', null, 'iconog');
			Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - In Steel Wheel";
			#end

		super.create();

		WeekData.reloadWeekFiles(true);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesats/menuDesat'));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		menuTextBG = new FlxText(0, 0, FlxG.width,
			"Enter a secret code to unlock a secret song buddy!\nOr...unlock other secrets.",
			32);
		menuTextBG.setFormat("VCR OSD Mono", 32, FlxColor.BLACK, CENTER);
		menuTextBG.screenCenter();
		menuTextBG.x += 3;
		menuTextBG.y += 3;
		add(menuTextBG);

		menuText = new FlxText(0, 0, FlxG.width,
			"Enter a secret code to unlock a secret song buddy!\nOr...unlock other secrets.",
			32);
		menuText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		menuText.screenCenter();
		add(menuText);

		bufferPrinter = new FlxText(500, 400, FlxG.width);
		bufferPrinter.scrollFactor.set();
		bufferPrinter.setFormat(Paths.font("vcr.ttf"), 50);
		bufferPrinter.updateHitbox();
		bufferPrinter.alignment = CENTER;
		bufferPrinter.screenCenter(X);
		//trace(bufferPrinter.y);
		//bufferPrinter.visible = false;

		bufferPrinterBG = new FlxText(500, 400, FlxG.width);
		bufferPrinterBG.scrollFactor.set();
		bufferPrinterBG.setFormat(Paths.font("vcr.ttf"), 50);
		bufferPrinterBG.updateHitbox();
		bufferPrinterBG.alignment = CENTER;
		bufferPrinterBG.screenCenter(X);
		bufferPrinterBG.x = bufferPrinter.x + 2;
		bufferPrinterBG.y = bufferPrinter.y + 2;
		bufferPrinterBG.color = 0xFF000000;
		//trace(bufferPrinter.y);
		//bufferPrinterBG.visible = false;
		add(bufferPrinterBG);

		add(bufferPrinter);
		}
	
		override function update(elapsed:Float)
		{

				if (FlxG.keys.firstJustPressed() != FlxKey.NONE)
				{
					var selectedSong:String = '';
					var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
					var keyName:String = Std.string(keyPressed);
					if(allowedKeys.contains(keyName)) {
						passwordBuffer += keyName;
						if(passwordBuffer.length >= 32) passwordBuffer = passwordBuffer.substring(1);
						trace('Keys test: ' + passwordBuffer);

						bufferPrinter.text = passwordBuffer;
						bufferPrinterBG.text = passwordBuffer;
	
						for (wordRaw in easterEggKeys)
						{
							var word:String = wordRaw.toUpperCase(); //just for being sure you're doing it right

							if (passwordBuffer.length > 26 && passwordBuffer != word) {
								bufferPrinter.text = "WRONG CODE!!!";
								bufferPrinter.visible = true;
								FlxG.sound.play(Paths.sound('incorrect'));
	
								FlxFlicker.flicker(bufferPrinter, 2, 0.1, false, true, function(flk:FlxFlicker) {
									new FlxTimer().start(0.5, function (tmr:FlxTimer) {
	
										new FlxTimer().start(0.25, function(tmr:FlxTimer)
											{
												bufferPrinter.color = FlxColor.RED;
											});
										new FlxTimer().start(0.25, function(tmr:FlxTimer)
											{
												bufferPrinter.color = FlxColor.WHITE;
											});
										});
								});
								passwordBuffer = '';

								} else if (passwordBuffer.contains(word) && wordRaw == 'demonsdance') {

								if (FlxG.save.data.leadHeadedUnlocker == 'demonsdance'){
									FlxG.save.data.leadHeadedUnlocker = '';
								} else {
									FlxG.save.data.leadHeadedUnlocker = 'demonsdance';
								FlxG.save.flush();
								}


								if (ClientPrefs.flashing){
									FlxG.camera.flash(0xFF970000);
									}
	
								FlxG.sound.play(Paths.sound('correct'));

								bufferPrinter.setFormat(Paths.font("Firestarter.ttf"), 32);
								bufferPrinter.color = 0xFF920000;
								bufferPrinter.text = wordRaw;
								//bufferPrinter.visible = true;

								bufferPrinterBG.setFormat(Paths.font("Firestarter.ttf"), 32);
								bufferPrinterBG.color = 0xFF000000;
								bufferPrinterBG.text = wordRaw;
								//bufferPrinterBG.visible = true;
	
								var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
								black.alpha = 0;
								add(black);
	
								FlxTween.tween(black, {alpha: 1}, 1.5, {onComplete:
									function(twn:FlxTween) {
										if (word == "demonsdance")
										if (TitleState.unlockedSongs[0] != true) 
											TitleState.unlockedSongs[0] = true;
											FlxG.save.data.leadHeadedUnlocker = true;
											FlxG.save.flush();
											selectedSong = 'lead-headed';
											trace('Song unlocked:' + selectedSong);		
											Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - Unlocked A Secret Song!";					

									var diffic = CoolUtil.defaultDifficulties[2];
									if (diffic == null) 
										diffic = '';

									PlayState.storyPlaylist = [selectedSong];
					
									PlayState.storyDifficulty = 2;

									PlayState.isGearsSection = true;
					
									PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + "-" + diffic, PlayState.storyPlaylist[0].toLowerCase());
									//PlayState.storyWeek = 1;
									PlayState.campaignScore = 0;
									PlayState.campaignMisses = 0;
					
									new FlxTimer().start(0.25, function(tmr:FlxTimer)
									{
										LoadingState.loadAndSwitchState(new PlayState());
										FlxG.sound.music.volume = 0;
										FreeplayState.destroyFreeplayVocals();
									});
								}
					});


					FlxG.sound.music.fadeOut();
					if(FreeplayState.vocals != null)
					{
						FreeplayState.vocals.fadeOut();
					}
					passwordBuffer = '';
					//selectedSong = '';
					break;
				}  else	if (passwordBuffer.contains(word) && wordRaw == 'halloweenparty') {

					if (FlxG.save.data.maskedMelodyUnlocker == 'halloweenparty'){
						FlxG.save.data.maskedMelodyUnlocker = '';
					} else {
						FlxG.save.data.maskedMelodyUnlocker = 'halloweenparty';
					FlxG.save.flush();
					}

				if (ClientPrefs.flashing){
					FlxG.camera.flash(0xFFFF7E33);
					}

				FlxG.sound.play(Paths.sound('correct'));

				bufferPrinter.setFormat(Paths.font("Abusive Pencil.ttf"), 32);
				bufferPrinter.color = 0xFFFF6600;
				bufferPrinter.text = wordRaw;
				bufferPrinter.visible = true;

				bufferPrinterBG.setFormat(Paths.font("Abusive Pencil.ttf"), 32);
				bufferPrinterBG.color = 0xFF000000;
				bufferPrinterBG.text = wordRaw;
				//bufferPrinterBG.visible = true;

				var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
				black.alpha = 0;
				add(black);

				FlxTween.tween(black, {alpha: 1}, 1.5, {onComplete:
					function(twn:FlxTween) {
						if (word == "halloweenparty")
						if (TitleState.unlockedSongs[1] != true)
							TitleState.unlockedSongs[1] = true;
							FlxG.save.data.maskedMelodyUnlocker = true;
							FlxG.save.flush();
							selectedSong = 'masked-melody';	
							trace('Song unlocked:' + selectedSong);	
							Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - Unlocked A Secret Song!";					

					var diffic = CoolUtil.defaultDifficulties[2];
					if (diffic == null) 
						diffic = '';

					PlayState.storyPlaylist = [selectedSong];
	
					PlayState.storyDifficulty = 2;

					PlayState.isGearsSection = true;
	
					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + "-" + diffic, PlayState.storyPlaylist[0].toLowerCase());
					//PlayState.storyWeek = 1;
					PlayState.campaignScore = 0;
					PlayState.campaignMisses = 0;
	
					new FlxTimer().start(0.25, function(tmr:FlxTimer)
					{
						LoadingState.loadAndSwitchState(new PlayState());
						FlxG.sound.music.volume = 0;
						FreeplayState.destroyFreeplayVocals();
					});
				}
	});


		FlxG.sound.music.fadeOut();
		if(FreeplayState.vocals != null)
		{
			FreeplayState.vocals.fadeOut();
		}
		passwordBuffer = '';
		//selectedSong = '';
		break;
		}  else	if (passwordBuffer.contains(word) && wordRaw == 'password') {

		if (FlxG.save.data.spectrumUnlocker == 'password'){
			FlxG.save.data.spectrumUnlocker = '';
		} else{
			FlxG.save.data.spectrumUnlocker = 'password';
			FlxG.save.flush();
		}

		if (ClientPrefs.flashing){
			FlxG.camera.flash(0xFFA8A8A8);
			}

			FlxG.sound.play(Paths.sound('correct'));

			bufferPrinter.setFormat(Paths.font("chronic.ttf"), 32);
			bufferPrinter.color = 0xFF525252;
			bufferPrinter.text = wordRaw;
			bufferPrinter.visible = true;

			bufferPrinterBG.setFormat(Paths.font("chronic.ttf"), 32);
			bufferPrinterBG.color = 0xFF000000;
			bufferPrinterBG.text = wordRaw;
			//bufferPrinterBG.visible = true;

			var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			black.alpha = 0;
			add(black);

			FlxTween.tween(black, {alpha: 1}, 1.5, {onComplete:
			function(twn:FlxTween) {
			if (word == "password")
			if (TitleState.unlockedSongs[2] != true)
			TitleState.unlockedSongs[2] = true;
			FlxG.save.data.spectrumUnlocker = true;
			FlxG.save.flush();
			selectedSong = 'spectrum';	
			trace('Song unlocked:' + selectedSong);	
			Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - Unlocked A Secret Song!";					

			var diffic = CoolUtil.defaultDifficulties[2];
			if (diffic == null) 
				diffic = '';

			PlayState.storyPlaylist = [selectedSong];

			PlayState.storyDifficulty = 2;

			PlayState.isGearsSection = true;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + "-" + diffic, PlayState.storyPlaylist[0].toLowerCase());
			//PlayState.storyWeek = 1;
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;

			new FlxTimer().start(0.25, function(tmr:FlxTimer)
			{
			LoadingState.loadAndSwitchState(new PlayState());
			FlxG.sound.music.volume = 0;
			FreeplayState.destroyFreeplayVocals();
			});
			}
			});


			FlxG.sound.music.fadeOut();
			if(FreeplayState.vocals != null)
			{
			FreeplayState.vocals.fadeOut();
			}
			passwordBuffer = '';
			//selectedSong = '';
			break;
			} else if (passwordBuffer.contains(word) && wordRaw == 'darknessmyoldfriend') {

			if (FlxG.save.data.breakDownUnlocker == 'darknessmyoldfriend'){
			FlxG.save.data.breakDownUnlocker = '';
			} else {
			FlxG.save.data.breakDownUnlocker = 'darknessmyoldfriend';
			FlxG.save.flush();
			}

			if (ClientPrefs.flashing){
			FlxG.camera.flash(0xFF000000);
			}

			FlxG.sound.play(Paths.sound('correct'));

			bufferPrinter.setFormat(Paths.font("old evils.ttf"), 32);
			bufferPrinter.color = 0xFF000000;
			bufferPrinter.text = wordRaw;
			bufferPrinter.visible = true;

			bufferPrinterBG.setFormat(Paths.font("old evils.ttf"), 32);
			bufferPrinterBG.color = 0xFF000000;
			bufferPrinterBG.text = wordRaw;
			//bufferPrinterBG.visible = true;

			var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			black.alpha = 0;
			add(black);

			FlxTween.tween(black, {alpha: 1}, 1.5, {onComplete:
			function(twn:FlxTween) {
			if (word == "darknessmyoldfriend")
			if (TitleState.unlockedSongs[3] != true)
			TitleState.unlockedSongs[3] = true;
			FlxG.save.data.breakDownUnlocker = true;
			FlxG.save.flush();
			selectedSong = 'breakdown';	
			trace('Song unlocked:' + selectedSong);	
			Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - Unlocked A Secret Song!";

			var diffic = CoolUtil.defaultDifficulties[2];
			if (diffic == null) 
			diffic = '';

			PlayState.storyPlaylist = [selectedSong];

			PlayState.storyDifficulty = 2;

			PlayState.isGearsSection = true;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + "-" + diffic, PlayState.storyPlaylist[0].toLowerCase());
			//PlayState.storyWeek = 1;
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;

			new FlxTimer().start(0.25, function(tmr:FlxTimer)
			{
			LoadingState.loadAndSwitchState(new PlayState());
			FlxG.sound.music.volume = 0;
			FreeplayState.destroyFreeplayVocals();
			});
			}
			});


			FlxG.sound.music.fadeOut();
			if(FreeplayState.vocals != null)
			{
			FreeplayState.vocals.fadeOut();
			}
			passwordBuffer = '';
			//selectedSong = '';
			break;
			} else if (passwordBuffer.contains(word) && wordRaw == 'shades') {

			if (FlxG.save.data.shadows == 'shades'){
				FlxG.save.data.shadows = '';
			} else {
			FlxG.save.data.shadows = 'shades';
			FlxG.save.flush();
			}

			if (ClientPrefs.flashing){
			FlxG.camera.flash(0xFFA9A9A9);
			}

			FlxG.sound.play(Paths.sound('correct'));

			bufferPrinter.setFormat(("Diediedie"), 32);
			bufferPrinter.color = 0xFF000000;
			bufferPrinter.text = wordRaw;
			bufferPrinter.visible = true;

			bufferPrinterBG.setFormat(("Diediedie"), 32);
			bufferPrinterBG.color = 0xFFA9A9A9;
			bufferPrinterBG.text = wordRaw;
			//bufferPrinterBG.visible = true;

			var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			black.alpha = 0;
			add(black);

			FlxTween.tween(black, {alpha: 1}, 1.5, {onComplete:
			function(twn:FlxTween) {
			if (word == "shades")
			if (TitleState.unlockedSongs[3] != true)
			TitleState.unlockedSongs[3] = true;
			FlxG.save.data.shadows = true;
			FlxG.save.flush();
			selectedSong = 'shadows';	
			trace('Song unlocked:' + selectedSong);	
			Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - Unlocked A Secret Song!";

			var diffic = CoolUtil.defaultDifficulties[2];
			if (diffic == null) 
			diffic = '';

			PlayState.storyPlaylist = [selectedSong];

			PlayState.storyDifficulty = 2;

			PlayState.isGearsSection = true;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + "-" + diffic, PlayState.storyPlaylist[0].toLowerCase());
			//PlayState.storyWeek = 1;
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;

			new FlxTimer().start(0.25, function(tmr:FlxTimer)
			{
			LoadingState.loadAndSwitchState(new PlayState());
			FlxG.sound.music.volume = 0;
			FreeplayState.destroyFreeplayVocals();
			});
			}
			});


			FlxG.sound.music.fadeOut();
			if(FreeplayState.vocals != null)
			{
			FreeplayState.vocals.fadeOut();
			}
			passwordBuffer = '';
			//selectedSong = '';
			break;
			} else if (passwordBuffer.contains(word) && wordRaw == 'ilikecheating') {

				FlxG.sound.play(Paths.sound('correct'));
	
				bufferPrinter.setFormat("Jokerman", 32);
				bufferPrinter.color = 0xFF8C039E;
				bufferPrinter.text = wordRaw + '\nBig Cheater Mode has been unlocked.\nYou can find it by pressing Ctrl in either\nstory menu or freeplay.';
				bufferPrinter.visible = true;

				bufferPrinterBG.setFormat(("Jokerman"), 32);
				bufferPrinterBG.color = 0xFF000000;
				bufferPrinterBG.text = wordRaw + '\nBig Cheater Mode has been unlocked.\nYou can find it by pressing Ctrl in either\nstory menu or freeplay.';
				//bufferPrinterBG.visible = true;
	
				trace('Unlocked A Very Secret Gameplay Changer.');

				Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - Unlocked A Very Secret Gameplay Changer.";
	
				if(FlxG.save.data.unlockedAVerySecretGameplayChanger != true)
				FlxG.save.data.unlockedAVerySecretGameplayChanger = true;
	
				passwordBuffer = '';
				break;
			} else if (passwordBuffer.contains(word) && wordRaw == 'ledumbidea') {

				FlxG.sound.play(Paths.sound('correct'));
	
				bufferPrinter.setFormat("Jokerman", 32);
				bufferPrinter.color = 0xFF8C039E;
				bufferPrinter.text = wordRaw;
				bufferPrinter.visible = true;

				bufferPrinterBG.setFormat(("Jokerman"), 32);
				bufferPrinterBG.color = 0xFF000000;
				bufferPrinterBG.text = wordRaw;
				//bufferPrinterBG.visible = true;
	
				trace('The Player Just Discovered Le Funni.');

				Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - The Player Just Discovered Le Funni.";
	
				if(FlxG.save.data.unlockedLeDumbIdea != true)
				FlxG.save.data.unlockedLeDumbIdea = true;

				CreditsRollState.loadedFromLeDumbIdea = true;

				new FlxTimer().start(0.25, function(tmr:FlxTimer)
					{
					LoadingState.loadAndSwitchState(new CreditsRollState());
					FlxG.sound.music.volume = 0;
					});

				FlxG.sound.music.fadeOut();
	
				passwordBuffer = '';
				break;
				super.update(elapsed);
			}
			}
			}
			if (controls.BACK)
			{
			PlayState.isGearsSection = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
					}
				}
			}
		}
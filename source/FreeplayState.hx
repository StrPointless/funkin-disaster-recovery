package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import LoadingState.LoadingScreens;
import lime.app.Application;
import flixel.util.FlxTimer;
import WeekData;
#if modsImages_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var foreGround:FlxSprite;
	var songListBg:FlxSprite;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	var selectedSomething:Bool = false;

	public static var BF:FlxSprite;
	public static var myst:FlxSprite;
	public static var screwie:FlxSprite;
	public static var screwieL:FlxSprite;
	public static var hotRod:FlxSprite;
	public static var redlineBF:FlxSprite;
	public static var redlineGF:FlxSprite;
	public static var redlinePico:FlxSprite;
	public static var GF:FlxSprite;
	public static var halloweenPico:FlxSprite;
	public static var spectrum:FlxSprite;
	public static var breakdownBF:FlxSprite;

	var loadOut:GateTransition;
	var loadIn:GateTransition;

	override function create()
	{
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

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

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null, 'iconog');
		Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - In Freeplay";
		#end

		for (i in 0...WeekData.weeksList.length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.loadTheFirstEnabledMod();

		/*		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('Songlist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}*/

		if (TitleState.unlockedSongs[0])
			addSong('Lead Headed', 0, 'redpico', 0xFF970000);
		if (TitleState.unlockedSongs[1])
			addSong('Masked Melody', 0, 'pico', 0xFFFF7E33);
		if (TitleState.unlockedSongs[2])
			addSong('spectrum', 0, 'stik', 0xFFA8A8A8);
		if (TitleState.unlockedSongs[3])
			addSong('Breakdown', 0, 'bf', 0xFF000000);
		if (TitleState.unlockedSongs[4])
			addSong('Lo-Ghoul', 0, 'MystWhitty', 0xFF3C3C3C);
		if (TitleState.unlockedSongs[5])
			addSong('Shadows', 0, 'bf-chrome', 0xFFA9A9A9);
		
		bg = new FlxSprite().loadGraphic(Paths.image('freeplaybg'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		scoreBG = new FlxSprite().loadGraphic(Paths.image('scoreBG'));
		scoreBG.antialiasing = ClientPrefs.globalAntialiasing;
		scoreBG.screenCenter(X);
		scoreBG.x = 59;
		scoreBG.y = -62;
		add(scoreBG);

		songListBg = new FlxSprite().loadGraphic(Paths.image('songListBg'));
		songListBg.antialiasing = ClientPrefs.globalAntialiasing;
		songListBg.screenCenter(X);
		songListBg.y = -60;
		add(songListBg);

		if (ClientPrefs.freeplayCharacters){
		BF = new FlxSprite();
		myst = new FlxSprite();
		screwie = new FlxSprite();
		screwieL = new FlxSprite();
		hotRod = new FlxSprite();
		redlineBF = new FlxSprite();
		redlineGF = new FlxSprite();
		redlinePico = new FlxSprite();
		GF = new FlxSprite();
		halloweenPico = new FlxSprite();
		spectrum = new FlxSprite();
		breakdownBF = new FlxSprite();

		BF.frames = Paths.getSparrowAtlas('characters/Boyfriend_PhalvReanimation');
		BF.animation.addByPrefix('idle', 'BF idle dance0', 24, true);
		BF.animation.play('idle');
		myst.frames = Paths.getSparrowAtlas('characters/MystR');
		myst.animation.addByPrefix('idle', 'MystR idle0', 24, true);
		myst.animation.play('idle');
		screwie.frames = Paths.getSparrowAtlas('characters/screwiehd');
		screwie.animation.addByPrefix('idle', 'screwiehd idle0', 24, true);
		screwie.animation.play('idle');
		screwieL.frames = Paths.getSparrowAtlas('characters/screwiehd');
		screwieL.animation.addByPrefix('idle', 'screwiehd idle0', 24, true, true);
		screwieL.animation.play('idle');
		hotRod.frames = Paths.getSparrowAtlas('characters/Hotrod');
		hotRod.animation.addByPrefix('idle', 'Hotrod idle0', 24, true);
		hotRod.animation.play('idle');
		redlineBF.frames = Paths.getSparrowAtlas('characters/RedlineBf');
		redlineBF.animation.addByPrefix('idle', 'BF idle dance0', 24, true);
		redlineBF.animation.play('idle');
		redlineGF.frames = Paths.getSparrowAtlas('characters/RedlineGf');
		redlineGF.animation.addByPrefix('idle', 'GF Dancing Beat0', 24, true);
		redlineGF.animation.play('idle');
		redlinePico.frames = Paths.getSparrowAtlas('characters/RedlinePico');
		redlinePico.animation.addByPrefix('idle', 'Pico Idle Dance0', 24, true, true);
		redlinePico.animation.play('idle');
		GF.frames = Paths.getSparrowAtlas('characters/ovaries');
		GF.animation.addByPrefix('idle', 'GF Dancing Beat0', 24, true);
		GF.animation.play('idle');
		halloweenPico.frames = Paths.getSparrowAtlas('characters/Pico_Pumpkin');
		halloweenPico.animation.addByPrefix('idle', 'Pico Idle Dance0', 24, true, true);
		halloweenPico.animation.play('idle');
		spectrum.frames = Paths.getSparrowAtlas('characters/stik');
		spectrum.animation.addByPrefix('idle', 'stik idle0', 24, true);
		spectrum.animation.play('idle');
		breakdownBF.frames = Paths.getSparrowAtlas('characters/bfbreakingdown');
		breakdownBF.animation.addByPrefix('idle', 'bfbreakingdown idle0', 24, true);
		breakdownBF.animation.play('idle');

		BF.color = FlxColor.BLACK;
		myst.color = FlxColor.BLACK;
		screwie.color = FlxColor.BLACK;
		screwieL.color = FlxColor.BLACK;
		hotRod.color = FlxColor.BLACK;
		redlineBF.color = FlxColor.BLACK;
		redlineGF.color = FlxColor.BLACK;
		redlinePico.color = FlxColor.BLACK;
		GF.color = FlxColor.BLACK;
		halloweenPico.color = FlxColor.BLACK;
		spectrum.color = FlxColor.BLACK;
		breakdownBF.color = FlxColor.BLACK;

		BF.x = 1800;
		BF.y = 280;
		BF.alpha = 0.0;
		myst.x = -1800;
		myst.y = 40;
		myst.alpha = 0.0;
		screwie.x = -1800;
		screwie.y = 70;
		screwie.alpha = 0.0;
		screwieL.x = 1800;
		screwieL.y = 70;
		screwieL.alpha = 0.0;
		hotRod.x = -1800;
		hotRod.y = 300;
		hotRod.alpha = 0.0;
		redlineBF.x = 1800;
		redlineBF.y = 350;
		redlineBF.alpha = 0.0;
		redlineGF.screenCenter(X);
		redlineGF.y = 1800;
		redlineGF.alpha = 0.0;
		redlinePico.x = -1800;
		redlinePico.y = 350;
		redlinePico.alpha = 0.0;
		GF.screenCenter(X);
		GF.y = 1800;
		GF.alpha = 0.0;
		halloweenPico.x = -1800;
		halloweenPico.y = 400;
		halloweenPico.alpha = 0.0;
		spectrum.x = -1800;
		spectrum.y = 525;
		spectrum.alpha = 0.0;
		breakdownBF.x = 1800;
		breakdownBF.y = 260;
		breakdownBF.alpha = 0.0;
		}

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 628, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		for (i in 0...songs.length)
			{
				var songText:Alphabet = new Alphabet(0, (130 * i) + 30, songs[i].songName, true, false); //Had spent hours to make this menu cuz it's my first time literally touching this piece of code - luci
				songText.isMenuItem = true;
				songText.forceX = 233;
				songText.targetY = i;
				//songText.x -= 70;
				grpSongs.add(songText);
	
				if (songText.width > 330)
				{
					var textScale:Float = 370 / songText.width;
					370 / songText.height;
					songText.scale.x = textScale;
					for (letter in songText.lettersArray)
					{
						letter.x *= textScale;
						letter.offset.x *= textScale;
					}
					songText.offset.y -= 20;
					//songText.updateHitbox();
					//trace(songs[i].songName + ' new scale: ' + textScale);
				}
	
				Paths.currentModDirectory = songs[i].folder;
				var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
				icon.sprTracker = songText;
				icon.offset.x = 30;
				icon.offset.y -= 10;
				icon.scale.x = 0.6;
				icon.scale.y = 0.6;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
	
				// songText.x += 40;
				// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
				// songText.screenCenter(X);
			}

			foreGround = new FlxSprite().loadGraphic(Paths.image('foreGround'));
			foreGround.antialiasing = ClientPrefs.globalAntialiasing;
			foreGround.screenCenter(X);
			add(foreGround);

			if (ClientPrefs.freeplayCharacters){
			add(BF);
			add(myst);
			add(screwie);
			add(screwieL);
			add(hotRod);
			add(redlineBF);
			add(redlineGF);
			add(redlinePico);
			add(GF);
			add(halloweenPico);
			add(spectrum);
			add(breakdownBF);
			}

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		#if PRELOAD_ALL
		var leText:String = "Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		var size:Int = 16;
		#else
		var leText:String = "Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		var size:Int = 18;
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);

		if (ClientPrefs.transitionStyle){
			loadIn.animation.play('GateTransition');
			add(loadIn);
			add(loadOut);
			}

		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if(songs.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					changeDiff();
				}
			}

			if (ClientPrefs.middleMouseScroll){
			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				changeDiff();
			}
		}
	}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else if (upP || downP) changeDiff();

		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			if (ClientPrefs.transitionStyle){
				loadOut.alpha = 1;
				loadOut.animation.play('GateTransition');
				new FlxTimer().start(1, function(tmr:FlxTimer){
					MusicBeatState.switchState(new MainMenuState());
			});
			} else {
				MusicBeatState.switchState(new MainMenuState());
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			if(instPlaying != curSelected)
			{
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = curSelected;
				#end
			}
		}

		else if (accepted && !selectedSomething)
		{
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			/*#if modsImages_ALLOWED
			if(!sys.FileSystem.existsImagesJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
			#else
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			#end
				poop = songLowercase;
				curDifficulty = 1;
				trace('Couldnt find file');
			}*/

			selectedSomething = true;
			
			//trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			//trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
			if(colorTween != null) {
				colorTween.cancel();
			}
			
			if (FlxG.keys.pressed.SHIFT){
				if (ClientPrefs.transitionStyle){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
				});
			}
				LoadingState.loadAndSwitchState(new ChartingState());
			}else{
				new FlxTimer().start(1, function(tmr:FlxTimer){
					openSubState(new LoadingScreens());
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = false;
					new FlxTimer().start(1.2, function(tmr:FlxTimer){

					LoadingState.loadAndSwitchState(new PlayState());	
				});
			});
			}

			FlxG.sound.play(Paths.sound('confirmMenu'));

			//FlxG.sound.music.volume = 0;
					
			destroyFreeplayVocals();
		}
		else if(controls.RESET)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		/*for (item in grpSongs.members) //Old centered songs list - luci
			{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if (item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
					item.forceX = item.x;
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
					item.forceX = item.x;
				}
			}*/
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		positionHighscore();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		if (ClientPrefs.freeplayCharacters){
		if (!selectedSomething)
			{
				FlxTween.cancelTweensOf(BF);
				FlxTween.cancelTweensOf(myst);
				FlxTween.cancelTweensOf(screwie);
				FlxTween.cancelTweensOf(screwieL);
				FlxTween.cancelTweensOf(hotRod);
				FlxTween.cancelTweensOf(redlineBF);
				FlxTween.cancelTweensOf(redlineGF);
				FlxTween.cancelTweensOf(redlinePico);
				FlxTween.cancelTweensOf(GF);
				FlxTween.cancelTweensOf(halloweenPico);
				FlxTween.cancelTweensOf(spectrum);
				FlxTween.cancelTweensOf(breakdownBF);

				BF.x = 1800;
				BF.y = 300;
				BF.alpha = 0.0;
				myst.x = -1800;
				myst.y = -15;
				myst.alpha = 0.0;
				screwie.x = -1800;
				screwie.y = 75;
				screwie.alpha = 0.0;
				screwieL.x = 1800;
				screwieL.y = 75;
				screwieL.alpha = 0.0;
				hotRod.x = -1800;
				hotRod.y = 370;
				hotRod.alpha = 0.0;
				redlineBF.x = 1800;
				redlineBF.y = 382;
				redlineBF.alpha = 0.0;
				redlineGF.screenCenter(X);
				redlineGF.y = 1800;
				redlineGF.alpha = 0.0;
				redlinePico.x = -1800;
				redlinePico.y = 348;
				redlinePico.alpha = 0.0;
				GF.screenCenter(X);
				GF.y = 1800;
				GF.alpha = 0.0;
				halloweenPico.x = -1800;
				halloweenPico.y = 400;
				halloweenPico.alpha = 0.0;
				spectrum.x = -1800;
				spectrum.y = 560;
				spectrum.alpha = 0.0;
				breakdownBF.x = 1800;
				breakdownBF.y = 250;
				breakdownBF.alpha = 0.0;

				BF.scale.set(0.3, 0.3);
				myst.scale.set(0.2, 0.2);
				screwie.scale.set(0.2, 0.2);
				screwieL.scale.set(0.2, 0.2);
				hotRod.scale.set(0.3, 0.3);
				redlineBF.scale.set(0.3, 0.3);
				redlineGF.scale.set(0.3, 0.3);
				redlinePico.scale.set(0.3, 0.3);
				GF.scale.set(0.3, 0.3);
				halloweenPico.scale.set(0.3, 0.3);
				spectrum.scale.set(1, 1);
				breakdownBF.scale.set(0.3, 0.3);

				var curSongName:String = songs[curSelected].songName.toLowerCase();

				if (curSongName == 'experimental software'){
					FlxTween.tween(BF, {x: 600, alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				} else{
					FlxTween.tween(BF, {x: 660, alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				}

				FlxTween.tween(myst, {x: 30, alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(screwie, {x: 50, alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				if (curSongName == 'experimental software'){
				FlxTween.tween(screwieL, {x: 520, alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				} else {
				FlxTween.tween(screwieL, {x: 450, alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				}
				FlxTween.tween(hotRod, {x: 130, alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(redlineBF, {x: 650, alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(redlineGF, {y: 235, alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(redlinePico, {x: 80, alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(GF, {y: 300, alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(halloweenPico, {x: 80, alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(spectrum, {x: 350, alpha: 1}, 0.5, {ease: FlxEase.quartOut});
				FlxTween.tween(breakdownBF, {x: 370, alpha: 1}, 0.5, {ease: FlxEase.quartOut});

				//trace(songs[curSelected].songName);

				if (curSongName == 'tutorial'){
					BF.visible = true;
					myst.visible = false;
					screwie.visible = false;
					screwieL.visible = false;
					hotRod.visible = false;
					redlineBF.visible = false;
					redlineGF.visible = false;
					redlinePico.visible = false;
					GF.visible = true;
					halloweenPico.visible = false;
					spectrum.visible = false;
					breakdownBF.visible = false;
				} else if (curSongName == 'new ghoul' || curSongName == 'supernatural' || curSongName == 'rebirth'){
					BF.visible = true;
					myst.visible = true;
					screwie.visible = false;
					screwieL.visible = false;
					hotRod.visible = false;
					redlineBF.visible = false;
					redlineGF.visible = false;
					redlinePico.visible = false;
					GF.visible = false;
					halloweenPico.visible = false;
					spectrum.visible = false;
					breakdownBF.visible = false;
				} else if (curSongName == 'latency' || curSongName == 'syntax' || curSongName == 'syntaxr' || curSongName == 'reprogrammed'){
					BF.visible = true;
					myst.visible = false;
					screwie.visible = true;
					screwieL.visible = false;
					hotRod.visible = false;
					redlineBF.visible = false;
					redlineGF.visible = false;
					redlinePico.visible = false;
					GF.visible = false;
					halloweenPico.visible = false;
					spectrum.visible = false;
					breakdownBF.visible = false;
				} else if (curSongName == 'invalid input' || curSongName == 'alt f4'){
					BF.visible = true;
					myst.visible = false;
					screwie.visible = false;
					screwieL.visible = false;
					hotRod.visible = true;
					redlineBF.visible = false;
					redlineGF.visible = false;
					redlinePico.visible = false;
					GF.visible = false;
					halloweenPico.visible = false;
					spectrum.visible = false;
					breakdownBF.visible = false;
				} else if (curSongName == 'experimental software'){
					BF.visible = true;
					myst.visible = false;
					screwie.visible = false;
					screwieL.visible = true;
					hotRod.visible = true;
					redlineBF.visible = false;
					redlineGF.visible = false;
					redlinePico.visible = false;
					GF.visible = false;
					halloweenPico.visible = false;
					spectrum.visible = false;
					breakdownBF.visible = false;
				} else if (curSongName == 'breakthrough'){
					BF.visible = true;
					myst.visible = false;
					screwie.visible = true;
					screwieL.visible = false;
					hotRod.visible = false;
					redlineBF.visible = false;
					redlineGF.visible = false;
					redlinePico.visible = false;
					GF.visible = false;
					halloweenPico.visible = false;
					spectrum.visible = false;
					breakdownBF.visible = false;
				} else if (curSongName == 'confutation'){
					BF.visible = false;
					myst.visible = false;
					screwie.visible = false;
					screwieL.visible = true;
					hotRod.visible = false;
					redlineBF.visible = false;
					redlineGF.visible = false;
					redlinePico.visible = false;
					GF.visible = false;
					halloweenPico.visible = false;
					spectrum.visible = true;
					breakdownBF.visible = false;
				} else if (curSongName == 'lead headed'){
					BF.visible = false;
					myst.visible = false;
					screwie.visible = false;
					screwieL.visible = false;
					hotRod.visible = false;
					redlineBF.visible = true;
					redlineGF.visible = true;
					redlinePico.visible = true;
					GF.visible = false;
					halloweenPico.visible = false;
					spectrum.visible = false;
					breakdownBF.visible = false;
				} else if (curSongName == 'masked melody'){
					BF.visible = true;
					myst.visible = false;
					screwie.visible = false;
					screwieL.visible = false;
					hotRod.visible = false;
					redlineBF.visible = false;
					redlineGF.visible = false;
					redlinePico.visible = false;
					GF.visible = true;
					halloweenPico.visible = true;
					spectrum.visible = false;
					breakdownBF.visible = false;
				} else if (curSongName == 'zach noises'){
					BF.visible = true;
					myst.visible = false;
					screwie.visible = false;
					screwieL.visible = false;
					hotRod.visible = false;
					redlineBF.visible = false;
					redlineGF.visible = false;
					redlinePico.visible = false;
					GF.visible = true;
					halloweenPico.visible = false;
					spectrum.visible = true;
					breakdownBF.visible = false;
				} else if (curSongName == 'breakdown'){
					BF.visible = false;
					myst.visible = false;
					screwie.visible = false;
					screwieL.visible = false;
					hotRod.visible = false;
					redlineBF.visible = false;
					redlineGF.visible = false;
					redlinePico.visible = false;
					GF.visible = false;
					halloweenPico.visible = false;
					spectrum.visible = false;
					breakdownBF.visible = true;
				} else {
					BF.visible = false;
					myst.visible = false;
					screwie.visible = false;
					screwieL.visible = false;
					hotRod.visible = false;
					redlineBF.visible = false;
					redlineGF.visible = false;
					redlinePico.visible = false;
					GF.visible = false;
					halloweenPico.visible = false;
					spectrum.visible = false;
					breakdownBF.visible = false;
				}
			}
		}
			
		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha -= 0.5;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha -= 0.5;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

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
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;

		//scoreText.scale.x = FlxG.width - scoreBG.x;
		//scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		scoreText.screenCenter();
		scoreText.x = 760;
		diffText.screenCenter();
		diffText.x = 815;
		diffText.y += 35;
		//diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		//diffText.x -= diffText.width / 2;
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}
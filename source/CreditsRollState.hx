package;
import flixel.*;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import openfl.Assets;
import options.OptionsState;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import lime.app.Application;

class CreditsRollState extends MusicBeatState
{	
	var rollPicture:FlxSprite = new FlxSprite();

	var secretSongIcon:FlxSprite;

	var loadOut:GateTransition;
	var loadIn:GateTransition;

	public static var loadedFromLeDumbIdea:Bool = false;
	
	override function create() 
	{
		
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
		
		super.create();
		//bgColor = 0xFF000000;
		
		rollPicture.loadGraphic(Paths.image("creds", "shared"));
		rollPicture.antialiasing = true;
		add(rollPicture);

		if (loadedFromLeDumbIdea){
		secretSongIcon = new FlxSprite().loadGraphic(Paths.image("hiddenIcon"));
		secretSongIcon.x = 890;
		secretSongIcon.y = 1910;
		secretSongIcon.flipX = true;
		secretSongIcon.antialiasing = true;
		secretSongIcon.updateHitbox();
		add(secretSongIcon);
		}
		
		rollPicture.scale.y = rollPicture.scale.x = 1280 / rollPicture.width;
		rollPicture.updateHitbox();
		FlxG.sound.playMusic(Paths.music("breakfast","shared"),1,false);
		FlxTween.tween(FlxG.camera.scroll, {y: ((rollPicture.height) - FlxG.sound.music.time)}, (FlxG.sound.music.length / 1000) , {ease:FlxEase.linear,onComplete:finishedRolling});

		if (loadedFromLeDumbIdea){
			FlxG.camera.alpha = 0.5;
		}

		if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
			loadIn.animation.play('GateTransition');
			add(loadIn);
			add(loadOut);
			}

			Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - Rolling The Credits";
	}

	override function update(elapsed:Float)
	{
		var selectedSong:String = '';

		if (loadedFromLeDumbIdea){
		FlxG.mouse.visible = true;
		FlxG.mouse.enabled = true;
		var add:Float = 50;
		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;
		if(controls.UI_LEFT) {
			FlxG.camera.x -= (elapsed * -add * multiplier);
		} else if(controls.UI_RIGHT) {
			var add:Float = -50;
			FlxG.camera.x += (elapsed * add * multiplier);
		}
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(secretSongIcon))
			{
					secretSongIcon.scale.x = 0.9;
					secretSongIcon.scale.y = 0.9;
					FlxG.sound.play(Paths.sound('correct'));
					FlxG.mouse.visible = false;
					FlxG.mouse.enabled = false;

					FlxG.camera.fade(FlxColor.BLACK, 1.5, false, function(){});
							if (TitleState.unlockedSongs[4] != true) 
								TitleState.unlockedSongs[4] = true;
								FlxG.save.data.loGhoul = true;
								FlxG.save.flush();
								selectedSong = 'lo-ghoul';
								trace('Song unlocked:' + selectedSong);		
								Application.current.window.title = "Friday Night Funkin': A Funkin' Disaster - Unlocked A Secret Song!";					

						var diffic = CoolUtil.defaultDifficulties[2];
						if (diffic == null) 
							diffic = '';

						PlayState.storyPlaylist = [selectedSong];
		
						PlayState.storyDifficulty = 2;

						PlayState.isGearsSection = true;
		
						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + "-" + diffic, PlayState.storyPlaylist[0].toLowerCase());
						PlayState.campaignScore = 0;
						PlayState.campaignMisses = 0;

						FlxG.sound.music.fadeOut();
		
						new FlxTimer().start(2.0, function(tmr:FlxTimer)
						{
							LoadingState.loadAndSwitchState(new PlayState());
							FlxG.sound.music.volume = 0;
							FreeplayState.destroyFreeplayVocals();
						});
					}
				}

		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ESCAPE){
			FlxG.sound.playMusic(Paths.music('/mainMenu/' + ClientPrefs.mainMenuMusic), 0);
		FlxG.sound.music.fadeIn(4, 0, 1);
		if (!ClientPrefs.legacyEngine){
			if (OptionsState.loadedFromOptionsMenu == true){
				OptionsState.loadedFromOptionsMenu = false;
				if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
					loadOut.alpha = 1;
					loadOut.animation.play('GateTransition');
					new FlxTimer().start(1, function(tmr:FlxTimer){
						LoadingState.loadAndSwitchState(new options.OptionsState());
					});
					} else {
						LoadingState.loadAndSwitchState(new options.OptionsState());
					}
			} else {
			if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
			loadOut.animation.play('GateTransition');
			new FlxTimer().start(1, function(tmr:FlxTimer){
				LoadingState.loadAndSwitchState(new MainMenuState());
			});
			} else {
				LoadingState.loadAndSwitchState(new MainMenuState());
			}
			}
			} else {
				if (OptionsState.loadedFromOptionsMenu == true){
					OptionsState.loadedFromOptionsMenu = false;
					LoadingState.loadAndSwitchState(new options.OptionsState());
				} else {
					LoadingState.loadAndSwitchState(new legacy.LegacyMainMenuState());
				}
			}
			FlxG.mouse.visible = false;
			FlxG.mouse.enabled = false;
			loadedFromLeDumbIdea = false;
	}
	super.update(elapsed);
	}
	
	
	public function finishedRolling(e:FlxTween):Void{

		rollPicture.destroy();
		secretSongIcon.destroy();

		FlxG.sound.playMusic(Paths.music('/mainMenu/' + ClientPrefs.mainMenuMusic), 0);
		FlxG.sound.music.fadeIn(4, 0, 1);

		if (!ClientPrefs.legacyEngine){
			if (OptionsState.loadedFromOptionsMenu == true){
			if (ClientPrefs.transitionStyle){
				loadOut.alpha = 1;
				loadOut.animation.play('GateTransition');
				new FlxTimer().start(1, function(tmr:FlxTimer){
					LoadingState.loadAndSwitchState(new options.OptionsState());
				});
				} else {
					LoadingState.loadAndSwitchState(new options.OptionsState());
				}
				}
			if (ClientPrefs.transitionStyle && !ClientPrefs.legacyEngine){
				loadOut.alpha = 1;
				loadOut.animation.play('GateTransition');
				new FlxTimer().start(1, function(tmr:FlxTimer){
					LoadingState.loadAndSwitchState(new MainMenuState());
				});
				} else {
					LoadingState.loadAndSwitchState(new MainMenuState());
				}
			} else {
				if (OptionsState.loadedFromOptionsMenu == true){
					OptionsState.loadedFromOptionsMenu = false;
					LoadingState.loadAndSwitchState(new options.OptionsState());
			} else {
			LoadingState.loadAndSwitchState(new legacy.LegacyMainMenuState());
			}
		}

		FlxG.mouse.visible = false;
		FlxG.mouse.enabled = false;
		loadedFromLeDumbIdea = false;
		OptionsState.loadedFromOptionsMenu = false;
		
	};
}
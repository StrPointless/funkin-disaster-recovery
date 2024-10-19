package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class HowToPlayState extends MusicBeatState
{
	var bozoText:FlxText;

	var loadOut:GateTransition;
	var loadIn:GateTransition;

	override function create()
	{
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
		super.create();

		Application.current.window.title = 'Bozo momento';

		//var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		//add(bg);

		bozoText = new FlxText(0, 0, FlxG.width,
			"Figure it out for yourself\n
			        Bozo.",
			32);
		bozoText.setFormat("Jokerman", 100, FlxColor.RED, CENTER);
		bozoText.screenCenter(Y);
		add(bozoText);

		if (ClientPrefs.transitionStyle){
		loadIn.animation.play('GateTransition');
		add(loadIn);
		add(loadOut);
		}
	}

	override function update(elapsed:Float)
	{
			var back:Bool = controls.BACK;
			if (FlxG.keys.justPressed.SPACE) {
					FlxG.sound.play(Paths.sound('confirmMenu'));
					if (ClientPrefs.transitionStyle){
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
						loadOut.alpha = 1;
						loadOut.animation.play('GateTransition');
						new FlxTimer().start(1, function(tmr:FlxTimer){
							MusicBeatState.switchState(new MainMenuState());
						});
					} else{
						MusicBeatState.switchState(new MainMenuState());
						FlxTransitionableState.skipNextTransIn = false;
						FlxTransitionableState.skipNextTransOut = false;
					}
				} else if (FlxG.keys.justPressed.ESCAPE) {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					if (ClientPrefs.transitionStyle){
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
						loadOut.alpha = 1;
						loadOut.animation.play('GateTransition');
						new FlxTimer().start(1, function(tmr:FlxTimer){
							MusicBeatState.switchState(new MainMenuState());
						});
					} else{
						MusicBeatState.switchState(new MainMenuState());
						FlxTransitionableState.skipNextTransIn = false;
						FlxTransitionableState.skipNextTransOut = false;
					}
				}
		super.update(elapsed);
	}
}

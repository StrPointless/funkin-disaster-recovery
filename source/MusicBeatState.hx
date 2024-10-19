package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxState;
import flixel.FlxBasic;

class MusicBeatState extends FlxUIState
{
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create() {
		var skip:Bool = FlxTransitionableState.skipNextTransOut;
		super.create();

		if(!skip) {
			openSubState(new CustomFadeTransition(0.7, true));
		}
		FlxTransitionableState.skipNextTransOut = false;
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		//This should turn on full screen mode no matter which part of the game you are currently in - luci
		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.F)
			{
				FlxG.fullscreen = !FlxG.fullscreen;
			}

		/*Loading a custom sprite for the cursor, because why not?
		Just make sure to keep the code in this state so the sprite carries out
		to the rest of the game, otherwise, it will only load on the targeted state.
		For the rest, it will not have a sprite, which will be a problem - luci*/
		var defaultCursor:FlxSprite = new FlxSprite ().loadGraphic(Paths.image('ui/cursor', 'shared'));
		var mystCursor = new FlxSprite().loadGraphic(Paths.image('ui/Myst Cursor', 'shared'));
		var screwieCursor = new FlxSprite().loadGraphic(Paths.image('ui/Screwie Cursor', 'shared'));
		var hotRodCursor = new FlxSprite().loadGraphic(Paths.image('ui/Hotrod Cursor', 'shared'));
		var averageCursor = new FlxSprite().loadGraphic(Paths.image('ui/Average Cursor', 'shared'));
		var clutchCursor = new FlxSprite().loadGraphic(Paths.image('ui/Clutch Cursor', 'shared'));
		var luciCursor = new FlxSprite().loadGraphic(Paths.image('ui/luci Cursor', 'shared'));

		var cursorSprite = new FlxSprite();

		if (FlxG.save.data.cursorSprite == 0 || FlxG.save.data.cursorSprite == null){
			cursorSprite = defaultCursor;
		} else if(FlxG.save.data.cursorSprite == 1){
			cursorSprite = mystCursor;
		} else if (FlxG.save.data.cursorSprite == 2){
			cursorSprite = screwieCursor;
		} else if (FlxG.save.data.cursorSprite == 3){
			cursorSprite = hotRodCursor;
		} else if (FlxG.save.data.cursorSprite == 4){
			cursorSprite = averageCursor;
		} else if (FlxG.save.data.cursorSprite == 5){
			cursorSprite = clutchCursor;
		} else if (FlxG.save.data.cursorSprite == 6){
			cursorSprite = luciCursor;
		}
		
		if (PlayState.chartingMode == true && FlxG.save.data.cursorSprite != null && cursorSprite != defaultCursor ){
			FlxG.mouse.load(cursorSprite.pixels, 0.3);
		} else if (cursorSprite == defaultCursor || cursorSprite == null){
			FlxG.mouse.load(cursorSprite.pixels, 1.1);
		} else {
			FlxG.mouse.load(cursorSprite.pixels, 0.5);
		}

		cursorSprite.antialiasing = ClientPrefs.globalAntialiasing;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0)
				stepHit();

			if(PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;

		super.update(elapsed);
	}

	private function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	private function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public static function switchState(nextState:FlxState) {
		// Custom made Trans in
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		if(!FlxTransitionableState.skipNextTransIn) {
			leState.openSubState(new CustomFadeTransition(0.6, false));
			if(nextState == FlxG.state) {
				CustomFadeTransition.finishCallback = function() {
					FlxG.resetState();
				};
				//trace('resetted');
			} else {
				CustomFadeTransition.finishCallback = function() {
					FlxG.switchState(nextState);
				};
				//trace('changed state');
			}
			return;
		}
		FlxTransitionableState.skipNextTransIn = false;
		FlxG.switchState(nextState);
	}

	public static function resetState() {
		MusicBeatState.switchState(FlxG.state);
	}

	public static function getState():MusicBeatState {
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		return leState;
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//trace('Beat: ' + curBeat);
	}

	public function sectionHit():Void
	{
		//trace('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
}

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

class ScreenPackSubState extends MusicBeatSubstate
{
	var packsArray:Array<String> = ['Default Pack', 'Myst Pack', 'Screwie Pack', 'Hotrod Pack', 'Average Pack', 'Clutch Pack', 'luci Pack'];
	private static var curSelected:Int = 0;
	//private var grpCursors:FlxTypedGroup<FlxSprite>;
	var defaultBG:FlxSprite;
	var mystBG:FlxSprite;
	var screwieBG:FlxSprite;
	var hotrodBG:FlxSprite;
	//var bg:FlxSprite;

	var selectedText:FlxText;
    var packSelect:FlxSprite;

	var defaultCursor:FlxSprite;
	var mystCursor:FlxSprite;
	var screwieCursor:FlxSprite;
	var hotrodCursor:FlxSprite;
	var averageCursor:FlxSprite;
	var clutchCursor:FlxSprite;
	var luciCursor:FlxSprite;

	var posX = 545;
	override function create() {

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		FlxG.mouse.enabled = true;
		
		/*bg = new FlxSprite().loadGraphic(Paths.image('menuDesats/menuDesat'));
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);*/
		
		defaultBG = new FlxSprite().loadGraphic(Paths.image('menuDesats/menuDesat'));
		defaultBG.screenCenter();
		defaultBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(defaultBG);

		mystBG = new FlxSprite().loadGraphic(Paths.image('menuDesats/menuMyst'));
		mystBG.screenCenter();
		mystBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(mystBG);

		screwieBG = new FlxSprite().loadGraphic(Paths.image('menuDesats/menuScrewie'));
		screwieBG.screenCenter();
		screwieBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(screwieBG);

		hotrodBG = new FlxSprite().loadGraphic(Paths.image('menuDesats/menuHotrod'));
		hotrodBG.screenCenter();
		hotrodBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(hotrodBG);

		defaultCursor = new FlxSprite ().loadGraphic(Paths.image('ui/cursor', 'shared'));
		mystCursor = new FlxSprite ().loadGraphic(Paths.image('ui/Myst Cursor', 'shared'));
		screwieCursor = new FlxSprite ().loadGraphic(Paths.image('ui/Screwie Cursor', 'shared'));
		hotrodCursor = new FlxSprite ().loadGraphic(Paths.image('ui/Hotrod Cursor', 'shared'));
		averageCursor = new FlxSprite().loadGraphic(Paths.image('ui/Average Cursor', 'shared'));
		clutchCursor = new FlxSprite().loadGraphic(Paths.image('ui/Clutch Cursor', 'shared'));
		luciCursor = new FlxSprite().loadGraphic(Paths.image('ui/luci Cursor', 'shared'));

		defaultCursor.scale.set(1,1);

		defaultCursor.screenCenter();
		mystCursor.screenCenter();
		screwieCursor.screenCenter();
		hotrodCursor.screenCenter();
		averageCursor.screenCenter();
		clutchCursor.screenCenter();
		luciCursor.screenCenter();

		//trace(defaultCursor.x); // I did this just to know where exactly the middle of screen is X-wise for that sprite, which is 628 - luci

		//grpCursors = new FlxTypedGroup<FlxSprite>();
		//add(grpCursors);

		defaultCursor.antialiasing = ClientPrefs.globalAntialiasing;
		mystCursor.antialiasing = ClientPrefs.globalAntialiasing;
		screwieCursor.antialiasing = ClientPrefs.globalAntialiasing;
		hotrodCursor.antialiasing = ClientPrefs.globalAntialiasing;
		averageCursor.antialiasing = ClientPrefs.globalAntialiasing;
		clutchCursor.antialiasing = ClientPrefs.globalAntialiasing;
		luciCursor.antialiasing = ClientPrefs.globalAntialiasing;

		/*for (i in 0...grpCursors.length) {
			var item = grpCursors.members[i];
			blackBG = new FlxSprite(item.x, item.y).makeGraphic(Std.int(item.width), Std.int(item.height), FlxColor.BLACK);
			blackBG.alpha = 0.4;
			add(blackBG);
			}

		grpCursors.add(defaultCursor);
		grpCursors.add(mystCursor);
		grpCursors.add(screwieCursor);
		grpCursors.add(hotrodCursor);
		grpCursors.add(averageCursor);
		grpCursors.add(clutchCursor);*/

		mystCursor.x = -1800;
		screwieCursor.x = -1800;
		hotrodCursor.x = -1800;
		averageCursor.x = -1800;
		clutchCursor.x = -1800;
		luciCursor.x = -1800;

		add(defaultCursor);
		add(mystCursor);
		add(screwieCursor);
		add(hotrodCursor);
		add(averageCursor);
		add(clutchCursor);
		add(luciCursor);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 40, 0x91000000);
		add(blackBarThingie);

		var blackBarThingie2:FlxSprite = new FlxSprite(0, 680).makeGraphic(FlxG.width, 40, 0x91000000);
		add(blackBarThingie2);

		selectedText = new FlxText(0, 150, packsArray[0], 24);
		//selectedText.screenCenter(X);
		selectedText.x = 546.5;
		selectedText.offset.y = 20;
		selectedText.alignment = CENTER;
        add(selectedText);
        packSelect = new Alphabet(0, 50, "Select Your Screen Pack", true, false);
        packSelect.offset.x -= 150;
        add(packSelect);

		changeSelection();
		super.create();
		}		
		
	var isSwitching:Bool = false;
	override function update(elapsed:Float) {
			if (controls.UI_LEFT_P && isSwitching == false) {
				isSwitching = true;
				changeSelection(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'));

				defaultCursor.x = -1800;
				mystCursor.x = -1800;
				screwieCursor.x = -1800;
				hotrodCursor.x = -1800;
				averageCursor.x = -1800;
				clutchCursor.x = -1800;
				luciCursor.x = -1800;

				/*FlxTween.cancelTweensOf(defaultCursor);
				FlxTween.cancelTweensOf(mystCursor);
				FlxTween.cancelTweensOf(screwieCursor);
				FlxTween.cancelTweensOf(hotrodCursor);
				FlxTween.cancelTweensOf(averageCursor);
				FlxTween.cancelTweensOf(clutchCursor);*/

			if (curSelected == 0){
				selectedText.color = FlxColor.WHITE;
				defaultCursor.visible = true;
				screwieCursor.visible = false;
				hotrodCursor.visible = false;
				averageCursor.visible = false;
				clutchCursor.visible = false;
				FlxTween.tween(defaultCursor, {x: 628}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
					mystCursor.visible = false;
					luciCursor.visible = false;
				},
				});
				FlxTween.tween(mystCursor, {x: 1800}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
				},
				});
				FlxTween.tween(luciCursor, {x: -1800}, 0.5, {ease: FlxEase.quartOut});
				} else if (curSelected == 1){
				selectedText.color = 0x00a2ff;
				mystCursor.visible = true;
				screwieCursor.visible = false;
				hotrodCursor.visible = false;
				averageCursor.visible = false;
				clutchCursor.visible = false;
				luciCursor.visible = false;
				FlxTween.tween(defaultCursor, {x: 1800}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
					defaultCursor.visible = false;
				},
				});
				FlxTween.tween(mystCursor, {x: posX}, 0.5, {ease: FlxEase.quartOut});
				} else if (curSelected == 2){
				selectedText.color = 0xb3ffac;
				defaultCursor.visible = false;
				screwieCursor.visible = true;
				hotrodCursor.visible = false;
				averageCursor.visible = false;
				clutchCursor.visible = false;
				luciCursor.visible = false;
				FlxTween.tween(screwieCursor, {x: posX}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
					mystCursor.visible = false;
				},
				});
				FlxTween.tween(mystCursor, {x: 1800}, 0.5, {ease: FlxEase.quartOut});
				} else if (curSelected == 3){
				selectedText.color = 0xff0000;
				defaultCursor.visible = false;
				mystCursor.visible = false;
				hotrodCursor.visible = true;
				averageCursor.visible = false;
				clutchCursor.visible = false;
				luciCursor.visible = false;
				FlxTween.tween(hotrodCursor, {x: posX}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
					screwieCursor.visible = false;
				},
				});
				FlxTween.tween(screwieCursor, {x: 1800}, 0.5, {ease: FlxEase.quartOut});
				} else if (curSelected == 4){
				selectedText.color = 0xb45f19;
				defaultCursor.visible = false;
				mystCursor.visible = false;
				screwieCursor.visible = false;
				averageCursor.visible = true;
				clutchCursor.visible = false;
				luciCursor.visible = false;
				FlxTween.tween(averageCursor, {x: posX}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
					hotrodCursor.visible = false;
				},
				});
				FlxTween.tween(hotrodCursor, {x: 1800}, 0.5, {ease: FlxEase.quartOut});
				} else if (curSelected == 5){
					selectedText.color = 0xff8585;
					defaultCursor.visible = false;
					mystCursor.visible = false;
					screwieCursor.visible = false;
					hotrodCursor.visible = false;
					clutchCursor.visible = true;
					luciCursor.visible = false;
				FlxTween.tween(clutchCursor, {x: posX}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
					averageCursor.visible = false;
				},
				});
				FlxTween.tween(averageCursor, {x: 1800}, 0.5, {ease: FlxEase.quartOut});
				} else if (curSelected == 6){
					selectedText.color = 0x853aff;
					defaultCursor.visible = true;
					mystCursor.visible = false;
					screwieCursor.visible = false;
					hotrodCursor.visible = false;
					clutchCursor.visible = false;
					luciCursor.visible = true;
				FlxTween.tween(luciCursor, {x: posX}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
					clutchCursor.visible = false;
				},
				});
				FlxTween.tween(clutchCursor, {x: 1800}, 0.5, {ease: FlxEase.quartOut});
				}
			}
			if (controls.UI_RIGHT_P && isSwitching == false) {
				isSwitching = true;
				changeSelection(1);
				FlxG.sound.play(Paths.sound('scrollMenu'));

				defaultCursor.x = 1800;
				mystCursor.x = 1800;
				screwieCursor.x = 1800;
				hotrodCursor.x = 1800;
				averageCursor.x = 1800;
				clutchCursor.x = 1800;
				luciCursor.x = 1800;

				/*FlxTween.cancelTweensOf(defaultCursor);
				FlxTween.cancelTweensOf(mystCursor);
				FlxTween.cancelTweensOf(screwieCursor);
				FlxTween.cancelTweensOf(hotrodCursor);
				FlxTween.cancelTweensOf(averageCursor);
				FlxTween.cancelTweensOf(clutchCursor);*/

				if (curSelected == 0){
					selectedText.color = FlxColor.WHITE;
					defaultCursor.visible = true;
					screwieCursor.visible = false;
					hotrodCursor.visible = false;
					averageCursor.visible = false;
					FlxTween.tween(defaultCursor, {x: 628}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
						isSwitching = false;
						mystCursor.visible = false;
						clutchCursor.visible = false;
					},
					});
					FlxTween.tween(mystCursor, {x: -1800}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					},
					});
					FlxTween.tween(luciCursor, {x: 1800}, 0.5, {ease: FlxEase.quartOut});
					} else if (curSelected == 1){
					selectedText.color = 0x00a2ff;
					mystCursor.visible = true;
					screwieCursor.visible = false;
					hotrodCursor.visible = false;
					averageCursor.visible = false;
					clutchCursor.visible = false;
					luciCursor.visible = false;
					FlxTween.tween(defaultCursor, {x: -1800}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
						isSwitching = false;
						defaultCursor.visible = false;
					},
					});
					FlxTween.tween(mystCursor, {x: posX}, 0.5, {ease: FlxEase.quartOut});
					} else if (curSelected == 2){
					selectedText.color = 0xb3ffac;
					defaultCursor.visible = false;
					screwieCursor.visible = true;
					hotrodCursor.visible = false;
					averageCursor.visible = false;
					clutchCursor.visible = false;
					luciCursor.visible = false;
					FlxTween.tween(screwieCursor, {x: posX}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
						isSwitching = false;
						mystCursor.visible = false;
					},
					});
					FlxTween.tween(mystCursor, {x: -1800}, 0.5, {ease: FlxEase.quartOut});
					} else if (curSelected == 3){
					selectedText.color = 0xff0000;
					defaultCursor.visible = false;
					mystCursor.visible = false;
					hotrodCursor.visible = true;
					averageCursor.visible = false;
					clutchCursor.visible = false;
					luciCursor.visible = false;
					FlxTween.tween(hotrodCursor, {x: posX}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
						isSwitching = false;
						screwieCursor.visible = false;
					},
					});
					FlxTween.tween(screwieCursor, {x: -1800}, 0.5, {ease: FlxEase.quartOut});
					} else if (curSelected == 4){
					selectedText.color = 0xb45f19;
					defaultCursor.visible = false;
					mystCursor.visible = false;
					screwieCursor.visible = false;
					averageCursor.visible = true;
					clutchCursor.visible = false;
					luciCursor.visible = false;
					FlxTween.tween(averageCursor, {x: posX}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
						isSwitching = false;
						hotrodCursor.visible = false;
					},
					});
					FlxTween.tween(hotrodCursor, {x: -1800}, 0.5, {ease: FlxEase.quartOut});
					} else if (curSelected == 5){
						selectedText.color = 0xff8585;
						defaultCursor.visible = true;
						mystCursor.visible = false;
						screwieCursor.visible = false;
						hotrodCursor.visible = false;
						clutchCursor.visible = true;
						luciCursor.visible = false;
					FlxTween.tween(clutchCursor, {x: posX}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
						isSwitching = false;
						averageCursor.visible = false;
					},
					});
					FlxTween.tween(averageCursor, {x: -1800}, 0.5, {ease: FlxEase.quartOut});
					} else if (curSelected == 6){
						selectedText.color = 0x853aff;
						defaultCursor.visible = true;
						mystCursor.visible = false;
						screwieCursor.visible = false;
						hotrodCursor.visible = false;
						clutchCursor.visible = false;
						luciCursor.visible = true;
					FlxTween.tween(luciCursor, {x: posX}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
						isSwitching = false;
						clutchCursor.visible = false;
					},
					});
					FlxTween.tween(clutchCursor, {x: -1800}, 0.5, {ease: FlxEase.quartOut});
					}
					if (ClientPrefs.middleMouseScroll){
					if(FlxG.mouse.wheel != 0)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
							changeSelection(-FlxG.mouse.wheel);
						}
					}
			}
			if (controls.ACCEPT) {
				FlxG.sound.play(Paths.sound('confirmMenu'));
				//for (i in 0...grpCursors.length) 
				/*for (i in 0...packsArray.length) {
					var item = packsArray.members[i];
					if (curSelected == i){
						item.alpha = 1;
					}*/
					if (curSelected == 0){
						FlxG.save.data.cursorSprite = 0;
					} else if (curSelected == 1){
						FlxG.save.data.cursorSprite = 1;
					} else if (curSelected == 2){
						FlxG.save.data.cursorSprite = 2;
					} else if (curSelected == 3){
						FlxG.save.data.cursorSprite = 3;
					} else if (curSelected == 4){
						FlxG.save.data.cursorSprite = 4;
					} else if (curSelected == 5){
						FlxG.save.data.cursorSprite = 5;
					} else if (curSelected == 6){
						FlxG.save.data.cursorSprite = 6;
					}
				//}
				//return;
				}
				if (controls.BACK) {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxG.switchState(new options.OptionsState());
				}
				super.update(elapsed);
			}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		/*if (curSelected < 0)
			curSelected = grpCursors.length-1;
		if (curSelected >= grpCursors.length)
			curSelected = 0;*/

		if (curSelected < 0)
			curSelected = packsArray.length - 1;
		if (curSelected >= packsArray.length)
			curSelected = 0;

        selectedText.text = packsArray[curSelected];

        switch(curSelected){
        case 0:
		//defaultCursor.visible = true;
		//mystCursor.visible = false;
		//screwieCursor.visible = false;
		//hotrodCursor.visible = false;
		//averageCursor.visible = false;
		//clutchCursor.visible = false;
        //FlxTween.cancelTweensOf(defaultBG);
		//FlxTween.cancelTweensOf(mystBG);
		//FlxTween.cancelTweensOf(screwieBG);
		//FlxTween.cancelTweensOf(hotrodBG);
		/*FlxTween.tween(defaultBG, {color: FlxColor.GRAY, alpha: 1}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(mystBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(screwieBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(hotrodBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});*/
        case 1:
		//defaultCursor.visible = false;
		//mystCursor.visible = true;
		//screwieCursor.visible = false;
		//hotrodCursor.visible = false;
		//averageCursor.visible = false;
		//clutchCursor.visible = false;
		 //FlxTween.cancelTweensOf(defaultBG);
		 //FlxTween.cancelTweensOf(mystBG);
		//FlxTween.cancelTweensOf(screwieBG);
		//FlxTween.cancelTweensOf(hotrodBG);
		/*FlxTween.tween(defaultBG, {color: FlxColor.CYAN, alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(mystBG, {color: FlxColor.CYAN, alpha: 1}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(screwieBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(hotrodBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});*/
		case 2:
		//defaultCursor.visible = false;
		//mystCursor.visible = false;
		//screwieCursor.visible = true;
		//hotrodCursor.visible = false;
		//averageCursor.visible = false;
		//clutchCursor.visible = false;
		FlxTween.cancelTweensOf(defaultBG);
		FlxTween.cancelTweensOf(mystBG);
		FlxTween.cancelTweensOf(screwieBG);
		FlxTween.cancelTweensOf(hotrodBG);
		/*FlxTween.tween(defaultBG, {color: 0xFF8EFF77, alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(mystBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(screwieBG, {alpha: 1}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(hotrodBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});*/
		case 3:
		//defaultCursor.visible = false;
		//mystCursor.visible = false;
		//screwieCursor.visible = false;
		//hotrodCursor.visible = true;
		//averageCursor.visible = false;
		//clutchCursor.visible = false;
		FlxTween.cancelTweensOf(defaultBG);
		FlxTween.cancelTweensOf(mystBG);
		FlxTween.cancelTweensOf(screwieBG);
		FlxTween.cancelTweensOf(hotrodBG);
		/*FlxTween.tween(defaultBG, {color: FlxColor.RED, alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(mystBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(screwieBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(hotrodBG, {color: FlxColor.RED, alpha: 1}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});*/
		case 4:
		//defaultCursor.visible = false;
		//mystCursor.visible = false;
		//screwieCursor.visible = false;
		//hotrodCursor.visible = false;
		//averageCursor.visible = true;
		//clutchCursor.visible = false;
		FlxTween.cancelTweensOf(defaultBG);
		FlxTween.cancelTweensOf(mystBG);
		FlxTween.cancelTweensOf(screwieBG);
		FlxTween.cancelTweensOf(hotrodBG);
		/*FlxTween.tween(defaultBG, {color: FlxColor.BROWN, alpha: 1}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(mystBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(screwieBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(hotrodBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});*/
		case 5:
		//defaultCursor.visible = false;
		//mystCursor.visible = false;
		//screwieCursor.visible = false;
		//hotrodCursor.visible = false;
		//averageCursor.visible = false;
		//clutchCursor.visible = true;
		FlxTween.cancelTweensOf(defaultBG);
		FlxTween.cancelTweensOf(mystBG);
		FlxTween.cancelTweensOf(screwieBG);
		FlxTween.cancelTweensOf(hotrodBG);
		/*FlxTween.tween(defaultBG, {color: 0xFFE67A7A, alpha: 1}, 0.5, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(mystBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(screwieBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});
		FlxTween.tween(hotrodBG, {alpha: 0}, 0, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween) {
					isSwitching = false;
				},
				});*/
        }

	/*	for (i in 0...grpCursors.length) {
			var item = grpCursors.members[i];
			selectedText.text = ;
			trace("selectedText.text: " + selectedText.text);
			item.alpha = 0.6;
			item.scale.set(0.75, 0.75);
			if (curSelected == i){
			item.alpha = 1;
			item.scale.set(1, 1);
			}
		}*/
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}
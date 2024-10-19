package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import lime.app.Application;
import flash.display.BitmapData;
import openfl.Assets;
import flixel.FlxState;


class GateTransition extends FlxSprite{
    public function new(x:Float,y:Float,anim:String){

    super(x, y);
    switch (anim)
    {
        case 'in':
        frames = Paths.getSparrowAtlas('transIn');
        case 'out':
        frames = Paths.getSparrowAtlas('transOut');
    }


    
    antialiasing = true;
    animation.addByPrefix('GateTransition','loading anim',24,false);

    }

    override function update(elapsed:Float){

    super.update(elapsed);

    }

}
function onCreate()
	-- background shit

	makeLuaSprite('shadowstage', 'shadowstage', 350, -300);
	setLuaSpriteScrollFactor('shadowstage', 1.0, 1.0);
	scaleObject('shadowstage', 1.2, 1.2);	


	addLuaSprite('shadowstage', false);


	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end
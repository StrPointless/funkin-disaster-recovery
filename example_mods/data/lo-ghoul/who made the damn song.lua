function onCreatePost() 
    makeLuaText("message", "Cover by : Lucile (Luci)", 500, 1000, 50)
    setTextAlignment("message", "left")
    addLuaText("message")

    if getPropertyFromClass('ClientPrefs', 'downScroll') == false then
        setProperty('message.y', 680)
        setProperty('engineText.y', 660)
    end
end
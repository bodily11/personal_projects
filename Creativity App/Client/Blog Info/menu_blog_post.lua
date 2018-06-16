local composer = require( "composer" )
local mui = require( "materialui.mui" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view

    display.setDefault("background", 0,0,0)
    background = display.newRect( 0, 0, display.contentWidth, display.contentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x, background.y = 0, 0
    background:setFillColor( 0,0.6,1,1 )
    sceneGroup:insert( background )
    
    mui.init()
    
    
    local function handleButtonEvent( event )
        composer.removeScene("menu")
        composer.gotoScene("choose_level_type", { effect = "crossFade", time = 500 } )
        return true
    end

    local function handleButtonEvent2( event )
        composer.removeScene("menu")
        composer.gotoScene("settings", { effect = "crossFade", time = 500 } )
        return true
    end

    local function handleButtonEvent3( event )
        composer.removeScene("menu")
        composer.gotoScene("help", { effect = "crossFade", time = 500 } )
        return true
    end
    
    textOptions = {
    parent = sceneGroup,
    y = mui.getScaleVal(140),
    x = display.contentWidth / 2,
    name = "title-main",
    text = "My Title Here",
    align = "center",
    width = mui.contentWidth,
    font = native.systemFontBold,
    fontSize = mui.getScaleVal(65),
    fillColor = { 1, 1, 1, 1 },
}
    local title = mui.newText(textOptions)
    
    local button1 = mui.newRoundedRectButton({
        parent = sceneGroup,
        name = "play",
        text = "Play",
        width = mui.getScaleVal(400),
        height = mui.getScaleVal(100),
        x = display.contentWidth/2,
        y = mui.getScaleVal(320),
        font = native.systemFont,
        fillColor = { 1,1,1 },
        textColor = { .4,.4,.4 },
        callBack = handleButtonEvent,
    })
    
    local button2 = mui.newRoundedRectButton({
        parent = sceneGroup,
        name = "settings",
        text = "Settings",
        width = mui.getScaleVal(400),
        height = mui.getScaleVal(100),
        x = display.contentWidth/2,
        y = mui.getScaleVal(500),
        font = native.systemFont,
        fillColor = { 1,1,1 },
        textColor = { .4,.4,.4 },
        callBack = handleButtonEvent2,
    })
    
    local button3 = mui.newRoundedRectButton({
        parent = sceneGroup,
        name = "Help",
        text = "Help",
        width = mui.getScaleVal(400),
        height = mui.getScaleVal(100),
        x = display.contentWidth/2,
        y = mui.getScaleVal(680),
        font = native.systemFont,
        fillColor = { 1,1,1 },
        textColor = { .4,.4,.4 },
        callBack = handleButtonEvent3,
    })
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    local params = event.params
    
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    mui.destroy()
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene
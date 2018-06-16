local composer = require( "composer" )
local mui = require( "materialui.mui" )
local scene = composer.newScene()
local json = require( "json" )
local loadsave = require( "loadsave" )
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
    
    mui.init()
    numberVote = event.params["numberVote"]
    levelType = event.params["levelType"]
    levelDifficulty = event.params["levelDiff"]
    finalLevelNumber = event.params["finalLevelNumber"]
    display.setDefault("background", 0,0,0)
    background = display.newRect( 0, 0, display.contentWidth, display.contentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x, background.y = 0, 0
    background:setFillColor( 0,0.6,1,1 )
    sceneGroup:insert( background )
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
    composer.removeScene("pick_top_one_between")
    composer.gotoScene("pick_top_one", { effect = "crossFade", time = 500, params = {finalLevelNumber = finalLevelNumber, numberVote = numberVote, levelType = levelType, levelDiff = levelDifficulty}} )
 
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
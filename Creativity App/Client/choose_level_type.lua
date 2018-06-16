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
    userSession = loadsave.loadTable("userSession.json")
    local sceneGroup = self.view
    
    mui.init()
    
    
    local function handleButtonEvent( event )
        if ( "grid_demo2-tile-1" == event.name ) then
            composer.removeScene( "choose_level_type" )
            composer.gotoScene("difficulty", { effect = "crossFade", time = 500, params = {levelType = "tools"} } )
            return true
        elseif ( "grid_demo2-tile-2" == event.name ) then
            composer.removeScene( "choose_level_type" )
            composer.gotoScene("difficulty", { effect = "crossFade", time = 500, params = {levelType = "associations"} } )
            return true
        elseif ( "grid_demo2-tile-3" == event.name ) then
            composer.removeScene( "choose_level_type" )
            composer.gotoScene("difficulty", { effect = "crossFade", time = 500, params = {levelType = "solutions"} } )
            return true
        elseif ( "grid_demo2-tile-4" == event.name ) then
            composer.removeScene( "choose_level_type" )
            composer.gotoScene("difficulty", { effect = "crossFade", time = 500, params = {levelType = "problems"} } )
            
        end
    end
    
    local tilegrid = mui.newTileGrid({
	parent = sceneGroup,
    name = "grid_demo2",
	width = mui.contentWidth,
	height = mui.contentHeight,
	tileHeight = mui.getScaleVal(285),
	tilesPerRow = 2,
	x = 0,
	y = 0,
	iconFont = "MaterialIcons-Regular.ttf",
	labelFont = native.systemFont,
	textColor = { 1, 1, 1 },
	labelColor = { 1, 1, 1 },
	fillColor = { 0.8, 0.8, 0.8, 0.8 }, -- background color overall
	tileFillColor = {0,0.6,1,1}, -- #F47B00 background color of tiles
	touchpoint = false,
	callBack = handleButtonEvent,
	clickAnimation = {
		style = "highlight", -- highlight, spin, rubberband
		highlightColor = { 0, 0.5, 1 },
		highlightColorAlpha = 0.5,
		time = 400,
	}, 
	list = {
		{ key = "tools", value = "5", icon="laptop", parent = sceneGroup, labelText="Explore Tools", tileFillColor = {0,0.6,1,1}, isActive = false },
        { key = "associations", value = "2", icon="device_hub", parent = sceneGroup, labelText="Make Associations", tileFillColor = {0,0.6,1,1}, isActive = false },
        { key = "solutions", value = "7", icon="done", parent = sceneGroup, labelText="Find Solutions", tileFillColor = {0,0.6,1,1}, isActive = false },
        { key = "problems", value = "8", icon="error_outline", parent = sceneGroup, labelText="Find Problems", tileFillColor = {0,0.6,1,1}, isActive = false },
        --{ key = "stories", value = "1", icon="record_voice_over", parent = sceneGroup, labelText="Stories", tileFillColor = {0,0.6,1,1}, isActive = false },
		--{ key = "doodles", value = "3", icon="brush", parent = sceneGroup, labelText="Doodles", tileFillColor = {0,0.6,1,1}, isActive = false },
		--{ key = "observations", value = "4", icon="search", parent = sceneGroup, labelText="Observations", tileFillColor = {0,0.6,1,1}, isActive = false },
		--{ key = "impossibilities", value = "6", icon="lightbulb_outline", parent = sceneGroup, labelText="Impossibilities", tileFillColor = {0,0.6,1,1}, isActive = false },
		
	}
})
    
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
    sceneGroup:removeSelf()
    sceneGroup = nil
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
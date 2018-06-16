local composer = require( "composer" )
local mui = require( "materialui.mui" )
local scene = composer.newScene()
local widget = require( "widget" )
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
    levelType = event.params["levelType"]
    mui.init()
    
    local function handleButtonEvent( event )
        composer.removeScene("choose_level")
        composer.gotoScene( levelType,{ effect = "fade", time = 500 ,params = {levelName = event.name, levelType = levelType}})
        return true
        end

    
    list2 = {}
    for i = 1,50,1 
    do
        table.insert(list2,{key = tostring(i), value = tostring(i), name = tostring(i), labelText= tostring(i), tileFillColor = {0,0.6,1,1}, isActive = false })
    end
    
    local tilegrid = mui.newTileGrid({
	parent = sceneGroup,
    name = "choose_level",
	width = mui.contentWidth,
	height = mui.contentHeight,
	tileHeight = mui.getScaleVal(125),
	tilesPerRow = 5,
	x = 0,
	y = 0,
	iconFont = "MaterialIcons-Regular.ttf",
	labelFont = native.systemFont,
    fontIsScaled = false,
    fontSize = 100,
    textColor = { 1, 1, 1 },
	labelColor = { 1, 1, 1 },
	fillColor = { 0.8, 0.8, 0.8, 0.8 }, -- background color overall
	tileFillColor = { 1, 0.5, 0, 1 }, -- #F47B00 background color of tiles
	touchpoint = false,
	callBack = handleButtonEvent,
	clickAnimation = {
		style = "highlight", -- highlight, spin, rubberband
		highlightColor = { 0, 0.5, 1 },
		highlightColorAlpha = 0.5,
		time = 400,
	},
	list = list2
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
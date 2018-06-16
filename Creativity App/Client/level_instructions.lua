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
    userSession = loadsave.loadTable("userSession.json")
    local sceneGroup = self.view
    levelType = event.params["levelType"]
    levelDifficulty = event.params["difficulty"]
    mui.init()
    
    local function handleButtonEvent( event )
        
        math.randomseed(os.time())
        math.random(); math.random(); math.random()
        levelName = tostring(math.random(1))
        composer.removeScene("level_instructions")
        composer.gotoScene( levelType ,{ effect = "fade", time = 500 ,params = {levelName = levelName, levelType = levelType, difficulty = levelDifficulty}})
        end

    display.setDefault("background", 0, 0, 0)
    background = display.newRect( 0, 0, display.contentWidth, display.contentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x, background.y = 0, 0
    background:setFillColor( 0,0.6,1,1 )
    sceneGroup:insert( background )
    
    textOptions = {
    parent = sceneGroup,
    y = mui.getScaleVal(140),
    x = display.contentWidth / 2,
    name = "level-instructions-title",
    text = "Level Instructions",
    align = "center",
    width = mui.contentWidth,
    font = native.systemFontBold,
    fontSize = mui.getScaleVal(65),
    fillColor = { 1, 1, 1, 1 },
}
    local title = mui.newText(textOptions)
    
    local path = system.pathForFile( levelDifficulty.."-"..levelType.."-instructions.txt", system.ResourceDirectory )
         
    -- Open the file handle
    local file, errorString = io.open( path, "r" )
    local fileLines = {} 
    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else
        -- Output lines
        level_prompt = file:lines()
        for line in file:lines() do
            table.insert( fileLines,line )
        end
        -- Close the file handle
        
        io.close( file )
    end
    
    file = nil
    instructions_text = fileLines[1]
    
    textOptions2 = {
    parent = sceneGroup,
    y = mui.getScaleVal(500),
    x = display.contentWidth / 2,
    name = "level-instructions",
    text = instructions_text,
    align = "justify",
    width = display.contentWidth - mui.getScaleVal(40),
    font = native.systemFontBold,
    fontSize = mui.getScaleVal(55),
    fillColor = { 1, 1, 1, 1 },
}
    local instructions = mui.newText(textOptions2)
    
    local button = mui.newRoundedRectButton({
        parent = sceneGroup,
        name = "continue",
        text = "Continue",
        width = mui.getScaleVal(400),
        height = mui.getScaleVal(100),
        x = display.contentWidth/2,
        y = display.contentHeight - mui.getScaleVal(150),
        font = native.systemFont,
        fillColor = { 1,1,1 },
        textColor = { .4,.4,.4 },
        callBack = handleButtonEvent,
    })
    
    --[[list2 = {}
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
})--]]
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
    --composer.removeScene("tile_five")
    mui.destroy()
    sceneGroup:removeSelf()
    sceneGroup = nil
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
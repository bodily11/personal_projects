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
    
    userSession = loadsave.loadTable("userSession.json")
    levelID = tostring(event.params["finalLevelNumber"])
    levelType = event.params["levelType"]
    levelDifficulty = event.params["levelDiff"]
    display.setDefault("background", 0,0,0)
    background = display.newRect( 0, 0, display.contentWidth, display.contentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x, background.y = 0, 0
    background:setFillColor( 0,0.6,1,1 )
    sceneGroup:insert( background )
    
    function round(num, numDecimalPlaces)
      local mult = 10^(numDecimalPlaces or 0)
      return math.floor(num * mult + 0.5) / mult
    end
    
    function networkListener( event )
        user_stats = json.decode(event.response)
        if user_stats == nil then
            user_stats = {}
            user_stats.likes = '...'
            user_stats.quantity = '...'
            user_stats.detail = '...'
            user_stats.categories = '...'
            user_stats.rarity = '...'
        end
        textOptions = {
            parent = sceneGroup,
            y = mui.getScaleVal(100),
            x = display.contentWidth / 2,
            name = "title-main",
            text = "Your Level Scores",
            align = "center",
            width = mui.contentWidth,
            font = native.systemFontBold,
            fontSize = mui.getScaleVal(65),
            fillColor = { 1, 1, 1, 1 },
            }
        local title = mui.newText(textOptions)
        
        mui.newTableView({
            parent = sceneGroup,
            name = "respTable",
            width = mui.getScaleVal(600),
            height = mui.getScaleVal(620),
            top = mui.getScaleVal(200),
            left = 20,
            font = native.systemFont,
            fontSize = mui.getScaleVal(55),
            textColor = { 0, 0, 0, 1 },
            lineColor = { 1, 1, 1, 1 },
            lineHeight = mui.getScaleVal(3),
            rowColor = {1, 1, 1, 1}, --{ default={1,1,1}, over={1,0.5,0,0.2} },
            rowHeight = mui.getScaleVal(100),
            -- rowAnimation = false, -- turn on rowAnimation
            noLines = false,
            isLocked = false,
            --callBackTouch = mui.onRowTouchDemo,
            callBackRender = mui.onRowRenderDemo,
            --scrollListener = mui.scrollListener,  -- needed if using buttons, etc within the row!
            list = { -- if 'key' use it for 'id' in the table row
                
                { key = "Row5",text = "Row 5", value = "5", isCategory = true, columns = {
                        { text = "Category", value = "5A", align = "center" },
                        { text = "Score", value = "5Aa", align = "center" },
                    },
                },
                                
                { key = "Row5", text = "Row 5", value = "5", isCategory = false, columns = {
                        { text = " Number", value = "5A", align = "center" },
                        { text = user_stats.quantity, value = "5Aa", align = "center" },
                    },
                },
                { key = "Row6", text = "Row 6", value = "6", isCategory = false, columns = {
                        { text = " Length", value = "6A", align = "center" },
                        { text = user_stats.detail, value = "6B", align = "center" },
                    },
                },
                { key = "Row7", text = "Row 7", value = "7", isCategory = false, columns = {
                        { text = " Categories", value = "7A", align = "center" },
                        { text = user_stats.categories, value = "7B", align = "center" },
                    },
                },
                { key = "Row7", text = "Row 7", value = "7", fillColor = {0.83,0.83,0.83,1}, isCategory = false, columns = {
                        { text = " Rarity", value = "7A", align = "center" },
                        { text = user_stats.rarity, value = "7B", align = "center" },
                    },
                },
                { key = "Row8", text = "Row 8", value = "8", fillColor = {0.83,0.83,0.83,1}, isCategory = false, columns = {
                        { text = " Likes", value = "7A", align = "center" },
                        { text = user_stats.likes, value = "7B", align = "center" },
                    },
                },
            },
            columnOptions = {
                widths = { mui.getScaleVal(300), mui.getScaleVal(300)}, -- must supply each else "auto" is assumed.
            },
            categoryColor = { default={0.8,0.8,0.8,0.8} },
            categoryLineColor = { 1, 1, 1, 0 },
            touchpointColor = { 0.4, 0.4, 0.4 },
    })
    function continueNextScene( event )
        if ( event.phase == "onTarget" ) then
        composer.removeScene("level_stats")
        composer.gotoScene("leaderboard", { effect = "crossFade", time = 500, params = {finalLevelNumber = finalLevelNumber, levelType = levelType, levelDiff = levelDifficulty}} )
        end
    end
    
    mui.newRoundedRectButton({
        parent = sceneGroup,
        name = "continue",
        text = "Continue",
        width = mui.getScaleVal(350),
        height = mui.getScaleVal(80),
        radius = mui.getScaleVal(20),
        x = display.contentWidth/2,
        y = mui.getScaleVal(925),
        font = native.systemFont,
        fillColor = { 1,1,1,1 },
        textColor = { 0, .6, 1, 1},
        touchpoint = true,
        callBack = continueNextScene,
    })
            
            
        
    end
    network.request( "https://www.yourcreativitygym.com/getuserstats?levelType=" .. levelType .. "&levelID=" .. levelID .. "&levelDiff=" .. levelDifficulty .. "&userID=" .. userSession.username, "GET", networkListener )
    
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
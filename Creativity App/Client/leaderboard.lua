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
    levelID = tostring(event.params["finalLevelNumber"])
    levelType = event.params["levelType"]
    levelDifficulty = event.params["levelDiff"]
    local sceneGroup = self.view
    
    mui.init()
    
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
        --print(user_stats.likes)
        --print(user_stats.quantity)
        --print(user_stats.detail)
        
        textOptions = {
            parent = sceneGroup,
            y = mui.getScaleVal(100),
            x = display.contentWidth / 2,
            name = "title-main2",
            text = "Level Leaderboard",
            align = "center",
            width = mui.contentWidth,
            font = native.systemFontBold,
            fontSize = mui.getScaleVal(65),
            fillColor = { 1, 1, 1, 1 },
            }
            local title = mui.newText(textOptions)
        
        local list_options = {
                        { key = "Row5",text = "Row 5", value = "5", isCategory = true, columns = {
                                        { text = "Username", value = "5A", align = "center" },
                                        { text = "Creativity Score", value = "5Aa", align = "center" },
                                        },
                        }
        }
        
        function compare(a,b)
          return a[2] > b[2]
        end
        
        user_scores = {}
        --if no responses
        if user_stats == nil then
        --if one response
        elseif user_stats.likes then
            x = user_stats
            local user_score = (tonumber(x.quantity) + tonumber(x.detail) + tonumber(x.rarity) + tonumber(x.categories)) * (tonumber(x.likes) + 1)
            local user_score = round(user_score,0)
            table.insert(user_scores,{userSession.username,user_score})
        --if more than one response
        else
            for i,x in ipairs(user_stats) do
                local user_score = (tonumber(x.quantity) + tonumber(x.detail) + tonumber(x.rarity) + tonumber(x.categories)) * (tonumber(x.likes) + 1)
                user_score = round(user_score,0)
                table.insert(user_scores,{userSession.username,tostring(user_score)})
            end
        end
        
        table.sort(user_scores,compare)
        if user_scores == nil then
            --if one response
        else
            for i,x in pairs(user_scores) do
                table.insert(list_options,{ key = "Row5", text = "Row 5", value = "5", isCategory = false, columns = {
                            { text = "  "..x[1], value = "5A", align = "left" },
                            { text = x[2], value = "5Aa", align = "center" },
                        }})
            end
        end
        mui.newTableView({
            parent = sceneGroup,
            name = "responseTable",
            width = mui.getScaleVal(600),
            height = mui.getScaleVal(630),
            top = mui.getScaleVal(200),
            left = 20,
            font = native.systemFont,
            fontSize = mui.getScaleVal(55),
            textColor = { 0, 0, 0, 1 },
            lineColor = { 1, 1, 1, 1 },
            lineHeight = mui.getScaleVal(3),
            rowColor = {1, 1, 1, 1}, --{ default={1,1,1}, over={1,0.5,0,0.2} },
            rowHeight = mui.getScaleVal(150),
            -- rowAnimation = false, -- turn on rowAnimation
            noLines = false,
            isLocked = false,
            --callBackTouch = mui.onRowTouchDemo,
            callBackRender = mui.onRowRenderDemo,
            --scrollListener = mui.scrollListener,  -- needed if using buttons, etc within the row!
            list = list_options, --[[{ -- if 'key' use it for 'id' in the table row
                
                { key = "Row5",text = "Row 5", value = "5", isCategory = true, columns = {
                        { text = "Category", value = "5A", align = "center" },
                        { text = "Score", value = "5Aa", align = "center" },
                    },
                },
                                
                { key = "Row5", text = "Row 5", value = "5", isCategory = false, columns = {
                        { text = " Quantity", value = "5A", align = "center" },
                        { text = user_stats.quantity, value = "5Aa", align = "center" },
                    },
                },
                { key = "Row6", text = "Row 6", value = "6", isCategory = false, columns = {
                        { text = " Detail", value = "6A", align = "center" },
                        { text = round(tonumber(user_stats.detail),0), value = "6B", align = "center" },
                    },
                },
                { key = "Row7", text = "Row 7", value = "7", isCategory = false, columns = {
                        { text = " Quality", value = "7A", align = "center" },
                        { text = user_stats.likes, value = "7B", align = "center" },
                    },
                },
            },--]]
            columnOptions = {
                widths = { mui.getScaleVal(300), mui.getScaleVal(300)}, -- must supply each else "auto" is assumed.
            },
            categoryColor = { default={0.8,0.8,0.8,0.8} },
            categoryLineColor = { 1, 1, 1, 0 },
            touchpointColor = { 0.4, 0.4, 0.4 },
    })
    function continueNextScene( event )
        composer.removeScene("leaderboard")
        composer.gotoScene("menu", { effect = "crossFade", time = 500, params = {finalLevelNumber = finalLevelNumber}} )
    end
    
    mui.newRoundedRectButton({
        parent = sceneGroup,
        name = "leaderboardcontinue",
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
    
    network.request( "https://www.yourcreativitygym.com/getlevelleaderboard?levelType=" .. levelType .. "&levelID=" .. levelID .. "&levelDiff=" .. levelDifficulty, "GET", networkListener )
    
end
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    
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
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
    local phase = event.phase
    local params = event.params
    levelID = tostring(event.params["finalLevelNumber"])
    levelType = event.params["levelType"]
    levelDifficulty = event.params["levelDiff"]
    print(levelType)
    numberVote = event.params["numberVote"]
    numberVote = numberVote + 1
    mui.init()
    
    function string.urlEncode( str )
        if ( str ) then
            str = string.gsub( str, "\n", "\r\n" )
            str = string.gsub( str, "([^%w ])",
            function (c) return string.format( "%%%02X", string.byte(c) ) end )
                str = string.gsub( str, " ", "+" )
            end
    return str
    end
    
    likedResponses = {}
    local function networkListener( event )
 
        print(event.response)
        if ( event.isError ) then
            print( "Network error: ", event.response )
        else
            t = json.decode(event.response)
            
            count = 0
            finalResponsesDisplayTable = {}
            for i,x in pairs(t) do
                if x["responseText"] ~= nil then
                    count = count + 1
                    textResponse = x["responseText"]
                else textResponse = ""
                end
                table.insert(finalResponsesDisplayTable,1,{ key = x["responseID"], text = textResponse, value = x["responseID"], isCategory = false })
            end
            
            if count < 10 then
                composer.removeScene( "pick_top_one" )
                composer.gotoScene("level_stats_between", { effect = "crossFade", time = 500, params = {finalLevelNumber = finalLevelNumber, levelType = levelType, levelDiff = levelDifficulty}} )
            else
            end
            
            function addToSet(set, key)
                set[key] = true
            end
            
            chosen = {}
            for i,x in pairs(t) do
                responseID = x["responseID"]
                addToSet(chosen,responseID)
            end
            
            function tableTouch(event)
                local muiTarget = mui.getEventParameter(event, "muiTarget")
                local muiTargetValue = mui.getEventParameter(event, "muiTargetValue")
                local muiTargetIndex = mui.getEventParameter(event, "muiTargetIndex")
                local muiTargetRowParams = mui.getEventParameter(event, "muiTargetRowParams")
                local muiTableView = mui.getEventParameter(event, "muiTableView")

                function addToSet(set, key)
                    set[key] = true
                end

                function removeFromSet(set, key)
                    set[key] = nil
                end

                function setContains(set, key)
                    return set[key] ~= nil
                end
                
                local tableViewRows = nil
                if muiTableView ~= nil then
                    tableViewRows = muiTableView._view._rows
                end
                if muiTargetIndex ~= nil and tableViewRows ~= nil then
                    for k, row in ipairs(tableViewRows) do
                        if k == muiTargetIndex then
                            row.params.rowColor = { 0,0.6,1,.5 }
                            addToSet(likedResponses, row.id)
                        else
                            row.params.rowColor = { 1, 1, 1, 1 }
                            removeFromSet(likedResponses, row.id)
                        end
                    end
                    muiTableView:reloadData()
                end
            end
        end    
            
        tableOptions = {
        parent = sceneGroup,
        name = "responseTable",
        width = mui.getScaleVal(610),
        height = mui.getScaleVal(800),
        top = mui.getScaleVal(100),
        left = mui.getScaleVal(15),
        font = native.systemFont,
        textColor = { 0, 0, 0, 1 },
        lineColor = { 1, 1, 1, 1 },
        lineHeight = mui.getScaleVal(4),
        rowColor = { 1,1,1,1 },
        rowHeight = mui.getScaleVal(80),
        -- rowAnimation = false, -- turn on rowAnimation
        noLines = false,
        callBackTouch = tableTouch,
        callBackRender = mui.onRowRenderDemo,
        scrollListener = mui.scrollListener,  -- needed if using buttons, etc within the row!
        isLocked = false,
        list = finalResponsesDisplayTable,
        --categoryColor = { default={0.8,0.8,0.8,0.8} },
        categoryLineColor = { 1, 1, 1, 1 },
        touchpointColor = { 1, 1, 1 },
        }
    
        responseTableVariable2 = mui.newTableView(tableOptions)
        end 

    network.request( "https://www.yourcreativitygym.com/getrandomten?levelType=" .. levelType .. "&levelID=" .. levelID .. "&levelDiff=" .. levelDifficulty, "GET", networkListener )
    
    
    display.setDefault("background", 0,0,0)
    background = display.newRect( 0, 0, display.contentWidth, display.contentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x, background.y = 0, 0
    background:setFillColor( 0,0.6,1,1 )
    sceneGroup:insert( background )
    
    --[[mui.newRoundedRectButton({
        parent = sceneGroup,
        name = "submitresponse",
        text = "Submit",
        width = mui.getScaleVal(150),
        height = mui.getScaleVal(60),
        radius = mui.getScaleVal(10),
        x = mui.getScaleVal(550),
        y = mui.getScaleVal(50),
        font = native.systemFont,
        fillColor = { 1,1,1,1 },
        textColor = { 0, .6, 1, 1},
        touchpoint = true,
        callBack = setTimeToZero,
    })--]]
    
end
 
-- show()
function scene:show( event )
    
    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        local secondsLeft = .25 * 60    -- 20 minutes * 60 seconds

        --function setTimeToZero ( event )
        --    secondsLeft = 0
        --end
        
        local clockText = display.newText(
            "00:15",
            mui.getScaleVal(100), 
            mui.getScaleVal(50), 
            native.systemFont, 
            mui.getScaleVal(60))
        clockText:setFillColor( 1,1,1,1 )
        sceneGroup:insert( clockText )
        local function updateTime()
            -- decrement the number of seconds
            secondsLeft = secondsLeft - 1
            if secondsLeft <= 0 then
                
                local likedResponseString = ''
                for i,x in pairs(likedResponses) do
                    likedResponseString = likedResponseString .. "&responseID=" .. i:urlEncode()
                end
                
                local chosenResponseString = ''
                for i,x in pairs(chosen) do
                    chosenResponseString = chosenResponseString .. "&responseID=" .. i:urlEncode()
                end
                
                --THIS IS SUBMITTING CHOSENS
                local headers = {}
                
                headers["Content-Type"] = "application/x-www-form-urlencoded"
                headers["Accept-Language"] = "en-US"
                  
                local body = chosenResponseString .. "&type_of_like=chances"
                
                userID = userSession.username
                levelID = tostring(event.params["finalLevelNumber"])
                levelType = event.params["levelType"]
                
                local params = {}
                params.headers = headers
                params.body = body
                  
                network.request( "https://yourcreativitygym.com/submitlike", "POST", params )
                
                
                
                --THIS IS SUBMITTING LIKES
                local headers = {}
                
                headers["Content-Type"] = "application/x-www-form-urlencoded"
                headers["Accept-Language"] = "en-US"
                  
                local body = likedResponseString .. "&type_of_like=likes"
                
                userID = userSession.username
                levelID = tostring(event.params["finalLevelNumber"])
                levelType = event.params["levelType"]
                
                local params = {}
                params.headers = headers
                params.body = body
                  
                network.request( "https://yourcreativitygym.com/submitlike", "POST", params )
                --
                
                if ( numberVote == 5 ) then
                    composer.removeScene( "pick_top_one" )
                    composer.gotoScene("level_stats_between", { effect = "crossFade", time = 500, params = {finalLevelNumber = finalLevelNumber, levelType = levelType, levelDiff = levelDifficulty}} )
                else
                    composer.removeScene( "pick_top_one" )
                    composer.gotoScene("pick_top_one_between", { effect = "crossFade", time = 500, params = {finalLevelNumber = finalLevelNumber,numberVote = numberVote, levelType = levelType, levelDiff = levelDifficulty }} )
                end
            end
            -- time is tracked in seconds.  We need to convert it to minutes and seconds
            local minutes = math.floor( secondsLeft / 60 )
            local seconds = secondsLeft % 60
            
            -- make it a string using string format.  
            local timeDisplay = string.format( "%02d:%02d", minutes, seconds )
            clockText.text = timeDisplay
        end

        -- run them timer
        local countDownTimer = timer.performWithDelay( 1000, updateTime, secondsLeft )
        
        
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        mui.removeTableView("responseTable")
    
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
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
    levelType = event.params["levelType"]
    
    local sceneGroup = self.view
    
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
    
    
    
    responseText = ""
    responsesTable = {}
    responsesDisplayTable = {}
    responsesCurrentCount = 0
    function sendResponseToDatabase( event )
        
        --send response to database with user database
        local responseText = mui.getWidgetProperty("response","value")
        if responseText == "" then
        else
            table.insert(responsesTable,1,responseText)
            table.insert(responsesDisplayTable,1,{ key = responseText, text = responseText, value = "1", isCategory = false })
            --print(table.getn(responsesTable))
            
            --
            --SAVE data locally here
            --
            
            responsesCurrentCount = responsesCurrentCount + 1
            responseDisplay = string.format( "%02d", responsesCurrentCount )
            responseCount.text = responseDisplay
            
        end
        --for x,y in pairs(responsesDisplayTable) do
        --    for w,z in pairs(y) do
        --        print(w,z)
        --    end
        --end
        
        mui.removeTableView("responseTable")
        
        tableOptions = {
            parent = sceneGroup,
            name = "responseTable",
            width = mui.getScaleVal(610),
            height = mui.getScaleVal(440),
            top = mui.getScaleVal(685),
            left = mui.getScaleVal(15),
            font = native.systemFont,
            textColor = { 0, 0, 0, 1 },
            lineColor = { 0, 0, 0, 1 },
            lineHeight = mui.getScaleVal(4),
            rowColor = { 1,1,1,1 },
            rowHeight = mui.getScaleVal(60),
            -- rowAnimation = false, -- turn on rowAnimation
            noLines = false,
            callBackTouch = mui.onRowTouchDemo,
            callBackRender = mui.onRowRenderDemo,
            scrollListener = mui.scrollListener,  -- needed if using buttons, etc within the row!
            list = responsesDisplayTable,
            --categoryColor = { default={0.8,0.8,0.8,0.8} },
            categoryLineColor = { 1, 1, 1, 1 },
            touchpointColor = { 1, 1, 1 },
        }
        
        responseTableVariable = mui.newTableView(tableOptions)
        
        mui.removeTextBox("response")
        textBoxResponse = mui.newTextBox({
            parent = sceneGroup,
            name = "response",
            labelText = "",
            text = "",
            activeColor = { 0, 0, 0, 1},
            width = display.contentWidth * .95,
            height = mui.getScaleVal(200),
            font = native.systemFont,
            fontSize = mui.getScaleVal(60),
            --callBack = textListener,
            x = display.contentWidth / 2,
            y = mui.getScaleVal(550), 
            fillColor = { 1, 1, 1 },
            isEditable = true,
    })
        --native.setKeyboardFocus( textBoxResponse )


        --local textResponse = mui.getWidgetByName( "response")
        --textResponse.options.labelText = "HAHAHAHA!"
        
        --for k, v in pairs( textResponse.options ) do
        --    print(k, v)
        --end
        --print(mui.getWidgetProperty("response", "value"))
    end

    display.setDefault("background", 0, 0, 0)
    background = display.newRect( 0, 0, display.contentWidth, display.contentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x, background.y = 0, 0
    background:setFillColor( 0,0.6,1,1 )
    sceneGroup:insert( background )
    
    textBoxResponse = mui.newTextBox({
        parent = sceneGroup,
        name = "response",
        labelText = "",
        text = "",
        activeColor = { 0, 0, 0, 1},
        width = display.contentWidth * .95,
        height = mui.getScaleVal(200),
        font = native.systemFont,
        fontSize = mui.getScaleVal(60),
        x = display.contentWidth / 2,
        y = mui.getScaleVal(550), 
        fillColor = { 1, 1, 1 },
        isEditable = true,
    })
    --native.setKeyboardFocus( textBoxResponse )
    
    mui.newRoundedRectButton({
        parent = sceneGroup,
        name = "submitresponse",
        text = "Add",
        width = mui.getScaleVal(150),
        height = mui.getScaleVal(60),
        radius = mui.getScaleVal(10),
        x = display.contentWidth / 2,
        y = mui.getScaleVal(390),
        font = native.systemFont,
        fillColor = { 1,1,1,1 },
        textColor = { 0, .6, 1, 1},
        touchpoint = true,
        callBack = sendResponseToDatabase,
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
        local secondsLeft = 1 * 60    -- 20 minutes * 60 seconds

        local clockText = display.newText(
            "03:00", 
            mui.getScaleVal(100), 
            mui.getScaleVal(50), 
            native.systemFont, 
            mui.getScaleVal(60))
        clockText:setFillColor( 1,1,1,1 )
        sceneGroup:insert( clockText )
        local function updateTime()
            -- decrement the number of seconds
            secondsLeft = secondsLeft - 1
            if secondsLeft == 0 then
                
                --
                --SEND data to database HERE
                --
                --for response in responsesTable do
                --
                local responseString = ""
                for i,x in pairs(responsesTable)
                do
                    responseString = responseString .. "&response=" .. x:urlEncode()
                end
                userID = userSession.username
                levelID = tostring(finalLevelNumber)
                levelType = event.params["levelType"]
                
                local function networkListener23( event )
 
                    if ( event.isError ) then
                        print( "Network error: ", event.response )
                    else
                        print ( "Upload complete!" )
                    end
                end
                
                local headers = {}
                
                headers["Content-Type"] = "application/x-www-form-urlencoded"
                headers["Accept-Language"] = "en-US"
                  
                local body = "userID=" .. userID .. "&levelID=" .. levelID .. "&levelType=" .. levelType .. "&levelDiff=" .. levelDifficulty .. responseString
                 
                local params = {}
                params.headers = headers
                params.body = body
                  
                network.request( "https://yourcreativitygym.com/submitresponse", "POST", networkListener23, params )
                composer.removeScene( "solutions" )
                composer.gotoScene("pick_best_three_between", { effect = "crossFade", time = 500, params = {finalLevelNumber = finalLevelNumber, levelType = levelType}} )
                
                --print("Time is up!") --run function that ends the level/scene
                --for x,y in pairs(responsesTable) do
                --    print(x,y)
                --end
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
        
        textOptions = {
            parent = sceneGroup,
            y = mui.getScaleVal(580),
            x = display.contentWidth / 2,
            name = "title-main",
            text = "# of ideas: ",
            align = "center",
            width = display.contentWidth*.9,
            font = native.systemFontBold,
            fontSize = mui.getScaleVal(50),
            fillColor = { 1, 1, 1, 1 },
        }
        
        --local title = mui.newText(textOptions)

        --get level details from local file
        --this is the only thing that changes between levels
        --maybe we have a table with a level number and tool name
        --then I can use this level for all 100 levels
        
        finalLevelNumber = tonumber(event.params["levelName"])
        local path = system.pathForFile( levelDifficulty .. "-" .. levelType .. "-levels.txt", system.ResourceDirectory )
         
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
        --
        --
        --finalLevelNumber is the number of the level
        --
        --
        level_prompt = fileLines[finalLevelNumber]
        
        textOptions = {
            parent = sceneGroup,
            y = mui.getScaleVal(200),
            x = display.contentWidth / 2,
            name = "title-main",
            text = level_prompt,
            align = "center",
            width = mui.getScaleVal(600),
            font = native.systemFontBold,
            fontSize = mui.getScaleVal(50),
            fillColor = { 1, 1, 1, 1 },
        }
        
        local title = mui.newText(textOptions)
        
        textOptions = {
            parent = sceneGroup,
            y = mui.getScaleVal(50),
            x = mui.getScaleVal(410),
            name = "title-main",
            text = "# of responses:",
            align = "center",
            width = mui.contentWidth,
            font = native.systemFont,
            fontSize = mui.getScaleVal(40),
            fillColor = { 1, 1, 1, 1 },
        }
        
        local numResponses = mui.newText(textOptions)
        
        responseCount = display.newText(
            "00", 
            mui.getScaleVal(585), 
            mui.getScaleVal(50), 
            native.systemFont, 
            mui.getScaleVal(60))
        responseCount:setFillColor( 1,1,1,1 )
        sceneGroup:insert( responseCount )
        
        --[[mui.newIconButton({
            parent = sceneGroup,
            name = "help",
            text = "help",
            width = mui.getScaleVal(50),
            height = mui.getScaleVal(50),
            x = display.contentWidth - mui.getScaleVal(40),
            y = mui.getScaleVal(40),
            font = "MaterialIcons-Regular.ttf",
            textColor = { 1,1, 1, 1 },
            callBack = nil,
        })]]--
        
    responsesDisplayTable = {
        
    }
    tableOptions = {
            parent = sceneGroup,
            name = "responseTable",
            width = display.contentWidth - mui.getScaleVal(30),
            height = mui.getScaleVal(440),
            top = mui.getScaleVal(685),
            left = mui.getScaleVal(15),
            font = native.systemFont,
            fontSize = mui.getScaleVal(10),
            textColor = { 0, 0, 0, 1 },
            lineColor = { 0, 0, 0, 1 },
            lineHeight = mui.getScaleVal(4),
            rowColor = { 1,1,1,1 },
            rowHeight = mui.getScaleVal(60),
            rowAnimation = false, -- turn on rowAnimation
            noLines = false,
            callBackTouch = mui.onRowTouchDemo,
            callBackRender = mui.onRowRenderDemo,
            scrollListener = mui.scrollListener,  -- needed if using buttons, etc within the row!
            list = responsesDisplayTable,
            --categoryColor = { default={0.8,0.8,0.8,0.8} },
            categoryLineColor = { 1, 1, 1, 1 },
            touchpointColor = { 1, 1, 1 },
        }
        
        mui.newTableView(tableOptions)
    
        
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        native.setKeyboardFocus( nil )
        mui.removeTextBox("response")
    
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
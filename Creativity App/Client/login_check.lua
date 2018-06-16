local composer = require( "composer" )
local mui = require( "materialui.mui" )
local scene = composer.newScene()
local loadsave = require( "loadsave" )
local json = require( "json" )
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
    
    display.setDefault("background", 0,0,0)
    background = display.newRect( 0, 0, display.contentWidth, display.contentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x, background.y = 0, 0
    background:setFillColor( 0,0.6,1,1 )
    sceneGroup:insert( background )
    
    function string.urlEncode( str )
        if ( str ) then
            str = string.gsub( str, "\n", "\r\n" )
            str = string.gsub( str, "([^%w ])",
            function (c) return string.format( "%%%02X", string.byte(c) ) end )
                str = string.gsub( str, " ", "+" )
            end
    return str
    end
    
    function checkLocalSession()
        if loadsave.loadTable("userSession.json") then error() end
    end
    
    if not pcall(checkLocalSession) then
        userSession = loadsave.loadTable("userSession.json")
        local function networkListener23( event )
         
            if ( event.isError ) then
                print( "Network error: ", event.response )
            elseif ( json.decode(event.response)['responseMessage'] ) == "Session Check Successful" then
                composer.gotoScene("menu", { effect = "crossFade", time = 500 } )
            end
        end

        local headers = {}
        
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        headers["Accept-Language"] = "en-US"
        print(userSession.username)
        print(userSession.apiKey)
        local body = "username=" .. userSession.username:urlEncode() .. "&apiKey=" .. userSession.apiKey:urlEncode()
        
        local params = {}
        params.headers = headers
        params.body = body
        
        network.request( "https://yourcreativitygym.com/checksession", "POST", networkListener23, params )
        
        else
        
        composer.gotoScene("login", { effect = "crossFade", time = 500 } )
        end
    
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
    composer.removeScene("login_check")
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
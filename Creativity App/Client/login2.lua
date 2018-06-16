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
    
    display.setDefault("background", 0,0,0)
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
    name = "title-main",
    text = "The Creativity Gym",
    align = "center",
    width = mui.contentWidth,
    font = native.systemFontBold,
    fontSize = mui.getScaleVal(65),
    fillColor = { 1, 1, 1, 1 },
    }
    local title = mui.newText(textOptions)
    
    mui.newTextField({
	parent = sceneGroup,
    name = "email",
	labelText = "Email",
	text = "",
	font = native.systemFont,
	width = mui.getScaleVal(500),
	height = mui.getScaleVal(70),
	x = display.contentWidth/2,
	y = mui.getScaleVal(300),
	activeColor = {0,0,0,1},
	inactiveColor = { 1, 1, 1, 1 },
	callBack = mui.textfieldCallBack,
    fontSize = mui.getScaleVal(40)
})
    mui.newTextField({
	parent = sceneGroup,
    name = "password",
	labelText = "Password",
	text = "",
	font = native.systemFont,
	width = mui.getScaleVal(500),
	height = mui.getScaleVal(70),
	x = display.contentWidth/2,
	y = mui.getScaleVal(450),
	activeColor = {0,0,0,1},
	inactiveColor = { 1, 1, 1, 1 },
	callBack = mui.textfieldCallBack,
    fontSize = mui.getScaleVal(40),
    isSecure = true
})

    local loginMessage = display.newText(
        "", 
        display.contentWidth/2, 
        mui.getScaleVal(900), 
        native.systemFont, 
        mui.getScaleVal(20))
    loginMessage:setFillColor( 1,1,1,1 )
    sceneGroup:insert( loginMessage )
    
    function string.urlEncode( str )
        if ( str ) then
            str = string.gsub( str, "\n", "\r\n" )
            str = string.gsub( str, "([^%w ])",
            function (c) return string.format( "%%%02X", string.byte(c) ) end )
                str = string.gsub( str, " ", "+" )
            end
    return str
    end

    function validemail(str)
      if str == nil then return nil end
      if (type(str) ~= 'string') then
        error("Expected string")
        return nil
      end
      local lastAt = str:find("[^%@]+$")
      local localPart = str:sub(1, (lastAt - 2)) -- Returns the substring before '@' symbol
      local domainPart = str:sub(lastAt, #str) -- Returns the substring after '@' symbol
      -- we werent able to split the email properly
      if localPart == nil then
        return nil, "Local name is invalid"
      end

      if domainPart == nil then
        return nil, "Domain is invalid"
      end
      -- local part is maxed at 64 characters
      if #localPart > 64 then
        return nil, "Local name must be less than 64 characters"
      end
      -- domains are maxed at 253 characters
      if #domainPart > 253 then
        return nil, "Domain must be less than 253 characters"
      end
      -- somthing is wrong
      if lastAt >= 65 then
        return nil, "Invalid @ symbol usage"
      end
      -- quotes are only allowed at the beginning of a the local name
      local quotes = localPart:find("[\"]")
      if type(quotes) == 'number' and quotes > 1 then
        return nil, "Invalid usage of quotes"
      end
      -- no @ symbols allowed outside quotes
      if localPart:find("%@+") and quotes == nil then
        return nil, "Invalid @ symbol usage in local part"
      end
      -- only 1 period in succession allowed
      if domainPart:find("%.%.") then
        return nil, "Too many periods in domain"
      end
      -- just a general match
      if not str:match('[%w]*[%p]*%@+[%w]*[%.]?[%w]*') then
        return nil, "Email pattern test failed"
      end
      -- all our tests passed, so we are ok
      return true
end
    
    
    local function loginUser( event )
        if ( event.phase == "onTarget" ) then
            local email = mui.getWidgetProperty("email","value")
            local password = mui.getWidgetProperty("password","value")
            
            if email == '' or password == '' then
                loginMessage.text  = "Missing field"
                return ""
            elseif validemail(email) ~= true then
                print(validemail(email))
                loginMessage.text  = "Not a valid email address"
                return ""
            end
            
            local function networkListener23( event )
     
                if ( event.isError ) then
                    print( "Network error: ", event.response )
                elseif ( json.decode(event.response)['responseMessage'] ) == "Login Successful" then
                    userSessionInfo = {}
                    userSessionInfo.username = json.decode(event.response)['username']
                    userSessionInfo.apiKey = json.decode(event.response)['apiKey']
                    loadsave.saveTable(userSessionInfo, "userSession.json")
                    
                    composer.gotoScene("menu", { effect = "crossFade", time = 500 } )
                    
                else
                    loginMessage.text = json.decode(event.response)['responseMessage']
                end
            end
        
            local headers = {}
            
            headers["Content-Type"] = "application/x-www-form-urlencoded"
            headers["Accept-Language"] = "en-US"
              
            local body = "email=" .. email:urlEncode() .. "&password=" .. password:urlEncode()
            
            local params = {}
            params.headers = headers
            params.body = body
            
            network.request( "https://yourcreativitygym.com/checklogin", "POST", networkListener23, params )
            
        end
    end
    mui.newRoundedRectButton({
        parent = sceneGroup,
        name = "login",
        text = "Login",
        width = mui.getScaleVal(350),
        height = mui.getScaleVal(80),
        radius = mui.getScaleVal(20),
        x = display.contentWidth/2,
        y = mui.getScaleVal(600),
        font = native.systemFont,
        fillColor = { 1,1,1,1 },
        textColor = { 0, .6, 1, 1},
        touchpoint = true,
        callBack = loginUser,
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
    composer.removeScene("login2")
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
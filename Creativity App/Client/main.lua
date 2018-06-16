---------------------------------------------------------------------------------
--
-- main.lua
--
---------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- require the composer library
local composer = require "composer"

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc)


-- Add any system wide event handlers, location, key events, system resume/suspend, memory, etc.

-- load menu
composer.gotoScene( "login_check" )

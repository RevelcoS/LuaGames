-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")

--Hide status bar
display.setStatusBar(display.HiddenStatusBar)

-- Get random seed
math.randomseed(os.time())

-- Go to the menu
composer.gotoScene("menu")

-- Reserve channel 1 for background music
audio.reserveChannels(1)
audio.reserveChannels(2)

-- Reduce the overall volume of the channel
audio.setVolume(0.4, {channel = 1})
audio.setVolume(1, {channel = 2})
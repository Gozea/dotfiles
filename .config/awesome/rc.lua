-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")


-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty") 
local menubar = require("menubar")
-- widgets
local hotkeys_popup = require("awful.hotkeys_popup")
-- Collision 
require("collision")()

-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/zea/.config/awesome/theme.lua")

-- {{{ Variable definitions
-- modkey
modkey = "Mod4"
--terminal
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Sound manager
awful.spawn("start-pulseaudio-x11")

-- Small gap
beautiful.useless_gap = 5

--Random wallpaper
awful.spawn.with_shell("feh --bg-scale --randomize ~/.wallpapers/*")

-- Awesome config files
require("keybind")
require("rules")
require("error")
require("bar")

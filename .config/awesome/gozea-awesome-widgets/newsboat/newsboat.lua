local naughty = require("naughty")
local spawn = require("awful.spawn")
local gears = require("gears")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local awful = require("awful")

local newsboat_widget = {}


local function worker(user_args)
    local args = user_args or {}
    local path_to_icons = args.path_to_icons or "/usr/share/icons/Arc/status/symbolic/"
    local timeout = args.timeout or 300
    local space = args.space or 5


    local status
    newsboat_widget.widget = wibox.widget {
        {
            id = "newsboat_icon",
            widget = wibox.widget.imagebox,
        },
        layout = wibox.layout.fixed.horizontal,
        spacing = space,
        update_icon = function(self, name)
            self:get_children_by_id("newsboat_icon")[1]:set_image(path_to_icons .. name)
        end
    }

    -- set all notifications to read when clicking widget
    newsboat_widget.widget:buttons(
        gears.table.join(
            awful.button({}, 1, function ()
                spawn.easy_async_with_shell('sqlite3 ~/.newsboat/cache.db "update rss_item set unread = 0"')
            end)
        )
    )

    local function show_newsboat_status()
        spawn.easy_async_with_shell('sqlite3 ~/.newsboat/cache.db "select rss_item.title FROM rss_item LEFT JOIN rss_feed ON rssurl=feedurl WHERE unread = 1" ', function (stdout)
            naughty.destroy(status)
            status = naughty.notify {
                text = stdout,
                title = "Newsboat Status",
                icon = path_to_icons .. "weather-fog-symbolic.svg",
                position = "top_right",
                timeout=timeout,
                hover_timeout = 0.5,
                width = 400,
                screen = mouse.screen
            }
        end)
    end

    local function update_widget(widget, stdout, stderr, _, code)
        if code == 0 then
           spawn.easy_async_with_shell('sqlite3 ' .. os.getenv("HOME") .. '/.newsboat/cache.db "select rss_item.title FROM rss_item LEFT JOIN rss_feed ON rssurl=feedurl WHERE unread = 1" ' , function (out)
               if out == "" then
                    widget.newsboat_icon:set_image()
               else
                    widget.newsboat_icon:set_image(path_to_icons ..  "weather-fog-symbolic.svg")
               end
           end)
        end
    end


    newsboat_widget.widget:connect_signal("mouse::enter", function() show_newsboat_status() end)
    newsboat_widget.widget:connect_signal("mouse::leave", function() naughty.destroy(status) end)

    watch('sqlite3 ' .. os.getenv("HOME") .. '/.newsboat/cache.db "select rss_item.title FROM rss_item LEFT JOIN rss_feed ON rssurl=feedurl WHERE unread = 1" ', timeout, update_widget, newsboat_widget.widget)

    return newsboat_widget.widget
end



return setmetatable(newsboat_widget, { __call = function(_, ...)
    return worker(...)
end })

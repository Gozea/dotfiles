local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local spawn = require("awful.spawn")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local wifi_widget = {}

local function worker(user_args)
    local args = user_args or {}
    local path_to_icons =  args.path_to_icons or "/usr/share/icons/Arc/status/symbolic/"
    local timeout = args.timeout or 5
    local space = args.space or 5

    wifi_widget.widget = wibox.widget {
        {
            id = "wifi_icon",
            widget = wibox.widget.imagebox,
        },
        layout = wibox.layout.fixed.horizontal,
        spacing = space,
        update_icon = function(self, name)
            self:get_children_by_id("wifi_icon")[1]:set_image(path_to_icons .. name)
        end
    }


    wifi_widget.widget:buttons(
        gears.table.join(
            awful.button({}, 1, function ()
                spawn.easy_async_with_shell("nmcli | grep 'wlp3s0: connected'", function (stdout, _, _, code)
                    if code == 0 then
                        spawn.with_shell("wifidisconnect")  -- custom bash function
                    else
                        spawn.with_shell("wificonnect")     -- custom bash function
                    end
                end)
            end
            )
        )
    )
    local status
    local function show_wifi_status()
        spawn.easy_async_with_shell("nmcli dev wifi | awk '{ if(length($1)==1) { print $3, $6, $7, $8 \"%\" }}'| sed 's/ /\\n/'", function (stdout)
            naughty.destroy(status)
            status = naughty.notify {
                text = stdout,
                title = "Wifi status",
                icon = path_to_icons .. "network-wireless-connected-symbolic.svg",
                position = "top_right",
                timeout = 5, hover_timeout = 0.5,
                width = 200,
                screen = mouse.screen
            }
        end)
    end


    local function update_widget(widget, stdout, _, _, code)
        -- Currently connected to a Wifi
        if code == 0 then
            spawn.easy_async_with_shell("nmcli dev wifi | awk '{ if (length($1)==1) {print $8} }'", function (out)
                local signal = tonumber(out)
                if signal >= 85 then
                    widget:update_icon("network-wireless-signal-excellent-symbolic.svg")
                elseif signal >= 55 then
                    widget:update_icon("network-wireless-signal-good-symbolic.svg")
                elseif signal >= 35 then
                    widget:update_icon("network-wireless-signal-ok-symbolic.svg")
                else
                    widget:update_icon("network-wireless-signal-weak-symbolic.svg")
                end
            end)
        -- Not currently connected to a Wifi
        else
            widget:update_icon("network-wireless-offline-symbolic.svg")
        end
    end

    wifi_widget.widget:connect_signal("mouse::enter", function() show_wifi_status() end)
    wifi_widget.widget:connect_signal("mouse::leave", function() naughty.destroy(status) end)

    watch('bash -c "nmcli | grep \'wlp3s0: connected\'"', timeout, update_widget, wifi_widget.widget)

    return wifi_widget.widget
end

return setmetatable(wifi_widget, { __call = function(_, ...)
    return worker(...)
end })

local naughty = require("naughty")
local spawn = require("awful.spawn")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local vpn_widget = {}

local function worker(user_args)
    local args = user_args or {}
    local path_to_icons = args.path_to_icons or "/usr/share/icons/Arc/status/symbolic/"
    local timeout = args.timeout or 10
    local space = args.space or 5

    vpn_widget.widget = wibox.widget {
        {
            id = "vpn_icon",
            widget = wibox.widget.imagebox,
        },
        layout = wibox.layout.fixed.horizontal,
        spacing = space,
        update_icon = function(self, name)
            self:get_children_by_id("vpn_icon")[1]:set_image(path_to_icons .. name)
        end
    }

    local status
    local function show_vpn_status()
        spawn.easy_async_with_shell("wg | awk '/^interface:/ { print $2 } /endpoint:/,/sent/ { print }'", function (stdout)
            naughty.destroy(status)
            status = naughty.notify {
                text = stdout,
                title = "VPN status",
                icon = path_to_icons .. "user-not-tracked-symbolic.svg",
                position = "top_right",
                timeout = timeout, hover_timeout = 0.5,
                width = 400,
                screen = mouse.screen
            }
        end)
    end

    local function update_widget(widget, stdout, _, _, code)
        if code == 0 then
           spawn.easy_async_with_shell("wg | grep 'interface' | cut -d' ' -f2", function (out)
               if out == "" then
                   widget.vpn_icon:set_image()
               else
                    widget.vpn_icon:set_image(path_to_icons ..  "user-not-tracked-symbolic.svg")
               end
           end)
        end
    end

    vpn_widget.widget:connect_signal("mouse::enter", function() show_vpn_status() end)
    vpn_widget.widget:connect_signal("mouse::leave", function() naughty.destroy(status) end)

    watch("wg", timeout, update_widget, vpn_widget.widget)

    return vpn_widget.widget
end


return setmetatable(vpn_widget, { __call = function(_, ...)
    return worker(...)
end })

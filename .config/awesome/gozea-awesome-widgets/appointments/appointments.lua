local naughty = require("naughty")
local spawn = require("awful.spawn")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local appointment_widget = {}

local function worker(user_args)
    local args = user_args or {}
    local path_to_icons = args.path_to_icons or "/usr/share/icons/Arc/status/symbolic/"
    local timeout = args.timeout or 30
    local space = args.space or 5
    local foresee = args.foresee or 7

    appointment_widget.widget = wibox.widget {
        {
            id = "appointment_icon",
            widget = wibox.widget.imagebox,
        },
        layout = wibox.layout.fixed.horizontal,
        spacing = space,
        update_icon = function(self, name)
            self:get_children_by_id("appointment_icon")[1]:set_image(path_to_icons .. name)
        end
    }

    local status
    local function show_appointment_status()
        spawn.easy_async_with_shell("calcurse -a -d " .. foresee, function (stdout)
            naughty.destroy(status)
            status = naughty.notify {
                text = stdout,
                title = "Appointment Status",
                icon = path_to_icons .. "checkbox-checked-symbolic.svg",
                position = "top_right",
                timeout=timeout,
                hover_timeout = 0.5,
                width = 400,
                screen = mouse.screen
            }
        end)
    end


    local function update_widget(widget, stdout, _, _, code)
        if code == 0 then
           spawn.easy_async_with_shell("calcurse -a -d " .. foresee, function (out)
               if out == "" then
                    widget.appointment_icon:set_image()
               else
                    widget.appointment_icon:set_image(path_to_icons ..  "checkbox-checked-symbolic.svg")
               end
           end)
        end
    end

    appointment_widget.widget:connect_signal("mouse::enter", function() show_appointment_status() end)
    appointment_widget.widget:connect_signal("mouse::leave", function() naughty.destroy(status) end)

    watch("calcurse -a -d " .. foresee, timeout, update_widget, appointment_widget.widget)

    return appointment_widget.widget
end


return setmetatable(appointment_widget, { __call = function(_, ...)
    return worker(...)
end })

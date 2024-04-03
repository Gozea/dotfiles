local awful = require("awful")

-- switch current tag
local function switch_to_tag(tag_index)
    local screen = awful.screen.focused() or awful.screen.primary
    local tag = screen.tags[tag_index]
    if tag then
        tag:view_only()
    end
end

-- call the vpn connect function in tmux
local function openvpn_on_tag(tag_index)
    switch_to_tag(tag_index)
    local command = "vpnconnect"
    awful.spawn("alacritty -e " .. command )
end

-- return table
return {
    switch_to_tag = switch_to_tag,
    openvpn_tmux_session = openvpn_on_tag
}

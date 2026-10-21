local autoimg = require "commands.autoimg"

-- for functions within this file
local detection = {}

-- for local connections
local _connections = {}

-- debug logging
-- resource intensive, not intended for end user usage ofc
local function log(label, value)
    if EVIL_DEBUG_VARIABLE then
        c2.log(
            c2.LogLevel.Info,
            "detection.lua/" .. label .. ": " .. tostring(value)
        )
    end
end

local fetch_urls = function(text)
    local urls = {}
    local _seen = {}

    -- image rendering candidates (URLs)
    -- find the URLs and trim text around
    -- also use gmatch() instead of match()
    for candidate in text:gmatch("https?://[%w%-%._~:/%?#%[%]@!$&'()*+,;%%]+") do
        local url = candidate:gsub("[%.%,%!%?%;:%)]+$", "")
        if url ~= ""
            and not _seen[url] then
            _seen[url] = true
            urls[#urls + 1] = url
        end
    end
    return urls
end

-- "bake" the message containing the image's URL
local function assemble(_message, image_urls)
    local elements = {}
    local _source = _message:elements()

    for i = 1, #_source do
        elements[#elements + 1] = _source[i]
    end

    -- place the images contained each in a new line
    for _, image_url in ipairs(image_urls or {}) do
        if type(image_url) == "string" and image_url ~= "" then
            elements[#elements + 1] = {
                type = "linebreak",
                flags = c2.MessageElementFlag.AlwaysShow,
            }
            elements[#elements + 1] = {
                type = "image",
                image = c2.Image.from_url(image_url, IMAGE_SCALE),
                flags = c2.MessageElementFlag.AlwaysShow,
            }
        end
    end

    -- the baked message
    -- yes it has to be something new
    -- whatever
    return c2.Message.new({
        flags = _message.flags,
        id = _message.id,
        search_text = _message.search_text,
        message_text = _message.message_text,
        login_name = _message.login_name,
        display_name = _message.display_name,
        localized_name = _message.localized_name,
        user_id = _message.user_id,
        channel_name = _message.channel_name,
        username_color = _message.username_color,
        server_received_time = _message.server_received_time,
        highlight_color = _message.highlight_color,
        elements = elements
    })
end

-- attach a message handler on all channels
function detection.attach(channel)
    if _connections[channel] then return end
    local handle
    local ok, result = pcall(function()
        return channel:on_message_appended(function(_message, override_flags)
            if not _message then return end
            local text_ok, text = pcall(function()
                return _message.message_text
            end)

            if not text_ok or type(text) ~= "string" then
                log("stopping at", "message_text unavailable or not a string")
                return
            end

            local urls = fetch_urls(text)

            if #urls == 0 then return end

            handle:block()
            local replace_ok, replace_error = pcall(function()
                local replacement = assemble(_message, urls)
                log("message_text", text)
                channel:replace_message(_message, replacement)
            end)

            handle:unblock()
            if not replace_ok then
                log("replace_message error", replace_error)
            end
        end)
    end)

    if not ok then
        log("registration error", result)
        return
    end

    handle = result
    _connections[channel] = handle
end

return detection

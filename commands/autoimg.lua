local config = require "functions.config"
local _A = {}

function _A.is_enabled()
    return config.autoimg ~= "off"
end

function _A.is_streamer_mode()
    return config.autoimg == "streamer"
end

-- media automation configuration command
c2.register_command("/autoimg", function(ctx)
    -- get the arguments after the command
    -- start with an empty table
    local _argument = (ctx.words[2] or ""):lower()

    local function contains(list, value)
        for _, item in ipairs(list) do
            if item == value then return true end
        end
        return false
    end

    -- return usage
    if _argument == "" then
        ctx.channel:add_system_message(
            "Usage: /autoimg <on/off/streamer>"
        )
        return
    end

    -- lists of acceptable terms in the argument
    local _on = { "on", "ligado", "yes", "y", "sim", "s", "true" }
    local _off = { "off", "desligado", "no", "n", "nao", "não", "false" }
    local _streamer_mode = { "sm", "stream", "streamer", "streamer-mode", "streamermode", "streamer_mode" }

    -- enable
    if contains(_on, _argument) then
        config.autoimg = "on"
        config.save()
        if EVIL_DEBUG_VARIABLE then
            c2.log(
                c2.LogLevel.Info,
                "autoimg enabled: \"" .. tostring(config.enable) .. "\""
            )
            return
        end
    -- disable (should turn off streamer mode as well)
    elseif contains(_off, _argument) then
        config.autoimg = "off"
        config.save()
        if EVIL_DEBUG_VARIABLE then
            c2.log(
                c2.LogLevel.Info,
                "autoimg disabled: \"" .. tostring(config.enable) .. "\""
            )
            c2.log(
                c2.LogLevel.Info,
                "autoimg also disabled streamer mode automatically: \"" .. tostring(config.enable) .. "\""
            )
            return
        end
    -- streamer mode (enables)
    elseif contains(_streamer_mode, _argument) then
        config.autoimg = "streamer"
        config.save()
        if EVIL_DEBUG_VARIABLE then
            c2.log(
                c2.LogLevel.Info,
                "autoimg streamer mode was set to " .. tostring(config.streamer_mode)
            )
            return
        end
    end
end)

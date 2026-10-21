local json = require "chatterino.json"
local CONFIG_FILE = "config.json"

-- default configuration
local DEFAULT_CONFIG = {
    -- possible values:
    -- "off", "on", "streamer"
    autoimg = "off",

    -- range:
    -- 0.1 to 16.0
    imgsize = 1.0,

    -- rate limit the requests
    -- NOT YET IMPLEMENTED
    -- TODO: implement request rate limits
    ratelimit = 1000,

    -- exclude the url fetching from users or entire channels
    -- also define if the block requires streamer mode
    -- NOT yet implemented
    -- todo: implement blocked
    exclude = {
        users = {
            { "Twitch", false },
            { "7TVapp", true }
        },
        channels = {
            "/mentions",
            "/whisper",
            "/automod",
            "/watching"
        }
    }
}

-- i'm not going to place stuff that isn't implemented on here okay
-- specially because it's returned at the end of the file
local config = {
    autoimg = DEFAULT_CONFIG.autoimg,
    imgsize = DEFAULT_CONFIG.imgsize
}

local write = function()
    local file, _error = io.open(CONFIG_FILE, "w")
    if not file then
        c2.log(c2.LogLevel.Warning, "unable to write " .. CONFIG_FILE .. ": " .. tostring(_error))
        return false
    end

    file:write(string.format(
        '{\n  "autoimg": "%s",\n  "imgsize": %.1f\n}\n',
        -- hey! they also need to be written in here!
        config.autoimg,
        config.imgsize
    ))
    file:close()
    return true
end

local load = function()
    local file = io.open(CONFIG_FILE, "r")
    if not file then
        write()
        return
    end
    local contents = file:read("*a")
    file:close()

    local ok, data = pcall(json.parse, contents)
    if not ok or type(data) ~= "table" then
        c2.log(c2.LogLevel.Warning, "invalid " .. CONFIG_FILE .. "; using default media configuration")
        write()
        return
    end

    -- upid
    -- works tho
    if data.autoimg == "off" or data.autoimg == "on" or data.autoimg == "streamer" then
        config.autoimg = data.autoimg
    end

    if type(data.imgsize) == "number" and data.imgsize >= 0.1 and data.imgsize <= 16.0 then
        config.imgsize = data.imgsize
    end

    write()
end

-- allow write() to be called when imported on another file
-- TODO: move around
function config.save()
    return write()
end

-- same as above
function config.load()
    return load()
end

-- actually load the config
config.load()
return config

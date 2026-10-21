-- rendering media (images/gifs/emotes) makes use of EmoteImage as a sort of workaround that shows media in the current chat
-- this means that you could add messages on the middle of the messages, that would change

-- psst
EVIL_DEBUG_VARIABLE = false

local function initialize()
    IMAGE_SCALE = 1.0

    -- command to configure the size of images
    require 'commands.imgsize'

    -- command to render media in the current chat
    require 'commands.img'

    -- command to enable media related automation (and streamer mode)
    require 'commands.autoimg'

    -- the actual media automation
    require "functions.channel_scan".attach_open_channels()

    if EVIL_DEBUG_VARIABLE then
        c2.log(
            c2.LogLevel.Info,
            "mediaware initialized"
        )
    end
end
initialize()

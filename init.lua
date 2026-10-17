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
end
initialize()

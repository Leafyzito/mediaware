c2.register_command("/img", function(ctx)
    local args = {}
    for i = 2, #ctx.words do
        args[#args + 1] = ctx.words[i]
    end

    local url = table.concat(args, " ")
    -- return usage
    if url == "" then
        ctx.channel:add_system_message(
            "Usage: /img <URL>"
        )
        return
    end

    -- this should be an option but not on this command
    --[[
    if not url:match("^https?://") then
        -- the url passed through the command should have a protocol
        ctx.channel:add_system_message(
            "the argument provided does not provide a protocol, which is required (http://, https://)"
        )
        return
    end
    ]] --

    local scaled_url = url
        .. (url:find("?", 1, true) and "&" or "?")
        .. "chatterino_scale=" .. tostring(IMAGE_SCALE)

    ctx.channel:add_message(c2.Message.new({
        id = "inline-media",
        flags = c2.MessageFlag.System,
        elements = {
            {
                type = "image",
                image = c2.Image.from_url(scaled_url, IMAGE_SCALE),
                trailing_space = true,
                flags = c2.MessageElementFlag.EmoteImage,
            },
        },
    }))
end)
if EVIL_DEBUG_VARIABLE then
    c2.log(
        c2.LogLevel.Info,
        "[media-test/debug] init OK"
    )
end

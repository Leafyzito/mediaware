-- it's kind of weird to not have a lot of require'' on the top of the file but fine
c2.register_command("/imgsize", function(ctx)
    local value = tonumber(ctx.words[2])
    if not value then
        ctx.channel:add_system_message(
            string.format("current image scale: %.2f.", IMAGE_SCALE)
        )
        ctx.channel:add_system_message(
            string.format("Usage: /imgsize <scale>")
        )
        return
    end

    if value < 0.1 or value > 16.0 then
        ctx.channel:add_system_message(
            string.format("The image scale must be between %.1f and %.1f.", 0.1, 16.0)
        )
        return
    end
    IMAGE_SCALE = value
    ctx.channel:add_system_message(
        string.format("Image scale set to %.1f.", IMAGE_SCALE)
    )
end
)

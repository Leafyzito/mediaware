local detection = require "functions.detection"

-- this file's functions
local channel_scan = {}

-- attach the currently open channels to detection
function channel_scan.attach_open_channels()
    -- every currently open window
    for _, window in ipairs(c2.windows:all()) do
        -- the open window's "notebooks" (tabs/pages)
        for page_index = 0, window.notebook.page_count - 1 do
            local page = window.notebook:page_at(page_index)
            if page then
                for _, split in ipairs(page:splits()) do
                    if split.channel then detection.attach(split.channel)
                    end
                end
            end
        end
    end
end

-- the `attach_open_channels` function gets:
-- • every currently open window (usually just 1 with all the tabs)
-- • its "notebooks" (tabs/pages)
--     • considers the zero based indexes of page_index as well as checking pages for nil
-- • the splits within pages
--     • also consider wether there's a channel open inside the split or not
-- • runs the attach function for every single channel
--     ↑ i was unsure about this formatting but i hope it explains well how this loop works
--       since its very important for the autoimg implementation
-- TLDR: windows → notebook → pages → splits → channels → attach()

return channel_scan

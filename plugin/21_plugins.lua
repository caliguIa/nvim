-- vim.opt.rtp:prepend(vim.fn.stdpath("config") .. "/local/zendiagram")
local function add_local_plugins()
    local handle = vim.loop.fs_scandir(vim.fn.stdpath("config") .. "/local")
    if not handle then return end

    for name, type in vim.loop.fs_scandir_next, handle do
        if type == "directory" then
            vim.opt.rtp:prepend(string.format("%s/local/%s", vim.fn.stdpath("config"), name))
        end
    end
end

add_local_plugins()

-- Enable experimental lua loader
pcall(function() vim.loader.enable() end)

-- Define main config table
_G.Config = {
  path_package = vim.fn.stdpath("data") .. "/site/",
  path_source = vim.fn.stdpath("config") .. "/src/",
}

local mini_path = Config.path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.deps").setup({ path = { package = Config.path_package } })

_G.add, _G.now, _G.later = MiniDeps.add, MiniDeps.now, MiniDeps.later

local source = function(path) dofile(Config.path_source .. path) end
local function source_plugins()
  local plugins_dir = Config.path_source .. "plugins"

  for name, type in vim.fs.dir(plugins_dir) do
    if type == "file" and name:match("%.lua$") then
      local ok, err = pcall(source, "plugins/" .. name)
      if not ok then vim.notify(string.format("Failed to load %s: %s", name, err), vim.log.levels.ERROR) end
    end
  end
end

now(function() source("settings.lua") end)
now(function() source("functions.lua") end)
now(function() source("mappings.lua") end)

source_plugins()

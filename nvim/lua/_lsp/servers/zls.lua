local servers = require "nvim-lsp-installer.servers"
local server = require "nvim-lsp-installer.server"
local path = require "nvim-lsp-installer.path"
local installers = require "nvim-lsp-installer.installers"
local std = require "nvim-lsp-installer.installers.std"
local shell = require "nvim-lsp-installer.installers.shell"

local server_name = "zls"
local root_dir = server.get_server_root_path(server_name)

local install = installers.pipe {
  shell.bash [[
  git clone --depth=1 --recurse-submodules https://github.com/zigtools/zls.git
  cd zls
  zig build -Drelease-safe
  ]],
}

local zls = server.Server:new {
  name = server_name,
  root_dir = root_dir,
  homepage = "https://github.com/zigtools/zls",
  languages = { "zig" },
  installer = install,
  default_options = {
    cmd = { path.concat { root_dir, "zls", "zig-out", "bin", "zls" } },
  },
}

servers.register(zls)

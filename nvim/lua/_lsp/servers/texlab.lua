local servers = require "nvim-lsp-installer.servers"
local server = require "nvim-lsp-installer.server"
local Path = require "plenary.path"
local installers = require "nvim-lsp-installer.installers"
local std = require "nvim-lsp-installer.installers.std"
local shell = require "nvim-lsp-installer.installers.shell"

local server_name = "texlab"
local root_dir = server.get_server_root_path(server_name)

local git_url = "https://github.com/latex-lsp/texlab.git"
local wanted_version = "f376275c5c02fee8134256b47883f2533713a2d8"
local install_cmd = string.format(
  "cargo install --git %s --rev %s --locked",
  git_url,
  wanted_version
)

local install = installers.pipe {
  shell.bash(install_cmd),
}

local texlab = server.Server:new {
  name = server_name,
  root_dir = root_dir,
  homepage = "https://texlab.netlify.app/",
  languages = { "tex", "bib" },
  installer = install,
  default_options = {
    cmd = {
      tostring(Path:new { root_dir, "texlab/target/release/texlab"  }),
      "-vvvv",
      "--log-file",
      tostring(Path:new { vim.fn.stdpath "cache", "texlab.log" }),
    },
  },
}

servers.register(texlab)

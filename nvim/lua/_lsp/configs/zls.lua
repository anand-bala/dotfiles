local config = require("lspinstall/util").extract_config "zls"
config.default_config.cmd[1] = "./zls/zig-out/bin/zls"

require("lspinstall/servers").zls = vim.tbl_extend("error", config, {
  install_script = [[
        ! test -d zls && git clone --recursive https://github.com/zigtools/zls || true

        cd zls
        git pull origin master
        git submodule update --init
        zig build
    ]],
})

return {}

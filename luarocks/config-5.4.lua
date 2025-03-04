---@diagnostic disable: lowercase-global

cmake_generator = "Ninja"
local_by_default = true

home_tree = (os_getenv "XDG_DATA_HOME" or (home .. "/.local/share")) .. "/luarocks"
rocks_trees = {
  { name = "user", root = home_tree },
  { name = "system", root = "/usr" },
}

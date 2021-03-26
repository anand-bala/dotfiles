# vim: filetype=gdb

dashboard -layout !registers !assembly source variables stack !breakpoints !expressions !history !memory !threads

define hookpost-up
  dashboard
end

define hookpost-down
  dashboard
end

define hookpost-frame
  dashboard
end

dashboard source -style height 40
dashboard stack -style compact True
dashboard stack -style limit 10
dashboard variables -style align True
dashboard variables -style compact False



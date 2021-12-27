if test -n "$COLCON_HOME"
  set -l colcon_home_dir $COLCON_HOME
else
  set -l colcon_home_dir $HOME/.config/colcon
end

if test -d $colcon_home_dir
  set -gx --path COLCON_HOME $colcon_home_dir
end

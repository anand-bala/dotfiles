set -l mjbin_path $HOME/.mujoco/mjpro150/bin
set -l libglew_path /usr/lib/x86_64-linux-gnu/libGLEW.so

if test -d $mjbin_path
    contains $mjbin_path $LD_LIBRARY_PATH
    or set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH $mjbin_path

    contains $libglew_path $LD_PRELOAD
    or set -gx LD_PRELOAD $LD_PRELOAD $libglew_path
end

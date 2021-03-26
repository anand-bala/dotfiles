# Assumes the `fd` is installed in your system because `find` kinda sucks

# List of paths to search for a carla directory (at the top level)
set -l carla_search_paths /opt

# Use `fd` to search for a top level directory that has the name `carla` in it, e.g.,
# /opt/carla-simulator
set -l carla_root (fd -t d -d 1 carla . $carla_search_paths | head -n1)

# Path to the Pythonroot path for the python API
set -l carla_pyroot "$carla_root/PythonAPI"

# if both carla_root and carla_pyroot exist
if test -d $carla_root -a -d $carla_pyroot
  # find the egg file for python3
  set -l carla_pyegg (fd -t f -e egg py3 $carla_root)
  # set the CARLA_ROOT
  set -gx CARLA_ROOT $carla_root
  # set the PYTHONPATH
  set -gx PYTHONPATH $PYTHONPATH $carla_pyegg $carla_root
end



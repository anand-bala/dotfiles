# List of paths to search for a carla directory (at the top level)
set -l carla_search_paths /opt

# Search for a top level directory that has the name `carla` in it, e.g.,
# /opt/carla-simulator
set -l carla_root (find $carla_search_paths -maxdepth 1 -type d -name 'carla*' | head -n1)

if test -z "$carla_root"
  exit 0
end

# Path to the Pythonroot path for the python API
set -l carla_pyroot "$carla_root/PythonAPI"

# if both carla_root and carla_pyroot exist
if test -d $carla_root -a -d $carla_pyroot
  # find the egg file for python3
  set -l carla_pyegg (find $carla_root -type f \( -name "*.egg" -a -name "*py3*" \) | head -n1)
  # set the CARLA_ROOT
  set -gx CARLA_ROOT $carla_root
  # set the PYTHONPATH
  set -gx PYTHONPATH $PYTHONPATH $carla_pyegg $carla_root
end



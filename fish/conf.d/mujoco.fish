if not set -q MUJOCO_PY_MUJOCO_PATH; and test -d "$HOME/.mujoco/mujoco210"
  set -gx MUJOCO_PY_MUJOCO_PATH "$HOME/.mujoco/mujoco210"
end

not contains -- "$MUJOCO_PY_MUJOCO_PATH/bin" $LD_LIBRARY_PATH;
  and set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH $MUJOCO_PY_MUJOCO_PATH/bin

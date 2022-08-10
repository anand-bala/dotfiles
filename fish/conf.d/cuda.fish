# --- CUDA config
if not set -q CUDA_HOME; and test -d "/usr/local/cuda"
  set -gx CUDA_HOME           /usr/local/cuda
end

if set -q CUDA_HOME
  fish_add_path -gP   $CUDA_HOME/bin

  not contains -- "$CUDA_HOME/lib" $DYLD_LIBRARY_PATH;
    and set -gx DYLD_LIBRARY_PATH   $DYLD_LIBRARY_PATH $CUDA_HOME/lib

  not contains -- "$CUDA_HOME/lib64" $LD_LIBRARY_PATH;
    and set -gx LD_LIBRARY_PATH     $LD_LIBRARY_PATH $CUDA_HOME/lib64

  not contains -- "/usr/lib/nvidia" $LD_LIBRARY_PATH;
    and set -gx LD_LIBRARY_PATH     $LD_LIBRARY_PATH /usr/lib/nvidia

  if test -d $CUDA_HOME/extras/CUPTI/lib64
    not contains -- "$CUDA_HOME/extras/CUPTI/lib64" $LD_LIBRARY_PATH;
      and set -gx LD_LIBRARY_PATH   $LD_LIBRARY_PATH $CUDA_HOME/extras/CUPTI/lib64
  end

  if test -d $CUDA_HOME/targets/(uname -i)-linux/lib
    not contains == "$CUDA_HOME/targets/(uname -i)-linux/lib" $LD_LIBRARY_PATH;
      and set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH $CUDA_HOME/targets/(uname -i)-linux/lib
  end
end


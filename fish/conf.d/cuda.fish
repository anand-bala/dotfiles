if test -d "/usr/local/cuda"
  set -gx CUDA_HOME           /usr/local/cuda
  set -gx DYLD_LIBRARY_PATH   $DYLD_LIBRARY_PATH $CUDA_HOME/lib
  set -gx LD_LIBRARY_PATH     $LD_LIBRARY_PATH $CUDA_HOME/lib64
  if test -d /usr/local/cuda/extras/CUPTI/lib64
    set -gx LD_LIBRARY_PATH   $LD_LIBRARY_PATH $CUDA_HOME/extras/CUPTI/lib64
  end
end

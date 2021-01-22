# --- CUDA config
if not set -q CUDA_HOME; test -d "/usr/local/cuda"
  set -gx CUDA_HOME           /usr/local/cuda
end

if set -q CUDA_HOME
  not contains -- "$CUDA_HOME/bin" $PATH;
    and set -gx PATH                $CUDA_HOME/bin $PATH

  not contains -- "$CUDA_HOME/lib" $DYLD_LIBRARY_PATH;
    and set -gx DYLD_LIBRARY_PATH   $DYLD_LIBRARY_PATH $CUDA_HOME/lib

  not contains -- "$CUDA_HOME/lib64" $LD_LIBRARY_PATH;
    and set -gx LD_LIBRARY_PATH     $LD_LIBRARY_PATH $CUDA_HOME/lib64

  if test -d $CUDA_HOME/extras/CUPTI/lib64
    not contains -- "$CUDA_HOME/extras/CUPTI/lib64" $LD_LIBRARY_PATH;
      and set -gx LD_LIBRARY_PATH   $LD_LIBRARY_PATH $CUDA_HOME/extras/CUPTI/lib64
  end
end


if test -z "$TEXMFHOME"
  set -gx TEXMFHOME ~/texmf
end

if test -z "$TEXMFCONFIG"
  set -gx TEXMFCONFIG ~/.config/texlive/2019 # 2019 is the latest on Ubuntu 20.04
end

if test -z "$TEXMFVAR"
  set -gx TEXMFVAR ~/.cache/texlive
end



function ffdlp --wraps='yt-dlp' --description 'alias ffdlp yt-dlp --cookies-from-browser firefox'
  yt-dlp --cookies-from-browser firefox $argv
end

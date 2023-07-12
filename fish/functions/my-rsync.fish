function my-rsync --description 'alias my-rsync=rsync -azhuP --info=progress2 --info=name0'
  rsync -azhuP --info=progress2 --info=name0 $argv;
end


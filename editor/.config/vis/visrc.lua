require('vis')
vis.events.subscribe(vis.events.INIT, function()
  -- Your global configuration options

  vis.events.subscribe(vis.events.FILE_SAVE_PRE, function(file, path)
    -- Not sure why this is needed but otherwise sometimes selection is nil
    vis:feedkeys("<C-j>")

    local file = vis.win.file
    local range = vis.win.selection.range
    range.start = 0
    range.finish = file.size
    local old_line = vis.win.selection.line - 1
    local old_col =  vis.win.selection.col

    local extension = path:match("^.+(%..+)$")
    local pipe_command = nil
    local execute_command = nil

    if extension == '.java' then
      pipe_command = "x"
    elseif extension == '.go' then
      pipe_command = "gofmt"
      --vis:feedkeys("ggvG$:|gofmt")
      --vis:feedkeys("")
    elseif extension == ".sc" then
      execute_command = "oscsend localhost 57120 /reloadFile s " .. path
    end

    if string.match(path, "/home/mil/Mixtapes/Programming") then
      pipe_command = "colfmt"
    end

    
    local text = file:content(0, file.size)
    if not (pipe_command == nil) then
      local status, out, err = vis:pipe(file, range, pipe_command)
      if not status then
        vis:info(err)
      else
        --vis:feedkeys("'zm")
        file:delete(range)
        file:insert(range.start, out)
        --vis:feedkeys("'zM")
        vis.win.selection:to(old_line, old_col)
      end
    end

    if not (execute_command == nil) then
      vis:command("!" .. execute_command)
    end

    vis:feedkeys("<Escape><Escape>")
    return true
  end)
end)

function file_exists(name)
  local f=io.open(name,"r")
  if f~=nil then io.close(f) return true else return false end
end

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
  vis:command('set number')
  vis:command('set colorcolumn 80')
  vis:command('set expandtab')
  vis:command('set tabwidth 2')
  vis:command('set cursorline')
  vis:command('set autoindent on')
  vis:command('set shell /bin/sh')
  vis:command('set theme miles')
  vis:command('set show-tabs on')
end)


local extras = "/home/mil/.config/vis_additional/visrc.lua"
if file_exists(extras) then 
  dofile(extras)
end
# Helper fns
function add_to_path_if_exists
  if test -d $argv
    set -x PATH $argv $PATH
  end
end


# Main
function setup_envvars_and_path
  # Env vars
  setenv EDITOR vis
  setenv GIT_EDITOR vis
  setenv BROWSER firefox
  setenv PAGER 'w3m -X'
  setenv TZ America/Chicago
  set -x SURFRAW_graphical false
  set -x LEDGER_FILE ~/.ledger.journal

  # Path
  add_to_path_if_exists /home/$USER/.cargo/bin
  add_to_path_if_exists /usr/share/surfraw
  add_to_path_if_exists /usr/lib/surfraw
  add_to_path_if_exists /home/$USER/.bin
end


function setup_shortcuts
  abbr -a nb newsboat
  abbr -a g git
  abbr -a gco git checkout
  abbr -a gc git commit
  abbr -a yt youtube
  abbr -a h hg
  abbr -a r ranger

  alias nm='w3m -X'
  alias w3m='w3m -X'
  alias pf='set -x PAGER cat'
  alias po='set -x PAGER w3m -X'
  alias pv='set -x PAGER vis -'
  alias q='quit'
  alias m='w3m'
  alias c='cd'
  alias tw='tree -C|w3m'
  alias v='vis'
  alias gd='cd (git rev-parse --show-toplevel 2>/dev/null; or hg root)'
  alias cb='git rev-parse --abbrev-ref HEAD 2>/dev/null; or cat .hg/bookmarks.current'
  alias tc='set GIT_COMMITER_DATE (date); git commit --amend --date (date)'
end



function setup_colorsconfig
  set fish_color_selection 'black'  '--bold'  '--background=grey'
  set fish_color_search_match 'bryellow'  '--background=grey'
  set fish_pager_color_progress 'brwhite'  '--background=grey'
  set fish_pager_color_prefix 'red'  '--bold'  '--underline'
  set -x LS_COLORS 'di=01;34'
end



function setup_promptconfig
  set fish_greeting ""
  # Fish title
  function fish_title
    set -x pwd (dirs  | xargs)
    if test -n "$ft"
      echo $ft
    else if test -z $argv[1]
      dirs
    else
      echo $argv[1] "($pwd)"
    end
  end
end



function setup_vimlike
  # C-x in insert mode to edit
  function edit_commandline
    set -q EDITOR; or return 1
    set -l tmpfile (mktemp); or return 1
    commandline > $tmpfile
    eval $EDITOR $tmpfile
    commandline -r -- (cat $tmpfile)
    rm $tmpfile
  end
  function fish_user_key_bindings; bind -M insert \cx edit_commandline; end

  # Keybindings
  if not set --query SSH_CLIENT
    fish_vi_key_bindings #fish_vi_mode
    #cat ~/.todo
  end

  # Prompt
  function fish_mode_prompt --description 'Displays the current mode'
    switch $fish_bind_mode
        case default; set_color --bold --background red white
        case insert;  set_color --bold --background green white
        case visual;  set_color --bold --background magenta white
    end
    echo ' '
    set_color normal
    echo -n ' '
  end
end



function setup_addons_and_misc
  # J
  source /usr/share/autojump/autojump.fish

  # X autostart
  if status --is-login
      if test -z "$DISPLAY" -a $XDG_VTNR = 1
          startx -- -keeptty
      end
  end

  # Go-related
  setenv GO111MODULE on
  if test -d ~/Go; export GOPATH=/home/$USER/Go; end
  if test -d ~/.Go; export GOPATH=/home/$USER/.Go; end
  add_to_path_if_exists $GOPATH/bin

  # For compat
  export TERM='xterm-256color'
  set fish_function_path $fish_function_path ~/.config/fish/plugin-foreign-env/functions
  eval (dircolors -c)

  # Additional-configs if existant
  if test -d ~/.config/fish_additional; source ~/.config/fish_additional/config.fish; end
  if test -d ~/.config/fish_work; source ~/.config/fish_work/config.fish; end
end



setup_envvars_and_path
setup_shortcuts
setup_vimlike
setup_promptconfig
setup_colorsconfig
setup_addons_and_misc

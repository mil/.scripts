syntax enable
filetype plugin indent on
set encoding=utf-8
set ttyfast
set ttyscroll=3
set lazyredraw
set showcmd
set wrap
set linebreak
set nolist
set backspace=indent,eol,start
set textwidth=0
set wrapmargin=0
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set hlsearch
set incsearch
set ignorecase " search case-insensitive...
set smartcase " unless > 1 capital letter
set number " show line numbers!
set ai " auto identing
set listchars=tab:+-
set cursorline
set mouse=nv
set noswapfile
set clipboard=unnamedplus
set laststatus=2
set statusline=%t[%{strlen(&fenc)?&fenc:'none'}%{&ff}]%h%m%r%y%=%c,%l/%L\%P%m
"set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set foldlevel=3000

" Colorscheme Related
set t_Co=256
"set termguicolors
hi MatchParen cterm=none ctermbg=green ctermfg=black
hi Search ctermbg=Yellow
hi IncSearch ctermbg=Cyan
hi Pmenu ctermbg=White
hi PmenuSel ctermbg=Green
hi SpecialKey ctermbg=none ctermfg=gray
hi clear CursorLine
hi CursorLine   ctermbg=lightgray
highlight ExtraWhitespace ctermbg=green guibg=green
match ExtraWhitespace /\s\+$\| \+\ze\t/
set colorcolumn=80
if version >= 700
  au InsertEnter * hi StatusLine term=reverse ctermbg=green ctermfg=white
  au InsertLeave * hi StatusLine term=reverse ctermbg=blue
endif

" Keybindings
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>
map <up> <c-w>-
map <down> <c-w>+
map <right> <c-w>>
map <left> <c-w><

command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'
autocmd BufWritePost /home/mil/Mixtapes/*.sc Silent oscsend localhost 57120 /reloadFile s %:p

set t_te=

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
call SourceIfExists("~/.vimrc_additional")

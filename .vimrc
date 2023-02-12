" ####################
"        Keymap
" ####################

inoremap <silent> jj <ESC>
nmap <CR> i<CR><ESC>
nmap <BS> i<BS><ESC>
nmap <Space> i<Space><ESC>
nmap gr gT


" ####################
"        Plugin
" ####################



" ####################
"   General setting
" ####################

source $VIMRUNTIME/defaults.vim

set fileencodings=utf-8

syntax on

set tabstop=2
set shiftwidth=2

set number
set cursorline
highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=black

" Cursor shape
if has('vim_starting')
  " Insert mode
  let &t_SI .= "\e[5 q"
  " Normal mode
  let &t_EI .= "\e[1 q"
  " Replace mode
  let &t_SR .= "\e[4 q"
endif

" Highlight search
set hlsearch

" Incremental search
set incsearch

set smartindent

set clipboard+=unnamed

" Enhance status line
set laststatus=2

" Conplete command line with Tab
set wildmenu

" Mute bell
set belloff=all

" Move to the next line when the cursor is at the end of the line
set whichwrap=b,s,h,l,<,>,[,]



" ####################
"       dein.vim
" ####################

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand('~/dein.vim')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

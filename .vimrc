" ####################
"     キーマップ
" ####################

inoremap <silent> jj <ESC>
inoremap <silent> っｊ <ESC>
nmap <CR> i<CR><ESC>
nmap <BS> i<BS><ESC>
nmap <Space> i<Space><ESC>
nmap gr gT
nnoremap <silent><C-e> :Fern . -reveal=% -drawer -toggle -width=40 <CR>



" ####################
"       dein.vim
" ####################

" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/dein.vim')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif



" ####################
"       初期設定
" ####################

source $VIMRUNTIME/defaults.vim

" エンコード設定
set fileencodings=utf-8

" 行数表示
set relativenumber

" カーソルライン表示
set cursorline
highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=black

" カーソルの形を変更
if has('vim_starting')
    " 挿入モード時に点滅の縦線カーソル
    let &t_SI .= "\e[5 q"
    " ノーマルモード時に点滅の箱型カーソル
    let &t_EI .= "\e[1 q"
    " 置換モード時に非点滅の下線カーソル
    let &t_SR .= "\e[4 q"
endif

" 検索ハイライトを有効化
set hlsearch

" インクリメントサーチの有効化
set incsearch

" インデントを賢くする
set smartindent

" クリップボードを共通に
set clipboard+=unnamed

" ステータスラインを強化
set laststatus=2

" コマンドラインをTabで補完
set wildmenu

" Beep音を消す
set belloff=all

"行頭行末の左右移動で行をまたぐ
set whichwrap=b,s,h,l,<,>,[,]

" シンタックスハイライトを有効化
syntax on

" タブ幅を２に変更
set tabstop=2
set shiftwidth=2


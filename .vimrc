" ####################
"     キーマップ
" ####################

inoremap <silent> jj <ESC>
nmap <CR> i<CR><ESC>
nmap <BS> i<BS><ESC>
nmap <Space> i<Space><ESC>
nmap gr gT



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


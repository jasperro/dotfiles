call plug#begin('~/.vim/plugged')
	Plug 'bling/vim-airline'
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'zchee/deoplete-jedi'
	Plug 'zchee/deoplete-clang'
	Plug 'zchee/deoplete-go', { 'do': 'make'}
	Plug 'vim-airline/vim-airline-themes'
	Plug '907th/vim-auto-save'
"	Plug 'vim-syntastic/syntastic'
	Plug 'neomake/neomake'
	Plug 'huawenyu/neogdb.vim'
	Plug 'sheerun/vim-polyglot'
	Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
	Plug 'jiangmiao/auto-pairs'
	Plug 'scrooloose/nerdtree'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'deviantfero/wpgtk.vim'
	Plug 'Shougo/neoinclude.vim'
call plug#end()
let g:colors_name = "wpgtk"
syntax on
set laststatus=2
set clipboard=unnamedplus
let g:airline_powerline_fonts = 1
let g:deoplete#enable_at_startup = 1
let g:airline_theme='term'
let g:auto_save = 1
let mapleader = ","
let g:mapleader = ","
let g:deoplete#sources#clang#libclang_path = "/usr/lib/libclang.so"
let g:deoplete#sources#clang#clang_header = "/usr/lib/clang"
let g:deoplete#sources#go#gocode_binary = "$GOPATH/bin/gocode"
set mouse=a

nnoremap x "_x
nnoremap X "_X
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d

if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
  nnoremap <leader>d "+d
  nnoremap <leader>D "+D
  vnoremap <leader>d "+d
else
  set clipboard=unnamed
  nnoremap <leader>d "*d
  nnoremap <leader>D "*D
  vnoremap <leader>d "*d
endif

"inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
"highlight LineNr ctermfg=grey ctermbg=darkgrey guibg=black guifg=grey
set nu
"highlight ColorColumn ctermbg=gray
"set colorcolumn=85

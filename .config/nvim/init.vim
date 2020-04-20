call plug#begin('~/.vim/plugged')
	Plug 'bling/vim-airline'
if has('nvim')
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
	Plug 'Shougo/deoplete.nvim'
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
endif
	Plug 'zchee/deoplete-jedi'
	Plug 'zchee/deoplete-go', { 'do': 'make'}
	Plug 'zchee/deoplete-clang',
	Plug 'vim-airline/vim-airline-themes'
	Plug '907th/vim-auto-save'
	Plug 'neomake/neomake'
	Plug 'huawenyu/neogdb.vim'
	Plug 'sheerun/vim-polyglot'
	Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
	"Plug 'jiangmiao/auto-pairs'
	Plug 'scrooloose/nerdtree'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'deviantfero/wpgtk.vim'
	Plug 'Shougo/neoinclude.vim'
	Plug 'sbdchd/neoformat'
	Plug 'altercation/vim-colors-solarized'
call plug#end()
"let g:colors_name = "industry"
"let g:colors_name = "elflord"
let g:colors_name = "wpgtk"
syntax on
set laststatus=2
set ruler
set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
set incsearch
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
let g:AutoPairsMultilineClose = 0
call neomake#configure#automake('w')

set mouse=a
set tabstop=3
set guicursor=
autocmd OptionSet guicursor noautocmd set guicursor=

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
hi NonText ctermbg=none
hi Normal guibg=NONE ctermbg=NONE

"set background=dark

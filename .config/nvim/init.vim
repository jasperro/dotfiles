call plug#begin('~/.vim/plugged')
	Plug 'bling/vim-airline'
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'zchee/deoplete-jedi'
	Plug 'vim-airline/vim-airline-themes'
	Plug '907th/vim-auto-save'
	Plug 'vim-syntastic/syntastic'
call plug#end()
syntax on
set laststatus=2
let g:airline_powerline_fonts = 1
let g:deoplete#enable_at_startup = 1
let g:airline_theme='cool'
let g:auto_save = 1
let mapleader = ","
let g:mapleader = ","
set mouse=a
nnoremap x "_x
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d
nnoremap dd "_dd
nnoremap <leader>d ""d
nnoremap <leader>D ""D
vnoremap <leader>d ""d
"inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
highlight LineNr ctermfg=grey ctermbg=darkgrey guibg=black guifg=grey
set nu

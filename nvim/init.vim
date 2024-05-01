syntax enable
set tabstop=4
set shiftwidth=4
set expandtab
set number
set nowrap

filetype plugin indent on
call plug#begin('~/.vim/plugged')
Plug 'github/copilot.vim'
Plug 'rust-lang/rust.vim'
call plug#end()

colorscheme github-dimmed

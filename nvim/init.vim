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
Plug 'flazz/vim-colorschemes'
Plug 'moll/vim-node'
Plug 'python-mode/python-mode'
call plug#end()

colorscheme material

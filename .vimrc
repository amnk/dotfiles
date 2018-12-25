" Automatic installation {{{
" https://github.com/junegunn/vim-plug/wiki/faq#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
    let g:clone_details = 'https://github.com/junegunn/vim-plug.git $HOME/.vim/bundle/vim-plug'
    silent call system('mkdir -p ~/.vim/autoload')
    silent call system('git clone --depth 1 '. g:clone_details)
    if v:shell_error | silent call system('git clone ' . g:clone_details) | endif
    silent !ln -s $HOME/.vim/bundle/vim-plug/plug.vim $HOME/.vim/autoload/plug.vim
    augroup FirstPlugInstall
        autocmd! VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
endif
" }}}
" Vim options {{{
if !has("gui_running")
    set mouse=
endif
set autoindent              " Carry over indenting from previous line
set background=dark
set backspace=2
set cindent                 " Automatic program indenting
set encoding=utf8           " UTF-8 by default
set expandtab               " No tabs
set foldopen-=search        " Search should ignore folded text
set hlsearch                " Hilight searching
set hidden                  " Allow switching unsaved buffers
set ignorecase              " Case insensitive
set incsearch               " Search as you type
set laststatus=2            " Always show statusline
set modelines=1             " Allow local modeline definitions
set nocompatible
set noshowmode              " Visible in Lightline
set number
set ruler                   " Show row/col and percentage
set scroll=4                " Number of lines to scroll with ^U/^D
set scrolloff=5             " Keep cursor away from this many chars top/bot
set showtabline=0           " Never show tabline
" https://github.com/justinmk/vim-sneak/issues/102
set showmatch               " Hilight matching braces/parens/etc.
set visualbell t_vb=        " No flashing or beeping at all
set wildmenu                " visual autocomplete
set nofoldenable            " no automated fold
" }}}
" Keybindings {{{

" Remap <Leader>
let g:mapleader=','

" Better shortcuts
nnoremap ; :

" Quickly switch buffers
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

" Maybe just install 'tpope/vim-unimpaired' ?
" Move between open buffers.
nmap [b :bprev<CR>
nmap ]b :bnext<CR>
nmap [B :bfirst<CR>
nmap ]B :blast<CR>
nmap [q :cprevious<CR>
nmap ]q :cnext<CR>
nmap [Q :cfirst<CR>
nmap ]Q :clast<CR>

" w0rp/ale keys
nmap <silent> [c <Plug>(ale_previous_wrap)
nmap <silent> ]c <Plug>(ale_next_wrap)

" Better fzf
nnoremap <Leader>b :Buffers<CR>
nmap <Leader>f :Files<CR>
nmap <Leader>t :Tags<CR>
nmap <Leader>w :Windows<CR>
nmap <Leader>g :Rg<CR>

" Bufkill
nmap <Leader>k :BD<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

" }}}
" AutoGroups {{{
" https://github.com/junegunn/fzf.vim/issues/123
au VimEnter * highlight clear SignColumn
au VimEnter * :Rooter
au BufEnter Makefile setlocal noexpandtab
au BufEnter *.sh setlocal tabstop=2|setlocal shiftwidth=2|setlocal softtabstop=2
au BufEnter *.py setlocal tabstop=4
au FileType terraform setlocal commentstring=#%s
au FileType yaml setlocal tabstop=2|setlocal shiftwidth=2
au FileType groovy setlocal tabstop=4|setlocal shiftwidth=4
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}
" Vim Plug {{{
syntax enable
call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'
Plug 'mgee/lightline-bufferline'
Plug 'maximbaz/lightline-ale'
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'
Plug 'tpope/vim-fugitive'
Plug 'qpkorr/vim-bufkill'
Plug 'airblade/vim-rooter'
Plug 'universal-ctags/ctags'
Plug 'majutsushi/tagbar'
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
Plug 'juliosueiras/vim-terraform-completion', { 'for': 'terraform' }
Plug 'justinmk/vim-sneak'
Plug 'pearofducks/ansible-vim'
Plug 'fatih/vim-go', { 'for': ['go', 'gohtmltmpl'], 'do': ':GoUpdateBinaries' }
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'yggdroot/indentline'
Plug 'yuttie/comfortable-motion.vim'
call plug#end()

colorscheme solarized
" }}}
" Lightline {{{
let g:lightline = {
    \ 'colorscheme': 'solarized',
    \ 'active': {
    \   'left': [ [ 'mode', 'gitbranch', 'paste' ],
    \             [ 'readonly' ],
    \             [ 'buffers' ],
    \           ],
    \   'right': [ [ 'fileencoding', 'filetype', 'percent', 'lineinfo' ],
    \              [ 'linter_errors', 'linter_warnings', 'linter_ok' ]
    \            ]
    \ },
    \ 'component_expand': {
    \   'linter_warnings': 'lightline#ale#warnings',
    \   'linter_errors': 'lightline#ale#errors',
    \   'linter_ok': 'lightline#ale#ok',
    \   'buffers': 'lightline#bufferline#buffers',
    \ },
    \ 'component_type': {
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'linter_ok': 'left',
    \   'buffers': 'tabsel',
    \ },
    \ 'component_function': {
    \   'bufferinfo' : 'lightline#buffer#bufferinfo',
    \   'gitbranch' : 'fugitive#head',
    \ },
    \ 'component': {
    \   'separator': '',
    \ },
    \ }
let g:lightline#bufferline#show_number=2
" }}}
" fzf {{{
set rtp+=/usr/local/opt/fzf
" }}}
" Rooter {{{
let g:rooter_patterns = ['.git/', '.python-version']
" }}}
" tagbar {{{
"nmap <F8> :TagbarToggle<CR>
" }}}
" vim-terraform {{{
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1
let g:terraform_fmt_on_save=1
" }}}
" w0rp/ale {{{
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 1
" }}}
" yggdroot/indentline {{{
let g:indentLine_setColors = 0
let g:indentLine_char = '|'
" }}}
" yuttie/comfortable-motion.vim {{{
let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"
" }}}
" vim:foldmethod=marker:foldlevel=0

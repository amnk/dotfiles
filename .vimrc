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
set showtabline=2           " Always show tabline
" https://github.com/justinmk/vim-sneak/issues/102
set showmatch               " Hilight matching braces/parens/etc.
set visualbell t_vb=        " No flashing or beeping at all
set wildmenu                " visual autocomplete
" }}}
" Keybindings {{{

" Remap <Leader>
let g:mapleader=','

" Quickly switch buffers
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

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
nmap <Leader>g :Find<CR>

" Bufkill
nmap <Leader>k :BD<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

" NerdTree
map <F2> :NERDTreeToggle<CR>
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
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}
" Vim Plug {{{
syntax enable
call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'ajmwagar/vim-deus'
Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'taohex/lightline-buffer'
Plug 'maximbaz/lightline-ale'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'
Plug 'tpope/vim-fugitive'
Plug 'qpkorr/vim-bufkill'
Plug 'bling/vim-bufferline'
Plug 'airblade/vim-rooter'
Plug 'universal-ctags/ctags'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-commentary'
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
Plug 'juliosueiras/vim-terraform-completion', { 'for': 'terraform' }
Plug 'tpope/vim-repeat'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-unimpaired'
Plug 'pearofducks/ansible-vim'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
call plug#end()
colorscheme solarized
" }}}
" Lightline {{{
let g:lightline = {
    \ 'colorscheme': 'solarized',
    \ 'tabline': {
    \   'left': [ [ 'bufferinfo' ],
    \             [ 'separator' ],
    \             [ 'bufferbefore', 'buffercurrent', 'bufferafter' ], ],
    \   'right': [ [  ], ],
    \ },
    \ 'active': {
    \   'left': [ [ 'mode', 'gitbranch', 'paste' ],
    \             [ 'readonly', 'relativepath', 'modified' ],
    \             [ 'bufferline' ]
    \           ],
    \   'right': [ [ 'fileencoding', 'filetype', 'percent', 'lineinfo' ],
    \              [ 'linter_errors', 'linter_warnings', 'linter_ok' ]
    \            ]
    \ },
    \ 'component_expand': {
    \   'buffercurrent': 'lightline#buffer#buffercurrent',
    \   'bufferbefore': 'lightline#buffer#bufferbefore',
    \   'bufferafter': 'lightline#buffer#bufferafter',
    \   'linter_warnings': 'lightline#ale#warnings',
    \   'linter_errors': 'lightline#ale#errors',
    \   'linter_ok': 'lightline#ale#ok',
    \ },
    \ 'component_type': {
    \   'buffercurrent': 'tabsel',
    \   'bufferbefore': 'raw',
    \   'bufferafter': 'raw',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'linter_ok': 'left',
    \ },
    \ 'component_function': {
    \   'bufferinfo' : 'lightline#buffer#bufferinfo',
    \   'gitbranch' : 'fugitive#head',
    \ },
    \ 'component': {
    \   'separator': '',
    \ },
    \ }
" }}}
" fzf {{{
set rtp+=/usr/local/opt/fzf
set rtp+=~/.fzf
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
" }}}
" Rooter {{{
let g:rooter_patterns = ['.git/', '.python-version']
" }}}
" tagbar {{{
nmap <F8> :TagbarToggle<CR>
" }}}
" vim-terraform {{{
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1
let g:terraform_fmt_on_save=1
" }}}
" bling/vim-bufferline {{{
let g:bufferline_echo = 0
" }}}
" nerdtree {{{
let NERDTreeChDirMode=2
let NERDTreeShowHidden=1
" }}}
" gotags {{{
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
	\ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
	\ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }
" }}}
" w0rp/ale {{{
let g:ale_sign_column_always = 1
" }}}
" vim:foldmethod=marker:foldlevel=0

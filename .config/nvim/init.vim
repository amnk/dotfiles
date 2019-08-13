" Automatic installation {{{
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/f1ad2d864ab43c56bf86ce01be9971f62bc14f6c/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}
" Vim Plug {{{
call plug#begin('~/.config/nvim/plugged')
Plug '0x84/vim-coderunner'
Plug 'airblade/vim-rooter'
Plug 'altercation/vim-colors-solarized'
Plug 'fatih/vim-go', { 'for': ['go', 'gohtmltmpl'], 'do': ':GoUpdateBinaries' }
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
Plug 'itchyny/lightline.vim'
Plug 'juliosueiras/vim-terraform-completion', { 'for': 'terraform' }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'majutsushi/tagbar'
Plug 'maximbaz/lightline-ale'
Plug 'mgee/lightline-bufferline'
Plug 'pearofducks/ansible-vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'tpope/vim-fugitive'
Plug 'universal-ctags/ctags'
Plug 'w0rp/ale'
Plug 'yggdroot/indentline'
Plug 'yuttie/comfortable-motion.vim'
call plug#end()
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
colorscheme solarized
" }}}
" Keybindings {{{

" Remap <Leader>
let g:mapleader=','

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
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>w :Windows<CR>
nnoremap <Leader>g :Rg<CR>

" Git shortcuts
nnoremap <leader>ga :Git add %<CR><CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gc :Gcommit -v -q<CR>
nnoremap <leader>gca :Gcommit --amend --noedit<CR>
nnoremap <leader>gcon :Git checkout -b<SPACE>
nnoremap <leader>ggp :Gpush -u origin<CR>
nnoremap <leader>gst :Gstatus<CR>

" Tagbar
nnoremap <F8> :TagbarToggle<CR>

" indentLine
nnoremap <Leader>i :IndentLinesToggle<CR>

" 0x84/vim-coderunner
nnoremap <Leader>r :RunCode<CR>

" vim-sneak
map f <Plug>Sneak_s
map F <Plug>Sneak_S

" }}}
" AutoGroups {{{
" https://github.com/junegunn/fzf.vim/issues/123
augroup vimrc
    autocmd!

    autocmd VimEnter * highlight clear SignColumn
    autocmd VimEnter * :Rooter

    " Project related workarounds for ansible
    autocmd BufRead,BufNewFile */ansible/*.yaml set filetype=yaml.ansible

    " NerdTree
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " Override tabs/spaces.
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType javascript,json,javascript.jsx,ruby,yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
augroup end
" 
" }}}
" Lightline {{{
let g:lightline = {
    \ 'colorscheme': 'solarized',
    \ 'active': {
    \   'left': [ [ 'mode', 'gitbranch', 'paste' ],
    \             [ 'readonly' ],
    \             [ 'buffers' ],
    \           ],
    \   'right': [ [ 'filetype', 'percent', 'lineinfo' ],
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
"
" pearofducks/ansible-vim
let g:ansible_unindent_after_newline = 1
" vim:foldmethod=marker:foldlevel=0

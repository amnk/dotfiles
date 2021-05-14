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
"Plug '0x84/vim-coderunner'
Plug 'airblade/vim-rooter'
Plug 'altercation/vim-colors-solarized'
"Plug 'autozimu/LanguageClient-neovim', {
"    \ 'branch': 'next',
"    \ 'do': 'bash install.sh',
"    \ }
Plug 'fatih/vim-go', { 'for': ['go', 'gohtmltmpl'], 'do': ':GoUpdateBinaries' }
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
Plug 'itchyny/lightline.vim'
"Plug 'juliosueiras/vim-terraform-completion', { 'for': 'terraform' }
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'mgee/lightline-bufferline'
Plug 'tpope/vim-fugitive'
"Plug 'towolf/vim-helm'
Plug 'universal-ctags/ctags'
"Plug 'w0rp/ale'
"Plug 'yggdroot/indentline'
"Plug 'rust-lang/rust.vim', { 'for': ['rust'] }
Plug 'yuttie/comfortable-motion.vim'
"Plug 'flazz/vim-colorschemes'
Plug 'arcticicestudio/nord-vim'
call plug#end()
" }}}

" Vim options {{{
if !has("gui_running")
    set mouse=
endif

"if has('termguicolors')
"  set termguicolors
"endif

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
colorscheme nord
" }}}
" Keybindings {{{

" Remap <Leader>
let g:mapleader=','

" Maybe just install 'tpope/vim-unimpaired' ?
nmap [b :bprev<CR>
nmap ]b :bnext<CR>
nmap [B :bfirst<CR>
nmap ]B :blast<CR>
nmap [q :cprevious<CR>
nmap ]q :cnext<CR>
nmap [Q :cfirst<CR>
nmap ]Q :clast<CR>
nmap [l :lprev<CR>
nmap ]l :lnext<CR>

" w0rp/ale keys
nmap <silent> [c <Plug>(ale_previous_wrap)
nmap <silent> ]c <Plug>(ale_next_wrap)

" Better fzf
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>t :Tags<CR>
nnoremap <Leader>w :Windows<CR>
nnoremap <Leader>g :Rg<CR>

" Tagbar
nnoremap <F8> :TagbarToggle<CR>

" indentLine
"nnoremap <Leader>i :IndentLinesToggle<CR>

" vim-sneak
map f <Plug>Sneak_s
map F <Plug>Sneak_S

" Go related ones
au FileType go nmap <F10> :GoTest -short<cr>
" }}}
" AutoGroups {{{
" https://github.com/junegunn/fzf.vim/issues/123
augroup vimrc
    autocmd!

    autocmd VimEnter * highlight clear SignColumn

    " Project related workarounds for ansible
    autocmd BufRead,BufNewFile */ansible/*.yaml set filetype=yaml.ansible

    " NerdTree
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " Override tabs/spaces.
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType python let b:coc_root_patterns = ['.git', '.env']
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
    \            ]
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
set rtp+=~/.asdf/shims/fzf
let g:fzf_layout = { 'down': '~30%' }
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, &columns > 80 ? fzf#vim#with_preview() : {}, <bang>0)
" }}}
" Rooter {{{
let g:rooter_patterns = ['vendor/', '.git/', '.python-version']
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

let g:ale_rust_cargo_use_check = 1
let g:ale_rust_cargo_check_tests = 1
let g:ale_rust_cargo_use_clippy = 1
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
" fatih/vim-go
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_sameids = 1
let g:go_gopls_enabled = 0
let g:go_def_mapping_enabled = 0

inoremap jh <Esc>

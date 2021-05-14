call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive', {'tag': 'v3.3' }
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'rhysd/vim-clang-format'
Plug 'fannheyward/coc-rust-analyzer'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

"remape leader to space
:let mapleader = "\<Space>"

"yank to clipboard
set clipboard^=unnamed,unnamedplus

" configure colorscheme
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
set termguicolors
set bg=dark
set t_Co=256

"configure status line
let g:lightline = {
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \ }
      \ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

" vim surround shortcuts
" ysiw(     means yank and substitute inner word and surround with ()
" cs'(      means change surrounding from '' to ()
" ds"       means delete surrounding "
" ysiw<em>  mwans wrap inner word wirh <em></em>
" use S in visual mode to trigger surround

" automatically read file changes
set autoread

let pyxversion=3

let g:lightline = {
\ 'separator': { 'left': '', 'right': '' },
\ 'subseparator': { 'left': '', 'right': '' }
\ }
set laststatus=2
set noshowmode

"configure fugitive commands
nnoremap <leader>gL :Gclog!<CR>
nnoremap <leader>gl :G log -n 100<CR>
nnoremap <leader>gs :G<CR>
nnoremap <leader>gb :G blame<CR>
nnoremap <leader>go $yiw:G show <C-r>"<CR>

nnoremap <leader>r :source /path/to/.nvimrc<CR>

"shortcuts for handling windows
nnoremap <leader>t :tabedit %<CR>

"move lines up and down
vnoremap <c-m> :m '>+1<CR>gv=gv
vnoremap <c-l> :m '<-2<CR>gv=gv


"allow swapping modified buffers
set hidden

"highlight current line
set cursorline

"configurefsearching
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan
:nnoremap <Leader>s :%s/\<<C-r><C-w>\>/


set linebreak
set scrolloff=3
set wildmenu

"enable relative line numbers
set number relativenumber

"enable mouse
set mouse=a

"use 4 spaces as tab
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

"disable visuall bell
set visualbell
set t_vb=

"enable backspace reliably in insert mode
set backspace=indent,eol,start

syntax on
filetype on

"fzf commands
" CTRL-A CTRL-Q to select all and build quickfix list

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
"TODO replace fzf ripgrep functionality with only ripgrep

nnoremap <silent> <leader>ff :GFiles<CR>
nnoremap <silent> <leader>fF :Files<CR>
nnoremap <silent> <leader>fh :History<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fr :Rg<CR>
nnoremap <silent> <leader>fR :RG<CR>
nnoremap <silent> <leader>fca :Commits<CR>
nnoremap <silent> <leader>fcf :BCommits<CR>

nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" map ClangFormat plugin to <Leader>f in C++ code
autocmd FileType c,cpp,objc,javascript nnoremap <buffer><Leader>h :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc,javascript vnoremap <buffer><Leader>h :ClangFormat<CR>

"custom fzf command
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, {'options': ['--tiebreak=end']}, <bang>0)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent><nowait> <leader>i  :<C-u>CocList -I symbols<cr>

"disable ex mode
:nnoremap Q <Nop>

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set list

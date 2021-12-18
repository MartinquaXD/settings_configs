call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'fannheyward/coc-rust-analyzer'
Plug 'rust-lang/rust.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'Chiel92/vim-autoformat'
Plug 'vifm/vifm.vim'


call plug#end()

"remape leader to space
:let mapleader = "\<Space>"

"yank to clipboard
set clipboard^=unnamed,unnamedplus

let g:rustfmt_autosave = 1

nnoremap <leader>fm :call OpenVifm()<CR>

function! OpenVifm()
    " this returns an empty string if there is no file associated with this
    " buffer
    let l:bufname = expand('%')
    if empty(l:bufname) || match(l:bufname, "/tmp") == 0
        execute "EditVifm ".getcwd()
    else
        execute "EditVifm --select ".l:bufname
    endif
endfunction


" configure colorscheme
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
set termguicolors
set bg=dark
set t_Co=256

" configure status line
let g:lightline = {
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '', 'right': '' },
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

set laststatus=2
set noshowmode

"configure fugitive commands
nnoremap <leader>gl :G log -n 100<CR>
nnoremap <leader>gb :G blame<CR>
nnoremap <leader>gs :G<CR>

nnoremap <leader>r :source /home/martin/.nvimrc<CR>

"shortcuts for handling windows
nnoremap <leader>t :tabedit %<CR>

nnoremap <c-q> :bd!<CR>


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

nnoremap <silent><leader> :Autoformat<CR>

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
"TODO replace fzf ripgrep functionality with only ripgrep

nnoremap <silent> <leader>ff :GFiles<CR>
nnoremap <silent> <leader>fF :Files<CR>
nnoremap <silent> <leader>fh :History<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fr :Rg<CR>
nnoremap <silent> <leader>fR :RG<CR>
nnoremap <silent> <leader>fc :Commits<CR>
nnoremap <silent> <leader>fC :BCommits<CR>

" Jonhoo sort by path proximity (start listing files in current dir)
function! s:list_cmd()
    let base = fnamemodify(expand('%'), ':h:.:S')
    return base == '.' ? 'fd -t f' : printf('fd -t f | proximity-sort %s', expand('%'))
endfunction

command! -bang -nargs=? -complete=dir GFiles
            \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
            \                               'options': '--tiebreak=index'}, <bang>0)

command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
            \                               'options': '--tiebreak=index'}, <bang>0)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent><nowait> <leader>i  :<C-u>CocList -I symbols<cr>
nnoremap <silent> <leader>cb :Cbuild<CR>
nnoremap <silent> <leader>cr :Crun<CR>
nnoremap <silent> <leader>cc :Ccheck<CR>
nnoremap <silent> <leader>Cd :CocDiagnostics<CR>
nnoremap <silent> <leader>Cf :CocFix<CR>

"disable ex mode
:nnoremap Q <Nop>

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set list

filetype plugin indent on

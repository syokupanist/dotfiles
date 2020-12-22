call plug#begin('~/.local/share/nvim/plugged')

Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neoyank.vim'
Plug 'vim-airline/vim-airline'
Plug 'bronson/vim-trailing-whitespace'
Plug 'thinca/vim-quickrun'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline-themes'
Plug 'rhysd/accelerated-jk'
Plug 'tpope/vim-surround'
Plug 'alvan/vim-closetag'
"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'jacoborus/tender.vim'
Plug 'whatyouhide/vim-gotham'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

call plug#end()

let s:p = { 'plugs': get(g:, 'plugs', {}) }
function! s:p.is_installed(name) abort
  return has_key(self.plugs, a:name) ? isdirectory(self.plugs[a:name].dir) : 0
endfunction

if s:p.is_installed('LanguageClient-neovim')
  let g:LanguageClient_serverCommands = {
      \ 'python': [expand('$HOME') . '/miniconda3/envs/rl/bin/pyls'],
      \ }
  nnoremap <F5> :call LanguageClient_contextMenu()<CR>
endif

if s:p.is_installed('deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
  "let g:deoplete#auto_complete_start_length = 2
  "let g:deoplete#enable_camel_case = 0
  "let g:deoplete#enable_ignore_case = 0
  "let g:deoplete#enable_refresh_always = 0
  "let g:deoplete#enable_smart_case = 1
  "let g:deoplete#file#enable_buffer_path = 1
  "let g:deoplete#max_list = 10
  "let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
  inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<tab>"
endif

if s:p.is_installed('denite.nvim')
    let g:denite_enable_start_insert=1
    let g:denite_source_history_yank_enable =1
    let g:denite_source_file_mru_limit = 100

    autocmd FileType denite call s:denite_my_settings()
    function! s:denite_my_settings() abort
      nnoremap <silent><buffer><expr> <CR>
      \ denite#do_map('do_action')
      nnoremap <silent><buffer><expr> d
      \ denite#do_map('do_action', 'delete')
      nnoremap <silent><buffer><expr> p
      \ denite#do_map('do_action', 'preview')
      nnoremap <silent><buffer><expr> q
      \ denite#do_map('quit')
      nnoremap <silent><buffer><expr> i
      \ denite#do_map('open_filter_buffer')
      nnoremap <silent><buffer><expr> <Space>
      \ denite#do_map('toggle_select').'j'
    endfunction

    nnoremap <silent> <space>b :<C-u>Denite -direction=topleft buffer<CR>
    nnoremap <silent> <space>f :<C-u>Denite -direction=topleft file/rec<CR>
    nnoremap <silent> <space>u :<C-u>Denite -direction=topleft file_mru buffer<CR>

    nnoremap <silent> <space>g :<C-u>Denite -direction=topleft grep<CR>
    nnoremap <silent> <space>w :<C-u>DeniteCursorWord -direction=topleft grep<CR>

    nnoremap <silent> <space>r :<C-u>Denite -direction=topleft -buffer-name=register register<CR>
    nnoremap <silent> <space>y :<C-u>Denite -direction=topleft -mode=normal neoyank<CR>

    nnoremap <silent> <space>d :<C-u>Denite -direction=topleft directory_rec<CR>
    nnoremap <silent> <space>c :<C-u>Denite -direction=topleft colorscheme<CR>

    call denite#custom#option('default', {
    \ 'auto_action': 'preview',
    \ })

    if executable('rg')
      call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
      call denite#custom#var('grep', 'command', ['ag'])
      call denite#custom#var('grep', 'recursive_opts', [])
      call denite#custom#var('grep', 'pattern_opt', [])
      call denite#custom#var('grep', 'default_opts', ['--follow', '--no-group', '--no-color'])
    endif
endif

"--------------------------------------------------------------
"environment dependent settings
"set rtp+=/usr/local/bin/fzf

let g:python_host_prog = expand('$HOME') . '/.pyenv/versions/3.9.0/bin/python'
let g:python3_host_prog = expand('$HOME') . '/.pyenv/versions/3.9.0/bin/python'

"os integration
"mac
if has("mac")
    set clipboard=unnamed
elseif has ("unix")
endif


"--------------------------------------------------------------
syntax enable

" encoding
set fileencodings=utf-8,ucs-bom,iso-2022-jp,cp932,euc-jp,default,latin
set encoding=utf8
set ffs=unix,mac,dos
set nobackup
set nowb
set noswapfile

"search
set incsearch
set hlsearch
set wildmenu
set ignorecase
set smartcase

" split
set splitbelow
set splitright

" color scheme
if has("mac")
    set termguicolors
    colorscheme tender
elseif has("unix")
    " set termguicolors
    " colorscheme gotham256
    autocmd ColorScheme * highlight Normal ctermbg=none
    autocmd ColorScheme * highlight LineNr ctermbg=none
    colorscheme tender

endif

set switchbuf=useopen
set mouse=a

set showmatch

set whichwrap=h,l
set hidden

" user interface
set ruler
set number
set lazyredraw

"folding
set foldenable
set foldlevelstart=1
set foldmethod=marker commentstring=//%s
"set foldmethod=indent
set foldnestmax=10
set modeline
set modelines=5



"---------------------------------------------------------------------------

"key map
nnoremap <space> <Nop>

noremap ; :
nnoremap : ;
nnoremap j gj
nnoremap k gk
nnoremap B ^
nnoremap E $

"screen operation key map
nnoremap <CR> o<ESC>
nnoremap s <Nop>
"split
nnoremap ss :<C-u>split<CR>
nnoremap sv :<C-u>vsplit<CR>
"window movement
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sr <C-w>r
"split pane size
nnoremap s. <C-w>>
nnoremap s, <C-w><
nnoremap s+ <C-w>+
nnoremap s- <C-w>-
nnoremap s= <C-w>=
"tab
nnoremap st :<C-u>tabnew<CR>
nnoremap sn gt
nnoremap sp gT
"buffer
nnoremap f <Nop>
nnoremap fd :<C-u>bd<CR>
nnoremap fn :<C-u>bn<CR>
nnoremap fp :<C-u>bp<CR>
nnoremap fl :<C-u>ls<CR>
inoremap <C-j> <Nop>
nnoremap <C-j> <Nop>
inoremap <C-m> <Nop>
nnoremap <C-m> <Nop>
inoremap <silent> <C-j> <ESC>:tabnext<CR>i
nnoremap <silent> <C-j> :tabnext<CR>
inoremap <silent> <C-m> <ESC>:tabprevious<CR>i
nnoremap <silent> <C-m> :tabprevious<CR>

nnoremap sq :<C-u>q<CR>
nnoremap sf :<C-u>e .<CR>
noremap <S-h> ^
noremap <S-l> $

inoremap <C-f> <ESC>
nnoremap <C-f> <ESC>
inoremap <C-r> <C-d>
"imap <C-f> <C-x><C-o>

inoremap <C-l> <Nop>
nnoremap <C-l> <Nop>
nnoremap <silent> <C-k> :bnext<CR>
nnoremap <silent> <C-l> :bprev<CR>

nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)

autocmd BufRead,BufNewFile *.py setfiletype python
autocmd BufRead,BufNewFile *.rb setfiletype ruby
autocmd BufRead,BufNewFile *.js setfiletype js
autocmd BufRead,BufNewFile *.html setfiletype html
autocmd BufRead,BufNewFile *.ts setlocal filetype=typescript
autocmd BufRead,BufNewFile *.css setfiletype css

"tab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set autoindent
set smartindent
set cindent
set backspace=indent,eol,start
set smarttab
set expandtab
"set virtualedit=all
set list
set listchars=tab:>-,trail:-
filetype plugin indent on
"sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtabの略
autocmd FileType c           setlocal sw=4 sts=4 ts=4 et
autocmd FileType html        setlocal sw=4 sts=4 ts=4 et
autocmd FileType ruby        setlocal sw=2 sts=2 ts=2 et
autocmd FileType js          setlocal sw=2 sts=2 ts=2 et
autocmd FileType vue         setlocal sw=2 sts=2 ts=2 et
autocmd FileType typescript  setlocal sw=2 sts=2 ts=2 et
autocmd FileType javascript  setlocal sw=2 sts=2 ts=2 et
autocmd FileType zsh         setlocal sw=4 sts=4 ts=4 et
autocmd FileType python      setlocal sw=4 sts=4 ts=4 et
autocmd FileType scala       setlocal sw=4 sts=4 ts=4 et
autocmd FileType json        setlocal sw=4 sts=4 ts=4 et
autocmd FileType html        setlocal sw=4 sts=4 ts=4 et
autocmd FileType htmldjango  setlocal sw=4 sts=4 ts=4 et
autocmd FileType css         setlocal sw=4 sts=4 ts=4 et
autocmd FileType scss        setlocal sw=4 sts=4 ts=4 et
autocmd FileType sass        setlocal sw=4 sts=4 ts=4 et



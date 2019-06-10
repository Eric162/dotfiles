" Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
" If you're using tmux version 2.2 or later, you can remove the outermost $TMUX
" check and use tmux's 24-bit color support
" (see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more
" information.)
if (empty($TMUX))
  if (has("nvim"))
    " For Neovim 0.1.3 and 0.1.4 <https://github.com/neovim/neovim/pull/2198>
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  " For Neovim > 0.1.5 and Vim > patch 7.4.1799
  " <https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162>

  " Based on Vim patch 7.4.1770 (`guicolors` option)
  " <https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd>
  " <https://github.com/neovim/neovim/wiki/Following-HEAD#20160511>
  if (has("termguicolors"))
    set termguicolors
  endif
endif

scriptencoding utf-8
set encoding=utf-8


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" basic behvior

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Tabs behavior
set list listchars=tab:»·,trail:· " tab/space character display
set tabstop=2 " size of a hard tabstop
set expandtab " always uses spaces instead of tab character
set shiftwidth=2" size of an "indent"
set shiftround " indent should be multiple of shiftwidth when using < and >
set showtabline=2 " Always show tabs
set backspace=2 " Fix backspace issue

" Enable mouse scrolling and clicking
" set mouse=a

" g<Ctrl+o> to create a new line above cursor in normal mode
nmap g<C-O> o <ESC>k
" gO to create a new line below cursor in normal mode
nmap gO O<ESC>j

" Leader-w to close a tab
nnoremap <leader>w :tabclose<CR>
nnoremap <leader><left> :tabprevious<CR>
nnoremap <leader><right> :tabnext<CR>

" keep the cursor centered
nnoremap j jzz
nnoremap k kzz
nmap G Gzz
nmap n nzz
nmap N Nzz
nmap } }zz
nmap { {zz

" searching
set is " enable incremental search
set ic " case insensitive search
set smartcase " case sensitive search when uppercase letters typed
set hls " highlight all search results (turn off until next search with `:noh`)
" nmap <silent> <leader>/ :nohlsearch<CR> " clear highlights until next search

" split right and below
set splitbelow
set splitright

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" visuals

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" syntax highlighting
syntax on

" theme (Atom One Dark)
let g:onedark_termcolors=256
colorscheme onedark

" column markers at 80 and 120 chars
set colorcolumn=80,120
" Highlight current row in insert mode
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

" line numbers
set number relativenumber " show line numbers (relative)
" set number " show line numbers (normal)

" Change cursor in insert mode to pipe
" changes the cursor shape/color
" in the terminal depending on the mode
" see http://code.google.com/p/iterm2/issues/detail?id=710&q=cursor
function! SetCursorStyle()
  if &term =~ "xterm\\|rxvt"
    " use a | cursor in insert mode
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"

    " use a rectangle cursor otherwise
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"

    " reset cursor when vim exits
    autocmd VimLeave * silent !echo -ne "\<Esc>]50;CursorShape=0\x7"

  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-plug

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin()
" Theme & Visuals
  Plug 'joshdick/onedark.vim'
  Plug 'bling/vim-airline'
" NERD
  Plug 'scrooloose/nerdtree'
  Plug 'jistr/vim-nerdtree-tabs'
" Linting & Code Comlpetion
  Plug 'scrooloose/syntastic'
  Plug 'mtscout6/syntastic-local-eslint.vim'
  " Plug 'valloric/youcompleteme'
  Plug 'neoclide/coc.nvim', {'do': './install.sh'}
  Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
  Plug 'sheerun/vim-polyglot'
  Plug 'joukevandermaas/vim-ember-hbs'
" 'should-be-standard' functionality
  Plug 'danro/rename.vim'
  Plug 'roxma/vim-paste-easy'
  Plug 'scrooloose/nerdcommenter'
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-surround'
" search
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'davidegx/ctrlp-smarttabs'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
" git
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
" To Try out
call plug#end()

"""""""""""""""""""
" Plugin Settings "
"""""""""""""""""""

" CtrlP Settings
" ignore files in gitignore
let g:ctrlp_user_command =
  \ ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
" Use smart tabs extensions with CTRL+P to open in a file if that tab is
" already open
let g:ctrlp_extensions = ['smarttabs']

" Syntastic Settings
let g:syntastic_javascript_checkers=['eslint']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" NERDTree
let NERDTreeMapOpenInTab='t' " Open in new tab with 't' key
let NERDTreeShowHidden=1 " Show hidden files and folders in NERDTree
" <Ctrl+\> to toggle nerdtree
nnoremap <silent> <c-\> :NERDTreeTabsToggle<CR>
inoremap <silent> <c-\> :NERDTreeTabsToggle<CR>
vnoremap <silent> <c-\> :NERDTreeTabsToggle<CR>

" Silver searcher async grep fuzzy finder search
map <leader>f <ESC>:Ag<CR>

" NERDCommenter settings
" nnoremap <silent> <c-/> :call NERDComment(0, "toggle")<CR>
let g:NERDSpaceDelims = 1

" Coc.nvim settings
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" " Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()

" " Use K to show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
  " if (index(['vim','help'], &filetype) >= 0)
    " execute 'h '.expand('<cword>')
  " else
    " call CocAction('doHover')
  " endif
" endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Various ViM settings

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Put swap files in a tmp directory instead of next to the file
set directory=~/.vim/tmp/swap

" set updatetime to higher interval (lower number) original is 4000
set updatetime=300

" allow hidden buffers to exist
set hidden


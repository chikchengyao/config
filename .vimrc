"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Auto installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" For syntax checking - need to individually enable checkers
Plug 'vim-syntastic/syntastic'

Plug 'ctrlpvim/ctrlp.vim'

" Initialize plugin system
call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Recommended syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Use merlin autocomplete instead
" let g:syntastic_ocaml_use_ocamlc = 1
" let g:syntastic_ocaml_use_janestreet_core = 1
" let g:syntastic_ocaml_janestreet_core_dir = '/Users/chik/.opam/default/lib/core'

let g:syntastic_cpp_compiler_options = ' -std=c++11'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UNCHANGING THINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set history=500

" Enable filetype plugins (syntax highlighting)
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Ensure 7-line border at top and bottom when scrolling
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en' 
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position (alternatively, g<C-g>)
set ruler

" Height of the command bar (prevent blocking error messages)
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" Add a bit extra margin to the left
set foldcolumn=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable 

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme desert
catch
endtry

set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
"set si "Smart indent (off, clashes with filetype indent on)
set wrap "Wrap lines

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Specify the behavior when switching between buffers 
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MY STUFF
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" When in insert mode, show absolute numbers
" When in normal mode, show offsets
set number relativenumber
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEY MAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set key combo timeout. Set short (20-50ms) otherwise jk has
" visual and accidental keypress issues.
set ttimeout
set timeoutlen=30

" Easy escape for simultaneous presses
inoremap kj <Esc>
inoremap jk <Esc>


" Clear search highlighting when <space> is pressed

" If in a Merlin environment, clear Merlin as well
function! UnhighlightMerlinIfDefined()
  if exists(":MerlinClearEnclosing")
    execute "MerlinClearEnclosing"
  endif
endfunction
command UnMerlin :call UnhighlightMerlinIfDefined()

" The actual mapping
map <silent> <space> :noh<CR>:UnMerlin<CR>


" Omnicomplete mappings
inoremap <C-f> <C-x><C-o>
inoremap <C-j> <C-o>
inoremap <C-k> <C-p>


" Map leaders
let mapleader = " "
let maplocalleader = " "

" Fast saving
nmap <leader>w :w!<cr>
nmap w<leader> <leader>w

" Fast quit
nmap <leader>q :q<cr>
nmap q<leader> <leader>q

" Toggle paste mode on and off
map <leader>p :setlocal paste!<cr>
map p<leader> <leader>p


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OCaml stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd Filetype ocaml call SetOcamlOptions()

function SetOcamlOptions()
    " type-checking: start 
    map <localleader>f <localleader>t
    map f<localleader> <localleader>f

	" type-checking: expand
    map <localleader>j <localleader>n
    map j<localleader> <localleader>j
    
	" type-checking: reduce
    map <localleader>k <localleader>p
    map k<localleader> <localleader>k

	" find declaration
    map <localleader>d :MerlinLocate<CR>
    map d<localleader> <localleader>d

    map <localleader>e :MerlinErrorCheck<CR><C-w><C-w>
    map e<localleader> <localleader>e
endfunction 

" Merlin config
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" OCP-INDENT
" The config recommended by realworldocaml
" autocmd FileType ocaml execute "set rtp+=" . substitute(system('opam config var share'), '\n$', '', '''') . "/ocp-indent/vim/indent/ocaml.vim"
" The config the installer recommended
" set rtp^="/Users/chik/.opam/default/share/ocp-indent/vim"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Weird mappings - to clean up at some point
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"" :W sudo saves the file 
"" (useful for handling the permission-denied error)
"command W w !sudo tee % > /dev/null
"
"" Smart way to move between windows
"map <C-j> <C-W>j
"map <C-k> <C-W>k
"map <C-h> <C-W>h
"map <C-l> <C-W>l
"
"" Close the current buffer
"map <leader>bd :Bclose<cr>:tabclose<cr>gT
"
"" Close all the buffers
"map <leader>ba :bufdo bd<cr>
"
"map <leader>l :bnext<cr>
"map <leader>h :bprevious<cr>
"
"" Useful mappings for managing tabs
"map <leader>tn :tabnew<cr>
"map <leader>to :tabonly<cr>
"map <leader>tc :tabclose<cr>
"map <leader>tm :tabmove 
"map <leader>t<leader> :tabnext 
"
"" Let 'tl' toggle between this and the last accessed tab
"let g:lasttab = 1
"nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
"au TabLeave * let g:lasttab = tabpagenr()
"
"
"" Opens a new tab with the current buffer's path
"" Super useful when editing files in the same directory
"map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
"
"" Switch CWD to the directory of the open buffer
"map <leader>cd :cd %:p:h<cr>:pwd<cr>



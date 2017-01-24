" VIMRC
" Evan Wickenden


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd VimEnter * echom ">^.^<"

" external shell will respect .bashrc functions etc.
set shellcmdflag=-ic

" Set to auto read when a file is changed from the outside
set autoread


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => FILE SPECIFIC BEHAVIOR
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

au BufRead *.txt call OnTxtEnter()
au BufRead .vimrc call OnVimEnter()
au BufRead *.c call OnCEnter()


function OnVimEnter()
	call SetComment('"')
endfunc

function OnTxtEnter()
	call SetComment("")
"	call SetLight()
	set tw=80
endfunc

function OnCEnter()
	call SetComment("//")
"	call SetDark()
	set tw=100
endfunc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => DISABLED Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap K k
nnoremap Q q


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Leader
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Commenting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"nnoremap <leader>p :!pset

"nnoremap ; :s/^/\/\//<CR>:nohlsearch<CR>

nnoremap Ú :s/\/\///<CR>:nohlsearch<CR>

vnoremap <expr> ; ':s/^/' . GetComment() . '/<CR>:nohlsearch<CR>'
"vnoremap <expr>  ':s/' . GetComment() . '//<CR>:nohlsearch<CR>'

nnoremap <expr> ; StartsWithComment() ? 'mq:s/' . GetComment() . '//<CR>:nohlsearch<CR>$`qhh' : 'mq:s/^/' . GetComment() . '/<CR>:nohlsearch<CR>$`qll'
let g:comment_char = '\/\/'
function SetComment(new_comment)
	let g:comment_char = a:new_comment
endfunc	

function GetComment()
	return g:comment_char
endfunc

function StartsWithComment()
let line=getline('.')
let words=split(line)
if(len(words)==0)
	return 0
endif
let fw = words[0]
if(match(fw,GetComment())!=-1)
	return 1
else
	return 0
endif
echom fw
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Height of the command bar
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

" line width
set tw=120

" matching
set shiftround
set showmatch
set matchtime=1

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Set Line Nubering
set number
set relativenumber

nnoremap <leader>num :call ToggleNumber()<cr>

let b:is_relative = 1

function ToggleNumber()
	if b:is_relative == 0
		call SetRelative()
	else
		call SetNorelative()
	endif
endfunc

function SetRelative()
	echom "relative"
	set relativenumber
	let b:is_relative = 1
endfunction

function SetNorelative()
	echom "norelative"
	set norelativenumber
	let b:is_relative = 0
endfunction



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

"colorscheme desert
"set background=light

"colorscheme vividchalk
"set background=dark

nnoremap <leader>col :call ToggleColor()<cr>

let w:is_light = 0

function ToggleColor()
	if w:is_light == 1
		call SetDark()
	else
		call SetLight()
	endif
endfunc

function SetDark()
"	colorscheme vividchalk
	set background=dark
	let w:is_light = 0
endfunc

function SetLight()
	colorscheme desert
	set background=light
	let w:is_light = 1
endfunc


" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
" set expandtab
set smartindent
set autoindent

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

set lbr
set wrap
set linebreak

" auto break after 100 characters
" set tf=100

set nolist  " list disables linebreak

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
nnoremap <space> /
nnoremap <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry


" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

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

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Remember info about open buffers on close
set viminfo^=%


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction


"  END

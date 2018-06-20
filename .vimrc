"VIMRC, Evan Wickenden


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd VimEnter * echom ">^.^<"

"Pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on
filetype plugin on

let g:tex_flavor='latex'

"Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 0
"turn of syntax checking
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']


" external shell will respect .bashrc functions etc.
"set shellcmdflag=-ic
set shellcmdflag=-c

" Set to auto read when a file is changed from the outside
set autoread


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => FILE SPECIFIC BEHAVIOR
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let b:filename = ""
let b:shell_tmp_buf = ""
let g:tmp_tex_filename = ""
let g:tmp_outbuf_name = ""
set splitright

au VimEnter * call OnEnter()
au VimEnter *.tex call OnTexVimEnter()
au BufEnter *.tex call OnTexBufEnter()
au BufEnter *.txt call OnTxtEnter()
au BufEnter .vimrc call OnVimEnter()
au BufEnter *.vim call OnVimEnter()
au BufEnter *.py call OnPythonEnter()
au BufEnter *.c call OnCEnter()
au BufEnter *.h call OnCEnter()
au BufEnter *.cpp call OnCppEnter()
au BufEnter *.cc call OnCCEnter()
au BufEnter *.hpp call OnCppEnter()
au BufEnter *.hs call OnHaskellEnter()
au BufEnter *.sh call OnShEnter()
au BufEnter Makefile call OnMakefileEnter()

function OnEnter()
	echom "OnEnter"
	let b:filename = expand('%:r')
	let b:shell_tmp_buf = ".shell_tmp_buf_" . b:filename
	if "light" ==# $COLOR
		call SetLight()
	else
		call SetDark()
	endif
endfunc

function OnMakefileEnter()
	call SetComment('#')
endfunc

function OnCEnter()
	call SetComment('\/\/')
endfunc

function OnCppEnter()
	call SetComment('\/\/')
endfunc

function OnCCEnter()
	call SetComment('\/\/')
endfunc

function OnHaskellEnter()
	call SetComment('--')
	set ts=4
	set expandtab
endfunc

function OnPythonEnter()
	call SetComment('#')
endfunc

function OnVimEnter()
	call SetComment('"')
endfunc

function OnTxtEnter()
	call SetComment("")
endfunc

function OnShEnter()
	call SetComment('#')
endfunc



function OnTexBufEnter()
	echom "OnTexBufEnter"
	call SetComment('%')
	set tw=100
endfunc

function PdfLatex()
	echom "PdfLatex"
	execute ":! ~/.vim/scripts/pdflatex.sh " . g:tmp_tex_filename . " " . g:tmp_outbuf_name
endfunc


function OnTexVimEnter()
	echom "OnTexVimEnter"
"	echom "b:filename " . b:filename
	let g:tmp_tex_filename = b:filename
	let g:tmp_outbuf_name = b:shell_tmp_buf
"	call AuTester("*")

"	autocmd FileChangedShell * echom "FUCKCHANGEDSHELL"
"	autocmd BufReadPost * echom "FUCK"
"	autocmd Buf

	execute ":vsp|view " . g:tmp_outbuf_name
"	execute "autocmd BufReadPost " . g:tmp_outbuf_name . " normal \<c-w>lggG\<c-w>h"

	vertical resize -20

	execute "normal \<c-w>h"
	nnoremap <leader>p :w<cr>:call PdfLatex()<cr><cr>
endfunc

function AuTester(group)
"	au InsertEnter <buffer> echom "InsertEnter test"
	execute 'autocmd FileChangedShell ' . a:group . ' echom "FileChangedShell test"'
	execute 'autocmd QuitPre ' . a:group . ' execute ":!echo QuitPre test"'
	execute 'autocmd VimLeavePre ' . a:group . ' execute ":!echo VimLeavePre test"'
	execute 'autocmd VimLeave ' . a:group . ' execute ":!echo VimLeave test"'
	execute 'autocmd BufLeave ' . a:group . ' execute ":!echo BufLeave test"'
	execute 'autocmd BufUnload ' . a:group . ' execute ":!echo BufUnload test"'
endfunc

function OutBufChanged()
	echom "OutBufChanged!"
endfunc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Load cscope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! LoadCscope()
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  " else add the database pointed to by environment variable 
  elseif $CSCOPE_DB != "" 
    cs add $CSCOPE_DB
  endif
endfunction
au BufRead /* call LoadCscope()


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
" => Abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

iab nn \nonumber\\<cr>&=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Commenting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"nnoremap <leader>p :!pset

"nnoremap ; :s/^/\/\//<CR>:nohlsearch<CR>

nnoremap Ú :s/\/\///<CR>:nohlsearch<CR>

vnoremap <expr> ; ':s/^/' . GetComment() . '/<CR>:nohlsearch<CR>'
vnoremap <expr> Ú ':s/' . GetComment() . '//<CR>:nohlsearch<CR>'

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
" => Templates
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function Templates()
	echom "TexTemplate() ~generic"
	echom "MTexTemplate() ~math"
	echom "Edit_T() ~edit generic"
	echom "Edit_M() ~edit math"
endfunc

function TexTemplate()
  execute "r ~/.tex/.tex_template"
endfunc

function MTexTemplate()
	execute "r ~/.tex/.tex_template_math"
endfunc

function Edit_T()
	execute "vsp ~/.tex/.tex_template"
endfunc

function Edit_M()
	execute "vsp ~/.tex/.tex_template_math"
endfunc

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
set tw=90


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
nnoremap <leader>tex :call MTexTemplate()<cr>
nnoremap <leader>next /NEXT<cr>

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


" toggle when switching modes
"au InsertEnter * call SetNorelative()
"au InsertLeave * call SetRelative()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

"colorscheme desert
"set background=light

"colorscheme vividchalk
"set background=dark

colorscheme industry

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
"	colorscheme desert
	set background=light
	let w:is_light = 1
endfunc


" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
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
"set expandtab

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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press 	<leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
"map <leader>n :cn<cr>
"map <leader>p :cp<cr>


function SeeDumpedMappings()
	execute "! cat " . g:dumped_mappings
endfunc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => IMAP plugin
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"good idea to end mappings with space, allow for promted execution, allow for
"overlapping abbvs, space will be dropped upon mapping
" e.g.   call IMAP ("bit`", "\\begin{itemize}\<cr>\\item <++>\<cr>\\end{itemize}<++>", "tex")

"call and retrieve mappings
noremap <c-l> :call EditMappings()<cr>
noremap <c-c> :call RecoverMappings()<cr>:echom "mappings recovered :)"<cr>


"define mappings within function
function SetIMappings()
  call IMAP ("al ","\\begin{align*}\<cr>\\end{align*}\<ESC>O<++>","tex")
  call IMAP ("tbf ","\\textbf\{<++>\}","tex")
  call IMAP ("mbb ","\\mathbb\{<++>\}","tex")
	echom "mappings defined"
endfunc

"autocmd BufReadPost * call SetIMappings()

"lol wtf -- only thing that would work
function Backslash(val)
  return substitute(a:val, '\', '\\\\\\\\', 'g')
endfunc

"extension specific imap functions
"store mappings
let g:temp_mappings = "~/.vim/.mappings.vim"
function StoreMap(str,val,type)
	execute '! echo call IMAP\(\"' . Backslash(a:str). '\",\"' .Backslash(a:val). '\",\"' .Backslash(a:type). '\"\) >> ' . g:temp_mappings
endfunc

"tex specific StoreMap
function TMAP(str,val)
	call IMAP(a:str,a:val,"tex")
	echom "Mapping defined"
	call StoreMap(a:str,a:val,"tex")
endfunc

"hacky unmap funcion, specific to tex
function UMAP(...)
	if(a:0 >= 1)
		IMAP(a:1,a:1,"tex")
	endif
endfunc


"functions to store and recover and edit mappings
function RecoverMappings()
	execute "source " . g:temp_mappings
endfunc

"should be used to copy and paste new permanent mappings from there to here
function SeeMappings()
	execute "! cat " . g:temp_mappings
endfunc

"used to comment out or delete unwanted mappings before recovery, or create a
"set of new mappings manually, before using RecoverMappings()
function EditMappings()
	execute "e " . g:temp_mappings
endfunc

let g:dumped_mappings = "~/.vim/.dumped_mappings"
function DumpMappings()
	execute "! cat " . g:temp_mappings . " >> " . g:dumped_mappings
	execute "! rm " . g:temp_mappings
endfunc

function EditDumpedMappings()
	execute "! vim " . g:dumped_mappings
endfunc

set background=dark
set t_Co=256 " Enable 256 colors
colorscheme torte

set wrap " Wrap lines
set linebreak " Break line on word
set hlsearch " Highlight search term in text
hi Search ctermbg=white ctermfg=black
hi VertSplit ctermbg=white ctermfg=white

set incsearch " Show search matches as you type
set ignorecase " Perform case-insensitive search by default
set smartcase " Perform case-insensitive search unless query has capital letters
set wrapscan " Automatically wrap search when hitting bottom
set autoindent " Enable autoindenting
set copyindent " Copy indent of previous line when autoindenting
set history=1000 " Command history
set wildignore=*.class " Ignore .class files
set tabstop=4 " Tab size
set expandtab " Spaces instead of tabs
set softtabstop=4 " Treat n spaces as a tab
set shiftwidth=4 " Tab size for automatic indentation
set shiftround " When using shift identation, round to multiple of shift width

set laststatus=2 " Always show statusline on last window
set pastetoggle=<F3> " Toggle paste mode
set mouse=nvc " Allow using mouse to change cursor position in normal, visual,
              " and command line modes
set timeoutlen=300 " Timeout for completing keymapping
set textwidth=100 " Maximum width in characters
set synmaxcol=150 " Limit syntax highlight parsing to first 150 columns
set foldmethod=marker " Use vim markers for folding
set foldnestmax=4 " Maximum nested folds
set noshowmatch " Do not temporarily jump to match when inserting an end brace
set cursorline " Highlight current line
" set lazyredraw " Conservative redrawing
set backspace=indent,eol,start " Allow full functionality of backspace
set scrolloff=5 " Keep cursor 5 rows above the bottom when scrolling
set nofixendofline " Disable automatic adding of EOL

set relativenumber number " Relative line number and line numbers

set pumheight=10 " Maximum height of pop-up window

set wildmenu

augroup BufferWrite
	autocmd!
	autocmd BufWritePre * call OnBufferWrite()
augroup END

augroup StatusLine
	autocmd!
	autocmd WinEnter * call SetStatusLine()
augroup END

function! OnBufferWrite()
	let l:save_view = winsaveview()
	" Remove trailing whitespace
	" Remove multiple newline
	" Remove undo entry
	silent! undojoin | %s/\s\+$//e "| %!cat -s
	" reset cursor position
	call winrestview(l:save_view)
endfunction

" Create ~/.vim directory if does not exist
if !isdirectory($HOME . '/.vim/')
	call mkdir($HOME . '/.vim/')
endif

" Backup settings
set directory=. " Store swapfiles in the same directory as the file
set directory+=$HOME/.vim/swap// " Alternatively, store swapfiles in a central directory
set backup " Back up previous versions of files
set backupdir=$HOME/.vim/backup// " Store backups in a central directory
set backupdir+=. " Alternatively, store backups in the same directory as the file
" Create swapfiles directory if it does not exist
if !isdirectory($HOME . '/.vim/swap/')
    call mkdir($HOME . '/.vim/swap/')
endif
" Create backup directory if it does not exist
if !isdirectory($HOME . '/.vim/backup/')
    call mkdir($HOME . '/.vim/backup/')
endif

" Persistent undo settings
set undofile " Save undo history
set undodir=$HOME/.vim/backup/undo// " Store undo history in a central directory
set undodir+=. " Alternatively, store undo history in the same directory as the file
set undolevels=1000 " Save a maximum of 1000 undos
set undoreload=10000 " Save undo history when reloading a file
" Create undo history directory if it does not exist
if !isdirectory($HOME . '/.vim/backup/undo')
    call mkdir($HOME . '/.vim/backup/undo')
endif

" Indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<Tab>"
    else
        return "\<C-P>"
    endif
endfunction

function! s:SetMappings()
	map <space> <Leader>
	" jj to escape insertion
	inoremap jj <Esc>

	" visual line movement
	nnoremap j gj
	nnoremap k gk

	" move lines
	map <Leader>j ddp
	map <Leader>k ddkP
	map <Leader>h <<
	map <Leader>l >>

	" autocomplete tabs with reserve navigation
	inoremap <expr> <Tab> pumvisible() ? "\<C-N>" : InsertTabWrapper()
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<S-Tab>"

	" remap start/end line
	nnoremap B ^
	nnoremap E $
	nnoremap ^ <nop>
	nnoremap $ <nop>

	" Easy page up/down
    nnoremap <C-Up> <C-u>
    nnoremap <C-Down> <C-d>
    nnoremap <C-k> 3k
    nnoremap <C-j> 3j
    vnoremap <C-k> 3k
    vnoremap <C-j> 3j

    " Center cursor jumps
    nnoremap <C-o> <C-o>zz
    nnoremap <C-i> <C-i>zz

    " Easy split navigation
    nnoremap <Leader><S-k> <C-w><Up>
    nnoremap <Leader><S-j> <C-w><Down>
    nnoremap <Leader><S-h> <C-w><Left>
    nnoremap <Leader><S-l> <C-w><Right>

    " Note: <bar> denotes |
    " Shortcuts for window commands
    nnoremap <bar> <C-w>v
    nnoremap <bar><bar> :vnew<CR><C-w>L
    nnoremap _ <C-w>s
    nnoremap __ <C-w>n
    nnoremap - <C-w>-
    nnoremap + <C-w>+

    " Easy system clipboard copy/paste
    vnoremap <C-c> "+y
    vnoremap <C-x> "+x
    inoremap <C-p> <Left><C-o>"+p
    " Select last pasted text
    nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

    " command CountMatches :$s///gn
endfunction
call s:SetMappings()

function! SetStatusLine()
    let bufName = bufname('%')
    let winWidth = winwidth(0)
    setlocal statusline=""
    if winWidth > 50
        setlocal statusline+=%t " Tail of the filename
    endif
    if winWidth > 40
        setlocal statusline+=%y " Filetype
    endif
    setlocal statusline+=%=                      " Left/right separator
    setlocal statusline+=%#Blue_39#              " File path begin
    setlocal statusline+=%{expand('%:p')}     " Full path
    setlocal statusline+=\ \ \ |
    setlocal statusline+=C:%2c\                  " Cursor column, reserve 2 spaces
    setlocal statusline+=R:%3l/%3L               " Cursor line/total lines, reserve 3 spaces for each
    setlocal statusline+=%#Green_41#\|%##%3p     " Percent through file, reserve 3 spaces
    setlocal statusline+=%%                      " Percent symbol

endfunction
call SetStatusLine()

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

set wrap " Wrap lines
set linebreak " Break line on word
set hlsearch " Highlight search term in text
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
set t_Co=256 " Enable 256 colors
set textwidth=100 " Maximum width in characters
set synmaxcol=150 " Limit syntax highlight parsing to first 150 columns
set foldmethod=marker " Use vim markers for folding
set foldnestmax=4 " Maximum nested folds
set noshowmatch " Do not temporarily jump to match when inserting an end brace
set cursorline " Highlight current line
set lazyredraw " Conservative redrawing
set backspace=indent,eol,start " Allow full functionality of backspace
set scrolloff=5 " Keep cursor 5 rows above the bottom when scrolling
set nofixendofline " Disable automatic adding of EOL

" jj to escape insertion
imap jj <Esc> 
set relativenumber number " relative line number and line numbers

" visual line movement
nnoremap j gj 
nnoremap k gk

" remap start/end line
nnoremap B ^
nnoremap E $
nnoremap ^ <nop>
nnoremap $ <nop>

colorscheme torte

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>


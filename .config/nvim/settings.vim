let mapleader="\<space>"
"----------------------------------------------------------
" Search
"----------------------------------------------------------
set incsearch   " Highlight while searching
set ignorecase  " Ignore case when searching
set smartcase   " Intelligent case sensitivity when searching (if there is upper case, turn off case ignoring)
set hlsearch    " Allow search highlighting
set wrapscan    " Allows to search the entire file repeatedly

"----------------------------------------------------------
" Tab, Intent
"----------------------------------------------------------
set expandtab                           " Use spaces instead of tabs
set tabstop=4                           " Width of a tab displayed
set softtabstop=4                       " Delete 4 spaces at once
set autoindent                          " Auto-indent, press o on the current line, the new line is always aligned with the current line
set copyindent
set smartindent                         " Set smart indent
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set shiftwidth=4                        " The width of indentation
set formatoptions-=cro
set signcolumn=yes                      " Set the width of the symbol column, if not set, it will cause an exception when displaying the icon

set number
set clipboard=unnamedplus


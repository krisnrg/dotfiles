:lua vim.opt.termguicolors = true



"--- Load plugins
:source ~/.config/nvim/setup/plugins.vim

"---  Telescope setup
:lua require('telescope-setup')

"   __  __                   _                 
"  |  \/  |                 (_)                
"  | \  / | __ _ _ __  _ __  _ _ __   __ _ ___ 
"  | |\/| |/ _` | '_ \| '_ \| | '_ \ / _` / __|
"  | |  | | (_| | |_) | |_) | | | | | (_| \__ \
"  |_|  |_|\__,_| .__/| .__/|_|_| |_|\__, |___/
"               | |   | |             __/ |    
"               |_|   |_|            |___/     

"--- Set the leader key
let mapleader=" "

"--- Diff Options
set diffopt=vertical,filler

nmap <expr> <Up> &diff ? '[czz' : '<Up>'
nmap <expr> <Down> &diff ? ']czz' : '<Down>'
"--- Goyo
nnoremap <leader>z :Goyo<cr>
let g:goyo_width = 130

"--- Limelight
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_guifg = '#6272a4' 

"--- Encoding
set encoding=UTF-8

"--- Select all
nnoremap <leader>a ggVG

"--- Hold indent in visual mode
xnoremap < <gv
xnoremap > >gv

"--- Move text up and down
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :move '>+1<CR>gv-gv
vnoremap <M-k> :move '<-2<CR>gv-gv

"--- Add a new carrage return in normal mode
"--- TODO: want to evntually map shift <cr> when possible
nnoremap <cr> o<Esc>
:autocmd CmdwinEnter * nnoremap <CR> <CR>
:autocmd BufReadPost quickfix nnoremap <CR> <CR>

"--- Fixing pasting in visual mode
xnoremap p pgvy

"--- Making G work better
nmap G Gzz

"--- Select word
inoremap <C-w> <Esc>viw

"--- Emacs basics movement in insert mode
inoremap <C-A> <Home>
inoremap <C-B> <Left>
inoremap <C-E> <End>
inoremap <C-F> <Right>

"--- Quit VIM
nnoremap <leader>q <cmd>:q <cr>

"--- Save the current file
nnoremap <leader>sf <cmd>:w <cr>

"--- Map key chord `jk` to <Esc>.
let g:esc_j_lasttime = 0
let g:esc_k_lasttime = 0
function! JKescape(key)
	if a:key=='j' | let g:esc_j_lasttime = reltimefloat(reltime()) | endif
	if a:key=='k' | let g:esc_k_lasttime = reltimefloat(reltime()) | endif
	let l:timediff = abs(g:esc_j_lasttime - g:esc_k_lasttime)
	return (l:timediff <= 0.08 && l:timediff >=0.001) ? "\b\e" : a:key
endfunction
inoremap <expr> j JKescape('j')
inoremap <expr> k JKescape('k')

"--- Terminal jk
let g:esc_j_lasttime = 0
let g:esc_k_lasttime = 0
function! JKescapeT(key)
	if a:key=='j' | let g:esc_j_lasttime = reltimefloat(reltime()) | endif
	if a:key=='k' | let g:esc_k_lasttime = reltimefloat(reltime()) | endif
	let l:timediff = abs(g:esc_j_lasttime - g:esc_k_lasttime)
    return (l:timediff <= 0.1 && l:timediff >=0.001) ? "\<C-\>\<C-N>" : a:key
endfunction
tnoremap <expr> j JKescapeT('j')
tnoremap <expr> k JKescapeT('k')

"--- Esc to hide highlight after search
nnoremap <silent> <esc> :noh <CR>

"--- Save and source your config file (while you have it open)
nnoremap <leader>rr <cmd>:w <cr>:source $MYVIMRC<cr>

"--- Run the npm run start command 
nnoremap <leader>rs <cmd>:w <cr> :!npm run start<cr>

"--- Open the init.vim config file
nnoremap <leader>fc <cmd>:e ~/.config/nvim<cr>

"--- Tab bindings
nnoremap tt :tabnext<CR>
nnoremap tb :tabprev<CR>
nnoremap tn :tabnew<CR>

"--- Toggle the line numbers
nnoremap <leader>n <cmd>:set number!<cr>

"--- Telescope bindings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope grep_string<cr>
nnoremap <leader>fl <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
noremap <leader>fs <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>ft :lua require'telescope-setup'.find_configs()<cr>
"--- Use alt + hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

"--- NERDTree bindings
nnoremap <leader>b <cmd>:NERDTreeToggle<cr>
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
let NERDTreeQuitOnOpen = 1
let g:NERDTreeHighlightCursorline = 1

"--- Set some vars
set timeoutlen=300

"--- Some search options
set ignorecase
set smartcase

"--- Smart Indent
set smartindent

"--- Not sure what this does, please tell me
set fillchars=eob:\ 

"--- Turn on line numbers 
set number

"--- Auto close tag filetypes
let g:closetag_filenames = '*.html,*.xhtml,*.js,*.jsx,javascript,*.ts,*.tsx,typescript,vue,*.vue'

"--- Use system clipboard
set clipboard=unnamedplus

"--- Spaces & Tab
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line

"--- Current theme controls
let g:dracula_colorterm = 1
set updatetime=100
filetype plugin on

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

"--- Easy moving between paragraphs but 
"--- To the beging and end of lines
"--- This will now also center your cursor as well
function! MoveParagraph(x,y) abort
  if empty(getline(line('.') + (a:x == '{' ? -1 : 1)))
     exec "norm! ".a:x
   endif
  exec "norm! ".a:x
  if empty(getline('.')) | exec "norm! ".a:y | endif
endfunction
nnoremap <C-k> :call MoveParagraph('{', 'wzz')<CR>
nnoremap <C-j> :call MoveParagraph('}', 'gezz')<CR>

":lua require("telescope").load_extension "file_browser"

"--- Setup hop
:lua require'hop'.setup()
:lua vim.api.nvim_set_keymap('n', 'f', ":HopChar1<CR>", {})
:lua vim.api.nvim_set_keymap('n', '<leader>hl', ":HopLineStart<CR>", {})

"--- Automaticaly close NVIM if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"--- Turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>

"--- Start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif

"   _____                  _              
"  |  __ \                (_)             
"  | |__) |___  __ _ _   _ _ _ __ ___ ___ 
"  |  _  // _ \/ _` | | | | | '__/ _ / __|
"  | | \ |  __| (_| | |_| | | | |  __\__ \
"  |_|  \_\___|\__, |\__,_|_|_|  \___|___/
"                 | |                     
"                 |_|     

"---  Lsp setup
:lua require('lsp-setup')

"---  cmp setup
:lua require('cmp-setup')

"---  treesitter setup
:lua require('treesitter-setup')

"---  surround setup
:lua require('surround-setup')

"---  which-key setup
:lua require('which-setup')

"---  Pears setup
:lua require "pears".setup()

"--- Colorizer setup"
:lua require'colorizer'.setup()

if has("nvim")
  au TermOpen * tnoremap <Esc> <c-\><c-n>
  au FileType fzf tunmap <Esc>
endif

if (has("termguicolors"))
 set termguicolors
endif

syntax enable
colorscheme dracula

"--- Set curserLine only on current window
set cursorline

"--- Default Colors for CursorLine
highlight CursorLine ctermbg=White  guibg=#232530
highlight CursorLineNr ctermfg=White cterm=bold guifg=#ffffff

"--- Change Color when entering Insert Mode
autocmd InsertEnter * highlight CursorLine ctermbg=None guibg=None
autocmd InsertLeave * highlight CursorLine ctermbg=White guibg=#232530

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=700})
augroup END


" Colors in tmux
if exists('$TMUX')
    let &t_8f = "<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "<Esc>[48;2;%lu;%lu;%lum"
endif

"set termguicolors
let g:airline_theme='transparent'
let g:airline#extensions#localsearch#enabled = 0
"so $VIMRUNTIME/syntax/hitest.vim

function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
  " ...
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"https://draculatheme.com/contribute
"green="#8aff80"
"yellow="#ffff80"
"pink="#ff80bf"
"purple="#9580ff"
"cyan="#80ffea"
"orange="#ffca80"
"red="#ff9580"

"hi link TelescopeBorder DraculaBgDarker
"link TelescopePromptBorder DraculaBgLight
"Promp text and bg
hi link TelescopePromptNormal DraculaBgLight
hi link TelescopePromptCounter DraculaComment
hi! TelescopeTitle guifg=#50FA7B term=bold,reverse ctermfg=117 gui=bold,reverse
hi! link TelescopeResultsTitle DraculaOrange
hi! link TelescopePreviewTitle DraculaTodo
"hi link TelescopeNormal DraculaBgDark
hi link TelescopeResultsNormal DraculaBgDark
hi link TelescopePreviewNormal DraculaBgDark

"hi link TelescopePromptBorder DraculaBgLight
hi! TelescopePromptBorder guifg=#343746 guibg=#343746
hi! TelescopeResultsBorder guifg=#21222C guibg=#21222C
hi! TelescopePreviewBorder guifg=#21222C guibg=#21222C

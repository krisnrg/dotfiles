" imports
runtime functions.vim

" jump to the last edited file
nnoremap <leader>o <C-^>

" jk as escape in insert mode
inoremap <silent> jk <Esc>
inoremap <silent> ｊｋ <Esc>
tnoremap <silent> jk <Esc>
tnoremap <silent> ｊｋ <Esc>

" move to start/end of line
noremap <C-h> ^
noremap <C-l> $

" Move up and down with wrap
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk
xnoremap j gj
xnoremap k gk
xnoremap <down> gj
xnoremap <up> gk

" Move text up and down
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
nnoremap <M-j> :m .+1<CR>==gi
nnoremap <M-k> :m .-2<CR>==gi
vnoremap <M-j> :move '>+1<CR>gv-gv
vnoremap <M-k> :move '<-2<CR>gv-gv

" Move to diffent panes with [hl]
nnoremap <leader>l <C-w>l
nnoremap <leader>h <C-w>h

" Hop keymaps
nnoremap f :HopChar1<CR>
nnoremap <leader>hl :HopLineStart<CR>

" select all
nnoremap <leader>a ggVG

" hold indent in visual mode
xnoremap < <gv
xnoremap > >gv

" add a new carrage return in normal mode
" TODO: want to evntually map shift <cr> when possible
nnoremap <cr> o<Esc>
:autocmd CmdwinEnter * nnoremap <CR> <CR>
:autocmd BufReadPost quickfix nnoremap <CR> <CR>

" fixing pasting in visual mode
" xnoremap p pgvy

" making G work better
nmap G Gzz

" select word
inoremap <C-w> <Esc>viw

" emacs basics movement in insert mode
inoremap <C-A> <Home>
inoremap <C-B> <Left>
inoremap <C-E> <End>
inoremap <C-F> <Right>

" quit nvim
nnoremap <leader>q <cmd>:q <cr>

" map key chord `jk` to <Esc>.
" inoremap <expr> j JKescape('j')
" inoremap <expr> k JKescape('k')

" rsc to hide highlight after search
nnoremap <silent> <esc> :noh <CR>

" run the npm run start command 
nnoremap <leader>rs <cmd>:w <cr> :!npm run start<cr>

" tab bindings
nnoremap tt :tabnext<CR>
nnoremap tb :tabprev<CR>
nnoremap tn :tabnew<CR>

" toggle the line numbers
nnoremap <leader>n <cmd>:set number!<cr>

" telescope bindings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope grep_string<cr>
nnoremap <leader>fl <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
noremap <leader>fs <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>ft :lua require'telescope-setup'.find_configs()<cr>

" return in normal mode
nnoremap <cr> o<Esc>

" use alt + hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" easy moving between paragraphs but 
" to the beging and end of lines
" this will now also center your cursor as well
function! MoveParagraph(x,y) abort
  if empty(getline(line('.') + (a:x == '{' ? -1 : 1)))
     exec "norm! ".a:x
   endif
  exec "norm! ".a:x
  if empty(getline('.')) | exec "norm! ".a:y | endif
endfunction
nnoremap <C-k> :call MoveParagraph('{', 'wzz')<CR>
nnoremap <C-j> :call MoveParagraph('}', 'gezz')<CR>

" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>

" Neotree
nnoremap <leader>b :Neotree toggle<cr>

if (has("termguicolors"))
 set termguicolors
endif

colorscheme dracula

" set curserLine only on current window
set cursorline

" default Colors for CursorLine
highlight CursorLine ctermbg=White  guibg=#232530
highlight CursorLineNr ctermfg=White cterm=bold guifg=#ffffff

" change Color when entering Insert Mode
autocmd InsertEnter * highlight CursorLine ctermbg=None guibg=None
autocmd InsertLeave * highlight CursorLine ctermbg=White guibg=#232530

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=700})
augroup END

" https://draculatheme.com/contribute
" green="#8aff80"
" yellow="#ffff80"
" pink="#ff80bf"
" purple="#9580ff"
" cyan="#80ffea"
" orange="#ffca80"
" red="#ff9580"

hi link TelescopePromptNormal DraculaBgLight
hi link TelescopePromptCounter DraculaComment
hi! TelescopeTitle guifg=#50FA7B term=bold,reverse ctermfg=117 gui=bold,reverse
hi! link TelescopeResultsTitle DraculaOrange
hi! link TelescopePreviewTitle DraculaTodo
hi link TelescopeResultsNormal DraculaBgDark
hi link TelescopePreviewNormal DraculaBgDark
hi! TelescopePromptBorder guifg=#343746 guibg=#343746
hi! TelescopeResultsBorder guifg=#21222C guibg=#21222C
hi! TelescopePreviewBorder guifg=#21222C guibg=#21222C
hi Normal ctermbg=NONE guibg=NONE
hi SignColumn guibg=NONE cterm=NONE term=NONE

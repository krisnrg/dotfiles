
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

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

" terminal jk
" let g:esc_j_lasttime = 0
" let g:esc_k_lasttime = 0
" function! JKescapeT(key)
" 	if a:key=='j' | let g:esc_j_lasttime = reltimefloat(reltime()) | endif
" 	if a:key=='k' | let g:esc_k_lasttime = reltimefloat(reltime()) | endif
" 	let l:timediff = abs(g:esc_j_lasttime - g:esc_k_lasttime)
"     return (l:timediff <= 0.1 && l:timediff >=0.001) ? "\<C-\>\<C-N>" : a:key
" endfunction

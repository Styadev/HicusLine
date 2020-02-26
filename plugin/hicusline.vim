" A highly customizable statusline in (neo)vim.
" Author: Styadev's everyone <https://github.com/Styadev>
" Last Change: <+++>
" Version: 1.0.0
" Repository: https://github.com/Styadev/HicusLine
" License: MIT

" AutoLoad {{{
if exists('g:HicusLineLoaded')
	finish
endif
function! s:ThrowError(errorType)
	echohl Error
	if a:errorType == 0
		echom '[HicusLine]: You have not set the HicusLineEnabled, run :help hicusline to know about it.'
	elseif a:errorType == 1
		echom '[HicusLine]: The HicusLineEnabled you set is wrong, run :help hicusline to know about it.'
	endif
	echohl None
endfunction
if !exists('g:HicusLineEnabled')
	call s:ThrowError(0)
	finish
elseif g:HicusLineEnabled == 0
	finish
elseif g:HicusLineEnabled != 0 && g:HicusLineEnabled != 1
	call s:ThrowError(1)
	finish
elseif type(g:HicusLineEnabled) != 0
	call s:ThrowError(1)
	finish
endif
let g:HicusLineLoaded = 1
" }}}

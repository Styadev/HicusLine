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
	elseif a:errorType == 2
		echom '[HicusLine]: You have not open the statusline, write: set laststatus=2 in your vimrc or init.vim.'
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
elseif &laststatus == 0
	call s:ThrowError(2)
	finish
endif
let g:HicusLineLoaded = 1
" }}}

command! -nargs=0 HicusLineEnable call s:TurnOn()
command! -nargs=0 HicusLineDisable call s:TurnOff()

function! s:TurnOn() " TurnOn the HicusLine
endfunction

function! s:TurnOff() " TurnOff the HicusLine
endfunction

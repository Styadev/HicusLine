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
function! s:ThrowError(errorType, otherContent)
	echohl Error
	if a:errorType == 0
		echom '[Hicusline]: '.a:otherContent
	elseif a:errorType == 1
		echom '[HicusLine]: You have not set the HicusLineEnabled, run :help hicusline to know about it.'
	elseif a:errorType == 2
		echom '[HicusLine]: The HicusLineEnabled you set is wrong, run :help hicusline to know about it.'
	elseif a:errorType == 3
		echom '[HicusLine]: You have not open the statusline, write: set laststatus=2 in your vimrc or init.vim.'
	endif
	echohl None
endfunction
if !exists('g:HicusLineEnabled')
	call s:ThrowError(1, '')
	finish
elseif g:HicusLineEnabled == 0
	finish
elseif g:HicusLineEnabled != 0 && g:HicusLineEnabled != 1
	call s:ThrowError(2, '')
	finish
elseif type(g:HicusLineEnabled) != 0
	call s:ThrowError(2, '')
	finish
elseif &laststatus == 0
	call s:ThrowError(3, '')
	finish
endif
let g:HicusLineLoaded = 1
" }}}

" Command mappings {{{
command! -nargs=0 HicusLineEnable call s:TurnOn()
command! -nargs=0 HicusLineDisable call s:TurnOff()
" }}}

" FUNCTION: s:TurnOn() {{{
function! s:TurnOn() abort " TurnOn the HicusLine
	if !exists('s:HicusLineStatus')
		call s:ThrowError(0, 'The HicusLine is openning, you can run :help hicusline-command to know about it.')
		return
	elseif s:HicusLineStatus == 1
		call s:ThrowError(0, 'The HicusLine is openning, you can run :help hicusline-command to know about it.')
		return
	endif
	let s:HicusLineStatus = 1
	" Call the status api function
endfunction " }}}

" FUNCTION: s:TurnOff() {{{
function! s:TurnOff() abort " TurnOff the HicusLine
	if s:HicusLineStatus == 0
		call s:ThrowError(0, 'The HicusLine is colsing, you can run :help hicusline-command to know about it.')
		return
	endif
	let s:HicusLineStatus = 0
	" Call the status close api function.
endfunction " }}}

function! s:StatuslineControl() " This function is to control the statusline.
	if !exists('s:HicusLineStatus')
		" Call the HicusLine's start function
	elseif s:HicusLineStatus == 0
		" Call the HicusLine's stop function
	elseif s:HicusLineStatus == 1
		" Call the HicusLine's start function
	else
		call s:ThrowError(0, 's:HicusLineStatus value is error,try to restart the (neo)vim.')
		finish
	endif
endfunction

function! s:StatuslineStart() abort
endfunction

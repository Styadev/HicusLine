" A highly customizable statusline in (neo)vim.
" Author: Styadev's everyone <https://github.com/Styadev>
" Last Change: <+++>
" Version: 1.0.0
" Repository: https://github.com/Styadev/HicusLine
" License: MIT

" AutoLoad {{{1
if exists('g:HicusLineLoaded')
	finish
endif
" FUNCTION: s:ThrowError(errorType[, otherContent]) {{{2
function! s:ThrowError(errorType, ...)
	echohl Error
	if a:errorType == 0
		echom '[Hicusline]: '.a:1
	elseif a:errorType == 1
		echom '[HicusLine]: You have not set the HicusLineEnabled, run :help hicusline to know about it.'
	elseif a:errorType == 2
		echom '[HicusLine]: The HicusLineEnabled you set is wrong, run :help hicusline to know about it.'
	elseif a:errorType == 3
		echom '[HicusLine]: You have not open the statusline, write: set laststatus=2 in your vimrc or init.vim.'
	endif
	echohl None
endfunction " 2}}}
if !exists('g:HicusLineEnabled')
	call s:ThrowError(1)
	finish
elseif g:HicusLineEnabled == 0
	finish
elseif g:HicusLineEnabled != 0 && g:HicusLineEnabled != 1
	call s:ThrowError(2)
	finish
elseif type(g:HicusLineEnabled) != 0
	call s:ThrowError(2)
	finish
elseif &laststatus == 0
	call s:ThrowError(3)
	finish
endif
let g:HicusLineLoaded = 1
" 1}}}

" Command mappings {{{
command! -nargs=0 HicusLineEnable call s:TurnOnOff(1)
command! -nargs=0 HicusLineDisable call s:TurnOnOff(0)
" }}}

" FUNCTION: s:TurnOn(turnType) {{{
function! s:TurnOnOff(turnType) abort " TurnOn the HicusLine
	if a:turnType == 0
		if s:HicusLineStatus == 0
			call s:ThrowError(0, 'The HicusLine is colsing, you can run :help hicusline-command to know about it.')
			return
		endif
		let s:HicusLineStatus = 0
		call s:StatuslineStop()
	elseif a:turnType == 1
		if !exists('s:HicusLineStatus')
			call s:ThrowError(0, 'The HicusLine is openning, you can run :help hicusline-command to know about it.')
			return
		elseif s:HicusLineStatus == 1
			call s:ThrowError(0, 'The HicusLine is openning, you can run :help hicusline-command to know about it.')
			return
		endif
		let s:HicusLineStatus = 1
		call s:StatuslineStart()
	endif
endfunction " }}}

" FUNCTION: s:CheckStatusline() {{{
function! s:CheckStatusline()
	if s:HicusLineLoaded == 0
		call s:ThrowError(0, 'The g:HicusLineLoaded is error, please check the source code or restart (neo)vim.')
		finish
	elseif s:HicusLineStatus == 0
		call s:ThrowError(0, 'Program wants to start statusline, but it is closing, please check the source code or restart (neo)vim.')
		return
	endif
endfunction " }}}

" FUNCTION: s:StatuslineStart() {{{
function! s:StatuslineStart() abort
	if s:CheckStatusline() == 0
		return
	endif
	call s:SetStatusline()
endfunction " }}}

" FUNCTION: s:StatuslineStop() {{{
function! s:StatuslineStop() abort
	if s:HicusLineStatus == 0
		call s:ThrowError(0, 'The s:HicusLineStatus is error, please check the source code or restart (neo)vim.')
		return
	endif
endfunction " }}}

" FUNCTION: s:UseDefaultTemplate() {{{
function! s:UseDefaultTemplate() abort
	if s:CheckStatusline() == 0
		return
	endif
	runtime template/default.vim
	call HicusLineDefaultUse()
endfunction " }}}

" FUNCTION: s:GetHicusLine(attribute, type[, list|dictionaries]) {{{
function! s:GetHicusLine(attribute, type, ...) abort
	if a:type == 0 " List
		let l:listNum = len(a:1)
		return l:listNum
	elseif a:type == 1 " Dictionaries
		if a:0 == 0
			if !exists('g:HicusLine') || empty(g:HicusLine)
				call s:ThrowError(0, 'The g:HicusLine is error, please check it or restart (neo)vim.')
				return
			endif
			let l:HicusLineDic = g:HicusLine
		elseif type(a:1) == 4
			let l:HicusLineDic = a:1
		else
			call s:ThrowError(0, 'The Dictionaries is error, please check the source code or restart (neo)vim.')
			return
		endif
		if has_key(l:HicusLineDic[a:attribute])
			let l:result = remove(l:HicusLineList, a:attribute)
			unlet l:HicusLineDic
			return l:result
		else
			return
		endif
	endif
endfunction " }}}

function! s:DecideAttribute(key, value)
	if a:key ==# 'left'
	endif
endfunction

function! s:SetStatusline() abort
	if s:CheckStatusline() == 0
		return
	endif
	if !exists('g:HicusLine') || empty(g:HicusLine)
		call s:ThrowError(0, 'The g:HicusLine is error, please check it or restart (neo)vim.')
		return
	endif
	let l:HicusLineNum = len(s:HicusLine)
	let l:HicusDic = g:HicusLine
	for [l:key, l:value] in items(l:HicusDic)
		call s:DecideAttribute(l:key, l:value)
	endfor
endfunction

function! s:GetBuffers() abort
endfunction

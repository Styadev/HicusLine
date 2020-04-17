" A highly customizable statusline in (neo)vim.
" Author: Styadev's everyone <https://github.com/Styadev>
" Last Change: 2020.4.17
" Version: 1.1.5
" Repository: https://github.com/Styadev/HicusLine.git &&
" https://gitee.com/springhan/HicusLine.git
" License: MIT

" AutoLoad {{{1
if exists('g:HicusLineLoaded')
	finish
endif
" FUNCTION: s:ThrowError(errorType[, otherContent]) {{{2
function! s:ThrowError(...)
	echohl Error | echom !exists('a:1')?'':'[Hicusline]: '.a:1 | echohl None
endfunction " 2}}}
execute !exists('g:HicusLineEnabled')?
			\"call s:ThrowError('[HicusLine]: You have not set the HicusLineEnabled, run :help hicusline to know about it.') | finish":
			\""
execute g:HicusLineEnabled != 0 && g:HicusLineEnabled != 1?
			\"call s:ThrowError('[HicusLine]: The HicusLineEnabled you set is wrong, run :help hicusline to know about it.') | finish":
			\""
execute &laststatus == 0?
			\"call s:ThrowError('[HicusLine]: You have not open the statusline, write: set laststatus=2 in your vimrc or init.vim.') | finish":
			\""
silent! execute g:HicusLineEnabled == 0?'finish':''
let g:HicusLineLoaded = 1
let g:HicusLineStatus = 1
" 1}}}

" HicusLineOptions {{{
let s:HicusLineOptions = { 0: '%*', 'truncate': '%<',
			\ 'modehighlight': '%#modehighlight#%{HicusModeHighlight()}',
			\ 'errorstatus': '%{HicusErrorStatus()}', 'gitinfo': '%{HicusGitInfo()}',
			\ 'warningstatus': '%{HicusWarningStatus()}', 'space': "\ ",
			\ 'spell': '%{HicusSpellStatus()}', 'mode': '%{HicusStatusMode()}',
			\ 'filename': '%t', 'fileformat': '%{&fileformat}',
			\ 'fileencoding': '%{&fileencoding}','bufferfilepath': '%f',
			\ 'filepath': '%F', 'buffernumber': '%n', 'chardecimal': '%b',
			\ 'charhexadecimal': '%B', 'printernumber': '%N', 'linenumber': '%l',
			\ 'bufferlinesnumber': '%L', 'columnnuber': '%c', 'overdecimal': '%o',
			\ 'overhexadecimal': '%O', 'virtualcolumn': '%v', 'virtualspecial': '%V',
			\ 'linepercentage': '%p', 'windowpercentage': '%P', 'modified': '%m',
			\ 'modified1': '%m', 'modified2': '%M', 'readonly': '%r',
			\ 'readonly1': '%r', 'readonly2': '%R', 'helpbuffer': '%h',
			\ 'helpbuffer1': '%h', 'helpbuffer2': '%H', 'preview': '%w',
			\ 'preview1': '%w', 'preview2': '%W', 'filetype': '%y',
			\ 'filetype2': '%{HicusFiletype(0)}', 'filetype3': '%{HicusFiletype(1)}',
			\ 'bufferline': '%<%#HicusBuffer#%{HicusBufferPrev()}'.
			\ '%#HicusCurrentBuffer#%{HicusBufferCur()}%#HicusBuffer#'.
			\ '%{HicusBufferNext()}%*', }
" }}}

" Command mappings {{{
command! -nargs=0 HicusLineEnable call s:TurnOnOff(1)
command! -nargs=0 HicusLineDisable call s:TurnOnOff(0)
command! -nargs=0 HicusSyntaxReload call s:SetHighlight()
" }}}

" FUNCTION: s:CheckStatusline() {{{
function! s:CheckStatusline()
	execute g:HicusLineLoaded == 0?
				\"call s:ThrowError('The g:HicusLineLoaded is error, please check the source code or restart (neo)vim.') | finish":
					\""
	execute g:HicusLineStatus == 0?
				\"call s:ThrowError('Program wants to start statusline, but it is closing, please check the source code or restart (neo)vim.') | return":
				\""
	return 1
endfunction " }}}

" FUNCTIONS: TipsSigns {{{
function! HicusGitInfo()
	let l:gitinfo = get(g:, 'coc_git_status', '')
	return empty(l:gitinfo)?'':l:gitinfo
endfunction

function! HicusErrorStatus()
	let l:errorStatus = get(b:, 'coc_diagnostic_info', '')
	let l:errors = empty(l:errorStatus)?'':get(l:errorStatus, 'error', '')
	unlet l:errorStatus
	return l:errors == ''?'':s:tipsSign[0].l:errors
endfunction

function! HicusWarningStatus()
	let l:warningStatus = get(b:, 'coc_diagnostic_info', '')
	let l:warnings = empty(l:warningStatus)?'':get(l:warningStatus, 'warning', '')
	return l:warnings == ''?'':s:tipsSign[1].l:warnings
endfunction " }}}

" FUNCTION: HicusModeHighlight() {{{
function! HicusModeHighlight() abort
	silent execute !has_key(g:HicusLineMode, mode())?"return ''":""
	let l:mode = get(g:HicusLineMode, mode())
	silent execute type(l:mode) != 3?"return 'Error'":"highlight link modehighlight ".l:mode[1]
	if len(l:mode) == 3 && type(l:mode[2]) == 4
		for [ l:key, l:value ] in items(l:mode[2])
			silent! execute 'highlight link '.l:key.' '.l:value
		endfor
	endif
	unlet l:key l:value l:mode
	return ''
endfunction " }}}

" FUNCTION: HicusStatusMode() {{{
function! HicusStatusMode() abort
	if !exists('g:HicusLineMode') || empty(g:HicusLineMode) ||
				\type(g:HicusLineMode) != 4
		call s:ThrowError('The g:HicusLineMode is error, please run :help g:HicusLineMode to know about it.')
		return
	endif
	silent! execute !has_key(g:HicusLineMode, mode())?"return":""
	let l:statusMode = get(g:HicusLineMode, mode())
	silent! execute type(l:statusMode) != 3?'return l:statusMode':
				\ 'return l:statusMode[0]'
endfunction " }}}

" FUNCTION: s:SetHighlight() {{{
function! s:SetHighlight() abort
	if !exists('g:HicusColor')
		call s:ThrowError('You have not set the g:HicusColor, if you do not want to set, you should delete the highlight group in g:HicusLine') | return
	endif
	for l:values in items(g:HicusColor)
		if len(l:values) != 2 || len(l:values[1]) != 3
			call ThrowError('The g:HicusColor is error, please check it.')
			return
		endif
		execute 'highlight '.l:values[0].' gui='.l:values[1][0].' guifg='.l:values[1][1].' guibg='.l:values[1][2]
	endfor
endfunction " }}}

" FUNCTION: HicusSpellStatus() {{{
function! HicusSpellStatus() abort
	if &spell == 0
		return ''
	elseif &spell == 1
		return 'SPELL['.&spelllang.']'
	endif
endfunction " }}}

" FUNCTION: HicusFiletype(type) {{{
function! HicusFiletype(type) abort
	if a:type == 0
		return toupper(&filetype)
	elseif a:type == 1
		return &filetype
	endif
endfunction " }}}

" FUNCTIONS: HicusBuffer {{{
function! HicusBufferPrev() abort
	let l:buffers = ''
	for l:bufferNr in range(1, bufnr('%')-1)
		if bufexists(l:bufferNr) && buflisted(l:bufferNr)
			if bufname(l:bufferNr) != ''
				let l:bufferName = s:buffertype == 'name'?
							\ fnamemodify(bufname(l:bufferNr), ':t'):
							\ fnamemodify(bufname(l:bufferNr), ':p')
				let l:buffers .= getbufvar(l:bufferNr, '&mod') == 1 ?
							\ l:bufferNr.' '.l:bufferName.' ' :
							\ l:bufferNr.' '.l:bufferName.'+ '
			else
				let l:buffers .= getbufvar(l:bufferNr, '&mod') == 1 ?
							\ l:bufferNr.' '.'[No Name] ' :
							\ l:bufferNr.' '.'[No Name]+ '
			endif
		endif
	endfor
	return l:buffers
endfunction

function! HicusBufferCur() abort
	let l:bufferName = s:buffertype == 'name'?
				\ fnamemodify(bufname('%'), ':t'):
				\ fnamemodify(bufname('%'), ':p')
	if bufname('%') != ''
		return getbufvar('%', '&mod') == 1 ? bufnr('%').' '.l:bufferName.'+' :
					\ bufnr('%').' '.l:bufferName
	else
		return getbufvar('%', '&mod') == 1 ? bufnr('%').' '.'[No Name]+' :
					\ bufnr('%').' '.'[No Name]'
	endif
endfunction

function! HicusBufferNext() abort
	let l:buffers = ''
	for l:bufferNr in range(bufnr('%')+1, bufnr('$'))
		if bufexists(l:bufferNr) && buflisted(l:bufferNr)
			if bufname(l:bufferNr) != ''
				let l:bufferName = s:buffertype == 'name'?
							\ fnamemodify(bufname(l:bufferNr), ':t'):
							\ fnamemodify(bufname(l:bufferNr), ':p')
				let l:buffers .= getbufvar(l:bufferNr, '&mod') == 1 ?
							\ l:bufferNr.' '.l:bufferName.' ' :
							\ l:bufferNr.' '.l:bufferName.'+ '
			else
				let l:buffers .= getbufvar(l:bufferNr, '&mod') == 1 ?
							\ l:bufferNr.' '.'[No Name] ' :
							\ l:bufferNr.' '.'[No Name]+ '
			endif
		endif
	endfor
	return l:buffers
endfunction " }}}

" FUNCTION: s:DecideAttribute(leftKey, rightKey) {{{
function! s:DecideAttribute(leftKey, rightKey) abort
	function! SetAttribute(keyAttribute)
		for l:attribute in a:keyAttribute
			let &statusline .= has_key(s:HicusLineOptions, l:attribute)?
						\ get(s:HicusLineOptions, l:attribute):l:attribute
		endfor
	endfunction
	if !exists('l:leftStatus') | call SetAttribute(a:leftKey)
		let l:leftStatus = 1
	endif
	if l:leftStatus == 1 | set statusline+=%= | call SetAttribute(a:rightKey)
	endif
	unlet l:leftStatus
endfunction " }}}

" FUNCTION: s:SetStatusline() {{{
function! s:SetStatusline() abort
	if !exists('g:HicusLine') || empty(g:HicusLine)
		call s:ThrowError('The g:HicusLine is error, please check it or restart (neo)vim.')
		return
	endif
	for [l:key, l:value] in items(g:HicusLine)
		if l:key == 'theme'
			call s:ThrowError('We are collecting themes.')
		endif
		if !exists('l:rightKey')
			let l:rightKey = get(l:value, 'right')
		endif
		if !exists('l:leftKey')
			let l:leftKey = get(l:value, 'left')
		endif
		if l:key == 'basic_option'
			let s:tipsSign = [ get(l:value, 'ErrorSign'), get(l:value, 'WarningSign'), ]
			let s:buffertype = get(l:value, 'buffertype', 'name')
		endif
	endfor
	if !empty(l:leftKey) && !empty(l:rightKey)
		call s:DecideAttribute(l:leftKey, l:rightKey)
	endif
	if &statusline == '' && has_key(g:HicusLine, 'active')
		call s:ThrowError('The g:HicusLine is error, please check the source code or restart (neo)vim.')
	endif
	unlet l:leftKey l:rightKey l:key l:value
endfunction " }}}

" FUNCTION: s:StatuslineStart() {{{
function! s:StatuslineStart() abort
	if s:CheckStatusline() == 0
		return
	endif
	call s:SetStatusline()
	if !exists('g:HicusColorSetWay') || g:HicusColorSetWay == 1
		call s:SetHighlight()
	endif
endfunction " }}}

" FUNCTION: s:StatuslineStop() {{{
function! s:StatuslineStop() abort
	if g:HicusLineStatus == 1
		call s:ThrowError('The g:HicusLineStatus is error, please check the source code or restart (neo)vim.')
		return
	endif
	let &statusline = ''
endfunction " }}}

" FUNCTION: s:TurnOn(turnType) {{{
function! s:TurnOnOff(turnType) abort " TurnOn the HicusLine
	if a:turnType == 0
		if exists('g:HicusLineStatus') && g:HicusLineStatus == 0
			call s:ThrowError('The HicusLine is colsing, you can run :help hicusline-command to know about it.')
			return
		endif
		let g:HicusLineStatus = 0
		call s:StatuslineStop()
	elseif a:turnType == 1
		if !exists('g:HicusLineStatus')
			call s:ThrowError('The HicusLine is openning, you can run :help hicusline-command to know about it.')
			return
		elseif g:HicusLineStatus == 1
			call s:ThrowError('The HicusLine is openning, you can run :help hicusline-command to know about it.')
			return
		endif
		let g:HicusLineStatus = 1
		call s:StatuslineStart()
	endif
endfunction " }}}

call s:StatuslineStart()

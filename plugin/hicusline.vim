" A highly customizable statusline in (neo)vim.
" Author: Styadev's everyone <https://github.com/Styadev>
" Last Change: 2020.3.27
" Version: 1.1.0
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
let g:HicusLineStatus = 1
" 1}}}

" Command mappings {{{
command! -nargs=0 HicusLineEnable call s:TurnOnOff(1)
command! -nargs=0 HicusLineDisable call s:TurnOnOff(0)
command! -nargs=0 HicusSyntaxReload call s:SetHighlight()
" }}}

" FUNCTION: s:CheckStatusline() {{{
function! s:CheckStatusline()
	if g:HicusLineLoaded == 0
		call s:ThrowError(0, 'The g:HicusLineLoaded is error, please check the source code or restart (neo)vim.')
		finish
	elseif g:HicusLineStatus == 0
		call s:ThrowError(0, 'Program wants to start statusline, but it is closing, please check the source code or restart (neo)vim.')
		return
	endif
	return 1
endfunction " }}}

" FUNCTIONS: TipsSigns {{{
function! HicusGitInfo()
	let l:gitinfo = get(g:, 'coc_git_status', '')
	if empty(l:gitinfo)
		return ''
	endif
	return l:gitinfo
endfunction

function! HicusErrorStatus()
	let l:status = get(b:, 'coc_diagnostic_info', '')
	if empty(l:status)
		return ''
	endif
	let l:errors = get(l:status, 'error', '')
	if l:errors == ''
		return ''
	endif
	return s:tipsSign[0].l:errors
endfunction

function! HicusWarningStatus()
	let l:status = get(b:, 'coc_diagnostic_info', '')
	if empty(l:status)
		return ''
	endif
	let l:warning = get(l:status, 'warning', '')
	if l:warning == ''
		return ''
	endif
	return s:tipsSign[1].l:warning
endfunction " }}}

" FUNCTION: s:UseDefaultTemplate() {{{
function! s:UseDefaultTemplate() abort
	if s:CheckStatusline() == 0
		return
	endif
	runtime template/default.vim
	call HicusLineDefaultUse()
endfunction " }}}

" FUNCTION: SetStatusMode() {{{
function! SetStatusMode() abort
	if !exists('g:HicusLineMode')
		call s:ThrowError(0, 'The g:HicusLineMode is not set, please run :help g:HicusLineMode to know about it.')
		return
	elseif empty(g:HicusLineMode) || type(g:HicusLineMode) != 4
		call s:ThrowError(0, 'The g:HicusLineMode is error, please run :help g:HicusLineMode to know about it.')
		return
	endif
	if has_key(g:HicusLineMode, mode())
		let l:statusMode = get(g:HicusLineMode, mode())
		if type(l:statusMode) != 3
			return l:statusMode
		endif
		silent! execute 'highlight link modehighlight '.l:statusMode[1]
		if len(l:statusMode) == 3 && type(l:statusMode[2]) == 4
			for [ l:key, l:value ] in items(l:statusMode[2])
				silent! execute 'highlight link '.l:key.' '.l:value
			endfor
		endif
	else
		return
	endif
	return l:statusMode[0]
endfunction " }}}

" FUNCTION: s:SetHighlight() {{{
function! s:SetHighlight() abort
	if !exists('g:HicusColor')
		call s:ThrowError(0, 'You have not set the g:HicusColor, if you do not want to set, you should delete the highlight group in g:HicusLine')
		return
	endif
	for l:values in items(g:HicusColor)
		if len(l:values) != 2 || len(l:values[1]) != 3
			call ThrowError(0, 'The g:HicusColor is error, please check it.')
			return
		endif
		execute 'highlight '.l:values[0].' gui='.l:values[1][0].' guifg='.l:values[1][1].' guibg='.l:values[1][2]
	endfor
endfunction " }}}

" FUNCTION: SpellStatus() {{{
function! SpellStatus() abort
	if &spell == 0
		return ''
	elseif &spell == 1
		return 'SPELL['.&spelllang.']'
	endif
endfunction " }}}

" FUNCTION: s:DecideAttribute(leftKey, rightKey) {{{
function! s:DecideAttribute(leftKey, rightKey) abort
	function! SetAttribute(keyAttribute)
		for l:attribute in a:keyAttribute
			if type(l:attribute) == 0 && l:attribute == 0
				set statusline+=%*
			elseif l:attribute ==# 'truncate'
				set statusline+=%<
			elseif l:attribute ==# 'modehighlight'
				set statusline+=%#modehighlight#
			elseif l:attribute ==# 'gitinfo'
				set statusline+=%{HicusGitInfo()}
			elseif l:attribute ==# 'errorstatus'
				set statusline+=%{HicusErrorStatus()}
			elseif l:attribute ==# 'warningstatus'
				set statusline+=%{HicusWarningStatus()}
			elseif l:attribute ==# 'space'
				let &statusline.="\ "
			elseif l:attribute ==# 'spell'
				set statusline+=%{SpellStatus()}
			elseif l:attribute ==# 'mode'
				set statusline+=%{SetStatusMode()}
			elseif l:attribute ==# 'filename'
				set statusline+=%t
			elseif l:attribute ==# 'fileformat'
				set statusline+=%{&fileformat}
			elseif l:attribute ==# 'fileencoding'
				set statusline+=%{&fileencoding}
			elseif l:attribute ==# 'bufferfilepath'
				set statusline+=%f
			elseif l:attribute ==# 'filepath'
				set statusline+=%F
			elseif l:attribute ==# 'buffernumber'
				set statusline+=%n
			elseif l:attribute ==# 'chardecimal'
				set statusline+=%b
			elseif l:attribute ==# 'charhexadecimal'
				set statusline+=%B
			elseif l:attribute ==# 'printernumber'
				set statusline+=%N
			elseif l:attribute ==# 'linenumber'
				set statusline+=%l
			elseif l:attribute ==# 'bufferlinesnumber'
				set statusline+=%L
			elseif l:attribute ==# 'columnnuber'
				set statusline+=%c
			elseif l:attribute ==# 'overdecimal'
				set statusline+=%o
			elseif l:attribute ==# 'overhexadecimal'
				set statusline+=%O
			elseif l:attribute ==# 'virtualcolumn'
				set statusline+=%v
			elseif l:attribute ==# 'virtualspecial'
				set statusline+=%V
			elseif l:attribute ==# 'linepercentage'
				set statusline+=%p
			elseif l:attribute ==# 'windowpercentage'
				set statusline+=%P
			elseif l:attribute ==# 'argumentlist'
				set statusline+=%a
			elseif l:attribute ==# 'modified' || l:attribute ==# 'modified1'
				set statusline+=%m
			elseif l:attribute ==# 'modified2'
				set statusline+=%M
			elseif l:attribute ==# 'readonly' || l:attribute ==# 'readonly1'
				set statusline+=%r
			elseif l:attribute ==# 'readonly2'
				set statusline+=%R
			elseif l:attribute ==# 'helpbuffer' || l:attribute ==# 'helpbuffer1'
				set statusline+=%h
			elseif l:attribute ==# 'helpbuffer2'
				set statusline+=%H
			elseif l:attribute ==# 'preview' || l:attribute ==# 'preview1'
				set statusline+=%w
			elseif l:attribute ==# 'preview2'
				set statusline+=%W
			elseif l:attribute ==# 'filetype' || l:attribute ==# 'filetype1'
				set statusline+=%y
			elseif l:attribute ==# 'filetype2'
				set statusline+=%Y
			else
				let &statusline .= l:attribute
			endif
		endfor
	endfunction
	if !exists('l:leftStatus')
		call SetAttribute(a:leftKey)
		let l:leftStatus = 1
	endif
	if l:leftStatus == 1
		set statusline+=%=
		call SetAttribute(a:rightKey)
	endif
	unlet l:leftStatus
endfunction " }}}

" FUNCTION: s:SetStatusline() {{{
function! s:SetStatusline() abort
	if !exists('g:HicusLine') || empty(g:HicusLine)
		call s:ThrowError(0, 'The g:HicusLine is error, please check it or restart (neo)vim.')
		return
	endif
	for [l:key, l:value] in items(g:HicusLine)
		if l:key == 'template' && l:value == 'default'
			call s:UseDefaultTemplate()
			return
		endif
		if !exists('l:rightKey')
			let l:rightKey = get(l:value, 'right')
		endif
		if !exists('l:leftKey')
			let l:leftKey = get(l:value, 'left')
		endif
		if l:key == 'basic_option'
			let s:tipsSign = [ get(l:value, 'ErrorSign'), get(l:value, 'WarningSign'), ]
		endif
	endfor
	if !empty(l:leftKey) && !empty(l:rightKey)
		call s:DecideAttribute(l:leftKey, l:rightKey)
	endif
	if &statusline == ''
		call s:ThrowError(0, 'The g:HicusLine is error, please check the source code or restart (neo)vim.')
	endif
	unlet l:leftKey
	unlet l:rightKey
	unlet l:key
	unlet l:value
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
		call s:ThrowError(0, 'The g:HicusLineStatus is error, please check the source code or restart (neo)vim.')
		return
	endif
	let &statusline = ''
endfunction " }}}

" FUNCTION: s:TurnOn(turnType) {{{
function! s:TurnOnOff(turnType) abort " TurnOn the HicusLine
	if a:turnType == 0
		if exists('g:HicusLineStatus') && g:HicusLineStatus == 0
			call s:ThrowError(0, 'The HicusLine is colsing, you can run :help hicusline-command to know about it.')
			return
		endif
		let g:HicusLineStatus = 0
		call s:StatuslineStop()
	elseif a:turnType == 1
		if !exists('g:HicusLineStatus')
			call s:ThrowError(0, 'The HicusLine is openning, you can run :help hicusline-command to know about it.')
			return
		elseif g:HicusLineStatus == 1
			call s:ThrowError(0, 'The HicusLine is openning, you can run :help hicusline-command to know about it.')
			return
		endif
		let g:HicusLineStatus = 1
		call s:StatuslineStart()
	endif
endfunction " }}}

call s:StatuslineStart()

function! s:GitInfo() abort
	let git = fugitive#head()
	if git != ''
		return ' '.fugitive#head()
	else
		return '⚡'
	endif
endfunction

" Find out current buffer's size and output it.
function! s:FileSize() abort
	let bytes = getfsize(expand('%:p'))
	if (bytes >= 1024)
		let kbytes = bytes / 1024
	endif
	if (exists('kbytes') && kbytes >= 1000)
		let mbytes = kbytes / 1000
	endif
	if bytes <= 0
		return '0'
	endif
	if (exists('mbytes'))
		return mbytes . 'MB '
	elseif (exists('kbytes'))
		return kbytes . 'KB '
	else
		return bytes . 'B '
	endif
endfunction

function! s:ReadOnly() abort
	if &readonly || !&modifiable
		return ''
	else
		return '✔'
	endif
endfunction

function! HicusLineDefaultUse()
	set statusline=%{s:ReadOnly()}
	set statusline+=\ %n\
	set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
	set statusline+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ ':''}
	set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ RPLACE\ ':''}
	set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
	set statusline+=%#Visual#
	set statusline+=%{&paste?'\ PASTE\ ':''}
	set statusline+=%{&spell?'\ SPELL\ ':''}
	set statusline+=%#CursorIM#
	set statusline+=%R
	set statusline+=%M
	set statusline+=%#Cursor#
	set statusline+=%#CursorLine#
	set statusline+=%.20F
	set statusline+=%=
	set statusline+=%{s:FileSize()}
	set statusline+=%#CursorLine#
	set statusline+=\ %Y\
	set statusline+=%{s:GitInfo()}
	set statusline+=%#CursorIM#
	set statusline+=\ %3l:%-2c\
	set statusline+=%#Cursor#
	set statusline+=\ %3p%%\
endfunction

hi User1 cterm=none ctermfg=171 ctermbg=183
hi User2 cterm=none ctermfg=171 ctermbg=225
hi User3 cterm=none ctermfg=1 ctermbg=226
hi User4 cterm=none ctermfg=169 ctermbg=223
hi User5 cterm=none ctermfg=169 ctermbg=231
hi User6 cterm=none ctermfg=169 ctermbg=219
hi User7 cterm=none ctermfg=169 ctermbg=219
hi User8 cterm=none ctermfg=169 ctermbg=147
hi User9 cterm=none ctermfg=169 ctermbg=224

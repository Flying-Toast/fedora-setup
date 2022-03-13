" Dont log viminfo
set viminfo=

" truecolor for onedark
if (empty($TMUX))
	if (has("termguicolors"))
		set termguicolors
	endif
endif

let mapleader = ","

syntax on
colorscheme onedark

" visible trailing whitespace
autocmd VimEnter,WinEnter * match TrailingWhitespace /\s\+$/
func ShowTrailingWhitespace()
	highlight TrailingWhitespace gui=strikethrough,underline cterm=strikethrough,underline guifg=red ctermfg=red
endfunc
func HideTrailingWhitespace()
	highlight clear TrailingWhitespace
endfunc
call ShowTrailingWhitespace()
autocmd InsertEnter * call HideTrailingWhitespace()
autocmd InsertLeave * call ShowTrailingWhitespace()

set shiftwidth=8
set tabstop=8
autocmd FileType haskell setlocal expandtab shiftwidth=4 tabstop=4
set smartindent
set noexpandtab
let g:haskell_indent_disable=1

set number
set rnu

set nowrap

set laststatus=2
set noshowmode
let g:lightline = {'colorscheme': 'onedark'}
let g:lightline.tabline = {'left': [['tabs']], 'right': []}
let g:lightline.tab = {'active': ['customtabname', 'modified'], 'inactive': ['customtabname', 'modified']}
let g:lightline.tab_component_function = {'customtabname': 'CustomTabName', 'modified': 'lightline#tab#modified'}
func CustomTabName(n)
	if a:n ==# 1
		return ""
	else
		return g:lightline#tab#filename(a:n)
	endif
endfunc
set showcmd

" make backspace act normally
set backspace=indent,eol,start

" use system clipboard
set clipboard+=unnamedplus

set shm+=I

func CommandAbbrev(from, to)
	execute 'cabbrev ' . a:from . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:to . '" : "' . a:from . '"<CR>'
endfunc

call CommandAbbrev("f", "find")

func OnTerminalMode()
	setlocal nonumber norelativenumber
endfunc
autocmd TermOpen * call OnTerminalMode()

" use <Esc> to exit terminal mode
tnoremap <Esc> <C-\><C-n>

" use <Esc> to clear search highlighting
nnoremap <silent> <Esc> :noh<CR>

" use ctrl-s to save
noremap <silent> <C-s> <Esc>:w<CR>
inoremap <silent> <C-s> <Esc>:w<CR>

" use [shift]-tab to cycle through tabs
nnoremap <silent> <Tab> :tabnext<CR>
nnoremap <silent> <S-Tab> :tabprevious<CR>

noremap <Space> :

" use alt-[left|right] to traverse buffer history
nnoremap <silent> <M-Left> :bprev<CR>
nnoremap <silent> <M-Right> :bnext<CR>

set path=**

noremap Q <Nop>

let g:netrw_liststyle=3
let g:netrw_bufsettings="noma nomod nowrap ro nobl"
let g:netrw_dirhistmax=0

let NERDTreeMouseMode=2
let NERDTreeBookmarksFile="/dev/null"
let NERDTreeHighlightCursorline=0
let NERDTreeCascadeSingleChildDir=0
"""
" see https://github.com/preservim/nerdtree/issues/323
autocmd VimEnter * call NERDTreeAddKeyMap({'key': '<2-LeftMouse>', 'scope': "FileNode", 'callback': "OpenInTab", 'override': 1})
func OpenInTab(node)
	call a:node.activate({'reuse': 'all', 'where': 't', 'keepopen': 1})
endfunc
"""
autocmd FileType nerdtree setlocal wrap
noremap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
command Te tabnew | NERDTree

set mouse=a

let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

func StripTrailingWhitespace()
	let l:saved_view = winsaveview()
	redir => l:matches
		silent keeppatterns %s/\s\+$//ne
	redir END
	let l:nsubbed = "0"
	if len(l:matches) != 0
		let l:nsubbed = trim(split(l:matches, ' ')[0])
	endif
	silent keeppatterns %s/\s\+$//e
	call winrestview(l:saved_view)
	echo "Trimmed " . l:nsubbed . " line(s)"
endfunc
nnoremap <silent> <Leader>s :call StripTrailingWhitespace()<CR>

omap s <Plug>Sneak_s
omap S <Plug>Sneak_S
let g:sneak#label = 1

" Matching <> messes up delimitMate with less-than sign
autocmd FileType rust setlocal matchpairs-=<:>

set completeopt=noinsert,menuone

" Disable automatic comment insertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

let g:vim_search_pulse_mode = 'pattern'

let g:svelte_preprocessor_tags = [{ 'name': 'ts', 'tag': 'script', 'as': 'typescript' }]
let g:svelte_preprocessors = ['ts']

set title
set titlestring=VIM\ \ \ %F

set nomodeline

" Highlight quotes as part of the string in elixir
hi def link elixirStringDelimiter String

" called when vim is opened without a file
func DoStartupSetup()
	tabnew

	terminal
	call OnTerminalMode()
	NERDTree
	wincmd w

	tabm 0
	tabnext
endfunc
autocmd VimEnter * call DoStartupSetup()

noremap <C-Space> <Esc>1gt<CR>

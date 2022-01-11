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
highlight TrailingWhitespace gui=strikethrough cterm=strikethrough guifg=fg ctermfg=fg ctermbg=red guibg=red
match TrailingWhitespace /\s\+$/

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
set showcmd

" make backspace act normally
set backspace=indent,eol,start

" use system clipboard
set clipboard+=unnamedplus

set shm+=I

function CommandAbbrev(from, to)
	execute 'cabbrev ' . a:from . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:to . '" : "' . a:from . '"<CR>'
endfunction

call CommandAbbrev("f", "find")

if has("nvim")
	" use <Esc> to exit terminal-mode
	tnoremap <Esc> <C-\><C-n>

	" use <Esc> to clear search highlighting
	nnoremap <silent> <Esc> :noh<CR>

	" don't show linenumbers in :terminal mode
	autocmd TermOpen * setlocal nonumber norelativenumber
endif

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

let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_bufsettings="noma nomod nowrap ro nobl"
let g:netrw_dirhistmax=0

let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

function StripTrailingWhitespace()
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
endfunction
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

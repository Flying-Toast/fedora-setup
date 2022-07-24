call plug#begin()
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'Raimondi/delimitMate'
Plug 'KabbAmine/vCoolor.vim'
Plug 'pangloss/vim-javascript'
Plug 'justinmk/vim-sneak'
Plug 'rust-lang/rust.vim'
Plug 'inside/vim-search-pulse'
Plug 'mustache/vim-mustache-handlebars'
Plug 'cespare/vim-toml'
Plug 'evanleck/vim-svelte'
Plug 'neovimhaskell/haskell-vim'
Plug 'tpope/vim-sleuth'
Plug 'vim-scripts/argtextobj.vim'
Plug 'gregsexton/MatchTag'
Plug 'elixir-editors/vim-elixir'
Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
if has("nvim")
	Plug 'neovim/nvim-lspconfig'
	Plug 'williamboman/nvim-lsp-installer'
endif
call plug#end()

if has("nvim")
	set shada="NONE"
else
	set viminfo=
endif

if (has("termguicolors"))
	set termguicolors
endif

" returns the tabnr of the project tab, or 0 if project mode is off
func GetProjectTabNr()
	for i in range(1, tabpagenr("$"))
		if gettabvar(i, "is_project_tab") == 1
			return i
		endif
	endfor

	return 0
endfunc

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
let g:lightline.tab_component_function = {'customtabname': 'CustomTabName', 'modified': 'CustomModified'}
func CustomTabName(n)
	if a:n == GetProjectTabNr()
		return "@"
	else
		return g:lightline#tab#filename(a:n)
	endif
endfunc
func CustomModified(n)
	if a:n == GetProjectTabNr()
		return ""
	else
		return g:lightline#tab#modified(a:n)
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
call CommandAbbrev("tm", "tab Man")
call CommandAbbrev("man", "Man")

func OnTerminalMode()
	setlocal nonumber norelativenumber
endfunc
autocmd TermOpen * call OnTerminalMode()

" use <Esc> to exit terminal mode
tnoremap <Esc> <C-\><C-n>

" use <Esc> to clear search highlighting
nnoremap <Esc> <Cmd>noh<CR>

" use ctrl-s to save
noremap <C-s> <Cmd>w<CR>
inoremap <C-s> <Cmd>w<CR>

" use [shift]-tab to cycle through tabs
nnoremap <Tab> <Cmd>tabnext<CR>
nnoremap <S-Tab> <Cmd>tabprevious<CR>

noremap <Space> :

" TODO Remove this reminder once muscle memory has adapted
nnoremap <M-Left> <Cmd>echo "Use ctrl-o"<CR>
nnoremap <M-Right> <Cmd>echo "Use ctrl-i"<CR>

set path=**

noremap Q <Nop>

let g:netrw_liststyle=3
let g:netrw_bufsettings="noma nomod nowrap ro nobl"
let g:netrw_dirhistmax=0

let NERDTreeMouseMode=2
let NERDTreeBookmarksFile="/dev/null"
let NERDTreeCascadeSingleChildDir=0
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeMapOpenSplit="S"
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal rnu
"""
" see https://github.com/preservim/nerdtree/issues/323
autocmd VimEnter * call NERDTreeAddKeyMap({'key': '<2-LeftMouse>', 'scope': "FileNode", 'callback': "OpenInTab", 'override': 1})
func OpenInTab(node)
	call a:node.activate({'reuse': 'all', 'where': 't', 'keepopen': 1})
endfunc
"""
" if `i` is pressed in NERDTree in project tab, focus the terminal instead
func OnNERDTreeI()
	if GetProjectTabNr() == tabpagenr()
		wincmd b
		startinsert
	endif
endfunc
func DoNERDTreeStuff()
	setlocal wrap
	highlight CursorLine cterm=reverse gui=reverse
	" right click for context menu
	map <buffer> <RightMouse> <LeftMouse>m
	nnoremap <buffer> i <Cmd>call OnNERDTreeI()<CR>
endfunc
autocmd FileType nerdtree call DoNERDTreeStuff()
noremap <C-e> <Cmd>NERDTreeToggle<CR>
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
nnoremap <Leader>s <Cmd>call StripTrailingWhitespace()<CR>

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
func MakeTitleString()
	if &ft == 'man'
		return '%t'
	else
		return '%F'
	endif
endfunc
set titlestring=%{%MakeTitleString()%}

set nomodeline

" Highlight quotes as part of the string in elixir
hi def link elixirStringDelimiter String

func StartProjectMode()
	if GetProjectTabNr() != 0
		echo "Project mode is already enabled"
		return
	endif

	tabmove 0
	call settabvar(1, "is_project_tab", 1)

	terminal
	call OnTerminalMode()

	tabnext
endfunc

noremap <Leader>p <Cmd>call StartProjectMode()<CR>

func OnCtrlSpace()
	if GetProjectTabNr() == 0
		return
	endif

	let l:lasttabnr = tabpagenr("#")

	if GetProjectTabNr() == tabpagenr() && l:lasttabnr !=# 0
		execute l:lasttabnr . "tabn"
	else
		execute GetProjectTabNr() . "tabn"
	endif
endfunc
noremap <C-Space> <Cmd>call OnCtrlSpace()<CR>

" open a terminal below the current buffer
func CreatePopupTerm()
	belowright 12split
	enew
	call termopen(&shell, {'on_exit': 'OnPopupTermExit'})
	startinsert
endfunc
func OnPopupTermExit(job_id, code, event)
	close
endfunc

" Leader-t for popup term
noremap <Leader>t <Cmd>call CreatePopupTerm()<CR>

" ctrl-q to close current tab
noremap <C-q> <Cmd>q<CR>
" ctrl-q to open new tab
noremap <C-t> <Cmd>tabnew<CR>

let g:ctrlp_match_window = 'min:1,max:20'
let g:ctrlp_show_hidden = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_max_history = 0
let g:ctrlp_mruf_max = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_root_markers = ['Cargo.toml', 'mix.exs']
nnoremap <C-l> <Cmd>tabnew<CR><Cmd>CtrlP<CR>

" Ctrl-p in insert mode pastes last yank unless completion popup is open
inoremap <expr> <C-p> pumvisible() ? '<C-p>' : '<C-r>0'
" Ctrl-k to put last delete/cut/etc into yank yegister
noremap <C-k> <Cmd>let @0=@"<Cr>

if has("nvim")
	set laststatus=3

lua <<EOF
	require('nvim-lsp-installer').setup({
		automatic_installation = true
	})
	local lspconfig = require('lspconfig')

	local on_attach = function(client, bufnr)
		vim.diagnostic.disable()

		vim.bo.omnifunc="v:lua.vim.lsp.omnifunc"
		local ctrln_handler = function()
			vim.fn.execute("inoremap <buffer> <expr> <C-n> pumvisible() ? '<C-n>' : '<C-x><C-o>'")
		end
		vim.keymap.set('i', '<C-n>', ctrln_handler, { buffer=bufnr, noremap=true })
	end

	lspconfig.rust_analyzer.setup({ on_attach=on_attach })
	lspconfig.clangd.setup({ on_attach=on_attach })
	lspconfig.jedi_language_server.setup({ on_attach=on_attach })

	vim.keymap.set('n', '<C-a>', vim.lsp.buf.hover)
	vim.keymap.set('i', '<C-j>', vim.lsp.buf.signature_help)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
	vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition)
EOF
endif

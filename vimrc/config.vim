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
let g:lightline.tab = {'active': ['filename', 'modified'], 'inactive': ['filename', 'modified']}
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
" use Ctrl-u instead of Ctrl-i becauase Tab is the same scancode as Ctrl-i
noremap <C-u> <C-i>

nnoremap <C-w>t <C-w>T

noremap <Space> :

set path=**

noremap Q <Nop>

let g:netrw_liststyle=3
let g:netrw_bufsettings="noma nomod nowrap ro nobl"
let g:netrw_dirhistmax=0
nnoremap <C-e> <CMD>Lexplore<CR>

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

" open a terminal below the current buffer
func CreatePopupTerm()
	belowright 17split
	enew
	call termopen(&shell, {'on_exit': 'OnPopupTermExit'})
	startinsert
endfunc
func OnPopupTermExit(job_id, code, event)
	bd
endfunc

" Leader-t for popup term
noremap <Leader>t <Cmd>call CreatePopupTerm()<CR>

" ctrl-q for bdelete
noremap <C-q> <Cmd>bd<CR>
" ctrl-t to open new tab
noremap <C-t> <Cmd>tabnew<CR>

let g:ctrlp_match_window = 'min:1,max:20'
let g:ctrlp_show_hidden = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_max_history = 0
let g:ctrlp_mruf_max = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_root_markers = ['Cargo.toml', 'mix.exs']
nnoremap <C-l> <Cmd>tabnew<CR><Cmd>CtrlP<CR>

" fix for https://github.com/elixir-editors/vim-elixir/issues/562
autocmd FileType heex set filetype=eelixir

if has("nvim")
	set laststatus=3
	autocmd TextYankPost * silent! lua vim.highlight.on_yank()

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
	lspconfig.elixirls.setup({
		on_attach=on_attach,
		cmd = { "language_server.sh" },
	})

	vim.keymap.set('n', '<C-a>', vim.lsp.buf.hover)
	vim.keymap.set('i', '<C-j>', vim.lsp.buf.signature_help)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
	vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition)
EOF
endif

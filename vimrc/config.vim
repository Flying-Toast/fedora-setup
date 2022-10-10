call plug#begin()
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'Raimondi/delimitMate'
Plug 'KabbAmine/vCoolor.vim'
Plug 'justinmk/vim-sneak'
Plug 'rust-lang/rust.vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'inside/vim-search-pulse'
Plug 'vim-scripts/argtextobj.vim'
Plug 'gregsexton/MatchTag'
Plug 'elixir-editors/vim-elixir'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'alvan/vim-closetag'
Plug 'preservim/nerdtree'
if has("nvim")
	Plug 'williamboman/mason.nvim'
	Plug 'williamboman/mason-lspconfig.nvim'
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif
call plug#end()

if has("nvim")
	set laststatus=3
	set shada="NONE"
else
	set laststatus=2
	set viminfo=
endif
set termguicolors
set tabstop=8
set shiftwidth=8
set smartindent
set noexpandtab
set number
set relativenumber
set noshowmode
set nomodeline
set showcmd
set nowrap
set backspace=indent,eol,start
set clipboard+=unnamedplus
set shm+=I
set path=**
set mouse=a
set completeopt=noinsert,menuone
set title
set titlestring=%{%MakeTitleString()%}

let mapleader = ","
syntax on
colorscheme onedark

let g:lightline = {'colorscheme': 'onedark'}
let g:lightline.tabline = {'left': [['tabs']], 'right': []}
let g:lightline.tab = {'active': ['filename', 'modified'], 'inactive': ['filename', 'modified']}

let g:sneak#label = 1
let g:sneak#target_labels = "qwertyuiopasdfgzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890"

let g:vim_search_pulse_mode = 'pattern'

let g:ctrlp_match_window = 'min:1,max:20'
let g:ctrlp_show_hidden = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_max_history = 0
let g:ctrlp_mruf_max = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_root_markers = ['Cargo.toml', 'mix.exs', 'dune-project']

let NERDTreeBookmarksFile="/dev/null"
let NERDTreeCascadeSingleChildDir=0
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal rnu

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_nesting_quotes = ['"', "'", "`"]
let g:delimitMate_balance_matchpairs = 1

let g:haskell_indent_disable=1

command -nargs=1 -complete=filetype Ft set ft=<args>

func CommandAbbrev(from, to)
	execute 'cabbrev ' . a:from . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:to . '" : "' . a:from . '"<CR>'
endfunc
call CommandAbbrev("f", "find")
call CommandAbbrev("tm", "tab Man")
call CommandAbbrev("man", "Man")
call CommandAbbrev("ft", "Ft")

" normal
nnoremap <C-l> <Cmd>tabnew<CR><Cmd>CtrlP<CR>
nnoremap <C-k> <Cmd>tabnext<CR>
nnoremap <C-j> <Cmd>tabprevious<CR>
nnoremap <Esc> <Cmd>noh<CR>
nnoremap <C-w>t <C-w>T
nnoremap <C-e> <CMD>Lexplore<CR>
nnoremap <C-t> <Cmd>tabnew<CR>
nnoremap <Leader>t <Cmd>call PopupTerm()<CR>
nnoremap <Leader>s <Cmd>call StripTrailingWhitespace()<CR>
nnoremap <Leader>f <Cmd>call FormatCurrentBuffer()<CR>
nnoremap <Leader>r <Cmd>call DoRunner()<CR>
nnoremap <C-e> <CMD>NERDTreeToggle<CR>
" insert
" terminal
tnoremap <Esc> <C-\><C-n>
" operator
omap s <Plug>Sneak_s
omap S <Plug>Sneak_S
" nvo
noremap <Space> :
noremap Q <Nop>

autocmd TermOpen * setlocal nonumber norelativenumber
autocmd TermOpen * syntax match TermExitMsg /^\[Process exited [0-9]\+\]$/
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" fix for https://github.com/elixir-editors/vim-elixir/issues/562
autocmd FileType heex set filetype=eelixir
autocmd FileType html inoremap <buffer> <expr> <CR> getline('.')[col('.')-2] == '>' ? '<CR><C-o>O<C-t>' : '<CR>'
autocmd FileType rust,html setlocal matchpairs-=<:>
autocmd FileType haskell setlocal expandtab shiftwidth=4 tabstop=4
autocmd FileType ocaml setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType ocaml let b:delimitMate_quotes = '"'
if has("nvim")
	autocmd TextYankPost * silent! lua vim.highlight.on_yank()
endif

" visible trailing whitespace
autocmd VimEnter,WinEnter * match TrailingWhitespace /\s\+$/
autocmd InsertEnter * highlight clear TrailingWhitespace
autocmd VimEnter,WinEnter,InsertLeave * highlight TrailingWhitespace gui=strikethrough,underline cterm=strikethrough,underline guifg=red ctermfg=red

hi def link elixirStringDelimiter String
hi link TermExitMsg Special

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

func MakeTitleString()
	if &ft == 'man'
		return '%t'
	else
		return '%F'
	endif
endfunc

func PopupTerm(...)
	let l:cmd = a:0 >= 1 ? a:1 : &shell
	let l:opts = a:0 >= 2 ? a:2 : {'on_exit': {job_id, code, event -> execute('bd')}}
	bot 17split
	enew
	" GRRRRRRRRRRRRR
	call termopen(l:cmd . " && sleep 0.02", l:opts)
	startinsert
endfunc

func FormatCurrentBuffer()
	let l:saved_view = winsaveview()
	if &ft == "rust"
		%!rustfmt
	elseif &ft == "ocaml"
		let l:expanded = expand("%:t")
		let l:filename = l:expanded == "" ? "vimocamlfmttmp.ml" : l:expanded
		exec "%!ocamlformat --enable-outside-detected-project - --name=" . l:filename
	else
		echo "No formatter configued for filetype='" . &ft . "'"
		return
	endif
	call winrestview(l:saved_view)
endfunc

func FileInCwdOrAbove(filename)
	return findfile(a:filename, ".;")
endfunc

func DoRunner()
	let l:filename = tempname()
	call writefile(getline(1, '$'), l:filename)
	let l:Cleanup = {job_id, code, event -> delete(l:filename)}
	let l:termopts = { 'on_exit': l:Cleanup }

	if &ft == "rust"
		if FileInCwdOrAbove("Cargo.toml") == ""
			let l:exename = tempname()
			call PopupTerm("rustc " . l:filename . " -o " . l:exename . " && " . l:exename, l:termopts)
		else
			call PopupTerm("cargo run", l:termopts)
		endif
	elseif &ft == "ocaml"
		let l:projfile = FileInCwdOrAbove("dune-project")
		if l:projfile == ""
			call PopupTerm("ocaml " . l:filename, l:termopts)
		else
			let l:termopts.cwd = fnamemodify(l:projfile, ":p:h")
			call PopupTerm("dune exec bin/main.exe", l:termopts)
		endif
	elseif &ft == "python"
		call PopupTerm("python " . l:filename, l:termopts)
	elseif &ft == "perl"
		call PopupTerm("perl " . l:filename, l:termopts)
	elseif &ft == "haskell"
		call PopupTerm("runhaskell " . l:filename, l:termopts)
	elseif &ft == "elixir"
		let l:projfile = FileInCwdOrAbove("mix.exs")
		if l:projfile == ""
			call PopupTerm("elixir " . l:filename, l:termopts)
		else
			let l:dir_containing_mixfile = fnamemodify(l:projfile, ":p:h")
			let l:termopts.cwd = l:dir_containing_mixfile
			if isdirectory(l:dir_containing_mixfile . "/deps/phoenix")
				call PopupTerm("mix phx.server", l:termopts)
			else
				call PopupTerm("mix run", l:termopts)
			endif
		endif
	elseif &ft == "c"
		let l:exename = tempname()
		call PopupTerm("gcc -x c " . l:filename . " -o " . l:exename . " && " . l:exename, l:termopts)
	elseif &ft == "prolog"
		call PopupTerm("swipl " . l:filename, l:termopts)
	else
		echo "No runner configued for filetype='" . &ft . "'"
		call l:Cleanup(0, 0, 0)
	endif
endfunc

if has("nvim")
lua <<EOF
	require('mason').setup()
	require('mason-lspconfig').setup({
		automatic_installation = true,
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
	lspconfig.ocamllsp.setup({ on_attach=on_attach })

	vim.keymap.set('n', '<C-a>', vim.lsp.buf.hover)
	vim.keymap.set('i', '<C-j>', vim.lsp.buf.signature_help)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
	vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition)

	-- treesitter
	require'nvim-treesitter.configs'.setup({
		ensure_intalled = { "ocaml" },
		auto_install = true,
		highlight = {
			enable = true,
			-- TODO: rmeove haskell and elixir once their treesitter impls aren't slow AF
			disable = { "vim", "elixir", "help", "haskell" },
		},
	})

	-- hack to get rid of the annoying warning when editing standalone rust files
	local old_notify = vim.notify
	local silence_pat = '[lspconfig] cmd ("cargo'
	vim.notify = function(msg, level, opts)
		if (string.sub(msg, 1, string.len(silence_pat)) ~= silence_pat)
		then
			old_notify(msg, level, opts)
		end
	end
EOF
endif

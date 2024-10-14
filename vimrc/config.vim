call plug#begin()
Plug 'vim-crystal/vim-crystal'
Plug 'Flying-Toast/quark.vim'
Plug 'itchyny/lightline.vim'
Plug 'Raimondi/delimitMate'
Plug 'KabbAmine/vCoolor.vim'
Plug 'justinmk/vim-sneak'
Plug 'rust-lang/rust.vim'
Plug 'vim-scripts/argtextobj.vim'
Plug 'gregsexton/MatchTag'
Plug 'alvan/vim-closetag'
Plug 'preservim/nerdtree'
if has("nvim")
	Plug 'williamboman/mason.nvim'
	Plug 'williamboman/mason-lspconfig.nvim'
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	" telescope dependency:
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
endif
call plug#end()

if has("nvim")
	set laststatus=3
	set shada="NONE"
else
	set laststatus=2
	set viminfo=
endif
set notermguicolors
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

let mapleader = ","

func PatchColorScheme()
	if has("nvim")
		let s:i = 0
		while s:i < 16
			execute "unlet! g:terminal_color_" . s:i
			let s:i += 1
		endwhile
	else
		unlet! g:terminal_ansi_colors
	endif

	hi! link rustCommentLineDoc Comment
	hi! link rustCommentBlockDoc Comment
	hi! link elixirStringDelimiter String
	hi! link TermExitMsg WarningMsg
	hi! CurSearch guibg=blue ctermbg=blue ctermfg=black guifg=black cterm=underline gui=underline
endfunc
autocmd ColorScheme * call PatchColorScheme()
syntax on
colorscheme quark

let g:lightline = {}
let g:lightline.tabline = {'left': [['tabs']], 'right': []}
let g:lightline.tab = {'active': ['filename', 'modified'], 'inactive': ['filename', 'modified']}

let g:sneak#label = 1
let g:sneak#target_labels = "qwertyuiopasdfgzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890"

let g:closetag_filenames = '*.html,*.xml,*.ui'

let NERDTreeBookmarksFile="/dev/null"
let NERDTreeCascadeSingleChildDir=0
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeShowLineNumbers=1
let NERDTreeMapJumpNextSibling=""
let NERDTreeMapJumpPrevSibling=""
autocmd FileType nerdtree setlocal rnu

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_nesting_quotes = ['"', "'", "`"]
let g:delimitMate_balance_matchpairs = 1

command -nargs=1 -complete=filetype Ft call DoFt(<q-args>)
func DoFt(newft)
	let &ft=a:newft
	if bufname() == "" && wordcount()["bytes"] == 0
		if a:newft == "rust"
			call setline(1, ['fn main() {', '    println!("{}", 123);', '}'])
			call setpos(".", [0, 2, 20, 0])
			normal! v
			call setpos(".", [0, 2, 22, 0])
		elseif a:newft == "c"
			call setline(1, ['#include <stdio.h>', '', 'int main(int argc, char **argv) {', "\t", '}'])
			call setpos(".", [0, 4, 0, 0])
			startinsert!
		elseif a:newft == "cpp"
			call setline(1, ['#include <iostream>', '', 'int main(int argc, char **argv) {', "\t", '}'])
			call setpos(".", [0, 4, 0, 0])
			startinsert!
		endif
	endif
endfunc

func CommandAbbrev(from, to)
	execute 'cabbrev ' . a:from . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:to . '" : "' . a:from . '"<CR>'
endfunc
call CommandAbbrev("f", "find")
call CommandAbbrev("tm", "tab Man")
call CommandAbbrev("th", "tab help")
call CommandAbbrev("man", "Man")
call CommandAbbrev("ft", "Ft")

" normal
nnoremap <C-p> <Cmd>Telescope find_files<CR>
nnoremap <C-l> <Cmd>tabnew<CR><Cmd>Telescope find_files<CR>
nnoremap <C-k> <Cmd>tabnext<CR>
nnoremap <C-j> <Cmd>tabprevious<CR>
nnoremap <Esc> <Cmd>noh<CR>
nnoremap <C-w>t <C-w>T
nnoremap <C-t> <Cmd>tab split<CR>
nnoremap <C-n> <Cmd>enew<CR>
nnoremap <Leader>t <Cmd>call PopupTerm()<CR>
nnoremap <Leader>s <Cmd>call StripTrailingWhitespace()<CR>
nnoremap <Leader>f <Cmd>call FormatCurrentBuffer()<CR>
nnoremap <Leader>r <Cmd>call DoRunner()<CR>
nnoremap <Leader>e <Cmd>call PopupTerm("cargo test", { 'on_exit': {job_id, code, event -> "foo"}})<CR>
nnoremap <Leader>g <Cmd>Telescope live_grep<cr>
nnoremap <C-e> <CMD>NERDTreeToggle<CR>
nnoremap gh <C-]>
nnoremap <C-d> <CMD>call ShowBracketMatchLine()<CR>
" insert
inoremap <C-k> <Cmd>tabnext<CR><esc>
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
autocmd BufEnter *.h set filetype=c
autocmd FileType qf setlocal cursorline
" fix for https://github.com/elixir-editors/vim-elixir/issues/562
autocmd FileType heex set filetype=eelixir
autocmd FileType rust,html,xml setlocal matchpairs-=<:>
autocmd FileType xml,html,blueprint setlocal shiftwidth=2 tabstop=2
autocmd FileType ocaml let b:delimitMate_quotes = '"'
if has("nvim")
	autocmd TextYankPost * silent! lua vim.highlight.on_yank()
endif

" visible trailing whitespace
autocmd VimEnter,WinEnter * match TrailingWhitespace /\s\+$/
autocmd InsertEnter,TermEnter * highlight clear TrailingWhitespace
autocmd VimEnter,WinEnter,InsertLeave * highlight TrailingWhitespace gui=strikethrough,underline cterm=strikethrough,underline guifg=red ctermfg=red

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

func ShowBracketMatchLine()
	let l:view = winsaveview()
	norm %
	let l:line = trim(getline("."))
	call winrestview(l:view)
	echo l:line
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
		RustFmt
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

func DirInCwdOrAbove(filename)
	return finddir(a:filename, ".;")
endfunc

func DoRunner()
	let l:filename = tempname()
	call writefile(getline(1, '$'), l:filename)
	let l:Cleanup = {job_id, code, event -> delete(l:filename)}
	let l:termopts = { 'on_exit': l:Cleanup }

	if DirInCwdOrAbove(".fenv") != ""
		call PopupTerm("fenv build && fenv run", l:termopts)
		return
	endif

	if &ft == "rust"
		if FileInCwdOrAbove("Cargo.toml") == ""
			let l:exename = tempname()
			call PopupTerm("rustc --edition 2021 " . l:filename . " -o " . l:exename . " && " . l:exename, l:termopts)
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
	elseif &ft == "cpp"
		let l:makefile = FileInCwdOrAbove("Makefile")
		if l:makefile == ""
			let l:exename = tempname()
			call PopupTerm("c++ -Wall -x c++ " . l:filename . " -o " . l:exename . " && " . l:exename, l:termopts)
		else
			call PopupTerm("cd " . fnamemodify(l:makefile, ":h") . " && make", l:termopts)
		endif
	elseif &ft == "c"
		let l:makefile = FileInCwdOrAbove("Makefile")
		if l:makefile == ""
			let l:exename = tempname()
			call PopupTerm("cc -Wall -x c " . l:filename . " -o " . l:exename . " && " . l:exename, l:termopts)
		else
			call PopupTerm("cd " . fnamemodify(l:makefile, ":h") . " && make", l:termopts)
		endif
	elseif &ft == "prolog"
		call PopupTerm("swipl " . l:filename, l:termopts)
	elseif &ft == "java"
		call PopupTerm("javac " . expand("%:l.%:e") . " && java " . expand("%:l"), l:termopts)
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
	require('nvim-treesitter.configs').setup({
		ensure_installed = { "c", "lua", "vimdoc", "vim", "blueprint" },
		auto_install = false,
		highlight = {
			enable = { "c", "blueprint" },
			disable = { "vimdoc", "lua", "help", "vim" }
		},
	})
	require("telescope").setup{
		defaults = {
			mappings = {
				i = {
					["<c-j>"] = "move_selection_next",
					["<c-k>"] = "move_selection_previous",
				}
			}
		}
	}

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

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
		vim.lsp.handlers.hover, { close_events={"QuitPre"} }
	)
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help, { focusable=false, close_events={"CursorMoved"} }
	)
	local hoverhandler = function()
		-- first call opens window, second call focuses it
		vim.lsp.buf.hover()
		vim.lsp.buf.hover()
	end
	vim.keymap.set('n', '<C-a>', hoverhandler)
	vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
	vim.keymap.set('n', 'gs', require('telescope.builtin').lsp_document_symbols)
	vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition)
	vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references)
	vim.keymap.set('n', '<C-c>', vim.lsp.buf.code_action)
EOF
endif

" ==========================================================
"	 				GLOBAL DEFINITIONS
" ==========================================================

let mapleader = "\\"

set number          " Show the current line number
set relativenumber  " Show distance to other lines

" desable vi
set nocompatible

" no sounds or flashes on errors!
set novisualbell
set noerrorbells
set t_vb=
set belloff=all

" This clears all values for selectmode. Vim has a "Select mode" 
" that behaves like a modern word processor (typing replaces text).
" By setting it to empty, you ensure Vim stays in its native
" "Visual mode" when highlighting tex
set selectmode=

" Enable mouse support in all modes (allows scrolling)
set mouse=a

set foldlevel=99

set cursorline
highlight CursorLine ctermbg=darkgray cterm=none

autocmd BufWinLeave * silent! mkview
autocmd BufWinEnter * silent! loadview

set autoread

" Optional: Force built-in 'new' to be vertical
cabbrev new vnew

" Repo root — derived from the real location of this file so it works
" regardless of where the repo is cloned.
let g:vimfiles_dir = fnamemodify(resolve(expand('$MYVIMRC')), ':h')

" ==========================================================
"	 				PLUGIN MANAGEMENT
" ==========================================================

" Configs are in the section 'Plugin Specific Config'

call plug#begin('~/.vim/plugged')

" The best plugin for Go development
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Optional: For VS Code-like autocomplete menus
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" add comment for all langs
Plug 'tpope/vim-commentary'

" Make braces, brackets, etc open a new empty line
Plug 'jiangmiao/auto-pairs'

Plug 'ludovicchabant/vim-gutentags'

Plug 'puremourning/vimspector'

Plug 'pseewald/vim-anyfold'
Plug 'Konfekt/FastFold'

Plug 'tomasr/molokai'

call plug#end()

" ==========================================================
"	 				GENERAL UI/UX
" ==========================================================

" Key bindings are in the section 'Global Keymaps'

syntax on
filetype plugin indent on

set termguicolors
set background=dark
colorscheme molokai

set tabstop=4

" How many columns an 'indent level' is worth
set shiftwidth=4

" Keep tabs as tabs (Required for Go)
set noexpandtab

set smartindent

set hlsearch
set incsearch
set backspace=indent,eol,start

" Always show the status line, even with only one window
set laststatus=2

" Custom statusline format
set statusline=%f\ %m\ %r%=%y\ [%p%%]\ %l:%c
highlight StatusLine ctermbg=white ctermfg=black

set showcmd

" make vertical the default for split view
set diffopt+=vertical

" Always open new window to the left
autocmd WinNew * wincmd H
set nosplitright

" This tells Vim to wait only 10ms for the rest of an escape sequence
set ttimeoutlen=10

set colorcolumn=111

autocmd Filetype * AnyFoldActivate

" Portable Cursor Shape (WSL & Linux)
" Uses 2 for Block, 4 for Underline, 6 for Beam (Steady variants)
if &term =~ 'xterm' || &term =~ 'screen' || &term =~ '256color'
    let &t_SI = "\<Esc>[6 q" " Insert mode: steady beam
    let &t_SR = "\<Esc>[4 q" " Replace mode: steady underline
    let &t_EI = "\<Esc>[2 q" " Normal mode: steady block
endif

" ==========================================================
"   		      PLUGIN SPECIFIC CONFIG
" ==========================================================

let g:coc_global_extensions = 
	\[
	\	'coc-go', 'coc-json', 'coc-sql', 
	\	'coc-sh', 'coc-tag', 'coc-clangd',
	\	'coc-markdownlint', 'coc-prettier',
	\	'@yaegassy/coc-marksman', 'coc-pyright'
	\]

" This sets semantic completion as priority and tags as low-priority fallback
let g:coc_user_config = {
  \ "coc.preferences.formatOnSaveFiletypes": ["*"],
  \
  \ "suggest.enablePreview": v:true,
  \ "diagnostic.enableSign": v:true,
  \ "diagnostic.errorSign": "✖",
  \ "diagnostic.warningSign": "⚠",
  \ "diagnostic.infoSign": "ℹ",
  \ "inlayHint.enable": v:true,
  \ "suggest.languageSourcePriority": 99,
  \ "coc.source.tag.priority": 1,
  \ "coc.source.tag.shortcut": "TAG",
  \ "suggest.lowPrioritySourceLimit": 5,
  \
  \ "prettier.printWidth": 110,
  \ "prettier.tabWidth": 4,
  \ "prettier.useTabs": v:true,
  \ "prettier.proseWrap": "always",
  \ "prettier.endOfLine": "lf",
  \ "prettier.trailingComma": "es5",
  \ "prettier.singleQuote": v:false,
  \ "prettier.requireConfig": v:false,
  \ "prettier.disableLanguages": ["markdown"],
  \
  \ "markdownlint.onOpen": v:true,
  \ "markdownlint.onChange": v:true,
  \ "markdownlint.onSave": v:true,
  \ "markdownlint.config": {
  \	  "default": v:true,
  \   "MD033": { "allowed_elements": ["details", "summary", "b"] },
  \	  "MD013": { "line_length": 110, "tables": v:false, "code_blocks": v:false },
  \   "MD024": { "siblings_only": v:true },
  \   "MD029": { "style": "ordered" },
  \   "MD046": { "style": "fenced" },
  \	  "list-marker-space": { "ul_multi": 1, "ul_single": 1 },
  \	  "ul-indent": { "indent": 4 }
  \ },
  \
  \ "marksman.enable": v:true,
  \ "marksman.maxNumberOfProblems": 100,
  \
  \ "python.analysis.typeCheckingMode": "strict",
  \ "python.analysis.autoImportCompletions": v:true,
  \ "python.analysis.diagnosticMode": "workspace",
  \ "python.analysis.inlayHints.variableTypes": v:true,
  \ "python.analysis.inlayHints.functionReturnTypes": v:true,
  \ "python.formatting.provider": "black",
  \ "python.formatting.blackPath": "black",
  \ "python.analysis.diagnosticSeverityOverrides": {
  \   "reportMissingTypeStubs": "none",
  \   "reportUnknownMemberType": "none"
  \ },
  \
  \ "go.goplsOptions": {
  \   "completeUnimported": v:true,
  \   "usePlaceholders": v:true,
  \   "staticcheck": v:true,
  \   "analyses": {
  \     "unusedparams": v:true,
  \     "shadow": v:true,
  \     "unusedwrite": v:true,
  \     "useany": v:true
  \   }
  \ },
  \
  \ "bashIde.shellcheckPath": "shellcheck",
  \ "bashIde.shellcheckArguments": "--severity=warning",
  \ "bashIde.globPattern": "**/*@(.sh|.inc|.bash|.command)",
  \ "bashIde.backgroundAnalysisMaxFiles": 500,
  \
  \ "json.format.enable": v:true,
  \ "json.validate.enable": v:true,
  \ "json.schemas": [
  \   {
  \     "fileMatch": [".vimspector.json"],
  \     "url": "https://puremourning.github.io/vimspector/schema/vimspector.schema.json"
  \   }
  \ ],
\ }


" Use Tab to confirm the selection when the menu is visible
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<TAB>"

" --- Vim-Go Settings ---
let g:go_metalinter_autosave = 1   " Run error checking on save
let g:go_highlight_functions = 1   " Enhanced syntax highlighting for Go
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1

" Ensure Vimspector is available
if empty(glob('~/.vim/plugged/vimspector'))
  echo "Vimspector not found. Run :PlugInstall first."
endif

" Put tags(from Gutentags) and vimspector.json in a global gitignore
" This runs only once if the global ignore file is missing
if executable('git') && empty(glob('~/.gitignore_global'))
  silent !touch ~/.gitignore_global
  silent !echo "tags" >> ~/.gitignore_global
  silent !echo "tags.lock" >> ~/.gitignore_global
  silent !echo ".vimspector.json" >> ~/.gitignore_global
  silent !git config --global core.excludesfile ~/.gitignore_global
  redraw!
  echo "Global .gitignore created and configured."
endif

" Debbuger mappings
" Toggle breakpoint
nnoremap <leader>gb :call vimspector#ToggleBreakpoint()<CR>
" Continue / Start
nnoremap <leader>gc :call vimspector#Continue()<CR>
" Stop
nnoremap <leader>gs :call vimspector#Stop()<CR>
" Restart
nnoremap <leader>gr :call vimspector#Restart()<CR>
" Step Over
nnoremap <leader>gn :call vimspector#StepOver()<CR>
" Step Into
nnoremap <leader>gi :call vimspector#StepInto()<CR>
" Step Out
nnoremap <leader>go :call vimspector#StepOut()<CR>
" Reset
nnoremap <leader>gq :VimspectorReset!<CR>

" --- Navigation ---
" Jump to definition
nmap <silent> <leader>d <Plug>(coc-definition)	
" Back from definition 
nnoremap <leader>b <C-o>
" Open a hover block with definition
nnoremap <leader>o :call CocActionAsync('doHover')<CR>

nmap <leader>ca <Plug>(coc-codeaction)

nmap <leader>rn <Plug>(coc-rename)
"
" Navigation for CoC diagnostics (errors/warnings)
nmap <silent> <leader>cp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>cn <Plug>(coc-diagnostic-next)

" Find references
nmap <silent> <leader>fr <Plug>(coc-references)

" ==========================================================
"	 				GLOBAL KEYMAPS
" ==========================================================

" Fast mapping for vertical split + file path
nnoremap <leader>nf :topleft vertical split<Space>

" Clear search highlighting. remap <Esc> to <Esc><Esc> to make it faster
nnoremap <Esc><Esc> :noh<CR>

" Window Navigation(normal and terminal mode)
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

tnoremap <leader>h <C-\><C-n><C-w>h
tnoremap <leader>j <C-\><C-n><C-w>j
tnoremap <leader>k <C-\><C-n><C-w>k
tnoremap <leader>l <C-\><C-n><C-w>l

" + and - now resize the window
nnoremap <silent> + :vertical resize +5<CR>
nnoremap <silent> - :vertical resize -5<CR>

" Map mouse wheel to scroll the window view (allows scrolling past EOF)
nnoremap <ScrollWheelUp> <C-y>
nnoremap <ScrollWheelDown> <C-e>

" Native jumps center automatically
nnoremap G Gzz
nnoremap n nzz
nnoremap N Nzz

" Center screen when moving up and down
nnoremap j gjzz
nnoremap k gkzz

" Reload your config
nnoremap <leader>v :source $MYVIMRC<CR>

" toggle between current and last file open
nnoremap <leader>tf <C-^>

" Map dd to not delete the line, jsut its contents.
" To delete line i made a new command
nnoremap dd 0D
nnoremap dl dd

" to create new lines in normal mode and stay there
nnoremap <space>j o<Esc>
nnoremap <space>k O<Esc>

" Normal mode: move current line
nnoremap <C-k> :m .-2<CR>==
nnoremap <C-j> :m .+1<CR>==

" Visual mode: move selected block
vnoremap <C-k> :m '<-2<CR>gv=gv
vnoremap <C-j> :m '>+1<CR>gv=gv

" Map qq to <Esc> in insert mode
inoremap qq <Esc>

" jump to beginning/end of line in insert mode
inoremap II <C-o>I
inoremap <leader>I II

inoremap AA <C-o>A
inoremap <leader>A AA

" Open netrw
nnoremap <leader>ft :Vex<CR>

tnoremap <Esc><Esc> <C-\><C-n>

nnoremap <leader>w :w<CR>

" some language shortcuts:
" C / C++
inoremap ;; <Esc>g_a;
" append ; at end of line
inoremap <leader>s std::
" append { at end of line
inoremap {{ <Esc>g_a{}<Esc>ha
" insert , after next character
inoremap ,, <Esc>la,

" Python
" append : at end of line
inoremap :: <Esc>g_a:

" ==========================================================
"   			  LANGUAGE SPECIFIC CONFIG
" ==========================================================

" ----------------- Go Language Config ---------------------

" \r to Run, \t to Test
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)

" Go uses real tabs, not spaces
" autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4

" Disable your manual autocmd to prevent conflicts with vim-go's autosave
" autocmd BufWritePost *.go silent !go fmt %

" --------------- Python Language Config -------------------

autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4
autocmd FileType python nmap <leader>r :terminal python3 %<CR>

" ------------------ C Language Config ---------------------

" ------------------ C Language Config ---------------------

autocmd FileType c nmap <leader>r :terminal gcc % -o /tmp/vimrun && /tmp/vimrun<CR>

" ---------------- C++ Language Config --------------------

autocmd FileType cpp nmap <leader>r :terminal g++ % -o /tmp/vimrun && /tmp/vimrun<CR>

" ------------------ Shell Language Config -----------------

autocmd FileType sh nmap <leader>r :terminal bash %<CR>

" -------------- Markdown Language Config -------------------

autocmd FileType markdown nmap <leader>mp :terminal glow %<CR>
" command! Preview if &filetype ==# 'markdown' | terminal glow % 
" 			\| else | echo "Preview is only available for markdown files" | endif
command! Preview if &filetype ==# 'markdown' | 
    \ execute "vertical topleft terminal glow " . expand("%") | 
    \ else | echo "Preview is only available for markdown files" | endif
" ==========================================================
"   				CUSTOM COMMANDS
" ==========================================================

" Format the current buffer
command! -nargs=0 Format :call CocActionAsync('format')

command! Shortcuts execute 'vsplit +setlocal\ readonly\ nomodifiable ' . g:vimfiles_dir . '/shortcuts.txt'

" Reload your config
command! Source source $MYVIMRC

" To config and install a debbuger(binaries must be available)
function! InstallDebugger(adapter)
  if a:adapter == ''
    echo "Usage: :InstallDebugger <adapter_name>"
    return
  endif

  execute 'VimspectorInstall ' . a:adapter

  let l:filetypes = {
        \ 'delve': ['go'],
        \ 'debugpy': ['python'],
        \ 'CodeLLDB': ['c', 'cpp'],
		\ 'vscode-bash-debug': ['sh'],
        \ }

  if has_key(l:filetypes, a:adapter)
    let l:ft = l:filetypes[a:adapter]
  else
    let l:input = input("Enter filetypes for '" . a:adapter . "' (comma-separated, e.g. go,python): ")
    let l:ft = split(l:input, '\s*,\s*')
  endif

  let l:new_entry = {
        \ 'adapter': a:adapter,
        \ 'filetypes': l:ft,
        \ 'configuration': {
        \   'request': 'launch',
        \   'program': '${program}',
        \   'args': [],
        \   'cwd': '${workspaceRoot}',
		\	'mode': 'debug',
  		\ 	'env':	{},
        \ }
        \ }

  if !filereadable('.vimspector.json')
    let l:vimspector = {'configurations': {a:adapter: l:new_entry}}
    echo "Created .vimspector.json with '" . a:adapter . "' configuration."
  else
    let l:content = join(readfile('.vimspector.json'), "\n")
    let l:vimspector = json_decode(l:content)
    if has_key(l:vimspector.configurations, a:adapter)
      echo "Configuration for '" . a:adapter . "' already exists."
      return
    endif
    let l:vimspector.configurations[a:adapter] = l:new_entry
    echo "Added '" . a:adapter . "' to existing .vimspector.json."
  endif

  call writefile([json_encode(l:vimspector)], '.vimspector.json')
endfunction

command! -nargs=1 InstallDebugger call InstallDebugger(<f-args>)
"
" sometimes I make w and q upercase. Now they(and variations) map to the correct command
command! W :w
command! Q :q
command! Qa :qa
command! QA :qa
cabbrev <expr> Q! getcmdtype()==':' && getcmdline()=='Q!' ? 'q!' : 'Q!'
command! Wq :wq
command! Wa :wa
command! Wqa :wqa
command! WQa :wqa
command! WQA :wqa

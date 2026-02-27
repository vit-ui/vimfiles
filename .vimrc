" ==========================================================
"	 				GLOBAL DEFINITIONS
" ==========================================================

let mapleader = "\\"

set number          " Show the current line number
set relativenumber  " Show distance to other lines

set cursorline
highlight CursorLine ctermbg=darkgray cterm=none

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

Plug 'puremourning/vimspector'

Plug 'ludovicchabant/vim-gutentags'

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

" Enable mouse support in all modes (allows scrolling)
set mouse=a


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

let g:coc_global_extensions = ['coc-go', 'coc-json', 'coc-sql', 'coc-sh', 'coc-snippets', 'coc-tag']

" This sets semantic completion as priority and tags as low-priority fallback
let g:coc_user_config = {
  \ "suggest.languageSourcePriority": 99,
  \ "coc.source.tag.priority": 1,
  \ "coc.source.tag.shortcut": "TAG",
  \ "suggest.lowPrioritySourceLimit": 5
  \ }

" Use Tab to confirm the selection when the menu is visible
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<TAB>"

" --- Vim-Go Settings ---
let g:go_fmt_autosave = 1          " Auto-format on save using vim-go
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

" ==========================================================
"	 				GLOBAL KEYMAPS
" ==========================================================

" Clear search highlighting
nnoremap <Esc> :noh<CR>

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
nnoremap j jzz
nnoremap k kzz

" Reload your config
nnoremap <leader>v :source $MYVIMRC<CR>

" toggle between current and last file open
nnoremap <leader>tf <C-^>

" Map dd to not delete the line, jsut its contents.
" To delete line i made a new command
nnoremap dd 0D
nnoremap dl dd

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

" nothing yet

" ------------------ C Language Config ---------------------

" nothing yet

" ==========================================================
"   				CUSTOM COMMANDS
" ==========================================================

" Format the current buffer
command! -nargs=0 Format :call CocActionAsync('format')

command! Shortcuts vsplit ~/vimfiles/shortcuts.txt

" Reload your config
command! Source source $MYVIMRC

" To config and install a debbuger(binaries must be available)
function! InstallDebugger(adapter)
  if a:adapter == ''
    echo "Usage: :InstallDebugger <adapter_name>"
    return
  endif

  execute 'VimspectorInstall ' . a:adapter

  let l:new_entry = {
        \ 'adapter': a:adapter,
        \ 'configuration': {
        \   'request': 'launch',
        \   'program': '${workspaceRoot}',
        \   'mode': 'debug'
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

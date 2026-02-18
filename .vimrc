call plug#begin('~/.vim/plugged')

" The best plugin for Go development
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Optional: For VS Code-like autocomplete menus
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" add comment for all langs
Plug 'tpope/vim-commentary'

" Make braces, brackets, etc open a new empty line
Plug 'jiangmiao/auto-pairs'

call plug#end()

" --- General Settings ---
syntax on
filetype plugin indent on

set smartindent
set number
set termguicolors
set background=dark
colorscheme molokai

" Use Tab to confirm the selection when the menu is visible
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<TAB>"

" How many columns a tab counts for (Visual only)
set tabstop=4

" How many columns an 'indent level' is worth
set shiftwidth=4

" Keep tabs as tabs (Required for Go)
set noexpandtab

" Search and Navigation
set hlsearch
set incsearch
set backspace=indent,eol,start

" --- Go-Specific Formatting ---
" Go uses real tabs, not spaces
autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4

" --- Vim-Go Settings ---
let g:go_fmt_autosave = 1          " Auto-format on save using vim-go
let g:go_metalinter_autosave = 1   " Run error checking on save
let g:go_highlight_functions = 1   " Enhanced syntax highlighting for Go
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1

" Disable your manual autocmd to prevent conflicts with vim-go's autosave
" autocmd BufWritePost *.go silent !go fmt %

" Use \ as your leader key
let mapleader = "\\"

" Always show the status line, even with only one window
set laststatus=2

" Custom statusline format
set statusline=%f\ %m\ %r%=%y\ [%p%%]\ %l:%c
highlight StatusLine ctermbg=white ctermfg=black

" \r to Run, \t to Test, \d for Definition
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>d <Plug>(go-def)
" Pair with \d (GoDef) to jump BACK to where you were
nnoremap \b <C-t>

set showcmd

" Old command: command! GoHelpMe vsplit ~/crawlergo/shortcuts.txt
command! Shortcuts vsplit ~/go_shortcuts.txt

" Alternative: Using Leader (\h, \j, etc.)
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

"+ and - now resize the window
nnoremap <silent> + :vertical resize +5<CR>
nnoremap <silent> - :vertical resize -5<CR>

" Debugger Shortcuts
nnoremap \bp :GoDebugBreakpoint<CR>
nnoremap \ds :GoDebugStart<CR>
nnoremap \dn :GoDebugNext<CR>
nnoremap \dc :GoDebugContinue<CR>
nnoremap \dt :GoDebugStop<CR>

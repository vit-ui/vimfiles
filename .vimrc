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

call plug#end()

" Ensure Vimspector is available
if empty(glob('~/.vim/plugged/vimspector'))
  echo "Vimspector not found. Run :PlugInstall first."
endif

function! InstallDebugger(adapter)
  if a:adapter == ''
    echo "Usage: :InstallDebugger <adapter_name>"
    return
  endif

  " Install adapter
  execute 'VimspectorInstall ' . a:adapter

  " Create .vimspector.json if missing
  if !filereadable('.vimspector.json')
    let l:config = [
          \ '{',
          \ '  "configurations": {',
          \ '    "Launch": {',
          \ '      "adapter": "' . a:adapter . '",',
          \ '      "configuration": {',
          \ '        "request": "launch",',
          \ '        "program": "${workspaceRoot}",',
          \ '        "mode": "debug"',
          \ '      }',
          \ '    }',
          \ '  }',
          \ '}'
          \ ]
    call writefile(l:config, '.vimspector.json')
    echo ".vimspector.json created."
  else
    echo ".vimspector.json already exists."
  endif

  echo "Debugger installation complete."
endfunction

command! -nargs=1 InstallDebugger call InstallDebugger(<f-args>)

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

" \r to Run, \t to Test
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)

" --- Navigation ---
" \d for Definition, \b for Back
autocmd FileType go nmap <leader>d <Plug>(go-def)
nnoremap <leader>b <C-t>

" --- Go Debugger (Using \g prefix instead of \d) ---
" Toggle breakpoint
nnoremap <leader>gp :call vimspector#ToggleBreakpoint()<CR>

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

set showcmd

" Old command: command! GoHelpMe vsplit ~/crawlergo/shortcuts.txt
command! Shortcuts vsplit ~/vimfiles/shortcuts.txt

" Alternative: Using Leader (\h, \j, etc.)
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

"+ and - now resize the window
nnoremap <silent> + :vertical resize +5<CR>
nnoremap <silent> - :vertical resize -5<CR>

" Portable Cursor Shape (WSL & Linux)
" Uses 2 for Block, 4 for Underline, 6 for Beam (Steady variants)
if &term =~ 'xterm' || &term =~ 'screen' || &term =~ '256color'
    let &t_SI = "\<Esc>[6 q" " Insert mode: steady beam
    let &t_SR = "\<Esc>[4 q" " Replace mode: steady underline
    let &t_EI = "\<Esc>[2 q" " Normal mode: steady block
endif

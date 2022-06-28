" A (not so) minimal vimrc.
"
 "You want Vim, not vi. When Vim finds a vimrc, 'nocompatible' is set anyway.
" We set it explicitly to make our position clear!
"
set nocompatible

" Change highlighting of cursor line when entering/leaving Insert Mode
filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.
set omnifunc=syntaxcomplete#Complete
set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set tabstop =4         " Tab key indents by 4 spaces.
set shiftwidth  =4         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.
set sm

" set spell spelllang=en_us   " Spell checker
set nospell

" Show line numbers
" set number
set relativenumber
set cursorline
set number
set rnu

set colorcolumn=80 " Vertical ruler

" Markdown shite
set fo -=l

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.

set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.

set incsearch              " Highlight while searching with / or ?.
set hlsearch               " Keep matches highlighted.

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.

set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

set path+=**                " Fuzzy file search enabled
set wildignore+=**/node_modules/**
set wildignore+=**/__pycache__/**
set wrapscan               " Searches wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.

set list                   " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

" The fish shell is not very compatible to other shells and unexpectedly
" breaks things that use 'shell'.
if &shell =~# 'fish$'
  set shell=/bin/bash
endif

" Show buffers on F5
noremap <F5> :buffers<CR>:buffer<Space>

" Reload .vimrc with F6
noremap <F6> :source ~/.config/nvim/init.vim<CR>

call plug#begin('~/.config/autoload/plugged')
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'
Plug 'kamykn/spelunker.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-abolish'
Plug 'tribela/vim-transparent'
Plug 'kovisoft/slimv'
Plug 'vim-airline/vim-airline-themes'
Plug 'jremmen/vim-ripgrep'
call plug#end()

" Disable mouse
set mouse=
" VS Code like colors
set t_Co=256
set t_ut=
colorscheme gruvbox

" Show Tree
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Leader key
let mapleader=" "

" when in normal mode, stop highlighting search results
nnoremap <silent> <Esc> :nohlsearch<CR>

" replace the word under the cursor in the current file
nnoremap <Leader>fr :%s/<C-r><C-w>/<C-r><C-w>/g<Left><Left>
" replace the selection in the current file
xnoremap <Leader>fr "sy:%s/<C-r>s/<C-r>s/g<Left><Left>

" Nerd tree bindings
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

" Kills all buffers then reopens the current one
function! KillOtherBuffers()
  %bd|e#
endfunction

command! -nargs=0 KillOtherBuffers call KillOtherBuffers()

noremap <silent> <C-o> :KillOtherBuffers<CR>
" Kills buffer without messing windows
noremap <silent> <leader>c :bp\|bd #<CR>

" Set 85 length on vertical split
nnoremap <silent> <leader>w :vertical resize 85<CR>

" Navigation on Buffers
nnoremap <silent> <C-Right> :bnext<CR>
nnoremap <silent> <C-Left> :bprevious<CR>
nnoremap <silent> <C-q> :bd<CR>

" Swap windowis with Ctrl + direction
nnoremap <C-l> <C-W>l
nnoremap <C-k> <C-W>k
nnoremap <C-j> <C-W>j
nnoremap <C-h> <C-W>h

" quickfix list navigation
nnoremap ]c :cnext<CR>
nnoremap [c :cprev<CR>

" location list navigation
nnoremap ]l :lnext<CR>
nnoremap [l :lprev<CR>

" search the word under the cursor in the project
nnoremap <silent> <Leader>ps :Rg <C-r><C-w><CR>
" search the selection in the project
xnoremap <Leader>ps "sy:Rg <C-r>s<CR>

 " Load .vimrc onto another buffer
nnoremap <leader>rc :e ~/.config/nvim/init.vim<CR>

" Run black
command! Black
          \ execute 'silent !black %:p --line-length 79'
          \ | redraw!

" Run ESLINT
command! Eslint
            \ execute 'silent !eslint %:p --quiet --fix'
            \ | redraw!

" Clear trailing whitespace
command! TrimTrailing execute ':%s/\s\+$//e'

" Save file
nnoremap <C-s> :w<CR>

" Redraw on Ctrl F5
nnoremap <C-F5> :redraw!<CR>
" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-pyright',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-fsharp',
  \ 'coc-css',
  \ 'coc-markdownlint',
  \ ]
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> gh :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)


" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <leader>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <leader>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <leader>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <leader>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <leader>p  :<C-u>CocListResume<CR>

" List only non ignored files in CTRL P fuzzy find
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" SET ENCONDING TO UTF8 ALWAYS
set fileencodings=utf-8

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" Apply macros on visual mode. Source: https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

"Disable arrows
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <right> <nop>

" Disable quit
noremap <C-w><C-q> <nop>

"" Go back to normal in :norm : C-v ESC
"" Pasre on command mode (:) (C-r + <reg> )

" COC scroll floating window
nnoremap <nowait><expr> <leader>d coc#float#has_scroll() ? coc#float#scroll(1) : "\<leader>d"
nnoremap <nowait><expr> <leader>u coc#float#has_scroll() ? coc#float#scroll(0) : "\<leader>u"

" Show arglist for current symbol

function! ShowSlimvArglist()
  let col = col('.')
  let line = line('.')
  execute SlimvArglist(line, col + 1)
endfunction
" Add current coc.nvim mappings for SLIMV
augroup slimv
  autocmd!
  autocmd FileType lisp set omnifunc=SlimvOmniComplete
  autocmd FileType lisp nnoremap <silent> gh :call SlimvDescribeSymbol()<CR>
  autocmd FileType lisp nnoremap <silent> gd :call SlimvFindDefinitions()<CR>
  autocmd FileType lisp nnoremap <silent> gi :call ShowSlimvArglist()<CR>
  autocmd FileType lisp,scheme nnoremap <silent> <C-C> :call SlimvInterrupt()<CR>
augroup end

" SWANK server startup command
let g:slimv_swank_cmd = '! kitty --single-instance sbcl --load ~/.config/autoload/plugged/slimv/slime/start-swank.lisp &'
" Set vertical split for SLIMV REPL
let g:slimv_repl_split=4
" Disable Syntax Highlight on REPL
let g:slimv_repl_syntax=0
let g:lisp_rainbow=1
let g:slimv_repl_split_size=60

" SWANK with Scheme

let g:scheme_builtin_swank = 1
let g:slimv_swank_scheme = '! kitty --single-instance mit-scheme --load ~/.config/autoload/plugged/slimv/slime/contrib/swank-mit-scheme.scm &'

" Set lisp automatically for .asd files
autocmd BufNewFile,BufRead *.asd :set filetype=lisp

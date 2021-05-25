call plug#begin('~/.config/nvim/plugged')

" Utils and snippets
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Smooth Scroll
Plug 'karb94/neoscroll.nvim'

" Fancy syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Javascript/Typescript/JSX Syntax
Plug 'styled-components/vim-styled-components'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'herringtondarkholme/yats.vim'

" ReasonML Syntax
Plug 'jordwalke/vim-reasonml'

" Error Handling
Plug 'scrooloose/syntastic'

" Tabs
Plug 'kyazdani42/nvim-web-devicons'
" Plug 'romgrk/barbar.nvim'

" Code completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" LSP and code formatters
Plug 'neoclide/coc.nvim' , { 'branch' : 'release' }
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'nvim-lua/lsp-status.nvim'

" GraphQL
Plug 'jparise/vim-graphql'
Plug 'mileszs/ack.vim'

" File search
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Cute tree
Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'ryanoasis/vim-devicons'

" Rust
Plug 'rust-lang/rust.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'kdheepak/lazygit.nvim'

" Airline because YES
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Testing
Plug 'vim-test/vim-test'

" Ident on paste
Plug 'sickill/vim-pasta'

" Comment lines
Plug 'preservim/nerdcommenter'

" Color Schemes
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'ghifarit53/tokyonight-vim'
Plug 'romgrk/doom-one.vim'

call plug#end()

lua require'nvim-treesitter.configs'.setup { highlight = { enable = true } }
set encoding=UTF-8

" lua require('neoscroll').setup({ mappings = {'<S-Up>', '<S-Down>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'}, hide_cursor = true, stop_eof = true,respect_scrolloff = false, cursor_scrolls_alone = true })

autocmd BufReadPost,BufNewFile
 \ *.test.tsx,*.test.ts,*spec.ts,*spec.tsx,*.test.jsx,*.test.js,*spec.js,*spec.jsx,
 \ set filetype=jasmine.javascript syntax=jasmine

let g:ale_fixers = {
 \ '*': ['remove_trailing_lines', 'trim_whitespace'],
 \ 'javascript': ['prettier', 'eslint'],
 \ 'typescript': ['prettier', 'eslint'] ,
 \ 'javascriptreact': ['prettier', 'eslint'],
 \ 'typescriptreact': ['prettier', 'eslint'],
 \ 'json': ['prettier']
 \ }

let g:ale_linters = {}
let g:ale_linters.typescript = ['eslint', 'tsserver']
let g:ale_linters.typescriptreact = ['eslint', 'tsserver']
let g:ale_linters.javascript = ['eslint', 'tsserver']
let g:ale_linters.javascriptreact = ['eslint', 'tsserver']

let g:ale_typescript_prettier_use_local_config = 2

let g:ale_fix_on_save = 2

let g:ale_linters_explicit = 2

let g:coc_global_extensions = [ 'coc-tsserver', 'coc-rls' ]

let g:rustfmt_autosave = 1

let g:syntastic_aggregate_errors = 1

let g:syntastic_rust_checkers = ['cargo']

if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif

let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }

" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Airline: Enable the airline extensions for esy project status and reason
" syntastic plugin.
let g:airline_extensions = ['esy', 'reason']
let g:reasonml_project_airline=1
let g:reasonml_syntastic_airline=1
let g:reasonml_clean_project_airline=1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1

autocmd FileType reason map <buffer> <D-C> :ReasonPrettyPrint<Cr>

" Run coc only in some files
augroup CocGroup
  autocmd!
  autocmd BufNew,BufRead * execute "CocDisable"
  autocmd BufNew,BufEnter *.ts execute "silent! CocEnable"
  autocmd BufNew,BufEnter *.tsx execute "silent! CocEnable"
  autocmd BufNew,BufEnter *.js execute "silent! CocEnable"
	autocmd BufNew,BufEnter *.jsx execute "silent! CocEnable"
augroup end

" these "Ctrl mappings" work well when Caps Lock is mapped to Ctrl
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
" setup mapping to call :LazyGit
nnoremap <silent> <C-g> :LazyGit<CR>
nmap <silent> <C-a> ggVG<CR>
nnoremap <silent> <C-f> :Telescope find_files<CR>
vmap <C-/> <plug>NERDCommenterToggle <CR>
nnoremap <silent><C-x> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-S-down> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-S-up> :set paste<CR>m`O<Esc>``:set nopaste<CR>
nmap <silent> <A-Up> :m-2  <CR>
nmap <silent> <A-Down> :m+  <CR>
vnoremap <A-down> :m '>+1<CR>gv=gv
vnoremap <A-up> :m '<-2<CR>gv=gv
" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
" GoTo code navigation.
nmap silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <C-b> :NERDTreeToggle <CR>
" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

"packadd! dracula
syntax enable
filetype plugin on
filetype plugin indent on
colorscheme dracula
set termguicolors

"let g:tokyonight_style = 'storm' " available: night, storm
"let g:tokyonight_enable_italic = 1

"colorscheme tokyonight
highlight Normal guibg=none
hi BufferTabpageFill guibg=none

set number
set tabstop=2
set shiftwidth=2
set autoindent

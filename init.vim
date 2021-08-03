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

" ReasonML Syntax
Plug 'jordwalke/vim-reasonml'

" Error Handling
Plug 'scrooloose/syntastic'

" Tabs
Plug 'kyazdani42/nvim-web-devicons'
" Plug 'romgrk/barbar.nvim'

" Code completion
Plug 'hrsh7th/nvim-compe'
Plug 'onsails/lspkind-nvim'

" LSP and code formatters
Plug 'editorconfig/editorconfig-vim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'neovim/nvim-lspconfig'

" GraphQL
Plug 'jparise/vim-graphql'
Plug 'mileszs/ack.vim'

" File search
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Cute tree
Plug 'kyazdani42/nvim-tree.lua'

" Rust
Plug 'rust-lang/rust.vim'
Plug 'prabirshrestha/async.vim'

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
Plug 'folke/tokyonight.nvim'
Plug 'romgrk/doom-one.vim'

call plug#end()

lua << EOF
local lspconfig = require"lspconfig"

vim.o.completeopt = "menuone,noselect"

require"lspkind".init({
    -- enables text annotations
    --
    -- default: true
    with_text = true,

    -- default symbol map
    -- can be either 'default' or
    -- 'codicons' for codicon preset (requires vscode-codicons font installed)
    --
    -- default: 'default'
    preset = 'codicons',

    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
      Text = '',
      Method = 'ƒ',
      Function = '',
      Constructor = '',
      Variable = '',
      Class = '',
      Interface = 'ﰮ',
      Module = '',
      Property = '',
      Unit = '',
      Value = '',
      Enum = '了',
      Keyword = '',
      Snippet = '﬌',
      Color = '',
      File = '',
      Folder = '',
      EnumMember = '',
      Constant = '',
      Struct = ''
    },
})


require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = false;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  signs = true,
  virtual_text = false,
})

vim.fn.sign_define('LspDiagnosticsSignError', { text = "" })
vim.fn.sign_define('LspDiagnosticsSignWarning', { text = "" })
vim.fn.sign_define('LspDiagnosticsSignInformation', { text = "" })
vim.fn.sign_define('LspDiagnosticsSignHint', { text = "" })

local function eslint_config_exists()
  local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)
  
  if not vim.tbl_isempty(eslintrc) then
    return true
  end

  if vim.fn.filereadable("package.json") then
    if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
      return true
    end
  end

  return false 
end


local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

local prettier = {
  formatCommand = "prettierd --stdin-filepath ${INPUT}",
  formatStdin = true
}

local terraform = {
  formatCommand = "terraform fmt -write=false -list=false ${INPUT}",
}

lspconfig.tsserver.setup {
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
  root_dir = function() return vim.loop.cwd() end,
  on_attach = function(client)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    client.resolved_capabilities.document_formatting = false
    if not client == nil then
      set_lsp_config(client)
    end
    vim.cmd [[autocmd! CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({show_header = false})]]
  end
}

lspconfig.efm.setup {
  cmd = {"efm-langserver"},
  init_options = {documentFormatting = true},
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.goto_definition = false
    
    if not client == nil then
      set_lsp_config(client)
    end
    vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.cmd [[autocmd! CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({show_header = false})]]
  end,
  root_dir = function() return vim.loop.cwd() end,
  settings = {
    rootMarkers = {vim.loop.cwd()},
    languages = {
      javascript = {eslint, prettier},
      javascriptreact = {eslint, prettier},
      ["javascript.jsx"] = {eslint, prettier},
      typescript = {eslint, prettier},
      ["typescript.tsx"] = {eslint, prettier},
      typescriptreact = {eslint, prettier},
      terraform = {terraform},
    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "terraform",
    "terraform.tf",
  },
}

lspconfig.terraformls.setup {}

EOF

" Errors in Red
hi LspDiagnosticsVirtualTextError guifg=Red ctermfg=Red
" Warnings in Yellow
hi LspDiagnosticsVirtualTextWarning guifg=Yellow ctermfg=Yellow
" Info and Hints in White
hi LspDiagnosticsVirtualTextInformation guifg=White ctermfg=White
hi LspDiagnosticsVirtualTextHint guifg=White ctermfg=White

" Underline the offending code
hi LspDiagnosticsUnderlineError guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi LspDiagnosticsUnderlineWarning guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi LspDiagnosticsUnderlineInformation guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi LspDiagnosticsUnderlineHint guifg=NONE ctermfg=NONE cterm=underline gui=underline

lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
EOF
set encoding=UTF-8

" lua require('neoscroll').setup({ mappings = {'<S-Up>', '<S-Down>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'}, hide_cursor = true, stop_eof = true,respect_scrolloff = false, cursor_scrolls_alone = true })

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

" Nvim Tree
let g:nvim_tree_auto_open = 1 "0 by default, opens the tree when typing `vim $DIR` or `vim`
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
let g:nvim_tree_gitignore = 1 "0 by default
let g:nvim_tree_auto_open = 1 "0 by default, opens the tree when typing `vim $DIR` or `vim`
let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
let g:nvim_tree_highlight_opened_files = 1
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   },
    \   'lsp': {
    \     'hint': "",
    \     'info': "",
    \     'warning': "",
    \     'error': "",
    \   }
    \ }

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Vim Tree
nnoremap <C-b> :NvimTreeToggle<CR>

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
nnoremap <silent> <C-A-f> :Telescope live_grep<CR>
vmap <C-/> <plug>NERDCommenterToggle <CR>
nnoremap <silent><C-x> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-S-down> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-S-up> :set paste<CR>m`O<Esc>``:set nopaste<CR>
nmap <silent> <A-Up> :m-2  <CR>
nmap <silent> <A-Down> :m+  <CR>
vnoremap <A-down> :m '>+1<CR>gv=gv
vnoremap <A-up> :m '<-2<CR>gv=gv

syntax enable
filetype plugin on
filetype plugin indent on
colorscheme dracula 
set termguicolors

highlight Normal guibg=none
hi BufferTabpageFill guibg=none

set number
set tabstop=2
set shiftwidth=2
set autoindent
set expandtab
set updatetime=1000

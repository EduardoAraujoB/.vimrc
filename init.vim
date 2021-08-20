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

" Pretty and fast status line
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}

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
local present1, gl = pcall(require, "galaxyline")
local present2, condition = pcall(require, "galaxyline.condition")
if not (present1 or present2) then
   return
end

local gls = gl.section

gl.short_line_list = { " " }

local left_separator = "" -- or " "
local right_separator = "" -- or "" " "

local colors = {
  dark_gray = '#282a36',
  light_gray = '#44475a',
  blue_gray = '#6272a4',
  cyan = '#8be9fd',
  green = '#50fa7b',
  pink = '#ff79c6',
  purple = '#bd93f9',
  white = '#f8f8f2',
  orange = '#ffb86c',
  red = '#ff5555',
  yellow = '#f1fa8c',
}

gls.left[1] = {
   FirstElement = {
      provider = function()
         return "▋"
      end,
      highlight = { colors.green, colors.green },
   },
}

gls.left[2] = {
   statusIcon = {
      provider = function()
         return "  "
      end,
      highlight = { colors.dark_gray, colors.green },
      separator = right_separator .. " ",
      separator_highlight = { colors.green, colors.blue_gray },
   },
}

gls.left[3] = {
   FileIcon = {
      provider = "FileIcon",
      condition = condition.buffer_not_empty,
      highlight = { colors.white, colors.blue_gray },
   },
}

gls.left[4] = {
   FileName = {
      provider = function()
         local fileinfo = require "galaxyline.provider_fileinfo"
         return fileinfo.get_current_file_name("", "")
      end,
      condition = condition.buffer_not_empty,
      highlight = { colors.white, colors.blue_gray },
      separator = right_separator, 
      separator_highlight = { colors.blue_gray, colors.cyan },
   },
}

gls.left[5] = {
   current_dir = {
      provider = function()
         local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
         return "  " .. dir_name .. " "
      end,
      highlight = { colors.dark_gray, colors.cyan },
      separator = right_separator,
      separator_highlight = { colors.cyan, colors.light_gray },
   },
}

local checkwidth = function()
   local squeeze_width = vim.fn.winwidth(0) / 2
   if squeeze_width > 30 then
      return true
   end
   return false
end

gls.left[6] = {
   DiffAdd = {
      provider = "DiffAdd",
      condition = checkwidth,
      icon = "  ",
      highlight = { colors.white, colors.light_gray },
   },
}

gls.left[7] = {
   DiffModified = {
      provider = "DiffModified",
      condition = checkwidth,
      icon = "   ",
      highlight = { colors.blue_gray, colors.light_gray },
   },
}

gls.left[8] = {
   DiffRemove = {
      provider = "DiffRemove",
      condition = checkwidth,
      icon = "  ",
      highlight = { colors.blue_gray, colors.light_gray },
   },
}

gls.left[9] = {
   DiagnosticError = {
      provider = "DiagnosticError",
      icon = "  ",
      highlight = { colors.red, colors.light_gray },
   },
}

gls.left[10] = {
   DiagnosticWarn = {
      provider = "DiagnosticWarn",
      icon = "  ",
      highlight = { colors.yellow, colors.light_gray },
   },
}

gls.right[1] = {
   lsp_status = {
      provider = function()
         local clients = vim.lsp.get_active_clients()
         if next(clients) ~= nil then
            local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
            for _, client in ipairs(clients) do
               local filetypes = client.config.filetypes
               if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  return " " .. "  " .. " LSP"
               end
            end
            return ""
         else
            return ""
         end
      end,
      highlight = { colors.blue_gray, colors.light_gray },
   },
}

gls.right[2] = {
   GitIcon = {
      provider = function()
         return " "
      end,
      condition = require("galaxyline.condition").check_git_workspace,
      highlight = { colors.blue_gray, colors.light_gray },
      separator = " ",
      separator_highlight = { colors.light_gray, colors.light_gray },
   },
}

gls.right[3] = {
   GitBranch = {
      provider = "GitBranch",
      condition = require("galaxyline.condition").check_git_workspace,
      highlight = { colors.blue_gray, colors.light_gray },
   },
}

local mode_colors = {
   [110] = { "NORMAL", colors.red },
   [105] = { "INSERT", colors.purple },
   [99] = { "COMMAND", colors.pink },
   [116] = { "TERMINAL", colors.green },
   [118] = { "VISUAL", colors.cyan },
   [22] = { "V-BLOCK", colors.cyan },
   [86] = { "V_LINE", colors.cyan },
   [82] = { "REPLACE", colors.orange },
   [115] = { "SELECT", colors.blue },
   [83] = { "S-LINE", colors.blue },
}

local mode = function(n)
   return mode_colors[vim.fn.mode():byte()][n]
end

gls.right[4] = {
   left_round = {
      provider = function()
         vim.cmd("hi Galaxyleft_round guifg=" .. mode(2))
         return left_separator
      end,
      separator = " ",
      separator_highlight = { colors.light_gray, colors.light_gray },
      highlight = { "GalaxyViMode", colors.light_gray },
   },
}

gls.right[5] = {
   viMode_icon = {
      provider = function()
         vim.cmd("hi GalaxyviMode_icon guibg=" .. mode(2))
         return " "
      end,
      highlight = { colors.light_gray, colors.red },
   },
}

gls.right[6] = {
   ViMode = {
      provider = function()
         vim.cmd("hi GalaxyViMode guifg=" .. mode(2))
         return "  " .. mode(1) .. " "
      end,
      highlight = { "GalaxyViMode", colors.light_gray },
   },
}

gls.right[7] = {
   some_RoundIcon = {
      provider = function()
         return " "
      end,
      separator = left_separator,
      separator_highlight = { colors.green, colors.light_gray },
      highlight = { colors.light_gray, colors.green },
   },
}

gls.right[8] = {
   line_percentage = {
      provider = function()
         local current_line = vim.fn.line "."
         local total_line = vim.fn.line "$"

         if current_line == 1 then
            return "  Top "
         elseif current_line == vim.fn.line "$" then
            return "  Bot "
         end
         local result, _ = math.modf((current_line / total_line) * 100)
         return "  " .. result .. "% "
      end,
      highlight = { colors.green, colors.light_gray },
   },
}

EOF


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

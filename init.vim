call plug#begin('~/.config/nvim/plugged')

" Utils and snippets
" Plug 'SirVer/ultisnips'
" Plug 'mlaursen/vim-react-snippets'

" Smooth Scroll
Plug 'karb94/neoscroll.nvim'

" Fancy syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Javascript/Typescript/JSX Syntax
Plug 'styled-components/vim-styled-components'

" ReasonML Syntax
Plug 'jordwalke/vim-reasonml'

" Error Handling
Plug 'scrooloose/syntastic'

" Icons
Plug 'kyazdani42/nvim-web-devicons'

" Tabs
" Plug 'romgrk/barbar.nvim'

" Code completion
Plug 'hrsh7th/nvim-compe'
Plug 'onsails/lspkind-nvim'

" LSP and code formatters
Plug 'editorconfig/editorconfig-vim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'tami5/lspsaga.nvim'

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

" Comment lines
Plug 'terrortylor/nvim-comment'

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" Color Schemes
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'folke/tokyonight.nvim'
Plug 'romgrk/doom-one.vim'

call plug#end()

" TODO: move those lua scripts into separeted files
lua << EOF
  require'nvim-tree'.setup{
   auto_close = true,
   open_on_setup = true,
   view = {
     side = 'left',
     auto_resize = true,
   }
  }
EOF

lua << EOF

require('nvim_comment').setup({
  comment_empty = false,
  line_mapping = '<C-l>',
  operator_mapping = '<C-k>',
})

EOF

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
      highlight = { colors.green, colors.light_gray },
   },
}

gls.left[7] = {
   DiffModified = {
      provider = "DiffModified",
      condition = checkwidth,
      icon = "   ",
      highlight = { colors.orange, colors.light_gray },
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
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    ultisnips = false;
    snippets_nvim = true;
    treesitter = true;
  };
}

require'lspsaga'.init_lsp_saga();

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  signs = true,
  virtual_text = false,
})

vim.fn.sign_define('LspDiagnosticsSignError', { text = "" })
vim.fn.sign_define('LspDiagnosticsSignWarning', { text = "" })
vim.fn.sign_define('LspDiagnosticsSignInformation', { text = "" })
vim.fn.sign_define('LspDiagnosticsSignHint', { text = "" })

vim.cmd 'autocmd BufRead,BufNewFile *.eslintrc,*.prettierrc set filetype=json'

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
      client.config.flags.allow_incremental_sync = true
    if client.config.flags then
    end
    client.resolved_capabilities.document_formatting = false
    if not client == nil then
      set_lsp_config(client)
    end
    vim.cmd [[autocmd! CursorHold <buffer> lua require'lspsaga.diagnostic'.show_line_diagnostics()]]
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
    vim.cmd [[autocmd! CursorHold <buffer> lua require'lspsaga.diagnostic'.show_line_diagnostics()]]
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
      markdown = {prettier},
      ["markdown.md"] = {prettier},
      json = {prettier},
      terraform = {terraform},
      ["terraform.tf"] = {terraform},
    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "json",
    "markdown",
    "markdown.md",
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
    enable = true,
  },
  indent = {
    enable = true 
  } 
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
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
let g:nvim_tree_gitignore = 1 "0 by default
" let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
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

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Nvim Tree
nnoremap <C-b> :NvimTreeToggle<CR>

" Markdown Preview
nmap <C-A-p> <Plug>MarkdownPreview
nmap <C-p-s> <Plug>MarkdownPreviewStop
nmap <C-p> <Plug>MarkdownPreviewToggle

" Remove search highlight
nmap <silent> <C-h> :noh<CR>

" LSP saga
nnoremap <silent> a :Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent> s :Lspsaga diagnostic_jump_next<CR>  
nnoremap <silent> <leader>d :Lspsaga preview_definition<CR>
nnoremap <silent> <leader>r :Lspsaga rename<CR>
nnoremap <silent> <leader>s :Lspsaga signature_help<CR>
nnoremap <silent> <leader>i :Lspsaga hover_doc<CR>
nnoremap <silent> <leader>k <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
nnoremap <silent> <leader>j <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
nnoremap <silent> <leader>f :Lspsaga lsp_finder<CR>
nnoremap <silent> <leader>a :Lspsaga code_action<CR>
vnoremap <silent> <leader>a :<C-U>Lspsaga range_code_action<CR>

" setup mapping to call :LazyGit
nnoremap <silent> <C-g> :LazyGit<CR>

" Telescope
nnoremap <silent> <C-f> :Telescope find_files<CR>
nnoremap <silent> <C-A-f> :Telescope live_grep<CR>

" Get all file content
nmap <silent> <C-a> ggVG<CR>

" Create empty lines
nnoremap <silent><C-S-down> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-S-up> :set paste<CR>m`O<Esc>``:set nopaste<CR>

" Move lines up and down
nmap <silent> <A-Up> :m-2  <CR>
nmap <silent> <A-Down> :m+  <CR>
vnoremap <A-down> :m '>+1<CR>gv=gv
vnoremap <A-up> :m '<-2<CR>gv=gv
" inoremap <silent><expr> <CR>  compe#confirm('<CR>')

syntax enable
filetype plugin on
filetype plugin indent on
colorscheme dracula 
set termguicolors

function! s:_ (name, ...)
  let fg = ''
  let bg = ''
  let attr = ''

  if type(a:1) == 3
    let fg   = get(a:1, 0, '')
    let bg   = get(a:1, 1, '')
    let attr = get(a:1, 2, '')
  else
    let fg   = get(a:000, 0, '')
    let bg   = get(a:000, 1, '')
    let attr = get(a:000, 2, '')
  end

  let has_props = v:false

  let cmd = 'hi! ' . a:name
  if !empty(fg) && fg != 'none'
    let cmd .= ' guifg=' . fg
    let has_props = v:true
  end
  if !empty(bg) && bg != 'none'
    let cmd .= ' guibg=' . bg
    let has_props = v:true
  end
  if !empty(attr) && attr != 'none'
    let cmd .= ' gui=' . attr
    let has_props = v:true
  end
  execute 'hi! clear ' a:name
  if has_props
    execute cmd
  end
endfunc

let s:blue = '#8be9fd'
let s:purple = '#bd93f9'
let s:green = '#50fa7b'

call s:_('DraculaCyan', s:blue, '', 'none')
call s:_('DraculaPurple', s:purple, '', 'none')
call s:_('DraculaGreen', s:green, '', 'none')

highlight Normal guibg=none
hi BufferTabpageFill guibg=none
hi! link TSConstant DraculaPurple
hi! link TSConstMacro DraculaPurple 
hi! link TSConstBuiltin DraculaPurple
hi! link TSLiteral DraculaPurple 
hi! link TSFuncBuiltin DraculaGreen 
hi! link TSLiteral DraculaPurple 

augroup csshighlight 
    au!
    au BufNewFile,BufRead *.css,*.scss,*styles.ts,*style.ts hi! link TSProperty DraculaCyan 
augroup end

set number
set tabstop=2
set shiftwidth=2
set autoindent 
set expandtab
set updatetime=1000 

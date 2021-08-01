local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options
local env = vim.env

---@param mode string
---@param lhs  string
---@param rhs  string
---@param opts table
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

---@param name string
---@param tbl  table
local function moduleSetupTable(name, tbl)
    return function()
        local status, module = pcall(require, name)
        if status then
            module.setup(tbl)
        else
            print("Module " .. name .. " not initialized, please run PaqInstall")
        end
    end
end

---@param name    string
---@param setupFn fun(mod:table)
local function moduleConfigureFn(name, setupFn)
    return function()
        -- try loading. May fail before calling :PaqInstall
        local status, module = pcall(require, name)
        if status and setupFn then
            setupFn(module)
        else
            print("Module " .. name .. " not configured, please run PaqInstall")
        end
    end
end

local install_path = fn.stdpath('data')..'/site/pack/paqs/opt/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  cmd('!git clone --depth 1 https://github.com/savq/paq-nvim.git '..install_path)
  cmd("packadd paq-nvim")
end

g.mapleader = ","

-- Plugins
local plugins = {
    -- Paq manages itself
  {"savq/paq-nvim"},
  {"sainnhe/everforest",
    configure = function()
          cmd("colorscheme everforest")
          g["everforest_background"] = "hard"
          g["everforest_enable_italic"] = 1
          g["everforest_diagnostic_text_highlight"] = 1
          g["everforest_diagnostic_virtual_text"] = "colored"
          g["everforest_current_word"] = "bold"
    end
  },
  {"glepnir/lspsaga.nvim"},
  {"hoob3rt/lualine.nvim",
  configure = moduleConfigureFn("lualine", function(line)
    line.setup {
      options = {
        icons_enabled = true,
        theme = "everforest",
        component_separators = {" ", " "},
        disabled_filetypes = {}
      },
      sections = {
        lualine_a = {"mode", "paste"},
        lualine_b = {
          {"branch"},
          {"diff", color_added = "#a7c080", color_modified = "#ffdf1b", color_removed = "#ff6666"}
        },
        lualine_c = {
          {"diagnostics", sources = {"nvim_lsp"}},
          function()
            return "%="
          end,
          "filename"
        },
        lualine_x = {"filetype"},
        lualine_y = {
          {
            "progress"
          }
        },
        lualine_z = {
          {
            "location",
          }
        }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {"filename"},
        lualine_x = {"location"},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = {}
    }
  end)
  },
  {"hrsh7th/nvim-compe",
  configure = moduleConfigureFn("compe", function(compe)
    compe.setup {
      enabled = true,
      autocomplete = true,
      debug = false,
      min_length = 1,
      preselect = "enable",
      throttle_time = 80,
      source_timeout = 200,
      resolve_timeout = 800,
      incomplete_delay = 400,
      max_abbr_width = 100,
      max_kind_width = 100,
      max_menu_width = 100,
      documentation = {
        border = {"", "", "", " ", "", "", "", " "}, -- the border option is the same as `|help nvim_open_win|`
        winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
        max_width = 120,
        min_width = 60,
        max_height = math.floor(vim.o.lines * 0.3),
        min_height = 1
      },
      source = {
        path = true,
        buffer = true,
        calc = true,
        nvim_lsp = true,
        nvim_lua = true,
        vsnip = false,
        luasnip = false
      }
    }
    -- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
    local t = function(str)
      return vim.api.nvim_replace_termcodes(str, true, true, true)
    end
    
    local check_back_space = function()
      local col = vim.fn.col(".") - 1
      if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
      else
        return false
      end
    end
    
    -- Use (s-)tab to:
    --- move to prev/next item in completion menuone
    --- jump to prev/next snippet's placeholder
    _G.tab_complete = function()
      if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
      elseif check_back_space() then
        return t "<Tab>"
      else
        return vim.fn["compe#complete"]()
      end
    end
    _G.s_tab_complete = function()
      if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
      else
        return t "<S-Tab>"
      end
    end
    map("i", "<Tab>",   "v:lua.tab_complete()",   {expr = true})
    map("s", "<Tab>",   "v:lua.tab_complete()",   {expr = true})
    map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

    map("i", "<C-Space>", "compe#complete()",       {silent = true, expr = true})
    map("i", "<C-y>",     "compe#confirm('<C-y>')", {silent = true, expr = true})
    map("i", "<C-e>",     "compe#close('<End>')",   {silent = true, expr = true}) 
    

  end)},
  {"kyazdani42/nvim-web-devicons"},
  {"onsails/lspkind-nvim"},
  {"neovim/nvim-lspconfig"},
  {"nvim-lua/plenary.nvim"},
  {"nvim-lua/popup.nvim"},
  {"nvim-telescope/telescope.nvim",
  configure = moduleConfigureFn("telescope", function(tele) 
    tele.setup {
         defaults = {
             winblend = 0,
         },
     }
     map("n", "<leader>f", "<cmd>Telescope find_files<cr>")
     map("n", "<leader>g", "<cmd>Telescope live_grep<cr>")
     map("n", "<leader>b", "<cmd>Telescope buffers<cr>")
     map("n", "<leader>ft", "<cmd>Telescope treesitter<cr>")
  end)
  },
  {"nvim-treesitter/nvim-treesitter",
    run = function()
        cmd("TSUpdate")
    end,
    configure = moduleConfigureFn("nvim-treesitter.configs", function(treesitterConfigs)
        treesitterConfigs.setup {
            ensure_installed = "maintained",
            highlight = {
                enable = true,
            },
        }
    end)
  },
  {"phaazon/hop.nvim"},
};

require("paq-nvim")(plugins)

for _, v in pairs(plugins) do
    if v.configure then v.configure() end
end

-- lspkind Icon setup
require("lspkind").init({})

-- Hop
require "hop".setup()
map("n", "<leader>j", "<cmd>lua require'hop'.hint_words()<cr>")
map("n", "<leader>l", "<cmd>lua require'hop'.hint_lines()<cr>")
map("v", "<leader>j", "<cmd>lua require'hop'.hint_words()<cr>")
map("v", "<leader>l", "<cmd>lua require'hop'.hint_lines()<cr>")


-- LSP Prevents inline buffer annotations
vim.lsp.diagnostic.show_line_diagnostics()
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    virtual_text = false
  }
)

-- LSP Saga config & keys https://github.com/glepnir/lspsaga.nvim
local saga = require "lspsaga"
saga.init_lsp_saga {
  code_action_icon = " ",
  definition_preview_icon = "  ",
  dianostic_header_icon = "   ",
  error_sign = " ",
  finder_definition_icon = "  ",
  finder_reference_icon = "  ",
  hint_sign = "⚡",
  infor_sign = "",
  warn_sign = ""
}

map("n", "<Leader>cf", ":Lspsaga lsp_finder<CR>", {silent = true})
map("n", "<leader>ca", ":Lspsaga code_action<CR>", {silent = true})
map("v", "<leader>ca", ":<C-U>Lspsaga range_code_action<CR>", {silent = true})
map("n", "<leader>ch", ":Lspsaga hover_doc<CR>", {silent = true})
map("n", "<leader>ck", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', {silent = true})
map("n", "<leader>cj", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', {silent = true})
map("n", "<leader>cs", ":Lspsaga signature_help<CR>", {silent = true})
map("n", "<leader>ci", ":Lspsaga show_line_diagnostics<CR>", {silent = true})
map("n", "<leader>cn", ":Lspsaga diagnostic_jump_next<CR>", {silent = true})
map("n", "<leader>cp", ":Lspsaga diagnostic_jump_prev<CR>", {silent = true})
map("n", "<leader>cr", ":Lspsaga rename<CR>", {silent = true})
map("n", "<leader>cd", ":Lspsaga preview_definition<CR>", {silent = true})


opt.backspace = {"indent", "eol", "start"}
opt.clipboard = "unnamedplus"
opt.completeopt = "menuone,noselect"
opt.cursorline = true
opt.encoding = "utf-8" -- Set default encoding to UTF-8
opt.expandtab = true -- Use spaces instead of tabs
opt.foldenable = false
opt.foldmethod = "indent"
opt.formatoptions = "l"
opt.hidden = true -- Enable background buffers
opt.hlsearch = true -- Highlight found searches
opt.ignorecase = true -- Ignore case
opt.inccommand = "split" -- Get a preview of replacements
opt.incsearch = true -- Shows the match while typing
opt.joinspaces = false -- No double spaces with join
opt.linebreak = true -- Stop words being broken on wrap
opt.list = false -- Show some invisible characters
opt.number = true -- Show line numbers
opt.numberwidth = 5 -- Make the gutter wider by default
opt.scrolloff = 4 -- Lines of context
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.showmode = false -- Don't display mode
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes:1" -- always show signcolumns
opt.smartcase = true -- Do not ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = "en"
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- You will have bad experience for diagnostic messages when it's default 4000.
opt.updatetime = 250 -- don't give |ins-completion-menu| messages.
opt.wrap = true

vim.g.netrw_liststyle = 3 -- Tree style Netrw

-- Use spelling for markdown files ‘]s’ to find next, ‘[s’ for previous, 'z=‘ for suggestions when on one.
-- Source: http:--thejakeharding.com/tutorial/2012/06/13/using-spell-check-in-vim.html
vim.api.nvim_exec(
  [[
augroup markdownSpell
    autocmd!
    autocmd FileType markdown,md,txt setlocal spell
    autocmd BufRead,BufNewFile *.md,*.txt,*.markdown setlocal spell
augroup END
]],
  false
)

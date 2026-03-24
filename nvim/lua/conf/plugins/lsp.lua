return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
  },

  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "rust_analyzer" }, 
      handlers = {
        function(server_name)
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,

      },
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      end,
    })

    local cmp = require("cmp")
    local kind_icons = {
      Text = "󰉿", Method = "󰆧", Function = "󰊕", Constructor = "",
      Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "",
      Module = "", Property = "󰜢", Unit = "󰑭", Value = "󰎟",
      Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
      File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "",
      Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕",
      TypeParameter = "󰅲",
    }

    cmp.setup({
      preselect = cmp.PreselectMode.None,
      sources = { { name = "nvim_lsp" } },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      }),
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
          vim_item.menu = ({ nvim_lsp = "[LSP]", buffer = "[Buffer]", path = "[Path]" })[entry.source.name]
          return vim_item
        end,
      },
    })
  end
}

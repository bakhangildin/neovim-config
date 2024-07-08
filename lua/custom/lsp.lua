require("neodev").setup()
require("fidget").setup({})
require("mason").setup()
local lspconfig = require("lspconfig")

local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

require("mason-tool-installer").setup({
  ensure_installed = {
    "basedpyright",
    "bashls",
    "emmet_language_server",
    "goimports",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "marksman",
    "sqlls",
    "stylua",
    "tailwindcss",
    "templ",
    "tsserver",
    "yamlls",

    "autoflake",
    "autopep8",
    "isort",
    "prettierd",
  },
})

require("mason-lspconfig").setup({
  handlers = {
    function(server_name)
      lspconfig[server_name].setup {
        capabilities = capabilities
      }
    end,

    lua_ls = function(server_name)
      lspconfig[server_name].setup({
        capabilities = capabilities,
        settings = {
          diagnostics = {
            globals = { "vim", "it", "describe", "after_each" },
          },
        },
      })
    end
  }
})

local conform = require("conform")
conform.setup({
  formatters_by_ft = {
    go              = { "goimports", "gofmt" },
    javascript      = { "prettierd", },
    javascriptreact = { "prettierd", },
    python          = { "isort", "autopep8", "flake8" },
    typescript      = { "prettierd" },
    typescriptreact = { "prettierd" },

  },
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    conform.format {
      bufnr = args.buf,
      lsp_fallback = true,
      quiet = true,
    }
  end,
})

vim.diagnostic.config {
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")
    vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    local set = vim.keymap.set

    set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
    set("n", "gr", vim.lsp.buf.references, { buffer = 0 })
    set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
    set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
    set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
    set("i", "<C-h>", vim.lsp.buf.signature_help, { buffer = 0 })

    set("n", "[d", vim.diagnostic.goto_next, { buffer = 0 })
    set("n", "]d", vim.diagnostic.goto_prev, { buffer = 0 })

    set("n", "<space>rn", vim.lsp.buf.rename, { buffer = 0 })
    set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
    set("n", "<leader>f",
      function()
        conform.format {
          bufnr = args.bufnr,
          lsp_fallback = true,
          quiet = false,
          async = true,
        }
      end,
      { buffer = 0 })

    client.server_capabilities.semanticTokensProvider = nil
  end,
})

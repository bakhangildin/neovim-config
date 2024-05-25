require("nvim-treesitter.configs").setup {
  modules = {},
  ensure_installed = {
    "c",
    "go",
    "html",
    "javascript",
    "lua",
    "python",
    "templ",
    "tsx",
    "typescript",
  },
  sync_install = false,
  auto_install = true,
  ignore_install = {},
}

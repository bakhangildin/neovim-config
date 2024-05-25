local telescope = require "telescope"
telescope.setup {}
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")

local set = vim.keymap.set

local builtin = require "telescope.builtin"
set("n", "<leader>sh", builtin.help_tags)
set("n", "<leader>sk", builtin.keymaps)
set("n", "<leader>pf", builtin.find_files)
set("n", "<C-p>", builtin.git_files)
set("n", "<leader>sg", builtin.live_grep)

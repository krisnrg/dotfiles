require('telescope').setup({
        defaults = {
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
            },
            border = true,
            --path_display = 'smart',
            selection_caret = "  ",
            prompt_prefix = "  ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                    preview_width = 0.55,
                    results_width = 0.8,
                },
                vertical = {
                    mirror = false,
                },
                width = 0.87,
                height = 0.80,
                preview_cutoff = 120,
            },
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            file_ignore_patterns = { "node_modules" },
            set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
            -- other defaults configuration here
        },
        -- other configuration values here
    })
require("telescope").load_extension "file_browser"

local M = {}
M.colors = {
   white = "#D3C6AA",
   darker_black = "#272f35",
   black = "#2b3339", --  nvim bg
   black2 = "#323a40",
   one_bg = "#363e44",
   one_bg2 = "#363e44",
   one_bg3 = "#3a4248",
   grey = "#4e565c",
   grey_fg = "#545c62",
   grey_fg2 = "#626a70",
   light_grey = "#656d73",
   red = "#e67e80",
   baby_pink = "#ce8196",
   pink = "#ff75a0",
   line = "#3a4248", -- for lines like vertsplit
   green = "#83c092",
   vibrant_green = "#a7c080",
   nord_blue = "#78b4ac",
   blue = "#7393b3",
   yellow = "#dbbc7f",
   sun = "#d1b171",
   purple = "#b4bbc8",
   dark_purple = "#d699b6",
   teal = "#69a59d",
   orange = "#e69875",
   cyan = "#95d1c9",
   statusline_bg = "#2e363c",
   lightbg = "#3d454b",
   lightbg2 = "#333b41",
   pmenu_bg = "#83c092",
   folder_bg = "#7393b3",
}
function M.find_configs()
  require("telescope.builtin").find_files {
    prompt_title = "Config Search",
    results_title = "Config Files",
    preview_title = "Preview",
    path_display = { "smart" },
    search_dirs = {
      "~/.config/nvim",
    },
    layout_strategy = "horizontal",
    layout_config = { preview_width = 0.65, width = 0.75 },
  }
end

return M

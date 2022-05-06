local wk = require("which-key")
wk.register({
  ["<leader>"] = {
    f = {
      name = "+Files/Find",
      f = { "File Git file" },
      b = { "Find in buffer" },
      l = { "Live Grep" },
      g = { "Grep String" },
      h = { "Help Tags" },
      s = { "Find Symbols" },
      c = { "Open Config" },
    },
    s = {
        name = "Text Select [Save Commands]",
        f = "Save File",
    },
    b = {"Tree Toggle"},
    e = {
        name = "Misc",
        e = { "Open Config"},
    },
    l = { "Word Hope Line"},
    r = {
        name = "Commands",
        s = "NPM Run Start",
        r = "Reload Config",
        },
        q = { "Quit VIM"},
        n = { "Set Numbers"},
      },
    })

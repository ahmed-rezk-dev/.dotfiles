local M = {}

M.setup = function()

    local wk = require "which-key"

    wk.setup {
        plugins = {
            marks = true, -- shows a list of your marks on ' and `
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            -- the presets plugin, adds help for a bunch of default keybindings in Neovim
            -- No actual key bindings are created
            presets = {
                operators = false, -- adds help for operators like d, y, ...
                motions = false, -- adds help for motions
                text_objects = false, -- help for text objects triggered after entering an operator
                windows = true, -- default bindings on <c-w>
                nav = true, -- misc bindings to work with windows
                z = true, -- bindings for folds, spelling and others prefixed with z
                g = true, -- bindings for prefixed with g
            },
            spelling = { enabled = true, suggestions = 20 }, -- use which-key for spelling hints
        },
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "➜", -- symbol used between a key and it's label
            group = "+", -- symbol prepended to a group
        },
        window = {
            border = "double", -- none, single, double, shadow
            position = "bottom", -- bottom, top
            margin = { 1, 2, 1, 4 }, -- extra window margin [top, right, bottom, left]
            padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        },
        layout = {
            height = { min = 4, max = 25 }, -- min and max height of the columns
            width = { min = 20, max = 50 }, -- min and max width of the columns
            spacing = 3, -- spacing between columns
        },
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
        show_help = true, -- show help message on the command line when the popup is visible
        ignore_missing = false,
    }

    local opts = {
        mode = "n", -- NORMAL mode
        prefix = "<space>",
        buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
        silent = true, -- use `silent` when creating keymaps
        noremap = true, -- use `noremap` when creating keymaps
        nowait = true, -- use `nowait` when creating keymaps
    }
    local vopts = {
        mode = "v", -- VISUAL mode
        prefix = "<space>",
        buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
        silent = true, -- use `silent` when creating keymaps
        noremap = true, -- use `noremap` when creating keymaps
        nowait = true, -- use `nowait` when creating keymaps
    }
    -- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
    -- see https://neovim.io/doc/user/map.html#:map-cmd
    local vmappings = {
        ["/"] = { ":lua require('Comment.api').toggle_blockwise_op(vim.fn.visualmode())<CR>", "Comment" },
    }
    local mappings = {
        ["w"] = { "<cmd>w!<CR>", "Save" },
        ["n"] = { "<cmd>lua _NOTES_TOGGLE()<cr>", "Notes" },
        ["q"] = { "<cmd>q!<CR>", "Quit" },
        ["a"] = { "<cmd>qa<CR>", "Quit All" },
        ["A"] = { "<cmd>qa!<CR>", "Quit All & Cancel" },
        ["/"] = { "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", "Comment" },
        ["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
        ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
        ["h"] = { '<cmd>let @/=""<CR>', "No Highlight" },
        ["m"] = { "<cmd>MarkdownPreviewToggle<CR>", "Markdown Preview" },
        ["f"] = { "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>", "Find files" },
        L = { "<cmd>:put =printf('console.log('' 🔔 %s 👉 %s 👉 %s:'', %s);', line('.'), expand('%:t'), expand('<cword>'), expand('<cword>'))<cr>", "Javascript Log" },

        -- Packer
        p = {
            name = "Packer",
            c = { "<cmd>PackerCompile<cr>", "Compile" },
            i = { "<cmd>PackerInstall<cr>", "Install" },
            r = { "<cmd>lua require('lv-utils').reload_lv_config()<cr>", "Reload" },
            s = { "<cmd>PackerSync<cr>", "Sync" },
            u = { "<cmd>PackerUpdate<cr>", "Update" },
        },

        -- Seacrh
        s = {
            name = "Search",
            b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
            c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
            f = { "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>", "Find files" },
            P = { "<cmd>Telescope projects<cr>", "Projects" },
            h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
            M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
            r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
            R = { "<cmd>Telescope registers<cr>", "Registers" },
            t = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
            k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
            C = { "<cmd>Telescope commands<cr>", "Commands" },
            m = { "<cmd>Telescope marks<cr>", "Bookmarks" },
            p = { "<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<cr>", "Colorscheme with Preview" },
            T = { "<cmd>TodoTelescope <cr>", "TODO" },
        },

        -- Sessions
        S = {
            name = "Sessions",
            s = { ":SaveSession<cr>", "Save Session" },
            S = { ":Telescope session-lens search_session<cr>", "All Sessions" },
            l = { ":RestoreSession<cr>", "Load Session" },
        },

        -- LSP
         l = {
            name = "LSP",
            H = { "<cmd>:lua signature_help()<cr>", "Signature help" },
            s = { "<cmd>:Telescope lsp_document_symbols<cr>", "Document symbols" },
            S = { "<cmd>:Telescope lsp_workspace_symbols<cr>", "Workspace symbols" },
            D = { "<cmd>:lua declaration({ border = 'rounded', max_width = 80 })<cr>", "Declaration" },
            A = { "<cmd>:lua range_code_action()<cr>", "Range code action" },
            c = { "<cmd>:lua incoming_calls()<cr>", "Incoming calls" },
            C = { "<cmd>:lua outgoing_calls(<cr>", "Outgoing calls" },
            t = { "<cmd>:lua type_definition()<cr>", "Type definition" },
            b = { "<cmd>:TroubleToggle workspace_diagnostics<cr>", "All diagnostics" },
            w = { "<cmd>:lua add_workspace_folder()<cr>", "Add workspace folder" },
            R = { "<cmd>:lua remove_workspace_folder()<cr>", "Remove workspace folder" },
            W = { "<cmd>:lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "List workspace folders" },
            e = { "<cmd>lua vim.diagnostic.setqflist()<cr>", "Workspace Diagnostics" },
            i = { "<cmd>LspInfo<cr>", "Info" },
            j = { "<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = O.lsp.popup_border}})<cr>", "Next Diagnostic" },
            k = { "<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = O.lsp.popup_border}})<cr>", "Prev Diagnostic" },
            q = { "<cmd>Telescope quickfix<cr>", "Quickfix" },
        },

        T = {
            name = "Treesitter",
            i = { ":TSConfigInfo<cr>", "Info" },
            p = { ":TSPlaygroundToggle<cr>", "Playground" },
            h = { ":TSHighlightCapturesUnderCursor<cr>", "Syntax highlight" },
        },

        -- Git
        g = {
            name = "Git",
            g = { "<cmd>lua _LAZYGIT_TOGGLE()<cr>", "LazyGit" },
            n = { "<cmd>Neogit<cr>", "Neogit" },
            j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
            k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
            l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
            p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
            r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
            R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
            s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
            u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
            o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
            b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
            c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
            C = { "<cmd>Telescope git_bcommits<cr>", "Checkout commit(for current file)" },
      },

      -- Debugging
      d = {
            name = "Debug",
            t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
            T = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Clear All Breakpoint" },
            b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
            c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
            C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
            d = { "<cmd>lua require'dap'.disconnect() require'dapui'.toggle()<cr>", "Disconnect" },
            g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
            i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
            o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
            u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
            p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
            r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
            s = { "<cmd>lua require'dap'.continue() require'dapui'.toggle()<cr>", "Start" },
            R = { "<cmd>lua require'dap'.restart()<cr>", "Restart" },
            S = { "<cmd>lua require'dapui'.toggle()<cr>", "Sidebar" },
            q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
            J = { "<cmd>:'<,'>SnipRun<cr>", "Javascript Run" },
      },


      -- notes comments
      t = {
            name = "Notes",
            a = { "<cmd>:TodoTrouble<cr>", "Notes" },
      },
}


    -- all of the mappings below are equivalent

    -- method 2
    wk.register(mappings, opts)
    wk.register(vmappings, vopts)
end

return M

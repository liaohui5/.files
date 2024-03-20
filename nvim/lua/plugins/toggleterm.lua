------------------------------------------------------------
-- 命令行集成
-- github: https://github.com/akinsho/toggleterm.nvim
------------------------------------------------------------
-- stylua: ignore start
-- terminal style options
local float_opts = {
    border   = "single", -- 浮动终端样式: single | double | shadow | curved
    width    = 160,      -- 全屏(width & height: 设置一个比较大的数字就会全屏显示)
    height   = 40,
    winblend = 1,
}

return {
    "akinsho/toggleterm.nvim",
    version = "*",
    event   = "VeryLazy",
    opts    = {
        open_mapping      = "<c-x>",       -- 触发插件的主要按键
        hide_numbers      = true,          -- 打开的终端中是否要隐藏行号
        shade_terminals   = false,         -- 是否添加阴影
        persist_size      = false,         -- 是否保存上一次打开时的尺寸
        start_in_insert   = true,          -- 打开终端是 insert 模式
        shading_factor    = 1,             -- 打开终端的背景颜色(1:暗色 3:亮色)
        insert_mappings   = true,          -- 插入模式是否应用快捷键
        terminal_mappings = true,          -- 在终端中是否应用快捷键
        persist_mode      = false,         -- 记住进入终端时vim的模式
        direction         = "horizontal",  -- 终端打开方式 vertical | horizontal | tab | float
        float_opts        = float_opts,
        close_on_exit     = true,          -- close the terminal window when the process exits
        auto_scroll       = true,          -- automatically scroll to the bottom on terminal output
        size              = function(term) -- 非浮动终端的大小
            if term.direction == "horizontal" then
                return 18
            elseif term.direction == "vertical" then
                return vim.o.columns * 0.5
            end
        end,
    },
    keys = function()
        -- use toggleterm api create Terminal instance
        local function createTerminal(cmd)
            return require("toggleterm.terminal").Terminal:new({
                cmd        = cmd,
                hidden     = true,
                direction  = "float",
                float_opts = float_opts,
            })
        end

        -- toggle terminals
        local actions = {
            -- lazygit: https://github.com/jesseduffield/lazygit
            toggle_lazygit = function()
                createTerminal("lazygit"):toggle()
            end,

            -- gitui: https://github.com/extrawurst/gitui
            toggle_gitui = function()
                createTerminal("gitui"):toggle()
            end,

            -- joshuto: https://github.com/kamiyaa/joshuto
            toggle_joshuto_cwd = function()
                local open_path = vim.fn.getcwd()
                return createTerminal(string.format("joshuto %s", open_path)):toggle()
            end,
            toggle_joshuto_current = function()
                local open_path = vim.fn.expand("%:p:h")
                return createTerminal(string.format("joshuto %s", open_path)):toggle()
            end,

            -- vifm: https://vifm.info/
            toggle_vifm = function()
                local buff_path = vim.fn.expand("%:p:h")
                local root_path = vim.fn.getcwd()
                local commands = string.format("vifm %s %s", buff_path, root_path)
                return createTerminal(commands):toggle()
            end,

            -- yazi: https://yazi-rs.github.io/
            toggle_yazi_cwd = function()
                local open_path = vim.fn.getcwd()
                return createTerminal(string.format("yazi %s", open_path)):toggle()
            end,
            toggle_yazi_current = function()
                local open_path = vim.fn.expand("%:p:h")
                return createTerminal(string.format("yazi %s", open_path)):toggle()
            end,
        }
        return {
            {
              "<C-n>",
              "<leader>oy",
              remap = true,
              noremap = true,
            },
            {
              "<C-f>",
              "<leader>oY",
              remap = true,
              noremap = true,
            },
            {
                "<leader>og",
                actions.toggle_lazygit,
                desc = "toggle lazygit[toggleterm.nvim]",
            },
            {
                "<leader>oG",
                actions.toggle_gitui,
                desc = "toggle gitui",
            },
            {
                "<leader>oy",
                actions.toggle_yazi_cwd,
                desc = "toggle yazi file manager",
            },
            {
                "<leader>oY",
                actions.toggle_yazi_current,
                desc = "toggle yazi file manager",
            },
            {
                "<leader>oj",
                actions.toggle_joshuto_cwd,
                desc = "toggle joshuto file manager",
            },
            {
                "<leader>oJ",
                actions.toggle_joshuto_current,
                desc = "toggle joshuto file manager",
            },
            {
                "<leader>of",
                actions.toggle_vifm,
                desc = "toggle vifm file manager",
            },
            {
                "<leader><c-x>",
                "<cmd>ToggleTermToggleAll<cr>",
                desc = "Toggle all terminals",
            },
        }
    end,
}

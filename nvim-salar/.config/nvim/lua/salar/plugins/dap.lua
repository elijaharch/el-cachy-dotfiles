return {
    "mfussenegger/nvim-dap",
    dependencies = { "nvim-neotest/nvim-nio" },

    config = function()
        local dap = require("dap")
        local uv = vim.uv or vim.loop

        local function file_exists(path)
            return path and uv.fs_stat(path) ~= nil
        end

        local function pick_cpp_binary()
            local cwd = vim.fn.getcwd()
            local current = vim.api.nvim_buf_get_name(0)
            local stem = vim.fn.fnamemodify(current, ":t:r")
            local candidates = {
                cwd .. "/" .. stem,
                cwd .. "/build/" .. stem,
                cwd .. "/bin/" .. stem,
                cwd .. "/build/debug/" .. stem,
                cwd .. "/build/Debug/" .. stem,
                cwd .. "/out/" .. stem,
            }

            for _, candidate in ipairs(candidates) do
                if file_exists(candidate) and vim.fn.executable(candidate) == 1 then
                    return candidate
                end
            end

            return vim.fn.input("Path to executable: ", cwd .. "/", "file")
        end

        local function split_args(input)
            local args = {}
            for arg in string.gmatch(input, "%S+") do
                table.insert(args, arg)
            end
            return args
        end

        local function prompt_args()
            return split_args(vim.fn.input("Program arguments: "))
        end

        local lldb_dap = vim.fn.exepath("lldb-dap")
        local codelldb = vim.fn.exepath("codelldb")

        -----------------------------------------------------------------------
        -- Adapter setup
        -----------------------------------------------------------------------
        if lldb_dap ~= "" then
            dap.adapters.lldb = {
                type = "executable",
                command = lldb_dap,
                name = "lldb",
            }
        elseif codelldb ~= "" then
            dap.adapters.lldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = codelldb,
                    args = { "--port", "${port}" },
                },
            }
        else
            vim.notify(
                "No C/C++ DAP adapter found. Install `lldb-dap` or `codelldb`.",
                vim.log.levels.WARN
            )
        end

        -----------------------------------------------------------------------
        -- Debug configurations for C, C++, Rust
        -----------------------------------------------------------------------
        local cpp_configurations = {
            {
                name = "Launch",
                type = "lldb",
                request = "launch",
                program = pick_cpp_binary,
                cwd = "${workspaceFolder}",
                console = "integratedTerminal",
                stopOnEntry = false,
            },
            {
                name = "Launch with args",
                type = "lldb",
                request = "launch",
                program = pick_cpp_binary,
                args = prompt_args,
                cwd = "${workspaceFolder}",
                console = "integratedTerminal",
                stopOnEntry = false,
            },
            {
                name = "Attach to process",
                type = "lldb",
                request = "attach",
                pid = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
            },
        }

        dap.configurations.cpp = cpp_configurations
        dap.configurations.c = cpp_configurations
        dap.configurations.rust = cpp_configurations

        -----------------------------------------------------------------------
        -- Keybindings
        -----------------------------------------------------------------------
        vim.keymap.set("n", "<leader>dc", dap.continue,          { desc = "Continue" })
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Breakpoint" })
        vim.keymap.set("n", "<leader>ds", dap.step_over,         { desc = "Step Over" })
        vim.keymap.set("n", "<leader>di", dap.step_into,         { desc = "Step Into" })
        vim.keymap.set("n", "<leader>do", dap.step_out,          { desc = "Step Out" })
        vim.keymap.set("n", "<leader>dr", dap.restart,           { desc = "Restart" })
        vim.keymap.set("n", "<leader>dt", dap.terminate,         { desc = "Terminate" })
    end,
}
